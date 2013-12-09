package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.ProfilesEvent;
	import com.adams.dt.event.WorkflowstemplatesEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Profiles;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	public final class ProfilesCommand extends AbstractCommand 
	{ 
		private var tempObj : Object ={};
		private var profilesEvent : ProfilesEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			profilesEvent = ProfilesEvent(event);
			this.delegate = DelegateLocator.getInstance().profileDelegate;
			this.delegate.responder = new Callbacks(result,fault);
		    switch(event.type){
		    	case ProfilesEvent.EVENT_GET_ALL_PROFILESS:
			      delegate.responder = new Callbacks(findAllResult,fault);
			      delegate.findAll();
		       	break; 
		     	case ProfilesEvent.EVENT_MSGSENDER_PROFILES:
			       delegate.responder = new Callbacks(getMsgSenderResult,fault);
			       trace("ProfilesCommand pass profileId:"+Profiles(profilesEvent.profiles).profileId);
			       delegate.findByMailProfileId(Profiles(profilesEvent.profiles).profileId); 
		       	break; 
		       	case ProfilesEvent.EVENT_GETPRJ_PROFILES:
		       		delegate.responder = new Callbacks(getPrjProfilesResult,fault);
		        	delegate.findProfilesList(model.person);
		      	break; 
		     	default:
		       	break; 
		    }		      
		}
		public function getPrjProfilesResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			var profilecollection : ArrayCollection = rpcEvent.result as ArrayCollection;
			if(profilecollection.length > 0)
			{
				model.profilesCollection = profilecollection
			}
		}
		public function getMsgSenderResult( rpcEvent : Object ) : void 
		{
			super.result(rpcEvent);
			model.senderProfile = Profiles(ArrayCollection(rpcEvent.result).getItemAt(0));
			trace("ProfilesCommand getMsgSenderResult profileId:"+model.senderProfile.profileId);
			
			var workflowTemplateEv:WorkflowstemplatesEvent = new WorkflowstemplatesEvent(WorkflowstemplatesEvent.EVENT_GETMSG_WORKFLOWSTEMPLATESID);
		 	workflowTemplateEv.workflows.workflowId = model.currentProjects.workflowFk.workflowId;	
		 	trace("ProfilesCommand getMsgSenderResult workflowId:"+model.currentProjects.workflowFK);	
		 	//trace("ProfilesCommand getMsgSenderResult workflowFk:"+model.currentProjects.workflowFk.workflowId);		
			var handler:IResponder = new Callbacks(result,fault)
 			var createmsgSeq:SequenceGenerator = new SequenceGenerator([workflowTemplateEv],handler)
  			createmsgSeq.dispatch();
		}
		public function findAllResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			model.teamProfileCollection = rpcEvent.result as ArrayCollection;
			trace("ProfilesCommand findAllResult teamProfileCollection :"+model.teamProfileCollection.length);	
			updateImpId();
			
			/* var domainwfev:DomainWorkFlowEvent = new DomainWorkFlowEvent(DomainWorkFlowEvent.EVENT_GET_ALL_DOMAIN_WORKLFLOW);
			var cataEvent:CategoriesEvent = new CategoriesEvent(CategoriesEvent.EVENT_GET_ALL_CATEGORIESS)
			var personEvt:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_GET_ALL_PERSONSS)
			var profilesColl:ArrayCollection = model.profilesCollection;
			if(profilesColl.length == 0){
			 	profilesColl.addItem(getProfile(model.person.defaultProfile));
			}
			filterCollection(profilesColl);
			var evtArr:Array = [];
			evtArr.push(personEvt);
			evtArr.push(cataEvent);
			evtArr.push(domainwfev);
			for each (var profile:Profiles in profilesColl){
			 var modEvent:ModuleEvent = new ModuleEvent(ModuleEvent.EVENT_GET_ALL_MODULES);
			 modEvent.profile = profile; 
			 evtArr.push(modEvent);	
			}
			
			var handler:IResponder = new Callbacks(successResult,fault);
			var loginSeq:SequenceGenerator = new SequenceGenerator(evtArr,handler)
          	loginSeq.dispatch();  */
          	
		}
		public function updateImpId():void{
			for each(var pro:Profiles in model.teamProfileCollection){
				if(pro.profileCode == 'EPR'){
					model.impProfileId = pro.profileId;
				}
			}
			trace("ProfilesCommand updateImpId model.impProfileId :"+model.impProfileId);	
		}
		public function successResult( rpcEvent : Object ) : void
		{
			//model.CF? model.dtState = 2:model.dtState = 1;
			//model.dtState = model.CF;
		} 
	}
}

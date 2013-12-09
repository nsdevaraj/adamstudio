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
			      delegate.getList();
		       	break; 
		     	case ProfilesEvent.EVENT_MSGSENDER_PROFILES:
			       delegate.responder = new Callbacks(getMsgSenderResult,fault);
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
			
			var workflowTemplateEv:WorkflowstemplatesEvent = new WorkflowstemplatesEvent(WorkflowstemplatesEvent.EVENT_GETMSG_WORKFLOWSTEMPLATESID);
		 	workflowTemplateEv.workflows.workflowId = model.currentProjects.workflowFk.workflowId;	
		 	
			var handler:IResponder = new Callbacks(result,fault)
 			var createmsgSeq:SequenceGenerator = new SequenceGenerator([workflowTemplateEv],handler)
  			createmsgSeq.dispatch();
		}
		public function findAllResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			model.delayUpdateTxt = "All Profiles";
			model.teamProfileCollection = rpcEvent.result as ArrayCollection;
			updateImpId();	
		}
		public function updateImpId():void{
			for each(var pro:Profiles in model.teamProfileCollection){
				if(pro.profileCode == 'EPR'){
					model.impProfileId = pro.profileId;
				}
			}
			trace("ProfilesCommand updateImpId model.impProfileId :"+model.impProfileId);	
		}
	}
}

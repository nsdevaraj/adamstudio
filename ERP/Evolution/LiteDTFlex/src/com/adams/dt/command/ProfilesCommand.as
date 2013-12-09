package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.event.ProfilesEvent;
	import com.adams.dt.model.vo.Profiles;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	public final class ProfilesCommand extends AbstractCommand 
	{ 
		
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
		      case ProfilesEvent.EVENT_CREATE_PROFILES:
		       delegate.create(profilesEvent.profiles);
		       break; 
		      case ProfilesEvent.EVENT_UPDATE_PROFILES:
		       delegate.update(profilesEvent.profiles);
		       break; 
		      case ProfilesEvent.EVENT_DELETE_PROFILES:
		      	delegate.deleteVO(profilesEvent.profiles);
		       break; 
		      case ProfilesEvent.EVENT_SELECT_PROFILES:
		       delegate.select(profilesEvent.profiles);
		       break;
		      case ProfilesEvent.EVENT_GETPRJ_PROFILES:
		       	delegate.responder = new Callbacks(getPrjProfilesResult,fault);
		        delegate.findProfilesList(model.person);
		       break;  
		      case ProfilesEvent.EVENT_MSGSENDER_PROFILES:
		       delegate.responder = new Callbacks(getMsgSenderResult,fault);
		       delegate.findById(profilesEvent.profiles.profileId);
		       break; 
		      default:
		       break; 
		      }
		      
		} 
		public function findAllResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			model.teamProfileCollection = rpcEvent.result as ArrayCollection;
			updateImpId(); 
			
		}
		public function updateImpId():void{
			for each(var pro:Profiles in model.teamProfileCollection){
				if(pro.profileCode == 'EPR'){
					model.impProfileId = pro.profileId;
				}
				//DECEMBER 31 2009  INDIA
				if(pro.profileCode == 'IND'){
					model.indProfileId = pro.profileId;
				}
			}
			
		}  
		public function getMsgSenderResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			model.senderProfile = Profiles(ArrayCollection(rpcEvent.result).getItemAt(0));
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
 	}
}

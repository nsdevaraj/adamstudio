package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.event.CategoriesEvent;
	import com.adams.dt.event.DomainWorkFlowEvent;
	import com.adams.dt.event.GroupsEvent;
	import com.adams.dt.event.ModuleEvent;
	import com.adams.dt.event.PersonsEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Groups;
	import com.adams.dt.model.vo.Profiles;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class GroupsCommand extends AbstractCommand 
	{ 
		private var tempObj : Object ={};
		private var groupsEvent : GroupsEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			groupsEvent = GroupsEvent(event);
			this.delegate = DelegateLocator.getInstance().groupDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			  switch(event.type){    
			      case GroupsEvent.EVENT_GET_ALL_GROUPSS:
			      	delegate.responder = new Callbacks(findAllResult,fault);
			        delegate.findAll();
			       break; 
			      case GroupsEvent.EVENT_GET_GROUPS:
			      	delegate.findById(groupsEvent.groups.groupId);
			       break; 
			      case GroupsEvent.EVENT_CREATE_GROUPS:
			      	delegate.responder = new Callbacks(createNewGroupResult,fault);
			      	delegate.create(groupsEvent.groups);
			       break; 
			      case GroupsEvent.EVENT_UPDATE_GROUPS:
			       delegate.update(groupsEvent.groups);
			       break; 
			      case GroupsEvent.EVENT_DELETE_GROUPS:
			      	delegate.deleteVO(groupsEvent.groups);
			       break; 
			      case GroupsEvent.EVENT_SELECT_GROUPS:
			       delegate.select(groupsEvent.groups);
			       break;  
			      default:
			       break; 
			      }
		} 
		
		public function findAllResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			model.CollectAllGroupsColl = rpcEvent.result as ArrayCollection;
			trace("GroupsCommand findAllResult CollectAllGroupsColl:"+model.CollectAllGroupsColl.length);
			var domainwfev:DomainWorkFlowEvent = new DomainWorkFlowEvent(DomainWorkFlowEvent.EVENT_GET_ALL_DOMAIN_WORKLFLOW);
			var evtArr:Array = [];
			evtArr.push(domainwfev);
			
			trace("GroupsCommand findAllResult profilesCollection:"+model.profilesCollection.length);
			
			var profilesColl:ArrayCollection = model.profilesCollection;
			if(profilesColl.length == 0){
			 profilesColl.addItem(GetVOUtil.getProfileObject(model.person.defaultProfile));
			}
			filterCollection(profilesColl);
			trace("GroupsCommand findAllResult profilesColl:"+profilesColl.length);
			for each (var profile:Profiles in profilesColl){
			 var modEvent:ModuleEvent = new ModuleEvent(ModuleEvent.EVENT_GET_ALL_MODULES);
			 modEvent.profile = profile; 
			 evtArr.push(modEvent);	
			 trace("GroupsCommand findAllResult profile:"+profile.profileId);
			}
			
			var handler:IResponder = new Callbacks(successResult,fault);
			var loginSeq:SequenceGenerator = new SequenceGenerator(evtArr,handler)
          	loginSeq.dispatch(); 
          	
		}

		private function filterCollection(ac:ArrayCollection) : void
		{
			// assign the filter function
			ac.filterFunction = deDupe;
			//refresh the collection
			ac.refresh();
		}

		private function deDupe(item : Object) : Boolean
		{
			// the return value
			var retVal : Boolean = false;
			// check the items in the itemObj Ojbect to see if it contains the value being tested
			if ( !tempObj.hasOwnProperty(item.profileId))
			{
				// if not found add the item to the object
				tempObj[item.profileId] = item;
				retVal = true;
			}

			return retVal;
			//	 or if you want to feel like a total bad ass and use only one line of code, use a tertiary statement ;)
			// return (tempObj.hasOwnProperty(item.label) ? false : tempObj[item.label] = item && true);
		} 
		
		public function successResult( rpcEvent : Object ) : void
		{
			model.dtState = model.CF;
		} 
		public function createNewGroupResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			model.createdGroup = Groups(rpcEvent.message.body);
			model.createdGroupColl.addItem(model.createdGroup);
		}
	}
}

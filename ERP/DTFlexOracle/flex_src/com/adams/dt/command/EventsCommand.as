package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.EventsEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Events;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	public final class EventsCommand extends AbstractCommand 
	{ 
		private var eventsEvent:EventsEvent;		
		
		override public function execute( event:CairngormEvent ) : void {	 
			super.execute( event );
			eventsEvent = EventsEvent( event );
			this.delegate = DelegateLocator.getInstance().eventDelegate;
			this.delegate.responder = new Callbacks( result, fault );
			 switch( event.type ) {    
			     case EventsEvent.EVENT_GET_ALL_EVENTSS:
			     	delegate.responder = new Callbacks( getAllEventsResult, fault );
			     	delegate.findAll();
			     break; 
			     case EventsEvent.EVENT_GET_EVENTS:
			     	delegate.responder = new Callbacks( getPersonsEventsResult, fault ); 
			     	delegate.findById( model.person.personId );
			     break; 
			     case EventsEvent.EVENT_CREATE_EVENTS:
			     	delegate.responder = new Callbacks( getEventsResult, fault );
			     	delegate.create( eventsEvent.events );
			     break; 
			     case EventsEvent.EVENT_UPDATE_EVENTS:
			     	delegate.update( eventsEvent.events );
			     break; 
			     case EventsEvent.EVENT_DELETE_EVENTS:
			     	delegate.responder = new Callbacks( afterDelete, fault );
			     	delegate.deleteVO( eventsEvent.events );
			     break; 
			     case EventsEvent.EVENT_DELETEALL_EVENTS:
			     	delegate.responder = new Callbacks( result, fault );
			     	delegate.deleteAll();
			     break;
			     case EventsEvent.EVENT_SELECT_EVENTS:
			     	delegate.select( eventsEvent.events );
			     break; 		
			     case EventsEvent.EVENT_GETCURRENTPROJECT_EVENTS:
			      	delegate.responder = new Callbacks( getCurrentProjectEventsResult, fault );
			      	delegate.findByIdName( model.currentProjects.projectId, "Message" );
			     break; 
			     case EventsEvent.EVENT_GETCURRENTPROJECT_PROPERTY:
			     	delegate.responder = new Callbacks( getProjectPropertyResult, fault );
			     	delegate.findByIdName( model.currentProjects.projectId, "Property Updation" );
			     break;		
			     default:
			     break; 
			}
		} 			
		
		private function afterDelete( rpcEvent:Object ):void {
			super.result( rpcEvent );
		}
		
		private function getAllEventsResult( rpcEvent:Object ):void {	
			super.result( rpcEvent );		
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection; 
			model.modelAdminHistoryColl.list = arrc.list; 
		}
		
		private function getProjectPropertyResult( rpcEvent:Object ):void {			
			model.modelPropertyEventsColl = rpcEvent.result as ArrayCollection;	
			super.result( rpcEvent );
		}
		
		private  function getEventsResult( rpcEvent:Object ):void {	
			super.result( rpcEvent );		
			var handler:IResponder = new Callbacks( result, fault );
			var eEvent:EventsEvent = new EventsEvent( EventsEvent.EVENT_GET_EVENTS, handler );			
			eEvent.dispatch();
	 	}
		
		private function getCurrentProjectEventsResult( rpcEvent:Object ):void {			
			model.currentProjectMessages = rpcEvent.result as ArrayCollection;	
			super.result( rpcEvent );
		}
		
		private function getPersonsEventsResult( rpcEvent:Object ):void {			
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.modelHistoryColl.list = arrc.list;
			super.result( rpcEvent );
		}
	}
}

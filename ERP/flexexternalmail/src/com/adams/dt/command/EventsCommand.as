package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.EventsEvent;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Events;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	
	public final class EventsCommand extends AbstractCommand 
	{ 
		private var eventsEvent : EventsEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			eventsEvent= EventsEvent(event);
			this.delegate = DelegateLocator.getInstance().eventDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			 switch(event.type){    
			     /* case EventsEvent.EVENT_GET_ALL_EVENTSS:
			     	delegate.findAll();
			      break; 
			     case EventsEvent.EVENT_GET_EVENTS:
			     	delegate.responder = new Callbacks(getPersonsEventsResult,fault);
			     	delegate.findById(model.person.personId);
			      break;  */
			     case EventsEvent.EVENT_CREATE_EVENTS:
			     	delegate.responder = new Callbacks(getEventsResult,fault);
			     	delegate.create(eventsEvent.events);
			      break; 
			     /* case EventsEvent.EVENT_UPDATE_EVENTS:
			     	delegate.update(eventsEvent.events);
			      break; 
			     case EventsEvent.EVENT_DELETE_EVENTS:
			     	delegate.deleteVO(eventsEvent.events);
			      break; 
			     case EventsEvent.EVENT_SELECT_EVENTS:
			     	delegate.select(eventsEvent.events);
			      break; 		
			      case EventsEvent.EVENT_GETCURRENTPROJECT_EVENTS:
			      	delegate.responder = new Callbacks(getCurrentProjectEventsResult,fault);
			      	delegate.findByIdName(model.currentProjects.projectId,"Message");
			     	//delegate.findById(model.person.personId);
			      break; */ 		
			      	     
			     default:
			      break; 
			     }
		} 	
		public function getEventsResult(rpcEvent : Object ): void{	
			super.result(rpcEvent);		
			//var arrc : ArrayCollection = rpcEvent.result as ArrayCollection;
			
			/* var eEvent:EventsEvent = new EventsEvent(EventsEvent.EVENT_GET_EVENTS);			
			var handler:IResponder = new Callbacks(result,fault)
	 		var eventtaskSeq:SequenceGenerator = new SequenceGenerator([eEvent],handler)
	  		eventtaskSeq.dispatch(); */
		}
		
		/* public function getCurrentProjectEventsResult(rpcEvent : Object ): void{			
			model.currentProjectMessages = rpcEvent.result as ArrayCollection;	
			var fileEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_GET_BASICFILEDETAILS);
			var handler:IResponder = new Callbacks(result,fault)
	 		var msgtaskSeq:SequenceGenerator = new SequenceGenerator([fileEvent],handler)
	  		msgtaskSeq.dispatch();
			super.result(rpcEvent);
		}
		public function getPersonsEventsResult(rpcEvent : Object ): void{			
			var arrc : ArrayCollection = rpcEvent.result as ArrayCollection;
			trace("----EventsCommand-----"+arrc.length);	
			model.modelHistoryColl.list = arrc.list;
			trace("----EventsCommand-----"+model.modelHistoryColl.length);	
			super.result(rpcEvent);
		} */
	}
}

package com.adams.dt.command
{
	import com.adams.dt.business.IDAODelegate;
	import com.adams.dt.event.EventsEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.EventStatus;
	import com.adams.dt.model.vo.Events;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.commands.Command;
	
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.messaging.messages.ErrorMessage;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	public class AbstractCommand extends Command implements ICommand , IResponder
	{
		public var delegate:IDAODelegate;
		public var eventType:String;
		public var model : ModelLocator = ModelLocator.getInstance();
		override public function execute( event : CairngormEvent ) : void
		{
			eventType = event.type;
	        trace(eventType +'eventType')
			super.execute( event );
		}
	
		override public function result(info : Object) : void
		{ 
		
			super.result(info)
		}

		override public function fault( info:Object ):void {
			super.fault( info );
			var faultEvt:FaultEvent = info as FaultEvent;
			var errorMessage:ErrorMessage ;
			if( faultEvt.message && eventType!= EventsEvent.EVENT_CREATE_EVENTS ) {
				 errorMessage = faultEvt.message as ErrorMessage;
				var str:String = 'Please inform Admin\n\n System Message:\n' + this + '\n ' + eventType + '\n '+ errorMessage.faultString;
				var errEvent:Events = new Events()
				var by:ByteArray = new ByteArray();
				by.writeUTFBytes( str );
				errEvent.details = by;
				errEvent.eventName = 'Java DB Error'; 
				errEvent.eventDateStart = new Date();
				errEvent.eventType = EventStatus.JAVADBError;
				var eventsEvent:EventsEvent = new EventsEvent( EventsEvent.EVENT_CREATE_EVENTS );
				if( model.person.personLogin ) {
				 	errEvent.personFk = model.person.personId;
				 	eventsEvent.events =  errEvent;
				 	eventsEvent.dispatch();			 
				}	
				Alert.show(str);
			}
		} 
	}
}

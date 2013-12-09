package com.adams.dam.command
{
	import com.adams.dam.business.interfaces.IDAODelegate;
	import com.adams.dam.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.commands.Command;
	
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	import mx.messaging.messages.ErrorMessage;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	
	public class AbstractCommand extends Command implements ICommand, IResponder
	{
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		public var delegate:IDAODelegate;
		
		override public function execute( event:CairngormEvent ):void {
			trace( event.type +'                  eventType' );
			super.execute( event );
		}
		
		override public function result( info:Object ):void { 
			super.result( info );
		}
		
		override public function fault( info:Object ):void {
			super.fault( info );
			var faultEvt:FaultEvent = info as FaultEvent;
			var errorMessage:ErrorMessage = faultEvt.message as ErrorMessage;
			Alert.show( errorMessage.faultString );
		} 
	}
}

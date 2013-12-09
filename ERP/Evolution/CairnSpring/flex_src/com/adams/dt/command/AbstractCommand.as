package com.adams.dt.command
{
	import com.adams.dt.business.IDAODelegate;
	import com.adams.dt.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.commands.SequenceCommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.commands.Command;
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	public class AbstractCommand extends Command implements ICommand , IResponder
	{
		public var delegate:IDAODelegate;
		
		public var model : ModelLocator = ModelLocator.getInstance();
		
		/**
	     * Method Name execute.
	     * @param CairngormEvent Event value pass
	     * Use the delegate to execute the service.
		 * return type void
	     */	
		override public function execute( event : CairngormEvent ) : void
		{
	        super.execute( event );
		}
		
		/**
	     * Method Name result.
	     * @param data The payload from the service call.
	     * Handle the successful return of the common service.
		 * return type void
	     */	
		override public function result(info : Object) : void
		{ 
		
			super.result(info)
		}
		/**
	     * Method Name fault.
	     * @param info Object value pass
	     * Handle the failed return of the employee service.
		 * return type void
	     */	
		override public function fault(info : Object) : void
		{
			super.fault(info)
			var faultEvt : FaultEvent = info as FaultEvent;
			if(faultEvt.message!=null)
			Alert.show(this+'fault handler' +faultEvt.message)
		}
	}
}

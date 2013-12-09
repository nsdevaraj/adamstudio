package com.adams.dt.command
{
	import com.adams.dt.business.IDAODelegate;
	import com.adams.dt.model.ModelLocator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.commands.Command;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	public class AbstractCommand extends Command implements ICommand , IResponder
	{
		public var delegate:IDAODelegate;
		public var model : ModelLocator = ModelLocator.getInstance();
		override public function execute( event : CairngormEvent ) : void
		{
	        super.execute( event );
		}
	
		override public function result(info : Object) : void
		{ 
		
			super.result(info)
		}

		override public function fault(info : Object) : void
		{
			super.fault(info)
			var faultEvt : FaultEvent = info as FaultEvent;
			if(faultEvt.message!=null)
			Alert.show(this+' fault handler ' +faultEvt.message+" , "+faultEvt.type+" , "+faultEvt.message.body)
			
			//Alert.show("AbstractCommand fault handler " +faultEvt.message+" , "+faultEvt.type+" , "+faultEvt.message.body)

			//if(faultEvt.message!=null)
			//Alert.show(this+' fault handler ' +faultEvt.message+", "+faultEvt.type)
		}
		//public function executeNextCommand():void{}
	}
}

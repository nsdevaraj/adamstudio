package com.adams.dt.command.filedetails
{
	import com.adams.dt.business.LocalFileDetailsDAODelegate;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.event.LocalDataBaseEvent;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.data.SQLResult;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	public final class SearchLocalFileDetailsCommand extends AbstractCommand implements ICommand , IResponder
	{
		override public function execute( event : CairngormEvent ) : void
		{
			var localDataBaseEvent : LocalDataBaseEvent = LocalDataBaseEvent(event);
			var delegate : LocalFileDetailsDAODelegate = new LocalFileDetailsDAODelegate(  );			
			var result:SQLResult = delegate.(localDataBaseEvent.fileDetailsObj);
		}

		override public function result( rpcEvent : Object ) : void
		{
			
			super.result(rpcEvent);
			var dataArr : Array = (rpcEvent.data is Array)? rpcEvent.data : [];
			if(dataArr.length > 0)
			{			
				model.localFileExist = true;
			}else
			{
				model.localFileExist = false;
			}
		} 
	}
}

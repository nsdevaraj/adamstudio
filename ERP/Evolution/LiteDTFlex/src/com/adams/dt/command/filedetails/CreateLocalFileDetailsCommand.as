package com.adams.dt.command.filedetails
{
	import com.adams.dt.business.LocalFileDetailsDAODelegate;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.event.LocalDataBaseEvent;
	import com.adams.dt.model.vo.FileDetails;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.data.SQLResult;
	
	import mx.rpc.IResponder;
	
	public final class CreateLocalFileDetailsCommand extends AbstractCommand implements ICommand , IResponder
	{
		override public function execute( event : CairngormEvent ) : void
		{
			var fileDetailsEvent : LocalDataBaseEvent = LocalDataBaseEvent(event);
			var delegate : LocalFileDetailsDAODelegate = new LocalFileDetailsDAODelegate( );
			for each (var item:FileDetails in fileDetailsEvent.fileDetails){
				var result:SQLResult = delegate.addFileDetails(item);
			}
		} 
	}
}

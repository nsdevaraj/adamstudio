package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.ColumnsEvent;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	public final class ColumnsCommand extends AbstractCommand 
	{ 
		private var columnEvent : ColumnsEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			columnEvent =ColumnsEvent(event);
			this.delegate = DelegateLocator.getInstance().columnDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type){    
				case ColumnsEvent.EVENT_GET_ALL_COLUMNS:
					delegate.responder = new Callbacks(findAllResult,fault);
					delegate.findAll();
					break;  
				default:
					break; 
				}
		}
		 
		/**
		 * get All columns details
		 */
		public function findAllResult( rpcEvent : Object ) : void
		{ 
			model.totalColumnsColl = rpcEvent.result as ArrayCollection;
			super.result(rpcEvent);
		}
	}
}

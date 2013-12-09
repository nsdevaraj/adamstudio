package com.adams.dt.command
{ 
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.LangEvent;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.messaging.ChannelSet;
	public final class InitializeDTCommand extends AbstractCommand 
	{  
		private var channelSet : ChannelSet;
		
		/**
	     * Method Name execute.
	     * @param CairngormEvent  Event  value pass
	     * Use the delegate to execute the service.
		 * return type void
	     */		 
		override public function execute( event : CairngormEvent ) : void
		{	
			super.execute(event);
			this.delegate = DelegateLocator.getInstance().languageDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type){   
				case LangEvent.EVENT_GET_ALL_LANGS:
					delegate.responder = new Callbacks(findAllLangResult,fault); 
					delegate.findAll();
					break;          
				default:
					break; 
				}
		}  
		/**
	     * Method Name findAllLangResult.
	     * @param rpcEvent  Object  value pass
		 * return type void
	     */			
		public function findAllLangResult( rpcEvent : Object ) : void
		{ 
			super.result(rpcEvent);
			model.langEntriesCollection = rpcEvent.result as ArrayCollection;
			var sort : Sort = new Sort();
			sort.fields = [new SortField("formid")];
			model.langEntriesCollection.sort = sort;
			model.langEntriesCollection.refresh();
			model.myLoc.langXML = model.langEntriesCollection;
			model.loc = model.myLoc;
			model.loc.language = "en";
		} 
	}
}
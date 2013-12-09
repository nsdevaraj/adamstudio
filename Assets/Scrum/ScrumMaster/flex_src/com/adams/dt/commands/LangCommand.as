package com.adams.dt.commands
{
	import com.adams.dt.model.vo.CurrentInstanceVO;
	import com.adams.dt.model.vo.SignalVO;
	import com.adams.dt.service.IDTService;
	import com.adams.dt.signals.SignalSequence;
	import com.adams.dt.utils.Action;
	import com.adams.dt.utils.Destination;
	
	import flash.data.SQLResult;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import com.adams.dt.service.ConfigDetailsDAODelegate;
	

	public class LangCommand
	{
		[Inject]
		public var signalSequence:SignalSequence;
		
		[Inject]
		public var server:IDTService;
		
		private var getLangsSignal:SignalVO 
		[Inject]
		public var currentInstance:CurrentInstanceVO; 
		public function execute():void
		{
			getLangsSignal= new SignalVO(Action.GET_LIST, Destination.LANG_SERVICE);
			var delegate:ConfigDetailsDAODelegate = new ConfigDetailsDAODelegate();
			var result:SQLResult = delegate.getAllConfigDetails()
			var array:Array = [];
			array = result.data as Array;
			if(array!=null){
				var configArrColl:ArrayCollection= new ArrayCollection(array);
				for each(var obj:Object in configArrColl){
					currentInstance.config[obj.Property] = obj.Value;
				}
				server.baseURL = currentInstance.config.serverLocation;
				server.configServer();
				signalSequence.addSignal(getLangsSignal);
			}
			
		} 
	}
}
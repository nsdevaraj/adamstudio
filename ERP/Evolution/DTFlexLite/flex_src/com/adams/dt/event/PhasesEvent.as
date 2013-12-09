package com.adams.dt.event
{
	import com.adams.dt.model.vo.Phases;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class PhasesEvent extends UMEvent
	{
		public static const EVENT_GET_ALL_PHASESS : String = 'getAllPhases';
		public static const EVENT_GET_PHASES : String = 'getPhases';
		public static const EVENT_CREATE_PHASES : String = 'createPhases';
		public static const EVENT_UPDATE_PHASES : String = 'updatePhases';
		public static const EVENT_AUTO_UPDATE_PHASES: String = 'AutoupdatePhases';
		public static const EVENT_DELETE_PHASES : String = 'deletePhases';
		public static const EVENT_DELETEALL_PHASES : String = 'deleteAllPhases';
		public static const EVENT_SELECT_PHASES : String = 'selectPhases';
		public static const EVENT_BULK_UPDATE_PHASES : String = 'BulkUpdatePhases';
		public static const EVENT_CREATE_BULK_PHASES : String = 'CreateBulkPhases';
		public static const EVENT_UPDATE_LASTPHASE : String = 'UpdateLastPhases';
		
		public var phases : Phases;
		public var phasesCollection : ArrayCollection = new ArrayCollection();
		;
		public function PhasesEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pPhases : Phases = null )
		{
			phases = pPhases;
			super(pType,handlers,true,false,phases);
		}

	}
}

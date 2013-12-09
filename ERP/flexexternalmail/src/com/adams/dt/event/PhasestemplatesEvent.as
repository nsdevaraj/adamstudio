package com.adams.dt.event
{
	import com.adams.dt.model.vo.Phasestemplates;
	import com.adams.dt.model.vo.Workflows;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class PhasestemplatesEvent extends UMEvent
	{
		public static const EVENT_GET_ALL_PHASESTEMPLATESS : String = 'getAllPhasestemplates';
		
		/* public static const EVENT_GET_PHASESTEMPLATES : String = 'getPhasestemplates';
		public static const EVENT_CREATE_PHASESTEMPLATES : String = 'createPhasestemplates';
		public static const EVENT_UPDATE_PHASESTEMPLATES : String = 'updatePhasestemplates';
		public static const EVENT_DELETE_PHASESTEMPLATES : String = 'deletePhasestemplates';
		public static const EVENT_SELECT_PHASESTEMPLATES : String = 'selectPhasestemplates';
		public static const EVENT_BULKUPDATE_PHASESTEMPLATES : String = 'bulkupdatePhasestemplates';
		public static const EVENT_GETWORKFLOW_PHASESTEMPLATES : String = 'copypastePhasestemplates'; */
		
		public var phasestemplates : Phasestemplates;
		public var workFlow : Workflows = new Workflows();
		[ArrayElementType("com.adams.dt.model.vo.Phasestemplates")]
		public var phasestemplatesColl :ArrayCollection = new ArrayCollection;
		
		public function PhasestemplatesEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pPhasestemplates : Phasestemplates = null )
		{
			phasestemplates = pPhasestemplates;
			super(pType,handlers,true,false,phasestemplates);
		}

	}
}


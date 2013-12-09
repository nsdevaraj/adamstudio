package com.adams.dt.event
{
	import com.adams.dt.model.vo.Workflows;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.rpc.IResponder;
	public final class WorkflowsEvent extends UMEvent
	{
		public static const EVENT_GET_ALL_WORKFLOWSS : String = 'getAllWorkflows';
		public static const EVENT_GET_WORKFLOWS : String = 'getWorkflows';
		public static const EVENT_GET_WORKFLOW : String = 'getWorkflow';
		public static const EVENT_CREATE_WORKFLOWS : String = 'createWorkflows';
		public static const EVENT_UPDATE_WORKFLOWS : String = 'updateWorkflows';
		public static const EVENT_DELETE_WORKFLOWS : String = 'deleteWorkflows';
		public static const EVENT_SELECT_WORKFLOWS : String = 'selectWorkflows';
		public static const EVENT_TEAMLINETEMPLATE :String = "getTeamlinetemplate";
		public var workflows : Workflows;
		public function WorkflowsEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pWorkflows : Workflows = null  )
		{
			workflows = pWorkflows;
			super(pType,handlers,true,false,workflows);
		}

	}
}

package com.adams.dt.event.workFlowEvent
{
	import com.adams.dt.model.vo.WorkFlowset;
	import com.adams.dt.model.vo.Workflowstemplates;
	
	import flash.events.Event;
	
	import mx.core.IUIComponent;
	import mx.rpc.IResponder;
	
	public final class WorkflowDropEvent extends Event
	{
		public static const WORKFLOW_DROPPED : String = "workFlowDropped";
		public var selectedWFKSet : WorkFlowset;
		public var doppedWorkFlowUI : IUIComponent;
		
		public var frontWFKPrevious : Workflowstemplates ;
		public var frontWFKNext : Workflowstemplates ;
		public var backWFKNext  : Workflowstemplates ;
		public var backWFKPrevious : Workflowstemplates ;
		
		public function WorkflowDropEvent(type : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false )
		{
			super(type , bubbles , cancelable);
		}

	}
}
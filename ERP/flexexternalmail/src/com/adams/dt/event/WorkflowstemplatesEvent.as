package com.adams.dt.event
{
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.Workflows;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.IResponder;

	public class WorkflowstemplatesEvent extends UMEvent
	{
		public static const EVENT_GETMSG_WORKFLOWSTEMPLATES:String='getMsgWorkflowstemplates';
		public static const EVENT_GETMSG_WORKFLOWSTEMPLATESID:String='getMsgWorkflowstemplatesID';
		public static const EVENT_GET_ALL_WORKFLOWSTEMPLATESS:String='getAllWorkflowstemplates';
				
		/* public static const EVENT_GET_ALL_WORKFLOWSTEMPLATESS:String='getAllWorkflowstemplates';
		public static const EVENT_GET_WORKFLOWSTEMPLATES:String='getWorkflowstemplates';
		public static const EVENT_GET_WF_WORKFLOWSTEMPLATES:String='getbyidWorkflowstemplates';
		public static const EVENT_GETBYWFID_WORKFLOWSTEMPLATES:String='getbyWorkflowidWorkflowstemplates';
		
		public static const EVENT_GETBYSTOPLABEl_WORKFLOWSTEMPLATES:String='getbyStopLabelWorkflowstemplates';
		public static const EVENT_CREATE_WORKFLOWSTEMPLATES:String='createWorkflowstemplates';
		public static const EVENT_UPDATE_WORKFLOWSTEMPLATES:String='updateWorkflowstemplates';
		public static const EVENT_DELETE_WORKFLOWSTEMPLATES:String='deleteWorkflowstemplates';
		public static const EVENT_SELECT_WORKFLOWSTEMPLATES:String='selectWorkflowstemplates';
		public static const EVENT_GETFILEACCESS_WORKFLOWSTEMPLATES:String='getFileAccessWorkflowstemplates';
		public static const EVENT_GETFIRSTRELEASE_WORKFLOWSTEMPLATES:String='getFirstReleaseWorkflowstemplates';
		public static const EVENT_GETOTHERRELEASE_WORKFLOWSTEMPLATES:String='getOterReleaseWorkflowstemplates';
		//add by kumar July 15
		public static const EVENT_GET_ANNULATION_WORKFLOWSTEMPLATES:String='getAnnulationWorkflowstemplates';
		public static const EVENT_GET_CLOSE_WORKFLOWSTEMPLATES:String='getCloseWorkflowstemplates';
		public static const EVENT_BULK_UPDATE_WORKFLOWSTEMPLATES:String='bulkUpdateWorkflowstemplates'; */
		
		public var workflowstemplates:Workflowstemplates;
		public var tasks:Tasks;
		public var profile:Profiles;
		public var workflows:Workflows = new Workflows();
		
		[ArrayElementType("com.adams.dt.model.vo.Workflowstemplates")]
		public var workflowstemplatesColl:ArrayCollection = new ArrayCollection()
		public function WorkflowstemplatesEvent (pType:String, handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pWorkflowstemplates:Workflowstemplates=null )
		{
			workflowstemplates= pWorkflowstemplates;
			super(pType,handlers,true,false,workflowstemplates);
			
		}
	}
}
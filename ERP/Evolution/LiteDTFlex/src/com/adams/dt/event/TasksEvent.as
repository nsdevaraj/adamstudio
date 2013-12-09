package com.adams.dt.event
{
	import com.adams.dt.model.vo.Tasks;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class TasksEvent extends UMEvent
	{
		public static const CREATE_AUTO_INITIAL_TASKS : String = 'createAutoInitialTask';
		public static const CREATE_AUTO_TASKS : String = 'createAutoTask';
		public static const UPDATE_AUTO_TASKS : String = 'updateAutoTask';
		public static const EVENT_GET_ALL_TASKSS : String = 'getAllTasks';
		public static const EVENT_GET_TASKS : String = 'getTasks';
		public static const EVENT_GET_TASK : String = 'getTask';
		public static const EVENT_GET_SPECIFIC_TASK:String = 'getSpecificTask';
		public static const EVENT_UPDATE_TASKS_STATUS:String = 'updateTaskStat';
		public static const EVENT_CREATE_TASKS : String = 'createTasks';
		public static const EVENT_UPDATE_TASKS : String = 'updateTasks';
		public static const EVENT_UPDATE_TASKFILEPATH : String = 'updateTasksFilePath';
		public static const EVENT_DELETE_TASKS : String = 'deleteTasks';
		public static const EVENT_DELETEALL_TASKS : String = 'deleteAllTasks';
		public static const EVENT_SELECT_TASKS : String = 'selectTasks';
		public static const EVENT_FETCH_TASKS : String = 'fetchTasks';
		public static const CREATE_DTLITE_MSG:String = 'createDtLiteMessage';
		public static const CREATE_MSG_TASKS : String = 'createMessage';
		public static const CREATE_PROPERTYMSG_TASKS : String = 'createPropertyMessage';		
		public static const CREATE_MSG_TO_OPE_TASKS : String = 'createMessageToOperator';		
		public static const EVENT_UPDATE_MSG_TASKS : String = 'updateMessage';
		public static const CREATE_BULK_TASKS : String = 'createBulkTask';
		public static const CREATE_INITIAL_TASKS : String = 'createInitialTask';
		public static const CREATE_MAX_TASKSID : String = 'getTaskMaxId';
		public static const EVENT_PUSH_CREATE_TASKS : String = 'getPushTaskCreate';	
		public static const EVENT_PUSH_OPERATOR_MSG:String = 'pushOperatorMsg';	
		public static const EVENT_DELAY_PROJECT : String = 'getDelayedProjects';	
		public static const EVENT_PUSH_GET_TASKS : String = 'getConsumerTasksAll';
		public static const EVENT_UPDATE_CLOSETASKS : String = 'getUpdateCloseTasks';
		public static const EVENT_BULKUPDATE_CLOSETASKS : String = 'getBulkUpdateCloseTasks';		
		public static const EVENT_PUSH_INITIAL_TASKS : String = 'getPushInitialTask';
		public static const EVENT_BULKUPDATE_DELAYEDTASKS : String = 'getBulkUpdateDelayedTasks';
		public static const EVENT_BULKUPDATE_TASKSSTATUS : String = 'getBulkUpdateTasksStatus';
		public static const EVENT_BULKUPDATE_CLOSEPROJECTTASKS : String = 'getBulkUpdateCloseProjectTasks';
		public static const CREATE_NWEMSG_TASKS : String = 'getNewMessageTasks';
		public static const CREATE_STANDBY_TASKS : String = 'createStandByTasks';
		public static const UPDATE_LAST_TASKS : String = 'updateLastTasks';
		public static const GET_SPRINT_TASKS:String = 'getSprintTasks';
		
		public static const PUSH_ALL_PROJECT_PRESETTEMP : String = 'pushAllProjPresetsTemplate';	
		public static const EVENT_FINISHED_TASK : String = 'taskFinish';
		
		public static const EVENT_GETPROJECT_CLOSE : String = 'projectClose';
		public static const EVENT_GETABORTEDPROJECT_CLOSE : String = 'AbortedProjectClose';
		public static const CREATE_IMP_IND_MSG_TASKS : String = 'createImpIndMSG';
 		public static const EVENT_UPDATE_PDFREAD_ARCHIVE : String = 'updateIndPDFArchive';	
		public static const EVENT_PUSH_SEND_STATUSUPDATEPROJECT : String = 'getPushStatusupdate';
		public static const EVENT_MAILPUSH : String = 'MAILPUSH';
				
		public static const EVENT_PUSH_PROJECTNOTES : String = 'pushProjectNotes';
		
		public static const EVENT_TODO_LASTTASKSCOMMENTS : String = 'lastTaskComments';
		
		public static const CREATE_COMMON_PROFILE_MSGTASKS : String = 'commonProfileTaskComments';
		public static const EVENT_CREATE_BULKEMAILTASKS:String = 'createBulkEmailTasks';
		
		public static const EVENT_ORACLE_NAV_CREATETASKS:String = 'createNavTasksOracle';
		public static const EVENT_STATUSCHANGE_TASK:String = 'createStatusChangeTask';	
		
		public var totalMailCollection : ArrayCollection;
							
		public var taskeventtaskId:int;	
		public var taskeventProjectId : Number;
		public var tasks:Tasks = new Tasks();
		public var tasksCollection:ArrayCollection;
		public var uploadFile:Boolean;
		public var alertMessage:String;
		public var prjName:String;
		
		public var projPresetTemplateId:String;
		public var finishtasks : Tasks;
		public var producerPresetTempMessage:String = '';
		
		public var alertImpIndMsgTask:String;
		public var bulkMsgTaskPersonCollection : ArrayCollection;
		public var lastTaskProjectId : int;
		
		public var projectId:int;
		public var workflowFk:int;
		public var projectStatus:int;
		public var taskMessage:String;
		public var personFk:int;
		public var msgToOperatorId:String;
		
		public function TasksEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pTasks : Tasks = null  )
		{			
			tasks = pTasks;
			super(pType,handlers,true,false,tasks);
		}

	}
}

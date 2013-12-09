package com.adams.dt.event
{
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.model.vo.Tasks;
	import com.universalmind.cairngorm.events.UMEvent;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	public final class TasksEvent extends UMEvent
	{
		public static const EVENT_GET_TASKS:String='getTasks';  //use
		public static const EVENT_CREATE_TASKS:String='createTasks';  //use
		public static const EVENT_UPDATE_TASKS : String = 'updateTasks';
		public static const EVENT_MAILUPDATE_TASKS : String = 'updateMailTasks';	
		public static const CREATE_MSG_TASKS:String = 'createMessage';		
		
		public static const EVENT_GETMAILTASKID_TASKS:String='getTasksIdMail';	
		public static const EVENT_PUSH_CREATE_TASKS : String = 'getPushTaskCreate';	
		public static const EVENT_PUSH_GET_TASKS : String = 'getConsumerTasksAll';
		public static const EVENT_PUSH_STATUS_SEND : String = 'getPushTasksStatus';
		public static const EVENT_GET_EMAILSEARCH_TASKS : String = 'getEmailSearch';	
		
		public static const EVENT_UPDATE_TODO_TASKS : String = 'updateTodoTasks';
		public static const CREATE_PROPERTYMSG_TASKS : String = 'createPropertyMessage';	
		
		public static const EVENT_PUSH_CREATE_MESSAGE_TASKS : String = 'getPushTaskMessageCreate';	

		public static const EVENT_PUSH_MAIL_REPLY_MSG : String = 'mailReplyMessage';					
		
		public var tasks : Tasks;
		public var tasksCollection:ArrayCollection;
		
		public var emailId :String;
		
		public var taskevtfiledetailsVo:FileDetails;
		public var taskevtstoreByteArray:ByteArray = new ByteArray();
		public var taskevtfileName:String = "";
		public var taskevtfilePath:String = "";
		
		public function TasksEvent (pType : String , handlers:IResponder=null,bubbles:Boolean=true,cancelable:Boolean=false, pTasks : Tasks = null  )
		{			
			tasks = pTasks;
			super(pType,handlers,true,false,tasks);
		}
	}
}
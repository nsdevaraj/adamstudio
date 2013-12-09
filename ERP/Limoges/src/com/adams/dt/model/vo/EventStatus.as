package com.adams.dt.model.vo
{
	import com.adams.swizdao.model.vo.AbstractVO;
	
	import mx.collections.ArrayCollection;
	
	public final class EventStatus extends AbstractVO
	{
		public static var PROJECTCREATED : int;
		public static var PROJECTINPROGRESS : int;
		public static var PROJECTSTANDBY : int;
		public static var PROJECTABORTED : int;
		public static var PROJECTARCHIVED : int;
		public static var CHATONLINE : int;
		public static var CHATOFFLINE : int;
		public static var CHATCONVERSATION : int;
		public static var NEXTTASK : int;
		public static var PREVIOUSTASK : int;
		public static var FILEUPLOADED : int;
		public static var FILEDELETE:int;
		public static var FILEREPLACE:int;
		public static var TASKNOTSTARTED : int;
		public static var TASKLAUNCHED : int;
		public static var TASKINPROGRESS : int;
		public static var TASKSTANDBY : int;
		public static var TASKFINISHED : int;
		public static var TASKMESSAGESEND : int;
		public static var TASKMESSAGEREPLY : int;
		public static var PHASENOTSTARTED : int;
		public static var PHASELAUNCHED : int;
		public static var PHASEINPROGRESS : int;
		public static var PHASESTANDBY : int;
		public static var PHASEFINISHED : int;
		public static var IMPMAIL : int;
		public static var INDMAIL : int;
		public static var REGISTERED : int;
		public static var SMTPError : int;
		public static var JAVADBError : int;		
		
		private static var _eventStatusColl:ArrayCollection;
		
		public static function set eventStatusColl( arrc:ArrayCollection ):void {
			_eventStatusColl = arrc;
			for each( var status:Status in _eventStatusColl ) {
				switch( status.statusLabel ) {
					case 'Project created':
						PROJECTCREATED = status.statusId
					break;
					case 'Project Inprogress':
						PROJECTINPROGRESS = status.statusId
					break;
					case 'Project StandBy':
						PROJECTSTANDBY = status.statusId
					break;
					case 'Project Aborted':
						PROJECTABORTED = status.statusId
					break;
					case 'Project Archived':
						PROJECTARCHIVED = status.statusId
					break;
					case 'Chat Online':
						CHATONLINE = status.statusId
					break;
					case 'Chat Offline':
						CHATOFFLINE = status.statusId
					break;
					case 'Chat Conversation':
						CHATCONVERSATION = status.statusId
					break;
					case 'Task Notstarted':
						TASKNOTSTARTED = status.statusId
					break;
					case 'Task Inprogress':
						TASKINPROGRESS = status.statusId
					break;
					case 'Task StandBy':
						TASKSTANDBY = status.statusId
					break;
					case 'Task Finished':
						TASKFINISHED = status.statusId
					break;
					case 'Task Message Send':
						TASKMESSAGESEND = status.statusId
					break;
					case 'Task Message Reply':
						TASKMESSAGEREPLY = status.statusId
					break;
					case 'Phase Not Started':
						PHASENOTSTARTED = status.statusId
					break;
					case 'Phase launched':
						PHASELAUNCHED = status.statusId
					break;
					case 'Phase Inprogress':
						PHASEINPROGRESS = status.statusId
					break;
					case 'Phase StandBy':
						PHASESTANDBY = status.statusId
					break;
					case 'Phase Finished':
						PHASEFINISHED = status.statusId
					break;					
					case 'Task launched':
						TASKLAUNCHED = status.statusId
					break;
					case 'File uploaded':
						FILEUPLOADED = status.statusId
					break;
					case 'File Delete':
						FILEDELETE = status.statusId;
					break;
					case 'File Replace':
						FILEREPLACE = status.statusId;
					break;
					case 'Next task':
						NEXTTASK = status.statusId
					break;
					case 'Previous task':
						PREVIOUSTASK = status.statusId
					break;	
					case 'IMPMAIL':
						IMPMAIL = status.statusId
					break;
					case 'INDMAIL':
						INDMAIL = status.statusId
				 	break;	
					case 'New Registry Entry':
						REGISTERED = status.statusId
					break;	
					case 'SMTP Error':
						SMTPError = status.statusId
					break; 
					case 'Java DB Error':
						JAVADBError = status.statusId
					break;		
				}
			}
		}
		
		public static function get eventStatusColl():ArrayCollection {
			return _eventStatusColl
		}
	}
}

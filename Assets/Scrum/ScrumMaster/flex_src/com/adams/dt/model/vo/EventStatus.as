package com.adams.dt.model.vo
{
	import mx.collections.ArrayCollection;
	
	public final class EventStatus
	{
		public static var PROJECTCREATED : int;
		//done      (WAITING)
		public static var PROJECTINPROGRESS : int;
		//done
		public static var PROJECTSTANDBY : int;
		//Now not use
		public static var PROJECTABORTED : int;
		//Now not use
		public static var PROJECTARCHIVED : int;
		//Now not use
		public static var CHATONLINE : int;
		//done
		public static var CHATOFFLINE : int;
		//done
		public static var CHATCONVERSATION : int;
		//done
		public static var NEXTTASK : int;
		//done
		public static var PREVIOUSTASK : int;
		//done
		public static var FILEUPLOADED : int;
		//Now not use
		public static var TASKNOTSTARTED : int;
		//Now not use
		public static var TASKLAUNCHED : int;
		//done          (WAITING)
		public static var TASKINPROGRESS : int;
		//done
		public static var TASKSTANDBY : int;
		public static var TASKFINISHED : int;
		//done
		public static var TASKMESSAGESEND : int;
		//done
		public static var TASKMESSAGEREPLY : int;
		//done
		public static var PHASENOTSTARTED : int;
		//Now not use
		public static var PHASELAUNCHED : int;
		//          (WAITING)
		public static var PHASEINPROGRESS : int;
		//
		public static var PHASESTANDBY : int;
		public static var PHASEFINISHED : int;
		public static var IMPMAIL : int;
		public static var INDMAIL : int;
		public static var REGISTERED : int;
		//
		public function EventStatus()
		{
		}
		private static var _eventStatusColl:ArrayCollection;
		public static function set eventStatusColl(arrc:ArrayCollection):void{
			_eventStatusColl = arrc;
			for each(var status:Status in _eventStatusColl){
				switch(status.statusLabel){
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
				}
			}
		}
		public static function get eventStatusColl():ArrayCollection{
			return _eventStatusColl
		}
	}
}

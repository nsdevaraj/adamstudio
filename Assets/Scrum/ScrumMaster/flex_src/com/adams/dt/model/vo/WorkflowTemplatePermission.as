package com.adams.dt.model.vo
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public final class WorkflowTemplatePermission
	{
		public static var ANNULATION : int;
		public static var FILEACCESS : int;
		public static var VERSIONLOOP : int;
		public static var FIRSTRELEASE : int;
		public static var OTHERRELEASE : int;
		public static var DOSSIERCLOTURE : int;
		public static var MESSAGE : int;
		public static var CLOSED : int;
		public static var ALARM : int;
		public static var STANDBY : int;
		public static var SENDIMPMAIL : int;
		public static var PDFREADER : int;
		public static var CHECKIMPREMIUR:int;	
		public static var IMPVALIDATOR:int;
		public static var INDVALIDATOR:int;	
		
		public function WorkflowTemplatePermission()
		{
		}
		private static var _workFlowTempStatusColl:ArrayCollection;
		public static function set workFlowTempStatusColl(arrc:ArrayCollection):void{
			_workFlowTempStatusColl = arrc;
			for each(var status:Status in _workFlowTempStatusColl){
				switch(status.statusLabel){
					case 'ANNULATION':
					ANNULATION = status.statusId
					break;
					case 'FILEACCESS':
					FILEACCESS = status.statusId
					break;
					case 'VERSION LOOP':
					VERSIONLOOP = status.statusId
					break;
					case 'FIRSTRELEASE':
					FIRSTRELEASE = status.statusId
					break;
					case 'OTHERRELEASE':
					OTHERRELEASE = status.statusId
					break;
					case 'DOSSIER CLOTURE':
					DOSSIERCLOTURE = status.statusId
					break;
					case 'MESSAGE':
					MESSAGE = status.statusId
					break;
					case 'CLOSED':
					CLOSED = status.statusId
					break;
					case 'ALARM':
					ALARM = status.statusId
					break;
					case 'STANDBY':
					STANDBY = status.statusId
					break;
					case 'SEND IMPMAIL':
					SENDIMPMAIL = status.statusId
					break;
					case 'PDFREADER':
					PDFREADER = status.statusId
					break;
					case 'CHECKIMPREMIUR':
					CHECKIMPREMIUR = status.statusId;
					break;
					case 'IMPVALIDATOR':
					IMPVALIDATOR = status.statusId;
					break;
					case 'INDVALIDATOR':
					INDVALIDATOR = status.statusId;
					break;
					default :
					break;
				}
			}
		}
		public static function get workFlowTempStatusColl():ArrayCollection{
			return _workFlowTempStatusColl
		}
	}
}
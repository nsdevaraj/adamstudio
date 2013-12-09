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
					break
					
					
				}
			}
		}
		public static function get workFlowTempStatusColl():ArrayCollection{
			return _workFlowTempStatusColl
		}
	}
} 

/* package com.adams.dt.model.vo
{
	public final class WorkflowTemplatePermission
	{
		public static const ANNULATION : String = '21';
		public static const FILEACCESS : String = '22';
		public static const VERSIONLOOP : String = '23';
		public static const FIRSTRELEASE : String = '24';
		public static const OTHERRELEASE : String = '25';
		public static const DOSSIERCLOTURE : String = '26';
		public static const MESSAGE : String = '27';
		public static const CLOSED : String = '28';
		public static const ALARM : String = '29';
		public static const STANDBY : String = '49';
				
		public function WorkflowTemplatePermission()
		{
		}
	}
}  */


package com.adams.dt.model.vo
{
	import mx.collections.ArrayCollection;
	
	public final class PhaseStatus
	{
		public static var NOTSTARTED : int;
		public static var WAITING : int;
		public static var INPROGRESS : int;
		public static var STANDBY : int;
		public static var FINISHED : int;
		public function PhaseStatus()
		{
		}
		private static var _phaseStatusColl:ArrayCollection;
		public static function set phaseStatusColl(arrc:ArrayCollection):void{
			_phaseStatusColl = arrc
			for each(var status:Status in _phaseStatusColl){
				switch(status.statusLabel){
					case 'not_started':
					NOTSTARTED = status.statusId
					break;
					case 'waiting':
					WAITING = status.statusId
					break;
					case 'in_progress':
					INPROGRESS = status.statusId
					break;
					case 'stand_by':
					STANDBY = status.statusId
					break;
					case 'finished':
					FINISHED = status.statusId
					break;
					
				}
			}
		}
		public static function get phaseStatusColl():ArrayCollection{
			return _phaseStatusColl
		}
	}
}

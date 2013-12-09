package com.adams.dt.model.vo
{
	import mx.collections.ArrayCollection;
	
	public final class ProjectStatus
	{
		public static var WAITING : int;
		public static var INPROGRESS : int;
		public static var STANDBY : int;
		public static var ABORTED : int;
		public static var ARCHIVED : int;
		public static var URGENT : int;
		public function ProjectStatus()
		{
		}
		private static var _projectStatusColl:ArrayCollection;
		public static function set projectStatusColl(arrc:ArrayCollection):void{
			_projectStatusColl = arrc
			for each(var status:Status in _projectStatusColl){
				switch(status.statusLabel){
					case 'waiting':
					WAITING = status.statusId
					break;
					case 'in_progress':
					INPROGRESS = status.statusId
					break;
					case 'stand_by':
					STANDBY = status.statusId
					break;
					case 'aborted':
					ABORTED = status.statusId
					break;
					case 'archived':
					ARCHIVED = status.statusId
					break;
					case 'urgent':
					URGENT = status.statusId
					break;
				}
			}
		}
		public static function get projectStatusColl():ArrayCollection{
			return _projectStatusColl
		}
	}
}

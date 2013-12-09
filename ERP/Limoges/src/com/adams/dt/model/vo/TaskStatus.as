package com.adams.dt.model.vo
{
	import com.adams.swizdao.model.vo.AbstractVO;
	
	import mx.collections.ArrayCollection;
	
	public final class TaskStatus extends AbstractVO
	{
		public static var NOTSTARTED : int;
		public static var WAITING : int;
		public static var INPROGRESS : int;
		public static var STANDBY : int;
		public static var FINISHED : int; 
		
		private static var _taskStatusColl:ArrayCollection;
		public static function set taskStatusColl(arrc:ArrayCollection):void{
			_taskStatusColl = arrc
			for each(var status:Status in _taskStatusColl){
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
		public static function get taskStatusColl():ArrayCollection{
			return _taskStatusColl
		}
	}
}

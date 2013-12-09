package controller
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	[Event(name="sessionExpired", type="flash.events.Event")]
	public class SessionManager extends EventDispatcher 
	{
		private static var _instance:SessionManager;
		private var _timeStamp:Number = 0;
		private var _oldTimeStamp:Number = 0; 
		public function SessionManager(singleton:SingletonEnforcer)
		{
		}
		public static function getInstance():SessionManager{
			if(_instance == null){
					_instance = new SessionManager(new SingletonEnforcer())
			}
			return _instance
		}
		public function set timeStamp(timeval:Number):void{
			_oldTimeStamp = _timeStamp;
			_timeStamp = timeval;
			if(_oldTimeStamp!=0&&(_timeStamp - _oldTimeStamp)>30000){
				dispatchEvent(new Event("sessionExpired"));
			}
		}

	}
}
class SingletonEnforcer{
	
}
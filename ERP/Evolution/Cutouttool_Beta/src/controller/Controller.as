package controller
{
	import business.LoadDemoXml;
	
	import components.Interface.IComponents;
	
	import data.Tasks;
	import data.Users;
	
	import events.HistoryEvents;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class Controller extends EventDispatcher
	{
		private static var _instance:Controller;
		private var _histryObj:ArrayCollection = new ArrayCollection();
		private var _taskObj:ArrayCollection = new ArrayCollection();
		private var _userObj:Users;
		private var _uploadDeatilsObj:ArrayCollection = new ArrayCollection();
		private var _view:Array = new Array();
		private var _currentTaskObj:Tasks;
		public function Controller(singleton:SingletonEnforcer)
		{
				
		}
		public static function getInstance():Controller{
			if(_instance == null){
					_instance = new Controller(new SingletonEnforcer())
			}
			return _instance
		}
		public function set registerView(view:IComponents):void{
			//view.init();
			_view.push(view);
		}
		public function get histryObj():ArrayCollection
		{
			return _histryObj;
		}
		public function get taskObj():ArrayCollection
		{
			return _taskObj;
		}
		
		public function set histryObj(obj:ArrayCollection):void
		{
			_histryObj = obj;
		}
		public function updateHistryObj(obj:Object):void
		{
			_histryObj.addItem(Object);
		}
		public function set taskObj(obj:ArrayCollection):void
		{
			_taskObj = obj;
		}
		public function updateTaskObj(obj:Object):void
		{
			_taskObj.addItem(Object);
		}
		public function get currentTaskObj():Tasks
		{
			return _currentTaskObj;
		}
		
		public function set currentTaskObj(obj:Tasks):void
		{
			_currentTaskObj = obj;
		}
		public function get userObj():Users{
			return _userObj;
		}
		public function set userObj(obj:Users):void{
			_userObj = obj;
		}
		public function updateHistoryData(type:String):void{
			dispatchEvent(new HistoryEvents(type,HistoryEvents.UPDATEHISTORY));
		}
		private var _demoXmlObj:LoadDemoXml;
		public function set demoObj(obj:LoadDemoXml):void{
			_demoXmlObj = obj;
		}
		public function get demoObj():LoadDemoXml{
			return _demoXmlObj;
		}
		public function getTaskObj(taskId:String):Tasks{
			for(var i:int=0; i<taskObj.length;i++){
				if(taskObj[i].task.pk_task == taskId){
				   	var taskObject:Tasks = taskObj[i].task;
				   	return taskObject;
				}
			}
			return taskObject;
		}
		public function garbageCollection():void{
			 _view.forEach(clearObjects);
			 _taskObj.removeAll();
			_histryObj.removeAll();
			_userObj = null
			_uploadDeatilsObj.removeAll();
			Controller._instance = null;
			
		}
		public function clearObjects(element:IComponents, index:int, arr:Array):void{
			element.garbageCollection();
		}
	}
}
class SingletonEnforcer{
	
}
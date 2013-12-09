package business
{
	import components.CutOutToolInterface;
	
	public class UpdateView
	{
		private var _gropuId:String;
		private var _view:CutOutToolInterface;
		public function UpdateView(view:CutOutToolInterface, id:String)
		{
			_view = view
			groupId = id;
		}
		public  function get groupId():String{
			return _gropuId;
		}
		public  function set groupId(grp:String):void{
			_gropuId = grp;
		}
		
		public  function upadateInterfaceView():void{
			switch(_gropuId){
				case "group01":
					_view.backOffice.visible = false;
				break;
				case "group02":
					_view.newTask.visible=false;
				break;
				case "group03":
					
				break;
			}
			
		}
		
		public function selectedTaskView():void{
			
		}
		public function EditTaskView():void{
			
		}	

	}
}
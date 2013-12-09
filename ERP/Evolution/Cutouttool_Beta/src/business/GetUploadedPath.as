package business
{
	import controller.Controller;
	
	import mx.core.Application;
	
	public class GetUploadedPath
	{
		public function GetUploadedPath()
		{
			
		}
		
		public function getPath(file:String):String{
			var root:String = "uploadedFiles";
			var userType:String = (Controller.getInstance().userObj.type=="2")?"client":"supplier";
			var company:String = Controller.getInstance().userObj.company;
			var actionDate:String = new String();
			//actionDate = 
			var year:String = Controller.getInstance().currentTaskObj.datetime_of_creation.split("-")[0];
			var month:String = Controller.getInstance().currentTaskObj.datetime_of_creation.split("-")[1];
			var date:Array = Controller.getInstance().currentTaskObj.datetime_of_creation.split(" ");
			var folder:String = date[0].split("-").join("")+date[1].split(":").join("");
			var fPath:String = Application.application.docRoot+"Cutouttool_Beta-debug";
			return fPath+"/"+root+"/"+userType+"/"+company+"/"+year+"/"+month+"/"+folder+"/"+file;
		}

	}
}
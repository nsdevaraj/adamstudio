package business
{
	import mx.collections.ArrayCollection;
	
	public class AccessRights
	{
		public static var type1:ArrayCollection = new ArrayCollection([
        {name:"newTask", src:"assets/images/newTask.png"},
        {name:"pendingTask", src:"assets/images/pendingTask.png"},
        {name:"report", src:"assets/images/Report.png"},
        {name:"logOut", src:"assets/images/logout.png"}]);
        
        public static var type2:ArrayCollection = new ArrayCollection([
        {name:"pendingTask", src:"assets/images/pendingTask.png"},
        {name:"report", src:"assets/images/Report.png"},
        {name:"logOut", src:"assets/images/logout.png"}]);
        
        public static var type3:ArrayCollection = new ArrayCollection([
        {name:"pendingTask", src:"assets/images/pendingTask.png"},
        {name:"report", src:"assets/images/Report.png"},
        {name:"backOffice", src:"assets/images/backOffice.png"},
        {name:"logOut", src:"assets/images/logout.png"} ]);
        
        public static var type_1:Object = {BackOffice:false,NewTask:true,Reports:true,selectedTask_Edit:true,
        										selectedTask_Archive:true,
        										editTask_Delivery:false,
        										editTask_task:true,
        										editTask_images:true,
        										editTask_deatils:true,
        										editTask_expected:true,
        										editTask_estimated:false,
        										editTask_timing:false,
        										editTask_status:false,
        										editTask_expectedTime:true,
        										editTask_estimatedTime:false};
		public static var type_2:Object = {BackOffice:false,NewTask:false,Reports:true,selectedTask_Edit:true,
												selectedTask_Archive:false,
												editTask_Delivery:true,
												editTask_task:false,
        										editTask_images:false,
        										editTask_deatils:false,
        										editTask_expected:false,
        										editTask_estimated:true,
        										editTask_estimatedTime:true,
        										editTask_expectedTime:false,
        										editTask_timing:true,
        										editTask_status:false};
        										
		public static var type_3:Object = {BackOffice:true,NewTask:false,Reports:true,selectedTask_Edit:false,
												selectedTask_Archive:false,
												editTask_Delivery:false,
												editTask_task:true,
        										editTask_images:true,
        										editTask_deatils:true,
        										editTask_expected:true,
        										editTask_estimated:true,
        										editTask_timing:true,
        										editTask_status:true,
        										editTask_estimatedTime:true,
        										editTask_expectedTime:true};

		public function AccessRights()
		{
		}
		
		public static function getEditState(status:String,type:String):Boolean{
			var bool:Boolean = false;
			switch(status){
				case "waiting":
					bool = true
				break;
				case "inprogress":
					if(type=="2"||type=="3"){
						bool = true
					}else{
						bool = false
					}
				break;
				case "delivered":
					if(type=="1"||type=="3"){
						bool = true
					}else{
						bool = false
					}
				break;
				case "archived":
					if(type=="3"){
						bool = true
					}else{
						bool = false
					}				
				break;
			}
			return bool;
		}
		public static function getStatusState(status:String,type:String):Boolean{
			var bool:Boolean = false;
			switch(status){
				case "waiting":
   					bool = (type=="1"||type=="3")?false:true;
				break;
				case "inprogress":
					bool = (type=="1"||type=="3")?false:true;
				break;
				case "delivered":
					bool = (type=="1")?true:false;
				break;
				case "archived":
					bool = false			
				break;
			}
			
			return bool;
		}
		public static function getAppletVisible(status:String,type:String,index:int):Boolean{
			trace(status,type,index)
			var bool:Boolean = false;
			switch(status){
				case "waiting":
   					bool = (type=="1"&& index==0)?true:false;
				break;
				case "inprogress":
					bool = (type=="2" && index==1)?true:false;
				break;
				case "delivered":
					bool = false;
				break;
				case "archived":
					bool = false			
				break;
			}
			
			return bool;
		}
		public static function getIndex(status:String,type:String,index:int):int{
			var indexVal:int = 0;
			switch(status){
				case "waiting":
   					if(type=='1'){
   						indexVal = (index==0)?1:0;
   					}else if(type=='2'){
   						indexVal = (index==0)?2:0;
   					}
				break;
				case "inprogress":
					if(type=='1'){
   						indexVal = 0;
   					}else if(type=='2'){
   						indexVal = (index==0)?2:1;
   					}
				break;
				case "delivered":
					if(type=='1'){
   						indexVal = (index==0)?0:2;
   					}else if(type=='2'){
   						indexVal = 0;
   					}
				break;
				case "archived":
					indexVal = 0;
				break;
			}
			
			return indexVal;
		}
		public static function getButtonVisi(status:String,type:String,index:int):Boolean{
			var bool:Boolean = false;
			switch(status){
				case "waiting":
   					bool = (index==0)?true:false;
				break;
				case "inprogress":
					if(index==0){
						bool = true;
					}else if(index==1){
						bool = (type=='1')?false:true;
					}
				break;
				case "delivered":
					bool = true;
				break;
				case "archived":
					bool = true;
				break;
			}
			
			return bool;
		}


	}

}
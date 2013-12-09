package business
{
	import business.communication.RemoteCommunicator;
	
	import data.Tasks;
	
	public class newDataEntry
	{
		private const USERS:String = "users";
		private const HISTORY:String = "history"
		private const TASKS:String = "tasks";
		private var taskFieldObj:Object = {pk_task:'',
									   	label:'',									   
										comments:'',
										status:'',
										creator:'',
										datetime_of_creation:'',
										number_of_images:'',
										dedline:'',
										datetime_of_estimated:'',
										date_of_delivery:'',
										datetime_archive:'',
										time_spending:'',
										activated:''
									 }
		public function newDataEntry()
		{
		}
		public function updateNewTask(obj:Tasks):void{
			var query:String = new String();
			var updateTable:RemoteCommunicator = new RemoteCommunicator();
			updateTable.updateQuery  =  getUpdateStr(obj);
			updateTable.updateTable();			
		}
		public function getUpdateStr(obj:Tasks):String{
			var fieldVal:String = ""
			var dataVal:String = ""
			for(var i:String in taskFieldObj){
				if(obj[i]==null||obj[i]==undefined){					
				}else{
					fieldVal+=i+",";
					dataVal+="'"+obj[i]+"' ,";
				}
			}
			fieldVal = fieldVal.substring(0,fieldVal.length-1);
			dataVal = dataVal.substring(0,dataVal.length-1);
			var query:String = 'insert into '+TASKS+' ('+fieldVal+') values ('+dataVal+')';
			//query = '"'+query+'"';
			trace(query);
			return query;
		}

	}
}
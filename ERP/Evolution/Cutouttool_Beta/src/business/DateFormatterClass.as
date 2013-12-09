package business
{
	import mx.validators.DateValidator;
	
	public class DateFormatterClass
	{
		public static const millisecondsPerDay:int = 1000 * 60; 
		public static var monthDisplay:Array =  ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","sep",
		 								"Oct","Nov","Dec"];
		public function DateFormatterClass()
		{
			
		}
		
		public static function displayFormat(str:String):String{
			var tempDate:Array = str.split(" ");
			var dateFormat:Array = tempDate[0].split("-");
			var tempStr:String
			if(int(dateFormat[2])>0){
				dateFormat = [dateFormat[2],monthDisplay[Number(dateFormat[1])-1],dateFormat[0]]
				tempStr = dateFormat.join("-")+","+tempDate[1];
			}else{
				tempStr='';
			}
			return tempStr;
		}
		public static function backendFormat(str:String):String{
			var tempDate:Array = str.split(" ");
			var dateFormat:Array = tempDate[0].split("-");
			var monthStr:String = String(monthDisplay.indexOf(dateFormat[1])+1)
			monthStr = (Number(monthStr)>9)?monthStr:'0'+monthStr;
			dateFormat = [dateFormat[2],monthStr,dateFormat[0]]
			var tempStr:String = dateFormat.join("-")+" "+tempDate[1];
			return tempStr;
		}
		
		public static function getDiffrenceBtDate(start:String,end:String,stTime:String,endTime:String):String{
			var startDate:Date = new Date(start.split("/")[2],Number(start.split("/")[0])-1,start.split("/")[1],stTime.split(":")[0],stTime.split(":")[1],stTime.split(":")[2]);
			var endDate:DateValidator = new Date(end.split("/")[2],Number(end.split("/")[0])-1,end.split("/")[1],endTime.split(":")[0],endTime.split(":")[1],endTime.split(":")[2]);
			
			return String(Math.ceil(( endDate.getTime() - startDate.getTime())/millisecondsPerDay));
		}
		
		public static function getMonth(date:String):String{
			var dateStr:String = new String();
			dateStr = date;
			dateStr = String(monthDisplay.indexOf(dateStr.split('-')[1])+1)
			return dateStr
		}
		public static function getDay(date:String):Number{
			var dateStr:String = new String();
			dateStr = date;
			dateStr = dateStr.split("-")[0]
			return Number(dateStr);
		}
		public static function getDateObj(date:String):Date{
			var dateArr:Array = date.split(" ");
			var dateObj:Date = new Date(Number(dateArr[0].split("-")[0]),Number(dateArr[0].split("-")[1])-1,Number(dateArr[0].split("-")[2]),Number(dateArr[1].split(":")[0]),Number(dateArr[1].split(":")[1]),Number(dateArr[1].split(":")[1]))
			return dateObj;
		}
		

	}
}
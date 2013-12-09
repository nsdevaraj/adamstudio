package business
{
	import controller.Controller;
	
	import data.Users;
	
	import mx.collections.ArrayCollection;
	import mx.core.IUIComponent;
	
	public class GenerateReport
	{
		private var _reportView:IUIComponent;
		private var month_arr:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
		private var dataTipArr:Array =  ["January","February","March","April","May","June","July","August","september",
		 								"October","November","December"];
		private var year_Report:ArrayCollection = new ArrayCollection();
		private var _yearCollection:ArrayCollection = new ArrayCollection();
		private var userObj:Users = Controller.getInstance().userObj;
		public function GenerateReport()
		{
			super();		
		}
		public function getReportQueryBt(year:Number,startMonth:Number,endMonth:Number):String{
			var yearStr:String =new String(year);
			var startmonthStr:String = new String(startMonth);
			var endmonthStr:String = new String(endMonth);
			startmonthStr = (startmonthStr.length==1)?("0"+startmonthStr): startmonthStr;
			endmonthStr = (endmonthStr.length==1)?("0"+endmonthStr): endmonthStr;
			var query:String;
			if(Controller.getInstance().userObj.type == "1"){
				query = "select t.userid,t.pk_task,t.label,t.pk_task,t.number_of_images,t.date_of_delivery,t.time_spending,u.firstname,u.group_id from tasks t,users u where t.creator='"+userObj.group_id+"' and u.pk_user=t.userid and t.date_of_delivery between '"+
											
						yearStr+"-"+startmonthStr+"-01' and '"+yearStr+"-"+endmonthStr+"-31  23:59' order by date_of_delivery";
						
			}else{
				query = "select t.userid,t.pk_task,t.label,t.pk_task,t.number_of_images,t.date_of_delivery,t.time_spending,u.firstname,u.group_id from tasks t,users u where t.userid = u.pk_user and t.date_of_delivery between '"+yearStr+"-"+startmonthStr+"-01' and '"+yearStr+"-"+endmonthStr+"-31  23:59' order by date_of_delivery";
			}
			trace(query);
			    return query;    
		}
		private function intialize():void{
			month_arr = [0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			year_Report = new ArrayCollection();
			_yearCollection = new ArrayCollection();
		}
		public function getReortData(xml:XML):ArrayCollection{
			intialize();
			var noOfRows:Number =  XMLList(xml.row).length();
			var reportList:XMLList = xml.row;
			var reportData:ArrayCollection = new ArrayCollection();
			for(var i:int = 0;i<noOfRows;i++){
				var id:String = unescape(reportList[i].pk_task);
				var labelVal:String = unescape(reportList[i].label);
				var taskVal:String = unescape(reportList[i].pk_task);
				var number_of_images:String = reportList[i].number_of_images;
				var name:String = unescape(reportList[i].firstname);
				var userGroup:String = reportList[i].group_id;
				var deliveryDate:String = DateFormatterClass.displayFormat(reportList[i].date_of_delivery);
				updateMonthCount(DateFormatterClass.getMonth(deliveryDate))
				deliveryDate = deliveryDate.split(",")[0];
				var hours:Number = getHours(Number(reportList[i].time_spending));
				var mins:Number = getmins(Number(reportList[i].time_spending));
				reportData.addItem({id:id,Task:labelVal,Delivery:deliveryDate,CreatedBy:name,QtImages:number_of_images,
										Timing:{Hours:hours, mins:mins}});
				}
				yearReport = reportData;
				generateYearCollection();				
				return getMonthReport(1);
			}
			private function updateMonthCount(_month:String):void{
				var monthVal:Number = Number(_month);
				month_arr[monthVal] = month_arr[monthVal]+1;
			}
			
			public function set yearReport(arr:ArrayCollection):void{
				year_Report = arr;
			}
			public function get yearReport():ArrayCollection{
				return year_Report;
			}
			private function generateYearCollection():void{
				_yearCollection = new ArrayCollection();
				for(var i:int=0;i<12;i++){				
					_yearCollection.addItem({toolTip:dataTipArr[i],noOfTask:month_arr[i+1]});
				}
			}
			public function get yearCollection():ArrayCollection{
				return _yearCollection;
			}
			public function getMonthReport(_month:Number):ArrayCollection{
				
				var indexArr:Array = getIndex(_month);
				trace(indexArr);
				var startIndex:Number = indexArr[0];
				var endIndex:Number = indexArr[1];
				var monthArr:Array = new Array();
				monthArr = year_Report.toArray();
				monthArr = monthArr.slice(startIndex,endIndex);
				lineChartCollection = createLineArray(new ArrayCollection(monthArr));
				return new ArrayCollection(monthArr);
			}
			private var _summaryOfHours:Number;
			private function set summaryOfHours(num:Number):void{
				
			}
			private function get summaryOfHours():Number{
				return _summaryOfHours;
			}
			private function createLineArray(month:ArrayCollection):ArrayCollection{
				var lineArr:Array = new Array();
				for(var i:int=1; i<=31;i++){
					var obj:Object = new Object();
					obj["date"]=i
					obj["total"]=0
					lineArr.push(obj);
				}
				for(var j:String in month){
					var date:Number = DateFormatterClass.getDay(month[j].Delivery);
					lineArr[date-1]['total']=Number(lineArr[date-1]['total'])+1;
					var taskid:String = lineArr[date-1]['total'];
					lineArr[date-1]["task_"+taskid]= month[j].QtImages;	
				}
				return new ArrayCollection(lineArr);
			}
			public var lineChartCollection:ArrayCollection = new ArrayCollection()
			private function getIndex(index:Number):Array{
				var count:Number = 0;
				var indexArr:Array = new Array();
				for(var i:int=0;i<=index;i++){
					count +=Number(month_arr[i]);					
					if(i == index-1){
						indexArr.push(count);
					}else if(i == index){
						indexArr.push(count);
					} 
					
				}
				return indexArr;
			}
			
			private function getHours(num:Number):Number{
				var hours:Number = Math.floor(num/60);
				return hours;
			}
			private function getmins(num:Number):Number{
				var min:Number = num%60;
				return min;
			}
		}
	}

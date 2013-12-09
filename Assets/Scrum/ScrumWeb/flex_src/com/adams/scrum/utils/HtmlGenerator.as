package com.adams.scrum.utils
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.Sprints;
	import com.adams.scrum.models.vo.Stories;
	import com.adams.scrum.models.vo.Tasks;
	import com.adams.scrum.models.vo.Tickets;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Panel;
	import mx.controls.Alert;
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	public class HtmlGenerator
	{
		private var _htmTemplate:String="<html>" +
										"<head>"+
										"<title>##fileName##</title>"+
										"<style>" +
										"table.sample {"+
										"background-color:#FFFFFF;"+
										"border: solid #000 1px;"+
										"border-left:0px;"+
										"font-size:13px;"+
										"font-family:verdana;"+
										"}"+
										"table.sample td {"+
										"border-LEFT: solid #666 1px;"+
										"border-TOP: solid #666 1px;"+
										"PADDING-LEFT:2PX;"+
										"WIDTH:120px;"+
										"text-align:center;"+
										"vertical-align:bottom;"+
										"}"+
										".toprow {"+
										"text-align: center;"+
										"background-color: #aaaaaa;"+
										"border-LEFT:solid #666 1px;"+
										"}"+
										"tr.d0 td {"+
										"background-color: #CC9999; color: black;"+
										"}"+
										"tr.d1 td {"+
										"background-color: #9999CC; color: black;"+
										"}"+
										"</style>"+
										"<body>"+
										"<P >"+
										"##HeaderDetails##"+
										"</P>"+
										"##_tabelContent##"+
										"</body>"+
										"</html>";
		
		/**
		 * Holds the column Tag and column Name of the table
		 **/
		private var gridColumn:String="";
		private var gridColumvalue:String="";
		
		private var gridTicketColumn:String="";
		private var gridTicketColumValue:String ="";
		
		
		[Inject("personDAO")]
		public var personDAO:AbstractDAO;
		
		[Inject("ticketDAO")]
		public var ticketDAO:AbstractDAO;
		
		/**
		 * Stores the Grid Tag and Grid Value of the table
		 **/
		private var gridContainer:String="";
		private var gridTicketContainer:String="";
		private var gridValues:String="";
		
		[Bindable]
		private var tabelContainer:String="";
		
		[Bindable]
		private var ticketContainer:String="";
		
		private var gridColumnArr:Array;
		private var gridTicketColumnArr:Array;
		
		private var gBytes:ByteArray = new ByteArray();	
		
		private var _totalHoursWorked:int
		
		/**
		 * Generate the Tabel Name for the task.
		 **/
		private function generateGridColumns() :void 
		{
			gridColumnArr = [];
			for( var i:int =0;i<Utils.GRID_TITLE_ARR.length;i++)
			{
				gridColumvalue += "<th bgcolor=#aaaaaa class=toprow>"+Utils.GRID_TITLE_ARR[i]+"</th>";
			}
			
			/// for the Ticket Column
			gridTicketColumnArr=[];
			for( var j:int =0;j<Utils.GRID_TICKET_TITLE_ARR.length;j++)
			{
				gridTicketColumValue += "<th bgcolor=#aaaaaa class=toprow>"+Utils.GRID_TICKET_TITLE_ARR[j]+"</th>";
			}
		}		
		
		/**
		 * Generate the  Total task tabels for the Selected Sprint
		 * and store in the local location.  
		 **/
		public var currentSprint:Sprints;
		public function createHtml( storiesColl:ArrayCollection ,sprint:Sprints ,ticketCollection:ArrayCollection ,
									personCollection:ArrayCollection,selectedDate:Date,ticketReport:Boolean):void 
		{
			
			generateGridColumns();
			for each ( var stories:Stories in storiesColl)
			{
				var taskArr:Array = [];
				var ticketArr:Array=[];
				var storyLabel:String =  Utils.expandStory(stories);;
				for each ( var task:Tasks in stories.taskSet)
				{
					var taskObj:Object = new Object();
					if(task.visible == 1)
					{
						taskObj.TaskId = task.taskId
						taskObj.Comment = task.taskComment
						taskObj.Status = Utils.getStatusName(task);
						taskObj.EstimationTime = task.estimatedTime
						taskObj.Done = task.doneTime
						taskObj.Balance = (int(task.estimatedTime) - int(task.doneTime))
						taskArr.push(taskObj);
					}
					for each ( var ticket:Tickets in ticketCollection )
					{
						if(task.taskId == ticket.taskFk && compareDate(ticket.ticketDate , selectedDate)&& ticketReport ){
							var ticketObj:Object = new Object();
							ticketObj.Ticket_of_Task = task.taskId
							ticketObj.Person = Persons(GetVOUtil.getVOObject(ticket.personFk,personCollection,'personId',Persons)).personFirstname;
							ticketObj.Hours_Spent = ticket.ticketTimespent;
							_totalHoursWorked +=ticket.ticketTimespent;
							ticketObj.Comments = ticket.ticketComments;
							ticketArr.push(ticketObj);
						}
					}
				}
				currentSprint = sprint;
				generateGrid(taskArr , storyLabel , stories ,ticketArr)
				ticketArr=[];
				gridContainer="";
				gridTicketContainer="";
				ticketContainer="";
				
			}
			
			var fileName:String = sprint.sprintLabel+"_taskdetails.html"
			var cContents:String = _htmTemplate;
			var createdDate:String = selectedDate.getDate()+"-"+selectedDate.getMonth()+"-"+selectedDate.getFullYear();
			var header:String = "TimeSheetReport for "+createdDate+"    "+" Total Hours "+_totalHoursWorked+"</br></br> Task Details"
			cContents = cContents.replace( "##HeaderDetails##", header );
			cContents = cContents.replace( "##fileName##", currentSprint.sprintLabel );
			cContents = cContents.replace( "##_tabelContent##", tabelContainer );
			gBytes.writeMultiByte( cContents, "utf-8" );
			Alert.show("Want to Export HTML report ?", "Reports", Alert.OK|Alert.CANCEL, null, saveHtml); 
		}
		/**
		 * Find the tickets Availble for the Selected Date 
		 **/
		public function compareDate (tDate : Date, sDate:Date) : Boolean
		{
			var resultVal : Boolean ;
			if (tDate.getDate() == sDate.getDate())
			{
				resultVal = true;
			}
			return resultVal;
		}
		protected function saveHtml( event:CloseEvent ):void
		{ 
			if ( event.detail == Alert.OK )
			{ 
				var fileRef:FileReference = new FileReference();
				fileRef.save(gBytes , currentSprint.sprintLabel+"_taskdetails.html");
			}
		}
		private function generateGrid(arr:Array ,title:String ,story:Stories,ticketArr:Array) :void
		{
			for( var j:int = 0; j < arr.length; j++ ) {
				
				gridContainer += "<tr class=d"+(j%2==0?1:0)+">" +
					"<td>"+arr[j].TaskId+"</td>" +
					"<td>"+arr[j].Comment+"</td>" +
					"<td>"+arr[j].Status+"</td>" +
					"<td>"+arr[j].EstimationTime+"</td>" +
					"<td>"+arr[j].Done+"</td>" +
					"<td>"+arr[j].Balance+"</td>" +
					"</tr>"
			}
			gridColumn= "<table border=0 class=sample cellPadding=0 cellSpacing=0 ><thead>"+
				"<tr>"+gridColumvalue+"</tr></thead>";
			
			title = "Story:-"+story.storyId+"   "+title+"<br/><br/>"
			gridContainer = "<tbody><tr>"+gridContainer+"</tbody></table>";
			if(ticketArr.length>0)
			{
				generateTicektGrid(ticketArr)	
			}
			tabelContainer += title+gridColumn+gridContainer;
			if(ticketContainer.length>0){ 
				tabelContainer += "<br/>Tickets of Story"+story.storyId+" <br/> "+ticketContainer;
			}
		}
		private function generateTicektGrid(arr:Array) :void
		{
			for( var j:int = 0; j < arr.length; j++ ) {
				gridTicketContainer += "<tr class=d"+(j%2==0?1:0)+">" +
					"<td>"+arr[j].Ticket_of_Task+"</td>" +
					"<td>"+arr[j].Person+"</td>" + 
					"<td>"+arr[j].Hours_Spent+"</td>" +
					"<td>"+arr[j].Comments+"</td>" +
					"</tr>"
			}
			gridTicketColumn= "<table border=0 class=sample cellPadding=0 cellSpacing=0 ><thead>"+
				"<tr>"+gridTicketColumValue+"</tr></thead>";
			
			gridTicketContainer = "<tbody><tr>"+gridTicketContainer+"</tbody></table>";
			ticketContainer += gridTicketColumn+gridTicketContainer+"<br/><br/>";
		} 
	}
}
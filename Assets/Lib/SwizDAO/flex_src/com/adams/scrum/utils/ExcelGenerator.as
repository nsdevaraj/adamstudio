package com.adams.scrum.utils
{
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.Sprints;
	import com.adams.scrum.models.vo.Stories;
	import com.adams.scrum.models.vo.Tasks;
	import com.adams.scrum.models.vo.Tickets;
	import com.alivepdf.colors.RGBColor;
	import com.alivepdf.data.Grid;
	import com.alivepdf.data.GridColumn;
	import com.alivepdf.layout.Align;
	
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;

	public class ExcelGenerator
	{
		private var gXLStemplate:String = "" +
										"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2//EN\"> " +
										"<HTML>" +
										"<HEAD>" +
										"    <META HTTP-EQUIV=\"CONTENT-TYPE\" CONTENT=\"application/octet_stream; charset=utf8\">" +
										"    <STYLE>" +
										"        <!-- " +
										"        BODY,DIV,TABLE,THEAD,TBODY,TFOOT,TR,TH,TD,P { font-family:\"Verdana\"; font-size:x-small }" +
										"         -->" +
										"    </STYLE>" +
										"</HEAD>" +
										"<BODY TEXT=\"#000000\">" + 
										"<TR><TD></TD></TR>" +
										"<TR><TD></TD></TR>" +
										"<BR>" +
										"<BR>" +
										"<TABLE Border=\"0\">" +
										"    <TR><TD ColSpan=\"6\"><FONT Size=\"+3\">##REPORTHEADER##</FONT></TD></TR>" + 
										"    <TR><TD></TD><TD></TD><TD></TD>" + 
										"</TABLE>" + 
										"<TABLE Border=\"0\">" +
										"    <TR><TD ColSpan=\"6\"><FONT Size=\"+3\">##TITLE##</FONT></TD></TR>" + 
										"    <TR><TD></TD><TD></TD><TD></TD>" + 
										"</TABLE>" + 
										"<BR>" +
										"<BR>" +
										"<TABLE FRAME=VOID CELLSPACING=0 COLS=4 BORDER=1>" +
										"    <COLGROUP>##COLDESC##</COLGROUP>" +
										"    <TBODY>" +
										"        ##HEADERS##" +
										"        ##ROWS##" +
										"    </TBODY>" +
										"</TABLE>" +
										"<BR>"+
										"<TABLE Border=\"0\">" +
										"    <TR><TD ColSpan=\"6\"><FONT Size=\"+3\">##TICKET##</FONT></TD></TR>" + 
										"    <TR><TD></TD><TD></TD><TD></TD>" + 
										"    <TR></TD></TR>" +
										"</TABLE>" + 
										"<TABLE FRAME=VOID CELLSPACING=0 COLS=4 BORDER=1>" +
										"    <COLGROUP>##TICKETDESC##</COLGROUP>" +
										"    <TBODY>" +
										"        ##TICKETHEADERS##" +
										"        ##TICKETROWS##" +
										"    </TBODY>" +
										"</TABLE>" +
										"<TABLE>" + 
										"<TR><TD></TD><TD></TD><TD><FONT Size=\"+1\">End of report</FONT></TD></TR>" +
										"<TR><TD></TD></TR>" +
										"<TR><TD></TD></TR>" +
										"<BR>" + 
										"</TABLE>" +
										"</BODY>" +
										"</HTML>";
		
		private var gridColumnArr:Array;
		private var gridTicketColumnArr:Array;
		private var gBytes:ByteArray = new ByteArray();
		public var cSprint:Sprints;
		private var ticketDetails:Array = [];
		private function generateGridColumns() :void 
		{
			/// for the Task Column
			gridColumnArr = [];
			for( var i:int =0;i<Utils.GRID_TITLE_ARR.length;i++)
			{
				var pdfGridColumn:GridColumn = new GridColumn(Utils.GRID_TITLE_ARR[i],Utils.GRID_TITLE_ARR[i],25, Align.CENTER, Align.CENTER );
				gridColumnArr.push(pdfGridColumn);
			}
			/// for the Ticket Column
			gridTicketColumnArr=[];
			for( var j:int =0;j<Utils.GRID_TICKET_TITLE_ARR.length;j++)
			{
				var ticketGridColumn:GridColumn = new GridColumn(Utils.GRID_TICKET_TITLE_ARR[j],Utils.GRID_TICKET_TITLE_ARR[j],25, Align.CENTER, Align.CENTER );
				gridTicketColumnArr.push(ticketGridColumn);
			}
		}
		public function createExcel( storiesColl:ArrayCollection , currentSprint:Sprints ,ticketCollection:ArrayCollection ,
									 personCollection:ArrayCollection,selectedDate:Date,ticketReport:Boolean):void 
		{
			generateGridColumns();
			cSprint = currentSprint;
			for each ( var stories:Stories in storiesColl)
			{
				var taskArr:Array = [];
				var storyLabel:String =  Utils.expandStory(stories);
				for each ( var task:Tasks in stories.taskSet)
				{
					var taskObj:Object = new Object()
					if(task.visible == 1)
					{
						taskObj.TaskId = task.taskId 
						taskObj.Comment = task.taskComment
						taskObj.Status = Utils.getStatusName(task);
						taskObj.EstimationTime = task.estimatedTime
						taskObj.Done = task.doneTime
						taskObj.Balance = (int(task.estimatedTime) - int(task.doneTime))
						taskObj.ticketDetails =[];
						for each ( var ticket:Tickets in ticketCollection )
						{
							if(task.taskId == ticket.taskFk && compareDate(ticket.ticketDate,selectedDate) && ticketReport ){
								var ticketObj:Object = new Object();
								ticketObj.Ticket_of_Task = task.taskId
								ticketObj.Person = Persons(GetVOUtil.getVOObject(ticket.personFk,personCollection,'personId',Persons)).personFirstname;
								ticketObj.Hours_Spent = ticket.ticketTimespent;
								ticketObj.Comments = ticket.ticketComments;
								taskObj.ticketDetails.push(ticketObj); 
							}
						} 
						taskArr.push(taskObj);
					}
				}
				generateGrid(taskArr , storyLabel ,stories,selectedDate) 
			}
			Alert.show("Want to Export EXCEL report ?", "Reports", Alert.OK|Alert.CANCEL, null, saveEXCEL); 
		}
		
		public var cContents:String
		public var titleBol:Boolean
		private function generateGrid(taskData:Array ,title:String,story:Stories,selectedDate:Date) :void
		{
			cContents = gXLStemplate;
			var taskColDesc:String = "";
			var ticketColDesc:String = "";
			var taskHeader:String = "";
			var ticketHeader:String = "";
			var taskRows:String = "";
			var ticketRows:String = "";
			var taskCols:Array;
			var ticketCols:Array;
			// to set the Report Title Name For the Excel Report....
			if(!titleBol)
			{
				var createdDate:String = selectedDate.getDate()+"-"+selectedDate.getMonth()+"-"+selectedDate.getFullYear();
				var timeSheetTitle:String = "Time Sheet Report for " +createdDate 
				cContents = cContents.replace( "##REPORTHEADER##", timeSheetTitle );
				titleBol = true;
			}else{
				cContents = cContents.replace( "##REPORTHEADER##", "" );
			}
			
			cContents = cContents.replace( "##TITLE##", "Stories: "+story.storyId+"  "+title );
			var ticketGridArr:Array=[];
			var ticketBol:Boolean
			for( var i:int=0;i<taskData.length;i++)
			{
				if(taskData[i].ticketDetails != undefined)
				{
					for( var h:int=0; h<taskData[i].ticketDetails.length; h++)
					{
						trace(taskData[i].TaskId+'tickets length' +taskData[i].ticketDetails.length)
						ticketGridArr.push(taskData[i].ticketDetails[h]);
						ticketBol = true;
					}
				}
			}
			var taskGrid:Grid = new Grid(taskData, 200, 120, new RGBColor ( 0x666666 ), new RGBColor (0xCCCCCC), true, new RGBColor( 0 ), .1, null, gridColumnArr );
			taskCols = taskGrid.columns;
			for( var j:int = 0; j < taskCols.length; j++ ) {
				taskColDesc += "<COL WIDTH=" + taskCols[ j ].width + ">";
			}
			
			cContents = cContents.replace( "##COLDESC##", taskColDesc );
			taskHeader = "<TR>"
			
			for( var k:int = 0; k < taskCols.length; k++ ) {
				taskHeader += "<TD><FONT Size=2>" + taskCols[ k ].headerText + "</FONT></TD>";
			}
			taskHeader += "</TR>"
			cContents = cContents.replace( "##HEADERS##", taskHeader );
			
			for( var m:int = 0; m < taskData.length; m++ ) {
				
				taskRows += "<TR>";
				for( var n:int = 0; n < taskGrid.columns.length; n++ ) {
					var fieldEntry:String
					var numVal:Number = Number( taskData[ m ][ taskGrid.columns[ n ].dataField ] )
					if( isNaN( numVal ) ){
						fieldEntry = taskData[ m ][ taskGrid.columns[ n ].dataField ];
					}
					else {
						fieldEntry = "'"+String( taskData[ m ][ taskGrid.columns[ n ].dataField ] );
					}
					taskRows += "<TD>" +fieldEntry + "</TD>";
				}
				taskRows += "</TR>";
			}
			cContents = cContents.replace( "##ROWS##", taskRows );
			
			if(ticketBol)
			{
				var ticketGrid:Grid = new Grid(ticketGridArr, 200, 120, new RGBColor ( 0x666666 ), new RGBColor (0xCCCCCC), true, new RGBColor( 0 ), .1, null, gridTicketColumnArr );
				ticketCols = ticketGrid.columns;
				for( var mm:int = 0; mm < ticketCols.length; mm++ ) {
					ticketColDesc += "<COL WIDTH=" + ticketCols[ mm ].width + ">";
				}
				cContents = cContents.replace( "##TICKETDESC##", taskColDesc );
				ticketHeader = "<TR>"
				
				for( var mn:int = 0; mn < ticketCols.length; mn++ ) {
					ticketHeader += "<TD><FONT Size=2>" + ticketCols[ mn ].headerText + "</FONT></TD>";
				}
				ticketHeader += "</TR>"
				cContents = cContents.replace( "##TICKETHEADERS##", ticketHeader );
				
				for( var mp:int = 0; mp < ticketGridArr.length; mp++ ) {
					ticketRows += "<TR>";
					for( var no:int = 0; no < ticketGrid.columns.length; no++ ) {
						var fieldEntrys:String
						var numVals:Number = Number( ticketGridArr[ mp ][ ticketGrid.columns[ no ].dataField ] )
						if( isNaN( numVals ) ){
							fieldEntrys = ticketGridArr[ mp ][ ticketGrid.columns[ no].dataField ];
						}
						else {
							fieldEntrys = "'"+String( ticketGridArr[ mp ][ ticketGrid.columns[ no ].dataField ] );
						}
						ticketRows += "<TD>" +fieldEntrys + "</TD>";
					}
					ticketRows += "</TR>";
				}
				trace(ticketGridArr.length + ' - ticket of story'+story.storyId )
				var ticketTitle:String = "Tickets of Story - "+story.storyId 
				cContents = cContents.replace( "##TICKET##",  ticketTitle);
				cContents = cContents.replace( "##TICKETROWS##", ticketRows );
			}
			else{
				cContents = cContents.replace( "##TICKETDESC##", "" );
				cContents = cContents.replace( "##TICKETHEADERS##", "" );
				cContents = cContents.replace( "##TICKETROWS##", "" );
				cContents = cContents.replace( "##TICKET##",  "" );
			}
			
			gBytes.writeMultiByte( cContents, "utf-8" );  
			
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
		protected function saveEXCEL( event:CloseEvent ):void
		{ 
			if ( event.detail == Alert.OK )
			{ 
				var fileRef:FileReference = new FileReference();
				fileRef.save(gBytes , cSprint.sprintLabel+".xls");
			}
		}
	}
}
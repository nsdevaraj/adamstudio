package com.adams.scrum.utils
{
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.Sprints;
	import com.adams.scrum.models.vo.Stories;
	import com.adams.scrum.models.vo.Tasks;
	import com.adams.scrum.models.vo.Tickets;
	import com.alivepdf.colors.RGBColor;
	import com.alivepdf.data.Grid;
	import com.alivepdf.data.GridColumn;
	import com.alivepdf.display.Display;
	import com.alivepdf.drawing.Caps;
	import com.alivepdf.drawing.Joint;
	import com.alivepdf.fonts.CoreFont;
	import com.alivepdf.fonts.FontFamily;
	import com.alivepdf.fonts.Style;
	import com.alivepdf.layout.Align;
	import com.alivepdf.layout.Layout;
	import com.alivepdf.layout.Orientation;
	import com.alivepdf.layout.Size;
	import com.alivepdf.layout.Unit;
	import com.alivepdf.pdf.PDF;
	import com.alivepdf.saving.Method;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;

	public class PdfGenerator
	{
		private var _generatePDF:PDF;
		private var gBytes:ByteArray = new ByteArray();
		private var _taskResultArray:Array = []; 
		private var _ticketResultArray:Array = []; 
		public var cSprint:Sprints;
		private var ticketDetails:Array = [];
		[Bindable]
		[Embed('assets/swf/Scrum_Assets.swf', symbol='waiting')]
		private  var Waiting:Class;

		[Bindable]
		[Embed('assets/swf/Scrum_Assets.swf', symbol='stand_by')]
		private var StandBy:Class;

		[Bindable]
		[Embed('assets/swf/Scrum_Assets.swf', symbol='in_progress')]
		private var InProgress:Class;
		
		[Bindable]
		[Embed('assets/swf/Scrum_Assets.swf', symbol='finished')]
		private var Finished:Class;

		private var displayDic:Dictionary = new Dictionary();
		public function PdfGenerator()
		{
			_generatePDF = new PDF( Orientation.LANDSCAPE, Unit.MM, Size.A4 );     
			_generatePDF.setDisplayMode( Display.REAL, Layout.SINGLE_PAGE );
			generateGridColumns();
		}
		
		/**
		 *  Adds a dynamic table to the current page. 
		 * This can be useful if you need to render large amount of data coming from an existing DataGrid or any data collection.
		 */
		public function createPdf( storiesColl:ArrayCollection , currentSprint:Sprints,ticketCollection:ArrayCollection ,
								   personCollection:ArrayCollection , selectedDate:Date,ticketReport:Boolean):void
		{
			var waitingObj:DisplayObject = new Waiting();
			displayDic['Waiting'] = waitingObj;
			
			var standByObj:DisplayObject = new StandBy();
			displayDic['StandBy'] = standByObj;

			var inProgressObj:DisplayObject = new InProgress();
			displayDic['InProgress'] = inProgressObj;
			
			var finishedObj:DisplayObject = new Finished();
			displayDic['Finished'] = finishedObj;
			
			cSprint = currentSprint;
			_generatePDF.getDic = displayDic;
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
						taskObj.ticketDetails = [];
						// For the Ticket Collection 
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
			Alert.show("Want to Export PDF report ?", "Reports", Alert.OK|Alert.CANCEL, null, savePDF); 
		}
		private function generateGridColumns() :void 
		{
			_taskResultArray = [];
			for( var i:int =0;i<Utils.GRID_TITLE_ARR.length;i++)
			{
				var pdfGridColumn:GridColumn = new GridColumn(Utils.GRID_TITLE_ARR[i],Utils.GRID_TITLE_ARR[i],25, Align.CENTER, Align.CENTER );
				_taskResultArray.push(pdfGridColumn);
			}
			_ticketResultArray = []
			for( var j:int =0;j<Utils.GRID_TICKET_TITLE_ARR.length;j++)
			{
				var ticketGrid:GridColumn = new GridColumn(Utils.GRID_TICKET_TITLE_ARR[j],Utils.GRID_TICKET_TITLE_ARR[j],25, Align.CENTER, Align.CENTER );
				_ticketResultArray.push(ticketGrid);
			}
		}
		private function generateGrid(arr:Array ,title:String ,story:Stories,cDate:Date) :void
		{
			var ticketGridArr:Array=[];
			var ticketBol:Boolean
			for( var i:int=0;i<arr.length;i++)
			{
				if(arr[i].ticketDetails != undefined)
				{
					for( var j:int=0;j<arr[i].ticketDetails.length;j++)
					{
						ticketGridArr.push(arr[i].ticketDetails[j]);
						ticketBol = true;
					}
				}
			}
			var taskGrid:Grid = new Grid(arr, 200, 120, new RGBColor ( 0x666666 ), new RGBColor (0xCCCCCC), true, new RGBColor( 0 ), .1, null, _taskResultArray );
			if(ticketBol)
			{
				var ticketGrid:Grid = new Grid(ticketGridArr, 200, 120, new RGBColor ( 0x666666 ), new RGBColor (0xCCCCCC), true, new RGBColor( 0 ), .1, null, _ticketResultArray );
			}
			
			_generatePDF.addPage();
			_generatePDF.textStyle( new RGBColor(0xFF0000), 0.5 ); 
			statusLabel();
			var createdDate:String = cDate.getDate()+"-"+cDate.getMonth()+"-"+cDate.getFullYear();
			var timeSheetTitle:String = "Time Sheet Report for " +createdDate 
			_generatePDF.addText( timeSheetTitle, 5, 10);
			_generatePDF.addGrid( taskGrid, 5, 15 );
			
			var taskTitle:String = "Story - "+story.storyId+"  "+title
			_generatePDF.addText( taskTitle, 5, 15);
			_generatePDF.textStyle( new RGBColor(0), 1 );
			
			if(ticketBol)
			{	
				var ticketTitle:String = "Tickets of Story - "+story.storyId 
				_generatePDF.addText( ticketTitle, _generatePDF.getX(), _generatePDF.getY()+10);
				_generatePDF.addGrid( ticketGrid,5,taskGrid.dataProvider.length*15 );
				ticketGridArr = [];
			}
		}
		
		private function statusLabel():void
		{
			var count:int = 0;
			var imageArr:Array  =['Waiting','StandBy','InProgress','Finished'] 
			_generatePDF.textStyle( new RGBColor(0), 1 );
			for( var i:int =0;i<imageArr.length;i++)
			{
				_generatePDF.addText( imageArr[i]+"   --->", 180, 23+count);
				_generatePDF.addImage(displayDic[imageArr[i]],null,200,10+count);
				count += 5;
			}
			
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
		protected function savePDF( event:CloseEvent ):void
		{ 
			if ( event.detail == Alert.OK )
			{ 
				gBytes = _generatePDF.save( Method.LOCAL );
				var fileRef:FileReference = new FileReference();
				fileRef.save(gBytes , cSprint.sprintLabel+".pdf");
			}
		}
	}
}
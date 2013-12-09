package com.adams.dt.model.scheduler.taskClasses
{
	import com.adams.dt.model.scheduler.util.DateUtil;
	import com.adams.dt.model.tracability.TaskBusinessCard;
	import com.adams.dt.model.vo.Phases;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Tasks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	public final class TaskData
	{	
		private var _colorArray:Array = ["0x2A7C69","0xB91854","0x005DB3","0xD91B00","0x5BC236"];
		private var _profileColor:Array = ["", "0xCCDDEE","0xFFDDEE","0x11AA22","0x22BBFF","0xDD99FE", "0xCCDD88"];
		[Bindable]
		public var projectNames:Array;
		[Bindable]
		public var archivedNames:Array;
		[Bindable]
		public var taskList:ArrayCollection;
		[Bindable]
		private var _taskEntryCollection:ArrayCollection;
		
		
		[Bindable]
		public function get taskEntryCollection():ArrayCollection {
			return _taskEntryCollection;
		}
		
		public function set taskEntryCollection( value:ArrayCollection ):void {
			_taskEntryCollection =  createTasks( value );
			
		}
		
		public function createPhases( dataCollection:ArrayCollection, str:String ):ArrayCollection {
			var result : Array = []; 	
			var rows:int = dataCollection.length;
			projectNames = [];
			archivedNames = [];
			var rows_Len:int=rows;
			for( var i : Number = 0; i < rows_Len; i++ ) {
				var row : IList = new ArrayCollection();
				projectNames[ i ] = Projects( dataCollection.getItemAt( i ) ).projectName;
				if( str == "Archive" ) {
					if( Projects( dataCollection.getItemAt( i ) ).projectDateEnd != null ) {
						var archiveStartDate:Date = new Date( Projects( dataCollection.getItemAt( i ) ).projectDateEnd.getTime() - DateUtil.DAY_IN_MILLISECONDS );
						var archiveEndDate:Date = Projects( dataCollection.getItemAt( i ) ).projectDateEnd;
						if( ( archiveStartDate != null ) && ( archiveEndDate != null ) ) {
							var archiveEntry : SimpleTask = createColoredEntry( i, archiveStartDate, archiveEndDate, 0, "", false, 0, projectNames[ i ],"","","",null,"",-1 );
							row.addItem( archiveEntry );
							result.push( row );
							archivedNames.push( Projects( dataCollection.getItemAt( i ) ).projectName );	
						}
					}
				}
				else {
					var phaseArray:ArrayCollection = Projects( dataCollection.getItemAt( i ) ).phasesSet;
					var phaseArray_Len:int=phaseArray.length;
					for( var j:int = 0; j < phaseArray_Len; j++ ) {
						var startDate : Date;
						var endDate: Date;
						if( str == "Pending" ) {
							startDate = Phases( phaseArray.getItemAt( j ) ).phaseStart;
							if( Phases( phaseArray.getItemAt( j ) ).phaseEnd == null ) {
								endDate = Phases( phaseArray.getItemAt( j ) ).phaseEndPlanified;
							}
							else {
								endDate = Phases( phaseArray.getItemAt( j ) ).phaseEnd;
							}
						}
						else if( str == "Planned" ) {
							if( j != 0 ) {
								startDate = Phases( phaseArray.getItemAt( j - 1 ) ).phaseEndPlanified;
							}
							else {
								startDate = Phases( phaseArray.getItemAt( j ) ).phaseStart;
							}
							endDate = Phases( phaseArray.getItemAt( j ) ).phaseEndPlanified;
						}
						else if( ( str == "Actual" ) || ( str == "History" ) ) {
							startDate = Phases( phaseArray.getItemAt( j ) ).phaseStart;
							endDate = Phases( phaseArray.getItemAt( j ) ).phaseEnd;
						} 
						var entryColor:uint = _colorArray[ j ];
						var entryLabel:String = Phases( phaseArray[ j ] ).phaseName;
						var phaseBelonging:int = Phases( phaseArray[ j ] ).phaseId;
						if( ( startDate != null ) && ( endDate != null ) ) {
							var entry : SimpleTask = createColoredEntry( j, startDate, endDate, entryColor, entryLabel, false, phaseBelonging, projectNames[ i ],"","","",null,"",-1 );
							row.addItem( entry );
						}
					}
					result.push( row ); 
				}	
			}
			return new ArrayCollection( result );
		}
		
		public function createTasks( dataCollection:ArrayCollection ):ArrayCollection {
			taskList = new ArrayCollection();
			var rows:int = dataCollection.length;
			var row : IList = new ArrayCollection();
			var result:Array = [];
			var rows_Len:int=rows;
			for( var j:int = 0; j < rows_Len; j++ ) {
				var startDate : Date = Tasks( dataCollection.getItemAt( j ) ).tDateCreation;
				var endDate: Date = Tasks( dataCollection.getItemAt( j ) ).tDateEnd;
				var entryColor:uint;
				if( Tasks( dataCollection.getItemAt( j ) ).workflowtemplateFK == null )	entryColor = 0xFF0000;
				else	 entryColor = _profileColor[ Tasks( dataCollection.getItemAt( j ) ).workflowtemplateFK.profileObject.profileId ];
				var entryLabel:String = "";
				var entryComment:String = String( Tasks( dataCollection.getItemAt( j ) ).taskComment );
				var entryPath:String = Tasks( dataCollection.getItemAt( j ) ).taskFilesPath;
				if(Tasks( dataCollection.getItemAt( j ) ).workflowtemplateFK!=null)
				var taskLabel:String = Tasks( dataCollection.getItemAt( j ) ).workflowtemplateFK.taskLabel;
				var taskBcard:TaskBusinessCard;
				if( Tasks( dataCollection.getItemAt( j ) ).personDetails != null ) {
					taskBcard = new TaskBusinessCard();
					taskBcard.personFirstName = Tasks( dataCollection.getItemAt( j ) ).personDetails.personFirstname;
					taskBcard.personLastName = Tasks( dataCollection.getItemAt( j ) ).personDetails.personLastname;
					taskBcard.pesonPosition = Tasks( dataCollection.getItemAt( j ) ).personDetails.personPosition;
					taskBcard.pesonPosition = Tasks( dataCollection.getItemAt( j ) ).personDetails.personPosition;
					taskBcard.perPicture = Tasks( dataCollection.getItemAt( j ) ).personDetails.personPict;
					taskBcard.company = Tasks( dataCollection.getItemAt( j ) ).personDetails.company;
					taskBcard.taskProfile = Tasks( dataCollection.getItemAt( j ) ).workflowtemplateFK.profileObject;
				}
				else {
					taskBcard = null;
				}
				if( ( startDate != null ) && ( endDate != null ) ) {
					taskList.addItem( Tasks( dataCollection.getItemAt( j ) ) );
					var entry : SimpleTask = createColoredEntry( j, startDate, endDate, entryColor, entryLabel, false, 0, "", entryComment, entryPath, taskLabel, taskBcard, 
					                                             taskBcard.taskProfile.profileLabel, ( taskList.length - 1 ) );
					row.addItem( entry );
				}
			}
			result.push( row );
			return new ArrayCollection( result );
		}
		
		private function createColoredEntry( i : Number, startDate : Date, endDate : Date, color : uint, label:String, finalTask:Boolean, val:int, name:String,
																   comment:String, path:String, taskLabel:String, taskBCard:TaskBusinessCard, profileTask:String, id:int ) : SimpleTask
		{
			var entry : ColouredTask = new ColouredTask();
			entry.startDate = startDate;
			entry.endDate = endDate;
			entry.label = label;
			entry.backgroundColor = color;
			entry.finalTask = finalTask;
			entry.phaseBelonging = val;
			entry.projectName = name;
			entry.taskComment = comment;
			entry.taskFilePath = path;
			entry.taskLabel = taskLabel;
			entry.taskBusinessCard = taskBCard;
			entry.profileTask = profileTask;
			entry.selectionId = id;
			
			return entry;
		}		
		
		private function randomInt( max : Number ) : Number
		{
			return Math.floor( Math.random() * max );
		}
	}
}
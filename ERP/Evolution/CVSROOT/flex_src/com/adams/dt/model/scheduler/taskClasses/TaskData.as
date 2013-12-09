package com.adams.dt.model.scheduler.taskClasses
{
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.model.scheduler.util.DateUtil;
	import com.adams.dt.model.tracability.TaskBusinessCard;
	import com.adams.dt.model.vo.Phases;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Tasks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	public final class TaskData
	{	
		private var _colorArray:Array = ["0x2A7C69","0xB91854","0x005DB3","0xD91B00","0x5BC236"];
		public var _profileColor:Array = ["", "0x000000","0x405418","0x2c1854","0x185452","0x185435", "0x541854","0x543818","0x544818","0x183054","0x54181a"];
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
			taskList = value;
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
						var archiveStartDate:Date = Projects( dataCollection.getItemAt( i ) ).projectDateStart;
						var archiveEndDate:Date = Projects( dataCollection.getItemAt( i ) ).projectDateEnd;
						if( ( archiveStartDate != null ) && ( archiveEndDate != null ) ) {
							var archiveEntry : ColouredEntry = createColoredEntry( i, archiveStartDate, archiveEndDate, 0, "", false, 0, projectNames[ i ],"","","",null,"",-1, false );
							row.addItem( archiveEntry );
							result.push( row );
							archivedNames.push( Projects( dataCollection.getItemAt( i ) ).projectName );	
						}
					}
				}
				else {
					var phaseArray:ArrayCollection = Projects( dataCollection.getItemAt( i ) ).phasesSet;
					var phaseArray_Len:int = phaseArray.length;
					for( var j:int = 0; j < phaseArray_Len; j++ ) {
						var startDate : Date;
						var endDate: Date;
						var entryColor:uint = _colorArray[ j ];
						if( str == "Planned" ) {
							if( j != 0 ) {
								startDate = Phases( phaseArray.getItemAt( j - 1 ) ).phaseEndPlanified;
							}
							else {
								startDate = Phases( phaseArray.getItemAt( j ) ).phaseStart;
							}
							endDate = Phases( phaseArray.getItemAt( j ) ).phaseEndPlanified;
						}
						else if( str == "Actual" ) {
							startDate = Phases( phaseArray.getItemAt( j ) ).phaseStart;
							endDate = Phases( phaseArray.getItemAt( j ) ).phaseEnd;
						} 
						var entryLabel:String = Phases( phaseArray[ j ] ).phaseName;
						var phaseBelonging:int = Phases( phaseArray[ j ] ).phaseId;
						if( ( startDate != null ) ) {
							if( endDate == null ) {
								endDate = new Date();
								entryColor = 0xFFFF00;
								var entry : ColouredEntry = createColoredEntry( j, startDate, endDate, entryColor, entryLabel, false, phaseBelonging, projectNames[ i ],"","","",null,"",-1, false );
								row.addItem( entry );
								break;
							}
							else {
								var myEntry:ColouredEntry = createColoredEntry( j, startDate, endDate, entryColor, entryLabel, false, phaseBelonging, projectNames[ i ],"","","",null,"",-1, false );
								row.addItem( myEntry );
							}
						}
					}
					result.push( row ); 
				}	
			}
			return new ArrayCollection( result );
		}
		
		public function createTasks( dataCollection:ArrayCollection ):ArrayCollection {
			var rows:int = dataCollection.length;
			var row : IList = new ArrayCollection();
			var result:Array = [];
			var rows_Len:int=rows;
			for( var j:int = 0; j < rows_Len; j++ ) {
				var startDate : Date = Tasks( dataCollection.getItemAt( j ) ).tDateCreation;
				var entryColor:uint;
				//if( Tasks( dataCollection.getItemAt( j ) ).workflowtemplateFK == null )	entryColor = 0xFF0000;
				//else	 entryColor = _profileColor[ Tasks( dataCollection.getItemAt( j ) ).workflowtemplateFK.profileFK];
				
				if( Tasks( dataCollection.getItemAt( j ) ).workflowtemplateFK == null ){	
					entryColor = 0xFF0000;
				}
				else{		
					var prof:Profiles = GetVOUtil.getProfileObject(Tasks( dataCollection.getItemAt( j ) ).workflowtemplateFK.profileFK);			
					// entryColor = uint(prof.profileColor);
					entryColor = uint(prof.profileColor);
				}
				
				var endDate: Date = Tasks( dataCollection.getItemAt( j ) ).tDateEnd;
				var currentTask:Boolean = false;
				if( endDate == null ) {
					endDate = new Date();
					currentTask = true;
					entryColor = 0xFFFF00;
				}  
				var entryLabel:String = "";
				var entryComment:String = String( Tasks( dataCollection.getItemAt( j ) ).taskComment );
				if( entryComment == 'null' )	entryComment = '';
				var entryPath:String = Tasks( dataCollection.getItemAt( j ) ).taskFilesPath;
				if(Tasks( dataCollection.getItemAt( j ) ).workflowtemplateFK!=null)
				var taskLabel:String = Tasks( dataCollection.getItemAt( j ) ).workflowtemplateFK.taskLabel;
				var taskBcard:TaskBusinessCard;
				taskBcard = new TaskBusinessCard();
				if( Tasks( dataCollection.getItemAt( j ) ).personDetails != null ) {
					taskBcard.personFirstName = Tasks( dataCollection.getItemAt( j ) ).personDetails.personFirstname;
					taskBcard.personLastName = Tasks( dataCollection.getItemAt( j ) ).personDetails.personLastname;
					taskBcard.pesonPosition = Tasks( dataCollection.getItemAt( j ) ).personDetails.personPosition;
					taskBcard.pesonPosition = Tasks( dataCollection.getItemAt( j ) ).personDetails.personPosition;
					taskBcard.perPicture = Tasks( dataCollection.getItemAt( j ) ).personDetails.personPict;
					taskBcard.company = GetVOUtil.getCompanyObject(Tasks( dataCollection.getItemAt( j ) ).personDetails.companyFk);
					taskBcard.taskProfile = Tasks( dataCollection.getItemAt( j ) ).workflowtemplateFK.profileObject;
				}
				if( ( startDate != null ) && ( endDate != null ) ) {
					var entry : ColouredEntry = createColoredEntry( j, startDate, endDate, entryColor, entryLabel, false, 0, "", entryComment, entryPath, taskLabel, taskBcard, 
					                                             Tasks( dataCollection.getItemAt( j ) ).workflowtemplateFK.profileObject.profileLabel, Tasks( dataCollection.getItemAt( j ) ).taskId, currentTask );
					row.addItem( entry ); 
				}
			}
			result.push( row );
			return new ArrayCollection( result );
		}
		
		private function createColoredEntry( i:Number, startDate:Date, endDate:Date, color:uint, label:String, finalTask:Boolean, val:int, name:String,
																   comment:String, path:String, taskLabel:String, taskBCard:TaskBusinessCard, profileTask:String, id:int, currentTask:Boolean ) : ColouredEntry
		{
			var entry:ColouredEntry = new ColouredEntry();
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
			entry.isCurrentTask = currentTask;
			return entry;
		}		
		
		private function randomInt( max : Number ) : Number
		{
			return Math.floor( Math.random() * max );
		}
	}
}
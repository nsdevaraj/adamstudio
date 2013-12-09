package com.adams.dt.business.util
{
	import com.adams.dt.event.PhasesEvent;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.scheduler.util.DateUtil;
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.model.vo.Phases;
	import com.adams.dt.model.vo.TaskStatus;
	import com.adams.dt.model.vo.Tasks;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	
	public class NavigationUtils
	{	
		private var tempObj : Object ={};
		[Bindable]
		private static var model:ModelLocator = ModelLocator.getInstance(); 
		private var phaseEventCollection : ArrayCollection = new ArrayCollection();

		public function NavigationUtils():void
		{
		}	
		public function getNavigationResult( arrcoll:ArrayCollection ) : void {
			var localtaskcoll:ArrayCollection = arrcoll;
			model.newTaskCreated = true;						 
			model.createdTask = arrcoll.getItemAt( 0 ) as Tasks;	
			//model.project = Tasks( rpcEvent.message.body ).projectObject;
			model.currentProjects= model.createdTask.projectObject;
			var eventsArr:Array = [];
			trace(" getNavigationResult createdTask taskId :"+model.createdTask.taskId);

			if(model.createdTask){
				trace(" getNavigationResult createdTask taskId :"+model.createdTask.taskId);
				if(model.createdTask.previousTask){
	            	trace(" getNavigationResult createdTask previousTask :"+model.createdTask.previousTask.taskId);
	            	if(model.createdTask.previousTask.fileObj){
	            		trace("\n getNavigationResult createdTask previousTask fileObj :"+model.createdTask.previousTask.fileObj.fileId);
	            	}
	            }
	        }
			
			checkPhases( model.createdTask );
			 
			var phaseEvent : PhasesEvent = new PhasesEvent( PhasesEvent.EVENT_UPDATE_PHASES );
			var taskupdateevent : TasksEvent = new TasksEvent( TasksEvent.EVENT_UPDATE_TASKS );
			var historyTasksEvent:TasksEvent = new TasksEvent( TasksEvent.EVENT_FETCH_TASKS );
			  
			if( phaseEventCollection.length > 0 ) {
				eventsArr.push( phaseEvent );
			}
			else if( model.currentTasks ) {
				trace("\n getNavigationResult EVENT_UPDATE_TASKS calling :"+model.createdTask.taskId);
				model.currentTasks.nextTask = model.createdTask;
				model.currentTasks.taskStatusFK = TaskStatus.FINISHED;
				if(model.currentTasks.previousTask){
	            	trace(" getNavigationResult previousTask :"+model.currentTasks.previousTask.taskId);
	            	if(model.currentTasks.previousTask.fileObj){
	            		trace("\n getNavigationResult previousTask fileObj :"+model.currentTasks.previousTask.fileObj.fileId);
	            	}
	            }
				eventsArr.push( taskupdateevent );
			}
			
			eventsArr.push( historyTasksEvent );
			
			for each( var item:FileDetails in model.currentProjectFiles ) {
				item.taskId = model.currentTasks.taskId;
				var filename:String = item.fileName; 
				var splitObject:Object = FileNameSplitter.splitFileName( item.fileName );
				
				if( item.taskId != 0 ) {
					filename = splitObject.filename + item.taskId + DateUtil.getFileIdGenerator() + "." + splitObject.extension;
	   			}
	   			if( item.type == "Tasks" && splitObject.extension == "pdf" ) {
	   				model.pdfConversion = true;
	   			}
	   			item.storedFileName = filename;
				item.projectFK = model.currentProjects.projectId;
				item.downloadPath = onUpload( item );
				model.filesToUpload.addItem( item );
			}
			
			if( model.filesToUpload.length > 0 ) {
				model.bgUploadFile.idle = true;
				model.bgUploadFile.fileToUpload = model.filesToUpload;
			}  
			var newProjectSeq:SequenceGenerator = new SequenceGenerator( eventsArr );
	  		newProjectSeq.dispatch(); 
		}
		private var newDate:Date; 
		private function checkPhases( createdTask:Tasks ):void {
			createdTask = setPhase( createdTask );
			var prevTask:Tasks;
			if( createdTask.previousTask ) {
				prevTask= setPhase( createdTask.previousTask );
			} 
			if( createdTask.workflowtemplateFK.phaseTemplateFK != 0 ) {
				if( createdTask.previousTask ) {
					//check the phase of new task is bigger than next task flow in wft
					if( createdTask.workflowtemplateFK.phaseTemplateFK > createdTask.previousTask.workflowtemplateFK.phaseTemplateFK ) {
						// the new task is first of the phase
						createdTask.firstofPhase = true;
					}
				}
				else {
					// the new task is first of the phase, first of the workflow
					createdTask.firstofPhase = true;
				} 
			} 
			
			//first of phase
			if( createdTask.firstofPhase ) {
				if( prevTask ) {
				// to fill phase end of prev task
					if( !prevTask.phase.phaseEnd ) { 
						prevTask.phase.phaseEnd = model.currentTime;
						if( model.AutoProj ) {
							prevTask.phase.phaseEnd = newDate;
						}
						prevTask.phase.phaseDuration = Math.ceil( ( prevTask.phase.phaseEnd.getTime() - prevTask.phase.phaseStart.getTime() ) / DateUtil.DAY_IN_MILLISECONDS );
						var planneddelay : Number = Math.ceil( ( prevTask.phase.phaseEndPlanified.getTime() - prevTask.phase.phaseEnd.getTime() ) / DateUtil.DAY_IN_MILLISECONDS );
						planneddelay = 0 -( planneddelay );
						prevTask.phase.phaseDelay = planneddelay;  
						phaseEventCollection.addItem( prevTask.phase );
					}
				}
				if(createdTask.phase!=null)	{	
					var index:int = createdTask.projectObject.phasesSet.getItemIndex( createdTask.phase );
					for( var i:int = index;i < createdTask.projectObject.phasesSet.length;i++ ) {
						if( i == index ) {
							Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseStart = model.currentTime; 
							if( model.AutoProj ) {
								Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseStart = newDate;
							} 
						}
						else {
							Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseStart = Phases( createdTask.projectObject.phasesSet.getItemAt( i - 1 ) ).phaseEndPlanified;
						}
						if( !Phases( createdTask.projectObject.phasesSet.getItemAt( 0 ) ).phaseEnd ) {
							Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseEndPlanified = model.tracTaskContent.getPlanifiedDate( Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseStart, Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseDuration );
						}	
						else {
							var duration:Number = Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseDuration;
							var delay:Number = Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseDelay;
							var diff:Number = duration - delay;
							if( !Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseEnd )
								Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseEndPlanified = model.tracTaskContent.getPlanifiedDate( Phases( createdTask.projectObject.phasesSet.getItemAt( i -1 ) ).phaseEndPlanified, diff );
							else
								Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseEndPlanified = new Date( Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ).phaseEnd.getTime() - ( delay * DateUtil.DAY_IN_MILLISECONDS ) );
						}
						phaseEventCollection.addItem( Phases( createdTask.projectObject.phasesSet.getItemAt( i ) ) );
					} 
				}
			}
			model.phaseEventCollection = phaseEventCollection;
		}		
	
		// set the phase for the provided task
		private function setPhase( task:Tasks ):Tasks {
			var sort : Sort = new Sort();
			sort.fields = [ new SortField( "phaseTemplateFK" ) ];
			if( task.projectObject.phasesSet ) {
				task.projectObject.phasesSet.sort = sort;
				task.projectObject.phasesSet.refresh();
				var cursor : IViewCursor = task.projectObject.phasesSet.createCursor();
				var phase : Phases = new Phases();
				phase.phaseTemplateFK = task.workflowtemplateFK.phaseTemplateFK;
				var found : Boolean = cursor.findAny(phase);
				if( found ) {
					task.phase = Phases( cursor.current );
				}
			}
			return task;
		}
		
		private function onUpload( fileObj:FileDetails ):String {
        	var uploadfile:File = new File( fileObj.downloadPath );
        	var fullPath:String = "DTFlex" + File.separator + String( fileObj.destinationpath + File.separator + fileObj.type ).split( model.parentFolderName )[ 1 ] + "/" + fileObj.storedFileName;
        	trace("onUpload fullPath :"+fullPath);
        	var copyToLocation:File = File.userDirectory.resolvePath( fullPath ); 
        	if( uploadfile.exists && !copyToLocation.exists ) {
        		uploadfile.copyTo( copyToLocation, true ); 
        	}	
        	return copyToLocation.nativePath;
  	 	} 
	}
}
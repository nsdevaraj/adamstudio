package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.LocalFileDetailsDAODelegate;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.event.PDFTool.CommentEvent;
	import com.adams.dt.event.PDFTool.PDFInitEvent;
	import com.adams.dt.event.PDFTool.updateSVGDataEvent;
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.model.vo.PDFTool.CommentVO;
	import com.adams.dt.model.vo.PDFTool.PDFDetailVO;
	import com.adams.dt.model.vo.PDFTool.SVGDetailVO;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.data.SQLResult;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
 	public final class NotesCommand extends AbstractCommand 
	{ 
		private var commentEvent : CommentEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
		 	commentEvent = event as CommentEvent;
			this.delegate = DelegateLocator.getInstance().commentDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type){    
				case CommentEvent.ADD_COMMENT:
					delegate.responder = new Callbacks(createCommentResult,fault);
					delegate.create(commentEvent.commentVO);
					break; 
				case CommentEvent.REMOVE_COMMENT:
					delegate.deleteVO(commentEvent.commentVO);
					removeComment(commentEvent.commentID);
					break; 
				case CommentEvent.UPDATE_COMMENT: 
					//removeUpdateComment(commentEvent.commentID , commentEvent.commentVO);
					delegate.responder = new Callbacks(updateCommentResult,fault);
					delegate.directUpdate(commentEvent.commentVO);
					break; 
				case CommentEvent.DELETEALL_COMMENT: 
				delegate.responder = new Callbacks(result,fault);
					delegate.deleteAll();
					break;  
				case CommentEvent.GET_COMMENT: 
					delegate.responder = new Callbacks(addCommentResult,fault);
					delegate.findByNums(commentEvent.fileFk,commentEvent.compareFileFk);
					break; 
				case updateSVGDataEvent.UPDATE_SVGDATA:
					model.svgDetailVO.svgDetailData = SVGDetailVO.SVG_BEGIN + model.svgDetailVO.svgData + SVGDetailVO.SVG_TERMINATOR;
					break; 
				case PDFInitEvent.PDF_INIT:
				
				 model.pdfDetailVO.initDone = true;
 					if(model.currentTasks.previousTask != null&&!(Utils.checkTemplateExist(model.messageTemplatesCollection,model.currentTasks.workflowtemplateFK.workflowTemplateId)))
					{
						//TRA is DIADEM purpose
						if(model.currentProfiles.profileCode == 'FAB' || model.currentProfiles.profileCode == 'CLT' || model.currentProfiles.profileCode == 'TRA')
						{
							versonLoop = Utils.getWorkflowTemplates(model.versionLoop,model.currentTasks.workflowtemplateFK.workflowFK);
							model.compareTask = getCompareTask(model.currentTasks);
							model.compareTasksCollection = new ArrayCollection();
							 var tempColl:ArrayCollection = getCompareTasksCollection(model.currentTasks);
							 var sort:Sort = new Sort(); 
							 sort.fields = [ new SortField( "taskId" ) ];
				             tempColl.sort = sort;
				             tempColl.refresh(); 
				             var object:Object = new Object();
			             	object['label'] = '';
				             model.compareTasksCollection.addItem(object)
				             for each(var item:Tasks in tempColl){
				             	var obj:Object = new Object();
				             	obj['label'] = "Release V"+(model.compareTasksCollection.length);
				             	obj['tasks'] = item;
				             	model.compareTasksCollection.addItem(obj)
				             	
				             } 
							if(!model.compareTask)model.compareTask = new Tasks();
							if(model.compareTask.taskId==0){
								model.compareTask = getInterCompareTask(model.currentTasks);
							}
							if(model.compareTask.taskId!=0&&model.pdfFileCollection.length>0){								
								model.compareTask.taskFilesPath = 'assets/images/preloader.png';
								var delegate : LocalFileDetailsDAODelegate = new LocalFileDetailsDAODelegate();
								if(model.compareTask.fileObj!=null){			
									var result:SQLResult = delegate.getSwfFileDetails(model.compareTask.fileObj);
									var array:Array = [];
									array = result.data as Array;
									if(array!=null){
										model.comaparePdfFileCollection = new ArrayCollection(array);
										model.compareTask.taskFilesPath = model.comaparePdfFileCollection.getItemAt(0).filePath;
										
									}else{
										var fileEvents:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_GET_SWFFILEDETAILS);
										fileEvents.fileDetailsObj = model.compareTask.fileObj;
										fileEvents.dispatch()
										model.loadComareTaskFiles = true;
									}
								}
							} else{
							}
								
						}else
						{
							model.compareTask = new Tasks();
						}
						
						if(model.pdfFileCollection.length>0){
							model.currentTasks.previousTask.taskFilesPath = model.pdfFileCollection.getItemAt(0).filePath;
							if(Utils.checkTemplateExist(model.indReaderMailTemplatesCollection,model.currentTasks.workflowtemplateFK.workflowTemplateId))
							{
								model.currentTasks.taskFilesPath = model.pdfFileCollection.getItemAt(0).filePath;
							}
						}else{
							model.currentTasks.previousTask.taskFilesPath = 'assets/images/preloader.png';
						}
						var commentEvent : CommentEvent = new CommentEvent(CommentEvent.GET_COMMENT);
						if(model.pdfFileCollection.length>0){
							model.currentSwfFile = FileDetails(model.pdfFileCollection.getItemAt(0));
							commentEvent.fileFk = FileDetails(model.pdfFileCollection.getItemAt(0)).remoteFileFk;
						}
						if(model.comaparePdfFileCollection.length>0)
							commentEvent.compareFileFk = FileDetails(model.comaparePdfFileCollection.getItemAt(0)).remoteFileFk
						commentEvent.dispatch()
						//model.pdfDetailVO.update(model.compareTask ,model.currentTasks.previousTask , model.currentProfiles.profileCode);
					}
					break;
				default:
					break; 
				}
		}
		private var versonLoop:Workflowstemplates = new Workflowstemplates();
		private function getCompareTask(_task : Tasks) : Tasks
		{
			var task : Tasks;

			if(_task.previousTask != null)
			{
				if(_task.workflowtemplateFK.phaseTemplateFK < versonLoop.phaseTemplateFK
				||_task.workflowtemplateFK.taskLabel=="CHECKING VALIDATION REQUEST"||_task.workflowtemplateFK.taskLabel=="CHECKING")//(RELECTURE V1 --> CHECKING) (COMPLEMENTS DE RELECTURE --> CHECKING VALIDATION REQUEST)
				{
					task = new Tasks()
				}else if(_task.previousTask.workflowtemplateFK.workflowTemplateId == versonLoop.workflowTemplateId )
				{
					 task = _task.previousTask;					 
					 if(model.currentTasks.previousTask.fileObj!=null &&  task.fileObj!=null){ 
						if(model.currentTasks.previousTask.fileObj.fileId == task.fileObj.fileId){
							task = task.previousTask;
							getCompareTask(task);
						}
					}
				}else
				{
					task = getCompareTask(_task.previousTask);
				}
			}

			return task;
		}
		private var _compareTasksColl:ArrayCollection = new ArrayCollection()
		private function getCompareTasksCollection(_task : Tasks) : ArrayCollection
		{ 
			var task : Tasks;
			if(_task.previousTask != null)
			{	
				if(_task.workflowtemplateFK.phaseTemplateFK < versonLoop.phaseTemplateFK
				||_task.workflowtemplateFK.taskLabel=="CHECKING VALIDATION REQUEST"||_task.workflowtemplateFK.taskLabel=="CHECKING") //(RELECTURE V1 --> CHECKING) (COMPLEMENTS DE RELECTURE --> CHECKING VALIDATION REQUEST)
				{
					task = new Tasks()
				}else if(_task.previousTask.workflowtemplateFK.workflowTemplateId == versonLoop.workflowTemplateId 
				&& _task.previousTask.taskId != model.currentTasks.previousTask.taskId )
				{
					 task = _task.previousTask;
					 
					 _compareTasksColl.addItem(task);
					 if(task.previousTask.fileObj!=null )
					   getCompareTasksCollection(task) 
					else
						return _compareTasksColl;
				}else
				{
					 getCompareTasksCollection(_task.previousTask);
				}  
			}
			return _compareTasksColl;
		}
		private function getInterCompareTask(_task : Tasks) : Tasks
		{
			/* var task : Tasks;
			if(_task.previousTask != null)
			{
				if(_task.previousTask.workflowtemplateFK.taskLabel == "CORRECTIONS REALISATION V1")
				{
					task = _task.previousTask.previousTask;
				}else
				{
					task = new Tasks();
				}
			}

			return task; */
			
			 var task : Tasks;
			if(_task.previousTask != null)
			{
				if(_task.previousTask.workflowtemplateFK.taskLabel == "EXECUTION CORRECTION REQUEST")  //CORRECTIONS REALISATION V1
				{
					task = _task.previousTask.previousTask;
				}else
				{
					task = new Tasks();
				}
			}

			return task; 
		}
		
		public function updateCommentResult(rpcEvent:Object) : void
		{
			super.result(rpcEvent);
			var commentVo : CommentVO = CommentVO(rpcEvent.message.body);
			
			var commentListArrayCollection_Len:int=model.pdfDetailVO.commentListArrayCollection.length;
			for(var i : Number = 0; i < commentListArrayCollection_Len; i++)
			{
				if((model.pdfDetailVO.commentListArrayCollection.getItemAt(i) as CommentVO).commentID == commentEvent.commentID)
				{
					model.pdfDetailVO.commentListArrayCollection.removeItemAt(i); 
					model.pdfDetailVO.commentListArrayCollection.addItemAt(commentVo,i);
				}
			}
			
			model.pdfDetailVO.commentListArrayCollection.refresh(); 
		}
		public function removeUpdateComment(commentID : Number , comment : CommentVO) : void
		{
			var commentListArrayCollection_Len:int=model.pdfDetailVO.commentListArrayCollection.length;
			for(var i : Number = 0; i < commentListArrayCollection_Len; i++)
			{
				if((model.pdfDetailVO.commentListArrayCollection.getItemAt(i) as CommentVO).commentID == commentID)
				{
					model.pdfDetailVO.commentListArrayCollection.removeItemAt(i); 
				}
			}
			model.pdfDetailVO.commentListArrayCollection.refresh();
		} 	
		public function removeComment(commentID : Number) : void
		{
			var commentListArrayCollection_Len:int=model.pdfDetailVO.commentListArrayCollection.length;
			for(var i : Number = 0; i < commentListArrayCollection_Len; i++)
			{
				if((model.pdfDetailVO.commentListArrayCollection.getItemAt(i) as CommentVO).commentID == commentID)
				{
					break;
				}
			}

			model.pdfDetailVO.commentListArrayCollection.removeItemAt(i);
			model.pdfDetailVO.commentListArrayCollection.refresh();
		}
		
		public function addCommentResult( rpcEvent : Object ) : void
		{
			var arrc:ArrayCollection = ArrayCollection(rpcEvent.result)
			model.pdfDetailVO.commentListArrayCollection = arrc;
			model.pdfDetailVO.commentListArrayCollection.refresh();
			super.result(rpcEvent);
		}
		public function createCommentResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			var commentVo : CommentVO = CommentVO(rpcEvent.message.body);
			model.pdfDetailVO.commentListArrayCollection.addItem(commentVo);
			model.pdfDetailVO.commentListArrayCollection.refresh();
		}
 	
	}
}

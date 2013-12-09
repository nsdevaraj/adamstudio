package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.event.PDFTool.CommentEvent;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.TeamlineEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.FileDetails;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.events.*;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.*;
	import mx.rpc.IResponder;
	
	public final class FileDetailsCommand extends AbstractCommand 
	{ 
		//import flash.net.FileReference;
    	//import flash.utils.ByteArray;
    	
		private var fileReference:FileReference;
    	private var type:String;
		private var obj:FileDetails;
		private var fileDetails:Object;
		private var fileDetailsEvent:FileDetailsEvent;
		private var fileCollection:ArrayCollection;
		private var filename:String;		
		private var evtype:String;
		
       	private var feventlocalvo:FileDetails;        	
		
		override public function execute( event : CairngormEvent ) : void
		{
			super.execute(event);
			fileDetailsEvent= FileDetailsEvent(event);
			this.delegate = DelegateLocator.getInstance().fileDetailsDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			this.evtype = event.type;
	       	switch(event.type){  
	       	   case FileDetailsEvent.EVENT_SELECT_FILEDETAILS:
	            	delegate.responder = new Callbacks(selectFiles,fault);
	            	delegate.findByIdName(model.currentProjects.projectId,"Message"); 
	           break;
	           case FileDetailsEvent.EVENT_GET_FILEDETAILS:
	            	delegate.responder = new Callbacks(getFileResult,fault);
	            	delegate.findByMailFileId(fileDetailsEvent.filedetailsVo.fileId);   
	           break;
	           case FileDetailsEvent.EVENT_SAVEAS_FILE:
	           		delegate = DelegateLocator.getInstance().fileUploadDelegate;
	            	delegate.responder = new Callbacks(downloadByteFile,fault);
	            	trace("\n FileDetailsCommand FileDetailsEvent.EVENT_SAVEAS_FILE:"+fileDetailsEvent.filedetailsVo.filePath);
	            	delegate.doDownload(fileDetailsEvent.filedetailsVo.filePath);  
	           break;
	           case FileDetailsEvent.EVENT_UPLOAD_FILE:
	           		delegate = DelegateLocator.getInstance().fileUploadDelegate;
	            	delegate.responder = new Callbacks(uploadByteFile,fault);
	            	feventlocalvo = fileDetailsEvent.filedetailsVo;
	            	delegate.doUpload(fileDetailsEvent.storeByteArray,fileDetailsEvent.fileName,fileDetailsEvent.filePath);
	           	break;	
	           	case FileDetailsEvent.EVENT_MAILCREATE_FILEDETAILS:
	            	delegate.responder = new Callbacks(getFinalResult,fault);
	            	trace("InsertUploadFileCommand fileName :"+fileDetailsEvent.filedetailsVo.fileName+" , "+fileDetailsEvent.filedetailsVo.filePath+" , "+fileDetailsEvent.filedetailsVo.taskId+" , "+fileDetailsEvent.filedetailsVo.categoryFK+" , "+fileDetailsEvent.filedetailsVo.type+" , "+fileDetailsEvent.filedetailsVo.storedFileName+" , "+fileDetailsEvent.filedetailsVo.projectFK);  
            		delegate.create(FileDetails(fileDetailsEvent.filedetailsVo));   
	           	break; 
	           	case FileDetailsEvent.EVENT_SELECT_IMP_FILE:
	           		delegate.responder = new Callbacks(selectIMPFiles,fault);
	            	//delegate.findByTaskId(model.currentTasks.previousTask.taskId); 
	            	delegate.findByIdName(model.currentProjects.projectId,"Basic");  
	           	break; 
	           	case FileDetailsEvent.EVENT_GET_IMPFILEDETAILS:
	            	delegate.responder = new Callbacks(getIMPFileResult,fault);
	            	delegate.findByMailFileId(fileDetailsEvent.filedetailsVo.fileId);   
	           	break;  
	           	case FileDetailsEvent.EVENT_IMPSAVEAS_FILE:
	           		delegate = DelegateLocator.getInstance().fileUploadDelegate;
	            	delegate.responder = new Callbacks(downloadByteIMPFile,fault);
	            	trace("\n FileDetailsCommand execute:"+fileDetailsEvent.impFileVo.filePath);
	            	delegate.doDownload(fileDetailsEvent.impFileVo.filePath);  
	           	break;
	            case FileDetailsEvent.EVENT_GET_SWFFILEDETAILS:
	            	delegate.responder = new Callbacks(swfFileDetails,fault);
	            	//delegate.findByNameId(fileDetailsEvent.fileDetailsObj.miscelleneous,fileDetailsEvent.fileDetailsObj.fileId);
	            	delegate.findByNameFileId('IND',model.modelProjectLocalId,model.modelFileLocalId);
	            break;  
	            case FileDetailsEvent.EVENT_GET_SINGLE_SWFFILE:
	            	delegate.responder = new Callbacks(singleswfFileDetails,fault);
	            	//delegate.findByNameFileId('IND',model.modelProjectLocalId,model.modelFileLocalId);
	            	delegate.findByIndProjId('IND',model.modelProjectLocalId);	            	
	            break;  
	            /* case FileDetailsEvent.EVENT_SELECT_IND_FILE:
	           		delegate.responder = new Callbacks(swfIndFiles,fault);
	            	delegate.findByIdName(model.modelProjectLocalId,"Basic");
	           	break;  */
	           	case FileDetailsEvent.EVENT_SELECT_IND_FILE:
	           		delegate.responder = new Callbacks(swfIndFilesView,fault);
	           		if(model.currentTasks!=null){
	           			if(model.currentTasks.fileObj!=null){
	           				delegate.findByMailFileId(model.currentTasks.fileObj.fileId);
	           			}else{
	           				model.typeINDFilefound = false;
	           			}
	           		}	            	
	           	break;
	           	case FileDetailsEvent.EVENT_CREATE_FILEDETAILS:
	           		delegate = DelegateLocator.getInstance().fileUploadDelegate;
	            	delegate.responder = new Callbacks(impUpload,fault);
	            	delegate.doUpload(model.impDoFileUploadCollection.getItemAt(model.attachmentsNo).storeByteArray,model.impDoFileUploadCollection.getItemAt(model.attachmentsNo).browseFileName,model.impDoFileUploadCollection.getItemAt(model.attachmentsNo).storeServerPath);
	            	//delegate.doUpload(fileDetailsEvent.storeByteArray,fileDetailsEvent.fileName,fileDetailsEvent.filePath);
	           	break; 
	           	case FileDetailsEvent.EVENT_CREATE_DB_FILEDETAILS:
	           		delegate.responder = new Callbacks(insertDBFileResult,fault);
	           		var tempFileDetails:FileDetails = FileDetails(model.impFileCollection.getItemAt(model.attachmentsNo)) as FileDetails;
	            	trace("InsertUploadFileCommand fileName :"+tempFileDetails.fileName+" , "+tempFileDetails.filePath+" , "+tempFileDetails.taskId+" , "+tempFileDetails.categoryFK+" , "+tempFileDetails.type+" , "+tempFileDetails.storedFileName+" , "+tempFileDetails.projectFK);  
            		delegate.create(tempFileDetails);   
	           	break;
	           	
	           	case FileDetailsEvent.EVENT_SELECT_INDDOWNLOAD_FILE:
	           		delegate.responder = new Callbacks(swfIndFilesDownload,fault);
	           		trace("KUMAR :"+model.currentTasks.fileObj.fileId);
	           		if(model.currentTasks!=null){
	           			if(model.currentTasks.fileObj!=null){
	           				//delegate.findByMailFileId(model.currentTasks.fileObj.fileId);
	           				delegate.findByIdName(model.currentTasks.projectObject.projectId,"Basic");
	           			}else{
	           				model.typeINDFilefound = false;
	           			}
	           		}	            	
	           	break; 
	           	case FileDetailsEvent.EVENT_SAVEAS_PDFDOWNLOADFILE:
	           		delegate = DelegateLocator.getInstance().fileUploadDelegate;
	            	delegate.responder = new Callbacks(downloadPreviewPDFByteFile,fault);
	            	trace("\n FileDetailsCommand FileDetailsEvent.EVENT_SAVEAS_PDFDOWNLOADFILE:"+fileDetailsEvent.filedetailsVo.filePath);
	            	delegate.doDownload(fileDetailsEvent.filedetailsVo.filePath);  
	          	break;
	           	  		       	   
	           	default:
	            	break;  
	    	}
 		
		} 	
		
		public function impUpload(rpcEvent : Object):void{		
			var returnstr:String = rpcEvent.result;	
			if(model.typeName == 'Prop')
				 model.delayUpdateTxt = "file upload process";
			if(model.typeName == 'All'){
				//if(model.typeSubAllName == 'AllProp')
				 model.delayUpdateTxt = "file upload process";
			} 
			if(returnstr == "success")  //success  
			{
				trace("\n\n impUpload --- file uploading sucessfully");

				if(model.typeName == 'Prop') 
				 	model.delayUpdateTxt = "file uploading sucessfully";
				 if(model.typeName == 'All'){
					//if(model.typeSubAllName == 'AllProp')
					 model.delayUpdateTxt = "file uploading sucessfully";
				} 
				 
				var fileEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_CREATE_DB_FILEDETAILS);
	 			var handler:IResponder = new Callbacks(result,fault)
	 			var fSeq:SequenceGenerator = new SequenceGenerator([fileEvent],handler)
	  			fSeq.dispatch(); 
			}
			else  //failure
			{
				Alert.show("File not upload");
			}
		}
		public function insertDBFileResult( rpcEvent : Object ) : void {
		
			if(model.typeName == 'Prop') 	
			{
				model.delayUpdateTxt = "database file created ";
				
				model.attachmentsNo++;
				if(model.attachmentsNo < model.attachmentsFiles.length){
					var fileEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_CREATE_FILEDETAILS);
					var handler:IResponder = new Callbacks(result,fault)
					var fSeq:SequenceGenerator = new SequenceGenerator([fileEvent],handler)
					fSeq.dispatch();
				}				 
			}
			else if(model.typeName == 'All') 	
			{
				/* if(model.typeSubAllName == 'AllProp')
				{ */
					model.delayUpdateTxt = "database file created ";
					
					model.attachmentsNo++;
					if(model.attachmentsNo < model.attachmentsFiles.length){
						var fileEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_CREATE_FILEDETAILS);
						var handler:IResponder = new Callbacks(result,fault)
						var fSeq:SequenceGenerator = new SequenceGenerator([fileEvent],handler)
						fSeq.dispatch();
					}	
				//}			 
			}
			else
			{
				model.expiryState = "sentState";	
			}
			 
		} 
		
		
		
		
		
		public function singleswfFileDetails(rpcEvent : Object ) : void
		{
			super.result(rpcEvent);		
			model.delayUpdateTxt = "get file details";
			
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			trace("\n\n ************** singleswfFileDetails arrc:"+arrc.length);
			if(arrc.length!=0)
			{
				for each(var filesvo:FileDetails in arrc)
				{
					//only PDF File visible is 1 but swf file visible is 0
					//only PDF File visible is 1 - true but swf file visible is 0 - false
					//SWF Arraycollection stored
					if(filesvo.visible == false)
					{
						model.modelFileDetailsVo = filesvo;
						
						trace("\n\n\n singleswfFileDetails :"+filesvo.fileId);
						model.currentSwfFile.remoteFileFk = filesvo.fileId;
						
						var arrcoll:ArrayCollection = new ArrayCollection();
						arrcoll.addItem(filesvo);
						model.pdfFileCollection = arrcoll;
						
						var events:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SAVEAS_FILE);
						events.filedetailsVo = new FileDetails();
						//trace("filePath :"+model.modelFileDetailsVo.filePath);
						//events.filedetailsVo.filePath = model.modelFileDetailsVo.filePath;
						events.filedetailsVo.filePath = filesvo.filePath;
						var handler:IResponder = new Callbacks(result,fault)
			 			var fSeq:SequenceGenerator = new SequenceGenerator([events],handler)
			  			fSeq.dispatch();

					}
					else
					{
						//only PDF File visible is 1 but swf file visible is 0
						//only PDF File page is 0 but swf page is 1,2,3,4
						//PDF Arraycollection stored
						if(filesvo.page == false)
						{
							trace("\n if PDF FILE :"+filesvo.fileId);
							model.modelFileDetailsPDFVo = filesvo;
						}						
					}
				}
				/* var events:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SAVEAS_FILE);
				events.filedetailsVo = new FileDetails();
				trace("filePath :"+model.modelFileDetailsVo.filePath);
				events.filedetailsVo.filePath = model.modelFileDetailsVo.filePath;
				var handler:IResponder = new Callbacks(result,fault)
	 			var fSeq:SequenceGenerator = new SequenceGenerator([events],handler)
	  			fSeq.dispatch(); */
				
				model.expiryState = "indState"; 
			}
		}
		public function swfFileDetails(rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
		
			model.delayUpdateTxt = "get file details";
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.modelTileFileCollection = arrc;
			trace("\n\n\n &&&&&&&&&&&&&&&&&& swfFileDetails :"+arrc.length);
			
			model.expiryState = "indState";
			
			/* model.modelFileDetailsVo = ArrayCollection(rpcEvent.result).getItemAt(0) as FileDetails;			
			model.modelIndFileName = model.modelFileDetailsVo.fileName;
				
			var events:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SAVEAS_FILE);
			//var events:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_IMPSAVEAS_FILE);
			events.filedetailsVo = new FileDetails();
			events.filedetailsVo.filePath = model.modelFileDetailsVo.filePath;
			var handler:IResponder = new Callbacks(result,fault)
 			var fSeq:SequenceGenerator = new SequenceGenerator([events],handler)
  			fSeq.dispatch(); */	
		}	
		public function selectIMPFiles(rpcEvent : Object):void{
			super.result(rpcEvent);
			
			//june 08 2010
			model.delayUpdateTxt = "Download Files";
			
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			var pdfonly:ArrayCollection = new ArrayCollection();
			
			trace("selectIMPFiles model.typeName :"+model.typeName+"==>"+model.typeSubAllName);
			if(model.typeName == 'Prop')
			{
				trace("\n\n\n selectIMPFiles :"+arrc.length);
				for each( var item:FileDetails in arrc){
					trace("selectIMPFiles item.visible:"+item.visible);
					if(item.visible)
					{	
						trace("selectIMPFiles item.visible:"+item.fileName);
						pdfonly.addItem(item);
						pdfonly.refresh();
					}
				}
				model.modelTileFileCollection = pdfonly; 
			}
			else if(model.typeName == 'All')
			{				
				//if(model.typeSubAllName == 'AllProp')
				//{
					trace("\n\n\n All selectIMPFiles :"+arrc.length);
					for each( var item:FileDetails in arrc){
						trace("All selectIMPFiles item.visible:"+item.visible);
						if(item.visible)
						{	
							trace("All selectIMPFiles item.visible:"+item.fileName);
							pdfonly.addItem(item);
							pdfonly.refresh();
						}
					}
					model.modelTileFileCollection = pdfonly; 
				//}
			}
			else
			{
				model.modelTileFileCollection = arrc;
			}
						
		}
		public function selectFiles(rpcEvent : Object):void{
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			trace("selectFiles :"+arrc.length);
			model.messageFileCollection = arrc;
			/* var sort:Sort = new Sort(); 
            sort.fields = [new SortField("taskId")];
            model.messageFileCollection.sort = sort; */
           // model.messageFileCollection.refresh(); 			
		}
		public function getIMPFileResult(rpcEvent : Object):void{
			model.modelFileDetailsVo = ArrayCollection(rpcEvent.result).getItemAt(0) as FileDetails;			
			model.modelLinkName = model.modelFileDetailsVo.fileName;
			
			trace("\n\n\n @@@@@@@@@@@@@@@@@@@@@@@@@@@ getIMPFileResult calling");
			
			var events:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SAVEAS_FILE);
			events.filedetailsVo = new FileDetails();
			events.filedetailsVo.filePath = model.modelFileDetailsVo.filePath;
			var handler:IResponder = new Callbacks(result,fault)
 			var fSeq:SequenceGenerator = new SequenceGenerator([events],handler)
  			fSeq.dispatch();
			
		} 
		public function downloadByteIMPFile(rpcEvent : Object):void{	
			if(rpcEvent.result!=null)
			{
				model.modelIMPByteArrray = rpcEvent.result as ByteArray;
				trace("downloadByteIMPFile :"+model.modelIMPByteArrray.toString());	
				//model.mainClass.fileView.saveimpid.dispatchEvent( new MouseEvent( MouseEvent.CLICK ) );		
				model.delayUpdateTxt = "get ByteArrray files";	
			}
			else
			{
				Alert.show("Server side File not found");
			}
		}
		
		public function getFileResult(rpcEvent : Object):void{	

			model.modelFileDetailsVo = ArrayCollection(rpcEvent.result).getItemAt(0) as FileDetails;			
			model.modelLinkName = model.modelFileDetailsVo.fileName;
			
			trace("\n\n\n $$$$$$$$$$$$$$$$$$$$$$$$$$$$$ getFileResult calling");
			
			var events:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SAVEAS_FILE);
			events.filedetailsVo = new FileDetails();
			events.filedetailsVo.filePath = model.modelFileDetailsVo.filePath;
			var handler:IResponder = new Callbacks(result,fault)
 			var fSeq:SequenceGenerator = new SequenceGenerator([events],handler)
  			fSeq.dispatch();
			
		} 
		public function downloadByteFile(rpcEvent : Object):void
		{							
			if(rpcEvent.result!=null)
			{
				if(model.typeName == 'Reader')
				{
					model.modelINDByteArrray = rpcEvent.result as ByteArray;
				}
				else if(model.typeName == 'All')
				{
					trace("FileDetailsCommand All IND downloadByteFile :"+model.typeSubAllName);
					model.modelINDByteArrray = rpcEvent.result as ByteArray;
				}
				else
				{
					model.modelByteArrray = rpcEvent.result as ByteArray;					
				}
			}
			else
			{
				Alert.show("Server side File not found");
			}
			
		}
		public function uploadByteFile(rpcEvent : Object):void{		
			var returnstr:String = rpcEvent.result;	
			if(model.typeName == 'Mail') 
				 model.delayUpdateTxt = "file upload process";
				 
			if(returnstr == "success")  //success  
			{
				trace("\n\n uploadByteFile --- file uploading sucessfully");

				if(model.typeName == 'Mail') 
				 	model.delayUpdateTxt = "file uploading sucessfully";
				 
				var fileEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_MAILCREATE_FILEDETAILS);
				fileEvent.filedetailsVo = feventlocalvo;
	 			var handler:IResponder = new Callbacks(result,fault)
	 			var fSeq:SequenceGenerator = new SequenceGenerator([fileEvent],handler)
	  			fSeq.dispatch(); 
			}
			else  //failure
			{
				Alert.show("File not upload");
			}
		}
		public function getFinalResult( rpcEvent : Object ) : void {
			//Alert.show("InsertUploadFileCommand result ");			
			//var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			
			if(model.typeName == 'Mail') 	
			{
				//model.expiryState = "sentState";	
				//model.expiryState = "loadState";	
				model.delayUpdateTxt = "database file created ";
				 
				var eventsArr:Array = [] 
				var eventteamlinesstatus:TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_TASK_STATUS);
				eventsArr.push(eventteamlinesstatus);
				//*******************
				var event:TasksEvent = new TasksEvent( TasksEvent.EVENT_MAILUPDATE_TASKS);
				eventsArr.push(event);
				var eventteamlines:TeamlineEvent = new TeamlineEvent(TeamlineEvent.EVENT_MAILMESSAGE_TEAMLINE);							
				eventsArr.push(eventteamlines); 				
				
				var handler:IResponder = new Callbacks(result,fault)
				var fSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
				fSeq.dispatch(); 
				 
			}
			else
			{
				model.expiryState = "sentState";	
			}
			 
		} 
		public function swfIndFiles(rpcEvent : Object):void{
			super.result(rpcEvent);		
			model.delayUpdateTxt = "get file details";
			
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			trace("\n\nswfIndFiles arrc:"+arrc.length);
			if(arrc.length!=0)
			{
				for each(var filesvo:FileDetails in arrc)
				{
					if(filesvo.miscelleneous!=null)
					{
						trace("FORLOOP"+(filesvo.miscelleneous).substr(0,3));
						if((filesvo.miscelleneous).substr(0,3) == 'IND')
						{
							//only PDF File visible is 1 but swf file visible is 0
							//only PDF File visible is 1 - true but swf file visible is 0 - false
							//SWF Arraycollection stored
							if(filesvo.visible == false)
							{
								model.modelFileDetailsVo = filesvo;
								
								trace("\n\n\n IF swfIndFiles IND SWFfile fileId:"+filesvo.fileId+" , "+filesvo.miscelleneous);
								model.currentSwfFile.remoteFileFk = filesvo.fileId;
								
								var arrcoll:ArrayCollection = new ArrayCollection();
								arrcoll.addItem(filesvo);
								model.pdfFileCollection = arrcoll;
								
								trace("\n\n\n IF swfIndFiles getFileResult calling"+filesvo.filePath);
								
								var events:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SAVEAS_FILE);
								events.filedetailsVo = new FileDetails();
								//trace("filePath :"+model.modelFileDetailsVo.filePath);
								//events.filedetailsVo.filePath = model.modelFileDetailsVo.filePath;
								events.filedetailsVo.filePath = filesvo.filePath;
								
								var commentevent : CommentEvent = new CommentEvent(CommentEvent.GET_COMMENT);
								commentevent.fileFk = filesvo.fileId;
								commentevent.compareFileFk = 0;
								var eventsArr:Array = [commentevent,events]
								
								var handler:IResponder = new Callbacks(result,fault)
					 			var fSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
					  			fSeq.dispatch();
					  			
					  			break;
		
							}
							else
							{
								//only PDF File visible is 1 but swf file visible is 0
								//only PDF File page is 0 but swf page is 1,2,3,4
								//PDF Arraycollection stored
								if(filesvo.page == false)
								{
									trace("ELSE swfIndFiles IND PDFfile  fileId :"+filesvo.fileId+" , "+filesvo.miscelleneous);
									model.modelFileDetailsPDFVo = filesvo;
								}						
							}
						}
						else
						{
							trace("ELSE swfIndFiles NOT USE IND WORD fileId:"+filesvo.fileId+" , "+filesvo.miscelleneous);
						}
					}
				}				
				if(model.typeName == 'Reader')	
					model.expiryState = "indState";
			}
			else{
				trace("ELSE swfIndFiles fileId FILE NOT FOUND");
				model.typeINDFilefound = false;
			}
		}
		
		//***************
		public function swfIndFilesView(rpcEvent : Object):void{
			super.result(rpcEvent);		
			//model.delayUpdateTxt = "get file details";
			
			//june 08 2010
			model.delayUpdateTxt = "PDF preview Files";
			
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			trace("\n\n swfIndFilesView arrc:"+arrc.length);
			if(arrc.length!=0)
			{
				for each(var filesvo:FileDetails in arrc)
				{
					if(filesvo.visible == false)
					{
						model.modelFileDetailsVo = filesvo;
						
						trace("\n\n\n IF swfIndFilesView IND SWFfile fileId:"+filesvo.fileId+" , "+filesvo.miscelleneous);
						model.currentSwfFile.remoteFileFk = filesvo.fileId;
						
						var arrcoll:ArrayCollection = new ArrayCollection();
						arrcoll.addItem(filesvo);
						model.pdfFileCollection = arrcoll;
						
						trace("\n\n\n IF swfIndFilesView getFileResult calling"+filesvo.filePath);
						
						var events:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SAVEAS_FILE);
						events.filedetailsVo = new FileDetails();
						//trace("filePath :"+model.modelFileDetailsVo.filePath);
						//events.filedetailsVo.filePath = model.modelFileDetailsVo.filePath;
						events.filedetailsVo.filePath = filesvo.filePath;
						
						var commentevent : CommentEvent = new CommentEvent(CommentEvent.GET_COMMENT);
						commentevent.fileFk = filesvo.fileId;
						commentevent.compareFileFk = 0;
						var eventsArr:Array = [commentevent,events]
						
						var handler:IResponder = new Callbacks(result,fault)
			 			var fSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
			  			fSeq.dispatch();
			  			
			  			break;

					}
					else
					{
						//only PDF File visible is 1 but swf file visible is 0
						//only PDF File page is 0 but swf page is 1,2,3,4
						//PDF Arraycollection stored
						if(filesvo.page == false)
						{
							trace("ELSE swfIndFilesView IND PDFfile  fileId :"+filesvo.fileId+" , "+filesvo.miscelleneous);
							model.modelFileDetailsPDFVo = filesvo;
						}						
					}
				}
			}
			else{
				trace("Else swfIndFilesView getFileResult calling");
			}
			
		}
		//****************
		
		public function swfIndFilesDownload(rpcEvent : Object):void{
			super.result(rpcEvent);		
			
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			trace("\n\n swfIndFilesDownload arrc:"+arrc.length);
			if(arrc.length!=0)
			{
				for each(var filesvo:FileDetails in arrc)
				{
					/* if(filesvo.visible == true){				
						if((tempFiledetails.projectFK == filesvo.projectFK) && (tempFiledetails.fileId == filesvo.fileId)){
							tempType = tempFiledetails.type;
							tempMiscelleneous = tempFiledetails.miscelleneous;
							break;
						}
					} */
					if(filesvo.visible == true)
					{
						trace("\n IF swfIndFilesDownload IND SWFfile fileId:"+filesvo.fileId+" , "+filesvo.miscelleneous);						
						trace("\n\n\n IF swfIndFilesDownload getFileResult calling"+filesvo.filePath);
						
						if(model.modelFileDetailsVo!=null){
							if((model.modelFileDetailsVo.projectFK == filesvo.projectFK) && (model.modelFileDetailsVo.type == filesvo.type) && (model.modelFileDetailsVo.miscelleneous == filesvo.miscelleneous)){
								trace(" IF swfIndFilesDownload getFileResult calling"+model.modelFileDetailsVo.projectFK+" , "+model.modelFileDetailsVo.type+" , "+model.modelFileDetailsVo.miscelleneous);
								model.modelINDPreviewFileVo = filesvo;
								var events:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SAVEAS_PDFDOWNLOADFILE);
								events.filedetailsVo = new FileDetails();
								events.filedetailsVo.filePath = filesvo.filePath;
								events.dispatch();
								break;
							}
						}
					}					
				}
			}			
		}
		public function downloadPreviewPDFByteFile(rpcEvent : Object):void
		{							
			if(rpcEvent.result!=null)
			{				
				if(model.typeName == 'All')
				{
					trace("All IND downloadPreviewPDFByteFile calling");
					model.modelINDPreviewByteArrray = rpcEvent.result as ByteArray;
					trace("\n\n IND downloadPreviewPDFByteFile :"+model.modelINDPreviewByteArrray);
					
				}
			}
			else
			{
				Alert.show("Server side File not found");
			}
			
		}
	}
}

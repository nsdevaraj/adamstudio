package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.LocalFileDetailsDAODelegate;
	import com.adams.dt.business.util.FileNameSplitter;
	import com.adams.dt.business.util.Pdf2SwfUtil;
	import com.adams.dt.business.util.StringUtils;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.EventsEvent;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.event.LocalDataBaseEvent;
	import com.adams.dt.event.PDFTool.PDFInitEvent;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.TeamlineEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.managers.SharedObjectManager;
	import com.adams.dt.model.vo.EventStatus;
	import com.adams.dt.model.vo.Events;
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.model.vo.Tasks;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.data.SQLResult;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	public final class FileDetailsCommand extends AbstractCommand 
	{ 
		private var count:int=0;
    	private var type:String;
		private var fileObject:File;
		private var obj:FileDetails;
		private var fileDetails:Object;
		private var fileDetailsEvent:FileDetailsEvent;
		private var fileCollection:ArrayCollection;
		private var filename:String;		
		private var evtype:String;
		
		override public function execute( event:CairngormEvent ):void
		{
		   super.execute( event );
		   fileDetailsEvent= FileDetailsEvent( event );
		   this.delegate = DelegateLocator.getInstance().fileDetailsDelegate;
		   this.delegate.responder = new Callbacks( result, fault );
		   this.evtype = event.type;
	       
	       switch( event.type ) {  
	       	    case FileDetailsEvent.EVENT_SELECT_FILEDETAILS:
		            delegate.responder = new Callbacks( selectFiles, fault );
		            delegate.findByMailFileId( fileDetailsEvent.fileDetailsObj.remoteFileFk );
	            break;	
	       	    case FileDetailsEvent.EVENT_GET_SWFFILEDETAILS:
		            delegate.responder = new Callbacks( swfFileDetails, fault );
		            delegate.findByNameId( fileDetailsEvent.fileDetailsObj.miscelleneous,fileDetailsEvent.fileDetailsObj.fileId );
	            break;
	            case FileDetailsEvent.EVENT_GET_INDFILEDETAILS:
	            	delegate.responder = new Callbacks( swfFileDetails, fault );
	            	delegate.findByMailFileId( fileDetailsEvent.fileDetailsObj.fileId );
	            break;
	            case FileDetailsEvent.EVENT_CREATE_FILEDETAILS:
		           	model.uploadFileNumbers = model.bgUploadFile.fileToUpload.length;
		            delegate.responder = new Callbacks( createFileDetailsResult, fault );	
		            delegate.bulkUpdate( fileDetailsEvent.fileDeatils );
	            break; 
	            case FileDetailsEvent.EVENT_CREATE_SWFFILEDETAILS:
		           	model.uploadFileNumbers = model.bgUploadFile.fileToUpload.length;
		            delegate.responder = new Callbacks( createSwfFileDetailsResult, fault );
		        	if( model.fileDetailsToUpdate.length > 0 ) {
		            	delegate.create( model.fileDetailsToUpdate.getItemAt( 0 ) as FileDetails );
		        	}	
	            break; 
	          	case FileDetailsEvent.EVENT_UPDATE_FILEDETAILS: 
	            	delegate.responder = new Callbacks( releaseFileDetailsResult, fault );	           
	            	if( model.fileCollectionToUpdate.length > 0 )	delegate.bulkUpdate( model.fileCollectionToUpdate );
	            	else updateFilesBulk();
	            break;
	            case FileDetailsEvent.EVENT_DUPLICATE_FILEDETAILS: 
	           		delegate.responder = new Callbacks( duplicateFileDetailsResult, fault );	
	           		delegate.create( model.refFilesDetails.getItemAt( 0 ) as FileDetails );           
	            break;
	           	case FileDetailsEvent.EVENT_UPDATE_DETAILS:
	           		delegate.responder = new Callbacks( onFileObjectUpdate, fault );
	            	delegate.update( fileDetailsEvent.fileDetailsObj );
	            break;  
	            case FileDetailsEvent.EVENT_GET_BASICFILEDETAILS:
	            	delegate.responder = new Callbacks( getBasicFileDetailsResult, fault );
	            	delegate.findByIdName( model.currentProjects.projectId, "Basic" );
	            break;
	            case FileDetailsEvent.EVENT_GET_TASKFILEDETAILS:
	            	delegate.responder = new Callbacks( getTaskFileDetailsResult, fault );
	            	delegate.findByIdName( model.currentProjects.projectId, "Tasks" );
	            break;
	            case FileDetailsEvent.EVENT_GET_MESSAGEFILEDETAILS:
	            	delegate.responder = new Callbacks( getMessageFileDetailsResult, fault );
	            	delegate.findByIdName( model.currentProjects.projectId, "Message" );
	            break;
	            case FileDetailsEvent.EVENT_GET_FILEDETAILS:
	            	delegate.responder = new Callbacks( getFileDetailsResult, fault );
	            	delegate.findById( model.referenceProject.projectId );
	            break;
	            case FileDetailsEvent.EVENT_DELETEALL_FILEDETAILS:
	            	delegate.responder = new Callbacks( result, fault );
	            	delegate.deleteAll();
	            break;
	            case FileDetailsEvent.EVENT_BGUPLOAD_FILE:
		            if( model.bgUploadFile.fileToUpload.length > 0 ) {	  
		        		fileDetails = model.bgUploadFile.fileToUpload.getItemAt( 0 );      
						loadAndUploadFiles( fileDetails );
		        	}
	            break;
	            case FileDetailsEvent.EVENT_BGDOWNLOAD_FILE:
		            delegate = DelegateLocator.getInstance().fileUploadDelegate;
		            delegate.responder = new Callbacks( onBgDownloadFileResult, fault );
		            if( model.bgDownloadFile.fileToDownload.length > 0 ) {
						obj = model.bgDownloadFile.fileToDownload.getItemAt( 0 ) as FileDetails;
						if( obj ) {
							if( obj.sourcePath ) {
								this.delegate.doDownload( obj.sourcePath );
							}
							else {
								this.delegate.doDownload( obj.filePath );
							}
						}	
					}	
	            break;
	            case FileDetailsEvent.EVENT_SAVEAS_FILE:
	            	delegate = DelegateLocator.getInstance().fileUploadDelegate;
	            	delegate.responder = new Callbacks(onSaveAsResult,fault);
	            	delegate.doDownload(fileDetailsEvent.fileObj.sourcePath);		
	            break;
	            case FileDetailsEvent.EVENT_GET_MESSAGE_BASICFILEDETAILS:
	            	delegate.responder = new Callbacks(getBasicMessageViewResult,fault);
	            	delegate.findByBasicMessageId(model.currentProjects.projectId,"Basic");
	            break;
	            case FileDetailsEvent.EVENT_CREATE_MSG_DUPLI_FILE:
	            	delegate.responder = new Callbacks(createMsgDuplicateResult,fault);
	            	delegate.bulkUpdate(fileDetailsEvent.messageColl);
	            break; 
	            case FileDetailsEvent.EVENT_GETPROJECT_FILEDETAILS:
	            	delegate.responder = new Callbacks( getProjectFileResult, fault );
	            	delegate.findById( fileDetailsEvent.projectId );
	            break;           
	            default:
	            break;  
	    	}
 		
		} 
		
		private function onFileObjectUpdate( rpcEvent:Object ):void {
			super.result( rpcEvent ); 
		}	
		
		/**
		 * get the refrence project file details 
		 */ 
		public function getProjectFileResult( rpcEvent:Object ):void {
			super.result(rpcEvent);	
		}
		
		/**
		 * remove invisible files
		 */
		public function removeInvisibleAllFile( fo:FileDetails ):Boolean {
			if( !fo.visible ) {
				model.projectAllFilesDetails.removeItemAt( model.projectAllFilesDetails.getItemIndex( fo ) );
			}	
			return true;
		}
		
		/**
		 * for refrence project duplicate the file details with new project id
		 */ 
		public function duplicateFileDetailsResult( rpcEvent:Object ):void {
			model.refFilesDetails.removeItemAt( 0 );
			 if( model.refFilesDetails.length > 0 ) {
			 	var newfiledetailsEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_DUPLICATE_FILEDETAILS );
				newfiledetailsEvent.dispatch();
			 }
			 else {			 	
				super.result( rpcEvent );	
			 }
		}
		
		/**
		 * get the refrence project file details 
		 */ 
		public function getFileDetailsResult( rpcEvent:Object ):void {
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.refFilesDetails = arrc;
			arrc.filterFunction = removeInvisibleFile;
			super.result( rpcEvent );	
		}
		
		/**
		 * remove invisible files
		 */
		public function removeInvisibleFile( fo:FileDetails ) : Boolean{
			if( !fo.visible ) {
				model.refFilesDetails.removeItemAt( model.refFilesDetails.getItemIndex( fo ) );
			}	
			return true;
		}
		
		/**
		 * duplicate the filedetails with diffrent message task id
		 */
		public function createMsgDuplicateResult( rpcEvent:Object ):void {
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			super.result( rpcEvent );		
		}
		
		/**
		 * get the file details object to download
		 */
		public function selectFiles( rpcEvent:Object ):void {
			var fileDetailObj:FileDetails = FileDetails( ArrayCollection( rpcEvent.result ).getItemAt( 0 ) );
			if( fileDetailObj ) {
				model.filesToDownload.addItem( fileDetailObj );
				model.bgDownloadFile.idle = true;
				model.bgDownloadFile.fileToDownload.list = model.filesToDownload.list;
			}
			super.result( rpcEvent );	
		}
		
		/**
		 * get the swf file details object to download
		 */
		public function swfFileDetails( rpcEvent:Object ):void {
			model.filesToDownload = ArrayCollection( rpcEvent.result );
			model.bgDownloadFile.fileToDownload.list = model.filesToDownload.list;
			model.bgDownloadFile.idle = true;
			super.result( rpcEvent );	
		}
		
		/**
		 * update release status result 
		 * call the push functionality
		 */
		public function releaseFileDetailsResult( rpcEvent:Object ):void {
			updateFilesBulk();
			super.result( rpcEvent );	
		}
		
		//add by kumar 8th June
		public function updateFilesBulk():void { 
			if( model.waitingFab ) {
				var eventteamlines:TeamlineEvent = new TeamlineEvent( TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE );			
	 			var handler:IResponder = new Callbacks( result, fault );
	 			var uploadSeq:SequenceGenerator = new SequenceGenerator(  [ eventteamlines ], handler );
	  			uploadSeq.dispatch();
	  		}
	  		else {
	  			model.waitingFab = true;
	  		}
		}
		
		/**
		 * get the task file details 
		 * get the message file details
		 */
		public function getTaskFileDetailsResult( rpcEvent:Object ):void {
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.taskFileCollection = arrc;
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( "taskId" ) ];
            model.taskFileCollection.sort = sort;
            model.taskFileCollection.refresh();  
            
            var filedetailsMessageEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_GET_MESSAGEFILEDETAILS );
			var eventsArr:Array = [ filedetailsMessageEvent ];    
 			var handler:IResponder = new Callbacks( result, fault );
 			var downloadMessageSeq:SequenceGenerator = new SequenceGenerator( eventsArr, handler );
  			downloadMessageSeq.dispatch();
  		}
		
		/**
		 * create bulk of file details result function
		 * create the local file details
		 * if its pdf conversion file update the task with file id
		 */ 
		public function createFileDetailsResult( rpcEvent:Object ):void {	
			super.result( rpcEvent );	
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			var gettaskEvent:TasksEvent = new TasksEvent( TasksEvent.EVENT_GET_TASK );
			var taskToUpdate:Tasks = new Tasks();
			for each( var obj:FileDetails in model.fileDetailsArray ) {
				var delegate : LocalFileDetailsDAODelegate = new LocalFileDetailsDAODelegate();	
	        	var fileDetail:FileDetails = new FileDetails();	        	
	        	fileDetail.fileName = obj.fileName;
	        	fileDetail.storedFileName = obj.storedFileName;	        	
	        	fileDetail.projectFK = obj.projectFK;
	        	fileDetail.miscelleneous = obj.miscelleneous;
	        	fileDetail.page = obj.page;     
	        	var sort:Sort = new Sort(); 
			    sort.fields = [ new SortField( "fileName" ) ];
			    arrc.sort = sort;
			    arrc.refresh(); 
			    var cursor:IViewCursor =  arrc.createCursor();
			    var found:Boolean = cursor.findAny(fileDetail);
	        	if( found ) {
	        		fileDetail.remoteFileFk = FileDetails( cursor.current ).fileId;
	        	} 
	        	fileDetail.taskId = obj.taskId;	
	            fileDetail.categoryFK = obj.categoryFK;		
	        	fileDetail.filePath = obj.sourcePath;
	        	fileDetail.type = obj.type
				var result1:SQLResult = delegate.addFileDetails( fileDetail );
			 	if( obj.extension== "pdf" ) {
	          		model.pdfConversion = true; 
	          		fileDetail.miscelleneous = obj.miscelleneous;
					var conversionName:String =  obj.fileName; 
					var conversionPath:String = obj.sourcePath.split( File.separator + filename )[ 0 ];
					model.swfConversion = true;
					Pdf2SwfUtil.doConvert( obj.filePath, fileDetail );
				 }
			}
			model.filesToUpload = new ArrayCollection();
			model.fileDetailsArray = new ArrayCollection();
			var SoM:SharedObjectManager = SharedObjectManager.instance; 
			SoM.data.filesToBeUpload = model.bgUploadFile.fileToUpload
			SoM.data.fileDetailsArrays = model.fileDetailsArray;
			for each( var item:FileDetails in arrc ) {
				if( item.extension == "pdf" && item.type == "Tasks" ) {					
					gettaskEvent.uploadFile = true;				
					taskToUpdate.taskId = item.taskId;
					var file:FileDetails = new FileDetails();
					file.fileId = item.fileId;
					file.filePath = item.filePath;
					taskToUpdate.fileObj = file;	
					model.updateFileToTask = taskToUpdate;			
				} 
			}	
			var eventsArr:Array = [ gettaskEvent ];    
 			var handler:IResponder = new Callbacks( result ,fault );
 			var uploadSeq:SequenceGenerator = new SequenceGenerator( eventsArr, handler );
  			uploadSeq.dispatch();
		}  
		
		public function createSwfFileDetailsResult( rpcEvent:Object ):void {
			var swfDetail:FileDetails = rpcEvent.result as FileDetails;
			model.fileDetailsToUpdate.removeItemAt( 0 );
			 if( model.fileDetailsToUpdate.length > 0 ) {
			 	var filedetailsTaskEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_CREATE_SWFFILEDETAILS );
				filedetailsTaskEvent.dispatch();
			 } 
			 else{
			 	var eventtask:TeamlineEvent = new TeamlineEvent( TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE );
				var seqArr:Array = []
				model.pdfConversion = false;			 			
	  			seqArr.push( eventtask );
	  			var seqhandler:IResponder = new Callbacks( result, fault );
		 		var eventSeq:SequenceGenerator = new SequenceGenerator( seqArr, seqhandler);
		  		eventSeq.dispatch();
			 }
		}
		
		public function onSaveAsResult( rpcEvent:Object ):void {	
			super.result( rpcEvent );	
			var file:File = new File();
			file.save( rpcEvent.result as ByteArray, fileDetails.name );
			file.addEventListener( Event.COMPLETE,onSaveAsDownLoadComplete,false,0,true );
		} 
		
		private function onSaveAsDownLoadComplete( event:Event ):void {
        	var downLoadedfile:File = File( event.currentTarget );
        	var path:String = model.currentProjects.categories.categoryName+File.separator+ StringUtils.compatibleTrim( model.currentProjects.projectName )+ "/" + downLoadedfile.name;
        	var copyToLocation:File = File.userDirectory.resolvePath( path );
        	if( !copyToLocation.exists )	copyToLocation.createDirectory();
        	if( !downLoadedfile.exists )	downLoadedfile.copyTo( copyToLocation, true );
        	var fileEvent:LocalDataBaseEvent = new LocalDataBaseEvent( LocalDataBaseEvent.EVENT_CREATE_FILEDETAILS );
			var fileDt:FileDetails = new FileDetails();
			fileDt.fileName = fileDetails.name;
			fileDt.filePath = copyToLocation.nativePath;
			fileEvent.fileDetailsObj  = fileDt;
			var eventsArr:Array = [ fileEvent ];    
 			var handler:IResponder = new Callbacks( result,fault );
 			var downloadSeq:SequenceGenerator = new SequenceGenerator( eventsArr, handler );
  			downloadSeq.dispatch();
       	}
		
		private function loadAndUploadFiles( fileObj:Object ):void {
			model.uploadFileNumbers = model.bgUploadFile.fileToUpload.length;
			delegate = DelegateLocator.getInstance().fileUploadDelegate;
			
			fileObject = new File( fileObj.sourcePath );
			if( model.onlyEmail == 'MESSAGE' || model.onlyEmail == 'REEMAIL' || model.onlyEmail == 'EMAIL' ) { 
				delegate.responder = new Callbacks( onMSGBgUploadResult, fault );
				fileObject.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onMSGBgUploadResult,false,0,true ); 
			}		
			else { 
				delegate.responder = new Callbacks( onBgUploadResult, fault );	
				fileObject.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onBgUploadResult,false,0,true ); 
			}					
			
           var data:ByteArray = new ByteArray();
			fileObj.storedName = StringUtils.trimAll( fileObj.storedName );
			filename = fileObj.storedName;
			
			var url:String = model.serverLocation + "uploadhandler";
			var request:URLRequest = new URLRequest( url );
			request.contentType = 'multipart/form-data; boundary=' + getBoundary();
			request.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables(); 
			variables.userEncrptName = model.encryptorUserName; 
			variables.passEncrptName = model.encryptorPassword; 
			
			variables.filePath = fileObj.destinationpath + "/" + fileObj.type;
			variables.fileName = filename; 
			
			request.data = variables; 
			
			fileObject.addEventListener( ProgressEvent.PROGRESS, progressHandler,false,0,true );
			fileObject.addEventListener( IOErrorEvent.IO_ERROR, faultHandler,false,0,true );
			fileObject.upload( request );
		}
		
		private function faultHandler( event:IOErrorEvent ):void {
			var str:String = 'File Name:' + ( event.target as File ).name  + ' File Path :' +  ( event.target as File ).nativePath;	
			var errEvent:Events = new Events();
			var by:ByteArray = new ByteArray();
			by.writeUTFBytes( str );
			errEvent.details = by;
			errEvent.eventName = 'File IO Error'; 
			errEvent.eventDateStart = new Date();
			errEvent.eventType = EventStatus.JAVADBError;
			var eventsEvent:EventsEvent = new EventsEvent( EventsEvent.EVENT_CREATE_EVENTS );
			errEvent.taskFk = ( model.currentTasks ) ? model.currentTasks.taskId : 0;
			errEvent.workflowtemplatesFk = ( model.currentTasks ) ? model.currentTasks.wftFK : 0;
			errEvent.projectFk = model.currentProjects.projectId;
			errEvent.personFk = model.person.personId;
			eventsEvent.events =  errEvent;
			eventsEvent.dispatch();			 
			
			if( model.onlyEmail == 'MESSAGE' || model.onlyEmail == 'REEMAIL' || model.onlyEmail == 'EMAIL' ) { 
				onMSGBgUploadResult( null ); 
			}		
			else { 
				 onBgUploadResult( null ); 
			}					
		}
		
		private function progressHandler( event:ProgressEvent ):void {
			model.uploadingFileName = event.target.nativePath.substr(event.target.nativePath.lastIndexOf(File.separator)+1);
			model.uploadingFileBytesLoaded = event.bytesLoaded.toString();
			model.uploadingFileBytesTotal = event.bytesTotal.toString(); 									
		}
		
		public function getBoundary():String {
			var _boundary:String = "";
			if(_boundary.length == 0) {
				for (var i:int = 0; i < 0x20; i++ ) {
					_boundary += String.fromCharCode( int( 97 + Math.random() * 25 ) );
				}
			}

			return _boundary;
		}
		
		public function onMSGBgUploadResult( rpcEvent:Object ):void {	
			super.result( rpcEvent );
			if( model.bgUploadFile.fileToUpload.length > 0 ) {
				model.bgUploadFile.fileToUpload.removeItemAt( 0 );
			}				
			for( var i:Number = 0; i < model.TaskIDAttachArrayColl.length; i++ ) {
				var fileObject:FileDetails = new FileDetails();
	          	fileObject.fileName = fileDetails.fileName;
	          	fileObject.storedFileName = filename;
	    		fileObject.taskId = int( model.TaskIDAttachArrayColl.getItemAt( i ) );  //taskId
	    		fileObject.fileCategory	= fileDetails.fileCategory;
	    		fileObject.fileDate = model.currentTime;
	    		fileObject.sourcePath = fileDetails.sourcePath;
	    		fileObject.visible = ( !fileDetails.visible ) ? true : fileDetails.visible;
				fileObject.projectFK =  fileDetails.projectId;
	          	fileObject.filePath = fileDetails.destinationpath + "/" + fileDetails.type + "/" + fileObject.storedFileName;
	          	fileObject.type = fileDetails.type;
	          	fileObject.miscelleneous = fileDetails.miscelleneous;
	          	if( Utils.checkTemplateExist( model.firstRelease, fileDetails.workflowId ) ) {
					fileObject.releaseStatus = 1;
				}
				else if( Utils.checkTemplateExist( model.otherRelease, fileDetails.workflowId ) ) {
					fileObject.releaseStatus = 2;
				}
	          	fileObject.page = fileDetails.page;   
	          	          	
	          	model.fileDetailsArray.addItem( fileObject );	
	          	model.FileIDDetialsAttachColl.addItem( fileObject );	
	        }
			
			var SoM:SharedObjectManager = SharedObjectManager.instance;
			SoM.data.filesToBeUpload = model.bgUploadFile.fileToUpload
			SoM.data.fileDetailsArrays = model.FileIDDetialsAttachColl;
			
            if( model.bgUploadFile.fileToUpload.length > 0 ) {
            	fileDetails = model.bgUploadFile.fileToUpload.getItemAt( 0 );         
				loadAndUploadFiles( fileDetails );	
            }
            else {
            	if( model.basicAttachFileColl.length != 0 ) {
	            	for( var i:Number = 0; i < model.TaskIDAttachArrayColl.length; i++ ) {
						for( var j:Number = 0; j < model.basicAttachFileColl.length; j++ ) {
							var tempFiledetails:FileDetails= model.basicAttachFileColl.getItemAt( j ) as FileDetails;
							var fileduplicate:FileDetails = new FileDetails();
							fileduplicate.fileId = NaN;
							fileduplicate.fileName = tempFiledetails.fileName;
							fileduplicate.filePath = tempFiledetails.filePath;
							fileduplicate.fileDate = tempFiledetails .fileDate;
							fileduplicate.taskId =  int( model.TaskIDAttachArrayColl.getItemAt( i ) );	
							fileduplicate.categoryFK = tempFiledetails.categoryFK;
							fileduplicate.type = "Message";						
							fileduplicate.storedFileName = tempFiledetails.storedFileName;
							fileduplicate.projectFK = tempFiledetails.projectFK;
							fileduplicate.visible = tempFiledetails.visible;
							fileduplicate.releaseStatus = tempFiledetails.releaseStatus;
							fileduplicate.miscelleneous = tempFiledetails.miscelleneous;
							fileduplicate.fileCategory = tempFiledetails.fileCategory;
							fileduplicate.page = tempFiledetails.page;
							model.FileIDDetialsAttachColl.addItem( fileduplicate ); 
						}
					}
    			}
				
				var fileEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_CREATE_FILEDETAILS );
				fileEvent.fileDeatils = model.FileIDDetialsAttachColl;
				var eventsArr:Array = [ fileEvent ];    
	 			var handler:IResponder = new Callbacks( result, fault );
	 			var uploadSeq:SequenceGenerator = new SequenceGenerator( eventsArr, handler );
	  			uploadSeq.dispatch();
            } 
			 	
		} 	
		
		public function onBgUploadResult( rpcEvent : Object ) : void {	
			super.result( rpcEvent );
			if( model.bgUploadFile.fileToUpload.length > 0 ) {
				model.bgUploadFile.fileToUpload.removeItemAt( 0 );
			}				
			
			var fileObject:FileDetails = new FileDetails();
			fileObject.fileName = fileDetails.name;
      		fileObject.storedFileName = filename;
			fileObject.taskId = fileDetails.taskId;
			fileObject.fileCategory = fileDetails.fileCategory;
    		fileObject.fileDate = model.currentTime;
    		fileObject.sourcePath = fileDetails.sourcePath;
    		fileObject.visible = ( !fileDetails.visible ) ? true : fileDetails.visible;
			fileObject.projectFK =  fileDetails.projectId;
          	fileObject.filePath = fileDetails.destinationpath + "/" + fileDetails.type + "/" + fileObject.storedFileName;
          	fileObject.type = fileDetails.type;
          	fileObject.miscelleneous = fileDetails.miscelleneous;
          	if( fileDetails.releaseStatus != 0 ) {
          		fileObject.releaseStatus = fileDetails.releaseStatus;
          	}
          	else {
	          	if( Utils.checkTemplateExist( model.firstRelease, fileDetails.workflowId ) ) {
					fileObject.releaseStatus = 1;
				}
				else if( Utils.checkTemplateExist( model.otherRelease, fileDetails.workflowId ) ) {
					fileObject.releaseStatus = 2;
				}
          	}
          	fileObject.page = fileDetails.page;
          	          	
          	model.fileDetailsArray.addItem( fileObject );	
   			var spliObj:Object = FileNameSplitter.splitFileName( fileDetails.storedName );
   			
   			//DECEMBER 31 2009  INDIA	
   			var checkInd:String = '';
   			if( fileDetails.miscelleneous ) {   				
   				checkInd = ( fileDetails.miscelleneous ).substr( 0, 3 );
   			}
   			fileObject.miscelleneous = FileNameSplitter.getUId();
			
			var SoM:SharedObjectManager = SharedObjectManager.instance;
			SoM.data.filesToBeUpload = model.bgUploadFile.fileToUpload;
			SoM.data.fileDetailsArrays = model.fileDetailsArray;
            if( model.bgUploadFile.fileToUpload.length > 0 ) {
            	fileDetails = model.bgUploadFile.fileToUpload.getItemAt( 0 );         
				loadAndUploadFiles( fileDetails );	
            } 
            else {
				var fileEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_CREATE_FILEDETAILS );
				fileEvent.fileDeatils = model.fileDetailsArray;
				var eventsArr:Array = [ fileEvent ];    
	 			var handler:IResponder = new Callbacks( result, fault );
	 			var uploadSeq:SequenceGenerator = new SequenceGenerator( eventsArr, handler );
	  			uploadSeq.dispatch();
            }
		} 	
		
		private function downloadFile():void {
			obj = model.bgDownloadFile.fileToDownload.getItemAt( 0 ) as FileDetails;
			if( obj ) {
				if( obj.sourcePath ) {
					this.delegate.doDownload( obj.sourcePath );
				}
				else {
					this.delegate.doDownload( obj.filePath );
				}
			}	
		}
		
		private function onDownLoadComplete(fileObj:File):void {
        	var downLoadedfile:File = fileObj;
        	var path:String = downLoadedfile.name;
        	var fullPath:String = "DTFlex/"+String(obj.filePath).split(model.parentFolderName)[1];         
        	var copyToLocation:File = File.userDirectory.resolvePath(fullPath);
        	if(!copyToLocation.exists) downLoadedfile.copyTo(copyToLocation,true);
        	var delegate : LocalFileDetailsDAODelegate = new LocalFileDetailsDAODelegate();	
        	var fileDetail:FileDetails = new FileDetails();
        	fileDetail.fileName = obj.fileName;
        	fileDetail.storedFileName = obj.storedFileName;
        	fileDetail.filePath = copyToLocation.nativePath;
        	fileDetail.taskId = obj.taskId;
        	fileDetail.categoryFK = obj.categoryFK;		
        	fileDetail.projectFK = obj.projectFK;
        	fileDetail.remoteFileFk = obj.fileId;
        	fileDetail.page = 	obj.page;
        	fileDetail.miscelleneous = obj.miscelleneous;
			var result1:SQLResult = delegate.addFileDetails(fileDetail);
			if(model.bgDownloadFile.fileToDownload.length==1){
				if(model.loadPushedSwfFiles){
					model.bgDownloadFile.downloadComplete();
					model.loadPushedSwfFiles = false;
				}				
				if(model.loadSwfFiles){
					if(model.currentTasks.previousTask.fileObj!=null){			
						var result:SQLResult = delegate.getSwfFileDetails(model.currentTasks.previousTask.fileObj);
						var array:Array = [];
						array = result.data as Array; 
						if(array!=null){
							model.pdfFileCollection = new ArrayCollection(array);
							var pdfInitEvent:PDFInitEvent = new PDFInitEvent();
							pdfInitEvent.dispatch();
							model.loadSwfFiles = false;
						}
					}
					if(Utils.checkTemplateExist(model.indReaderMailTemplatesCollection,model.currentTasks.workflowtemplateFK.workflowTemplateId))
					{
						var result:SQLResult = delegate.getIndFileDetails(model.currentTasks.fileObj);
						var array:Array = [];
						array = result.data as Array;
						if(array!=null){
							model.pdfFileCollection = new ArrayCollection(array);
							var pdfInitEvent:PDFInitEvent = new PDFInitEvent();
							pdfInitEvent.dispatch();
							model.loadSwfFiles = false;
						}
					}
				}else if(model.loadComareTaskFiles){
					if(model.compareTask.fileObj!=null){			
							var result:SQLResult = delegate.getSwfFileDetails(model.compareTask.fileObj);
							var array:Array = [];
							array = result.data as Array;
							if(array!=null){							
								model.comaparePdfFileCollection = new ArrayCollection(array); 
								var pdfInitEvent:PDFInitEvent = new PDFInitEvent();
								pdfInitEvent.dispatch();
								model.loadComareTaskFiles = false;
							}
					}
				}else if(model.loadMPVFiles){ 
					var result:SQLResult = delegate.getSwfFileDetails(model.currentPDFFile); 
					var array:Array = [];
					array = result.data as Array;
					var tempFilePath:String="";
					var currentSWF:FileDetails = new FileDetails()
					if( model.preloaderVisibility )	model.preloaderVisibility = false;

					if(array!=null){
						currentSWF = array[0] as FileDetails;
						model.currentSwfFile = currentSWF;
						/* var pop1:MiniPDFReader = MiniPDFReader(PopUpManager.createPopUp(model.mainClass, MiniPDFReader, true));
						pop1.pdfTool.imgURL =currentSWF.filePath;
						var commentEvent : CommentEvent = new CommentEvent(CommentEvent.GET_COMMENT);
						commentEvent.fileFk = currentSWF.remoteFileFk; 
						commentEvent.dispatch()			  
						pop1.x = (Capabilities.screenResolutionX/2) - ((Capabilities.screenResolutionX*0.9)/2);
						pop1.y = (Capabilities.screenResolutionY/2) - ((Capabilities.screenResolutionY*0.9)/2); */
						model.PopupOpenStatus = true;
						model.loadMPVFiles = false;
					}
				}
			}
       	}     
       	
		public function onBgDownloadFileResult( rpcEvent : Object ) : void {	
			super.result(rpcEvent);	
			var fileObj:File = new File();
			if(obj.extension=="swf"&&obj.type=="Tasks"){
				var tempDir:File;
				tempDir =File.createTempDirectory()
				fileObj = tempDir.resolvePath(obj.fileName);	
			}else{
				//fileObj = File.desktopDirectory.resolvePath(obj.fileName);
				var tempDir:File;
				tempDir =File.createTempDirectory()
				fileObj = tempDir.resolvePath(obj.fileName); 
			}
			var fileStre:FileStream = new FileStream();
			var SoM:SharedObjectManager = SharedObjectManager.instance;
			if(rpcEvent.result!= null){
				fileStre.open(fileObj,FileMode.WRITE);
				fileStre.writeBytes(rpcEvent.result as ByteArray);
				fileStre.close();
				onDownLoadComplete(fileObj);
				if(model.bgDownloadFile.fileToDownload.length>0)
					model.bgDownloadFile.fileToDownload.removeItemAt(0);
				var fileDt:FileDetails;
				SoM.data.filesToBeDownload = model.bgDownloadFile.fileToDownload;
				if(model.bgDownloadFile.fileToDownload.length>0){
					downloadFile();
				}
			}
			else{
				if(model.bgDownloadFile.fileToDownload.length>0)
					model.bgDownloadFile.fileToDownload.removeItemAt(0);
				SoM.data= null;
				Alert.show(model.loc.getString('fileServerSync'))
			}
			model.bgDownloadFileRefresh = true 
		}
		public function getBasicFileDetailsResult( rpcEvent:Object ):void {	
			model.basicFileCollection = rpcEvent.result as ArrayCollection;
		 	var filedetailsTaskEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_GET_TASKFILEDETAILS);
			var eventsArr:Array = [ filedetailsTaskEvent ]    
 			var handler:IResponder = new Callbacks( result, fault );
 			var downloadSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
  			downloadSeq.dispatch();
		} 
		
		public function getMessageFileDetailsResult( rpcEvent:Object ):void {
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.messageFileCollection = arrc;
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( "taskId" ) ];
            model.messageFileCollection.sort = sort;
            model.messageFileCollection.refresh(); 
            super.result( rpcEvent );           
		} 
		
		public function getBasicMessageViewResult( rpcEvent : Object ) : void {			
			super.result(rpcEvent);
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.modelBasicMessageCollect = arrc;
			var sort:Sort = new Sort(); 
            sort.fields = [new SortField("taskId")];
            model.modelBasicMessageCollect.sort = sort;
            model.modelBasicMessageCollect.refresh();
  		}	 	
	}
}

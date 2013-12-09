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
	import com.adams.dt.event.PDFTool.PDFInitEvent;
	import com.adams.dt.event.TasksEvent;
	import com.adams.dt.event.TeamlineEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.managers.SharedObjectManager;
	import com.adams.dt.model.vo.EventStatus;
	import com.adams.dt.model.vo.Events;
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.model.vo.Projects;
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
	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipOutput;
	public final class FileDetailsCommand extends AbstractCommand 
	{ 
		private var count:int=0;
    	private var type:String;
		private var downloadingFileObj:FileDetails;
		private var uploadingFileObj:FileDetails;
		private var fileDetailsEvent:FileDetailsEvent;
		private var fileCollection:ArrayCollection;
		private var filename:String;		
		private var evtype:String;
		private var bulDowloadPrj:Projects; 
		private var _bulkDownloadArray:Array;
		private var zipFile:ZipOutput;
		
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
		            delegate.findByNameId( fileDetailsEvent.fileDetailsObj.miscelleneous, fileDetailsEvent.fileDetailsObj.fileId );
	            break;
	            case FileDetailsEvent.EVENT_GET_INDFILEDETAILS:
	            	delegate.responder = new Callbacks( swfFileDetails, fault );
	            	delegate.findByMailFileId( fileDetailsEvent.fileDetailsObj.fileId );
	            break;
	            case FileDetailsEvent.EVENT_CREATE_FILEDETAILS:
		           	delegate.responder = new Callbacks( createFileDetailsResult, fault );	
		            delegate.bulkUpdate( fileDetailsEvent.fileDeatils );
	            break; 
	            case FileDetailsEvent.EVENT_CREATE_SWFFILEDETAILS:
		           	delegate.responder = new Callbacks( createSwfFileDetailsResult, fault );
		        	if( model.fileDetailsToUpdate.length > 0 ) {
		        		delegate.create( model.fileDetailsToUpdate.getItemAt( 0 ) as FileDetails );
		        	}	
	            break; 
	          	case FileDetailsEvent.EVENT_UPDATE_FILEDETAILS: 
	            	delegate.responder = new Callbacks( releaseFileDetailsResult, fault );	           
	            	if( model.fileCollectionToUpdate.length > 0 ) {	
	            		delegate.bulkUpdate( model.fileCollectionToUpdate );
	            	}
	            	else {
						updateFilesBulk();	            	
	            	}
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
	            case FileDetailsEvent.EVENT_GET_FILEDETAILSBYID:
	            	delegate.responder = new Callbacks( getfileDetailsbyId, fault );
		            delegate.findByMailFileId( fileDetailsEvent.fileDetailsObj.fileId );
	            break;
	             case FileDetailsEvent.EVENT_GET_REFFILEDETAILS:
	            	delegate.responder = new Callbacks( getRefFileDetailsResult, fault );
	            	delegate.findById( model.referenceProject.projectId );
	            break;
	            case FileDetailsEvent.EVENT_DELETEALL_FILEDETAILS:
	            	delegate.responder = new Callbacks( result, fault );
	            	delegate.deleteAll();
	            break;
	            case FileDetailsEvent.EVENT_BGUPLOAD_FILE:
		            if( model.bgUploadFile.fileToUpload.length > 0 ) {	  
		        		uploadingFileObj = model.bgUploadFile.fileToUpload.getItemAt( 0 ) as FileDetails;      
						loadAndUploadFiles( uploadingFileObj );
		        	}
	            break;
	            case FileDetailsEvent.EVENT_BGDOWNLOAD_FILE:
		            delegate = DelegateLocator.getInstance().fileUploadDelegate;
		            if( fileDetailsEvent.bulkDownload ) {
		            	model.bgDownloadFile.isBulkDownload = false;
		            	_bulkDownloadArray = [];
		            	bulDowloadPrj = model.currentProjects;
		            	delegate.responder = new Callbacks( bulkFileDownloadResult, fault );
		            }
		            else if( fileDetailsEvent.thumbDownload ) {
		            	model.bgDownloadFile.isThumbDownload = false;
		            	delegate.responder = new Callbacks( thumbDownloadResult, fault );
		            }
		            else {
		            	delegate.responder = new Callbacks( onBgDownloadFileResult, fault );
		            }
		            if( model.bgDownloadFile.fileToDownload.length > 0 ) {
		            	downloadingFileObj = model.bgDownloadFile.fileToDownload.getItemAt( 0 ) as FileDetails;
						if( downloadingFileObj ) {
							if( downloadingFileObj.downloadPath ) {
								this.delegate.doDownload( downloadingFileObj.downloadPath );
							}
							else {
								this.delegate.doDownload( downloadingFileObj.filePath );
							}
						}	
					}	
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
	            case FileDetailsEvent.EVENT_CREATE_REF_FILEDETAILS:
	            	if( model.referenceFiles.length > 0 ) {
	            		delegate.responder = new Callbacks( createRefFileResult, fault );
	            		
	            		if( !model.fileRefDict ) {
	            			model.fileRefDict = {};
	            		}
	            		
	            		if( !model.fileRefDict.hasOwnProperty( FileDetails( model.referenceFiles.getItemAt( 0 ) ).miscelleneous ) ) {
	            			model.fileRefDict[ FileDetails( model.referenceFiles.getItemAt( 0 ) ).miscelleneous ] = FileNameSplitter.getUId();
	            			FileDetails( model.referenceFiles.getItemAt( 0 ) ).miscelleneous = FileNameSplitter.getUId();
	            		}
	            		else {
	            			FileDetails( model.referenceFiles.getItemAt( 0 ) ).miscelleneous = model.fileRefDict[ FileDetails( model.referenceFiles.getItemAt( 0 ) ).miscelleneous ];
	            		}
	            		delegate.create( model.referenceFiles.getItemAt( 0 ) as FileDetails );
	            	}
	            break;          
	            default:
	            break;  
	    	}
 		} 
		
		private function createRefFileResult( rpcEvent:Object ):void {
			if( model.referenceFiles.length > 0 ) {
				model.referenceFiles.removeItemAt( 0 );
			}
			if( model.referenceFiles.length > 0 ) {
				var fileEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_CREATE_REF_FILEDETAILS );
				fileEvent.dispatch();	
			}
			else {
				model.fileRefDict = null;
				model.bgUploadFile.idle = true;
				model.bgUploadFile.fileToUpload = model.filesToUpload;
				model.refFilesDetails.removeAll(); 
			}
			super.result( rpcEvent ); 
		}
		
		private function onFileObjectUpdate( rpcEvent:Object ):void {
			super.result( rpcEvent ); 
		}	
		
		/**
		 * get the refrence project file details 
		 */ 
		private function getProjectFileResult( rpcEvent:Object ):void {
			super.result( rpcEvent );	
		}
		
		/**
		 * for refrence project duplicate the file details with new project id
		 */ 
		private function duplicateFileDetailsResult( rpcEvent:Object ):void {
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
		private function getFileDetailsResult( rpcEvent:Object ):void {
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			removeInvisibleFile( arrc );
			super.result( rpcEvent );	
		}
		
		/**
		 * remove invisible files
		 */
		private function getRefFileDetailsResult( rpcEvent:Object):void {
			super.result( rpcEvent );	
		}
		/**
		 * remove invisible files
		 */
		private function removeInvisibleFile( arrc:ArrayCollection ):void {
			model.refFilesDetails.removeAll();
			for each( var fo:FileDetails in arrc ) {
				if( fo.visible ) {
					model.refFilesDetails.addItem( fo );
				}	
			}
			model.refFilesDetails.refresh();
		}
		
		/**
		 * duplicate the filedetails with diffrent message task id
		 */
		public function createMsgDuplicateResult( rpcEvent:Object ):void {
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
		public function getfileDetailsbyId( rpcEvent:Object ):void {
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
			if( model.fileCollectionToUpdate.length > 0 ) {	
	           model.fileCollectionToUpdate.removeAll();
	        }
			updateFilesBulk();
			//AdminTool VersionTask used for current task
			if( model.currentUserProfileCode == 'ADM' )	 {
				var filedetailsTaskEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_GET_TASKFILEDETAILS);
        		filedetailsTaskEvent.dispatch();
			}
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
		 * create bulk of file details result function
		 * create the local file details
		 * if its pdf conversion file update the task with file id
		 */ 
		private function createFileDetailsResult( rpcEvent:Object ):void {	
			
			super.result( rpcEvent );	
			
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			var gettaskEvent:TasksEvent = new TasksEvent( TasksEvent.EVENT_GET_TASK );
			var taskToUpdate:Tasks = new Tasks();
			
			for each( var obj:FileDetails in model.fileDetailsArray ) {
				
				var delegate:LocalFileDetailsDAODelegate = new LocalFileDetailsDAODelegate();	
	        	
	        	var fileDetail:FileDetails = new FileDetails();	        	
	        	fileDetail.fileName = obj.fileName;
	        	fileDetail.storedFileName = obj.storedFileName;	        	
	        	fileDetail.projectFK = obj.projectFK;
	        	fileDetail.miscelleneous = obj.miscelleneous;
	        	fileDetail.page = obj.page;     
	        	fileDetail.downloadPath = obj.downloadPath;
	        	
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
	        	fileDetail.filePath = obj.downloadPath;
	        	fileDetail.type = obj.type
				
				var result1:SQLResult = delegate.addFileDetails( fileDetail );
			 	
			 	if( obj.extension== "pdf" ) {
	          		model.pdfConversion = true; 
	          		fileDetail.miscelleneous = obj.miscelleneous;
					var conversionName:String =  obj.fileName; 
					var conversionPath:String = obj.downloadPath.split( File.separator + filename )[ 0 ];
					Pdf2SwfUtil.doConvert( obj.filePath, fileDetail );
				 }
			}
			model.filesToUpload = new ArrayCollection();
			model.fileDetailsArray = new ArrayCollection();
			
			var SoM:SharedObjectManager = SharedObjectManager.instance; 
			SoM.data.filesToBeUpload = model.bgUploadFile.fileToUpload;
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
		
		private function createSwfFileDetailsResult( rpcEvent:Object ):void {
			var swfDetail:FileDetails = rpcEvent.result as FileDetails;
			model.fileDetailsToUpdate.removeItemAt( 0 );
			
			if( model.fileDetailsToUpdate.length > 0 ) {
			 	var filedetailsTaskEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_CREATE_SWFFILEDETAILS );
				filedetailsTaskEvent.dispatch();
			 } 
			 else {
			 	model.pdfConversion = false;
			 	
			 	var handler:IResponder = new Callbacks( result, fault );
			 	var eventtask:TeamlineEvent = new TeamlineEvent( TeamlineEvent.EVENT_PROFILE_PROJECT_TEAMLINE, handler );
				eventtask.dispatch();
			 }
		}
		
		private function loadAndUploadFiles( fileObj:FileDetails ):void {
			model.uploadFileNumbers = model.bgUploadFile.fileToUpload.length;
			delegate = DelegateLocator.getInstance().fileUploadDelegate;
			
			var fileToBeUpload:File = new File( fileObj.downloadPath );
			
			if( model.onlyEmail == 'MESSAGE' || model.onlyEmail == 'REEMAIL' || model.onlyEmail == 'EMAIL' ) { 
				delegate.responder = new Callbacks( onMSGBgUploadResult, fault );
				fileToBeUpload.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onMSGBgUploadResult, false, 0, true ); 
			}		
			else { 
				delegate.responder = new Callbacks( onBgUploadResult, fault );	
				fileToBeUpload.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onBgUploadResult, false, 0, true ); 
			}					
			
           fileObj.storedFileName = StringUtils.trimAll( fileObj.storedFileName );
		   filename = fileObj.storedFileName;
			
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
			
			fileToBeUpload.addEventListener( ProgressEvent.PROGRESS, progressHandler, false, 0, true );
			fileToBeUpload.addEventListener( IOErrorEvent.IO_ERROR, faultHandler, false, 0, true );
			fileToBeUpload.upload( request );
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
			model.uploadingFileName = event.target.nativePath.substr( event.target.nativePath.lastIndexOf( File.separator ) + 1 );
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
	          	fileObject.fileName = uploadingFileObj.fileName;
	          	fileObject.storedFileName = filename;
	    		fileObject.taskId = int( model.TaskIDAttachArrayColl.getItemAt( i ) );  //taskId
	    		fileObject.fileCategory	= uploadingFileObj.fileCategory;
	    		fileObject.fileDate = model.currentTime;
	    		fileObject.downloadPath = uploadingFileObj.downloadPath;
	    		fileObject.visible = ( !uploadingFileObj.visible ) ? true : uploadingFileObj.visible;
				fileObject.projectFK =  uploadingFileObj.projectFK;
	          	fileObject.filePath = uploadingFileObj.destinationpath + "/" + uploadingFileObj.type + "/" + fileObject.storedFileName;
	          	fileObject.type = uploadingFileObj.type;
	          	fileObject.miscelleneous = uploadingFileObj.miscelleneous;
	          	
	          	if( uploadingFileObj.taskId != 0 ) {
		          	if( Utils.checkTemplateExist( model.firstRelease, model.currentTasks.workflowtemplateFK.workflowTemplateId ) ) {
						fileObject.releaseStatus = 1;
					}
					else if( Utils.checkTemplateExist( model.otherRelease, model.currentTasks.workflowtemplateFK.workflowTemplateId ) ) {
						fileObject.releaseStatus = 2;
					}
	          	}
	          	
	          	fileObject.page = uploadingFileObj.page;   
	          	          	
	          	model.fileDetailsArray.addItem( fileObject );	
	          	model.FileIDDetialsAttachColl.addItem( fileObject );	
	        }
			
			var SoM:SharedObjectManager = SharedObjectManager.instance;
			SoM.data.filesToBeUpload = model.bgUploadFile.fileToUpload
			SoM.data.fileDetailsArrays = model.FileIDDetialsAttachColl;
			
            if( model.bgUploadFile.fileToUpload.length > 0 ) {
            	uploadingFileObj = model.bgUploadFile.fileToUpload.getItemAt( 0 ) as FileDetails;         
				loadAndUploadFiles( uploadingFileObj );	
            }
            else {
            	model.uploadFileNumbers = 0;
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
		
		private function onBgUploadResult( rpcEvent:Object ):void {	
			super.result( rpcEvent );
			
			if( model.bgUploadFile.fileToUpload.length > 0 ) {
				model.bgUploadFile.fileToUpload.removeItemAt( 0 );
			}				
			
			uploadingFileObj.storedFileName = filename;
			uploadingFileObj.fileDate = model.currentTime;
    		uploadingFileObj.visible = ( !uploadingFileObj.visible ) ? true : uploadingFileObj.visible;
			uploadingFileObj.filePath = uploadingFileObj.destinationpath + "/" + uploadingFileObj.type + "/" + uploadingFileObj.storedFileName;
          	uploadingFileObj.miscelleneous = FileNameSplitter.getUId();
          	
          	/*if( uploadingFileObj.taskId != 0 && model.currentTasks ) {
	          	if( Utils.checkTemplateExist( model.firstRelease, model.currentTasks.workflowtemplateFK.workflowTemplateId ) ) {
					uploadingFileObj.releaseStatus = 1;
				}
				else if( Utils.checkTemplateExist( model.otherRelease, model.currentTasks.workflowtemplateFK.workflowTemplateId ) ) {
					uploadingFileObj.releaseStatus = 2;
				}
          	}*/
          	          	
          	model.fileDetailsArray.addItem( uploadingFileObj );	
   			
   			var SoM:SharedObjectManager = SharedObjectManager.instance;
			SoM.data.filesToBeUpload = model.bgUploadFile.fileToUpload;
			SoM.data.fileDetailsArrays = model.fileDetailsArray;
            
            if( model.bgUploadFile.fileToUpload.length > 0 ) {
            	uploadingFileObj = model.bgUploadFile.fileToUpload.getItemAt( 0 ) as FileDetails;         
				loadAndUploadFiles( uploadingFileObj );	
            } 
            else {
            	model.uploadFileNumbers = 0;
            	var handler:IResponder = new Callbacks( result, fault );
				var fileEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_CREATE_FILEDETAILS, handler );
				fileEvent.fileDeatils = model.fileDetailsArray;
				fileEvent.dispatch();
            }
		} 	
		
		private function downloadFile():void {
			downloadingFileObj = model.bgDownloadFile.fileToDownload.getItemAt( 0 ) as FileDetails;
			if( downloadingFileObj ) {
				if( downloadingFileObj.downloadPath ) {
					this.delegate.doDownload( downloadingFileObj.downloadPath );
				}
				else {
					this.delegate.doDownload( downloadingFileObj.filePath );
				}
			}	
		}
		
		private function onDownLoadComplete( fileObj:File ):void {
        	
        	var downLoadedfile:File = fileObj;
        	var path:String = downLoadedfile.name;
        	var fullPath:String = "DTFlex/" + String( downloadingFileObj.filePath ).split( model.parentFolderName )[ 1 ];         
        	var copyToLocation:File = File.userDirectory.resolvePath( fullPath );
        	
        	if( !copyToLocation.exists ) {
        		downLoadedfile.copyTo( copyToLocation, true );
        	}
        	
        	var delegate : LocalFileDetailsDAODelegate = new LocalFileDetailsDAODelegate();	
        	var fileDetail:FileDetails = new FileDetails();
        	fileDetail.fileName = downloadingFileObj.fileName;
        	fileDetail.storedFileName = downloadingFileObj.storedFileName;
        	fileDetail.filePath = copyToLocation.nativePath;
        	fileDetail.taskId = downloadingFileObj.taskId;
        	fileDetail.categoryFK = downloadingFileObj.categoryFK;		
        	fileDetail.projectFK = downloadingFileObj.projectFK;
        	fileDetail.remoteFileFk = downloadingFileObj.fileId;
        	fileDetail.page = downloadingFileObj.page;
        	fileDetail.miscelleneous = downloadingFileObj.miscelleneous;
			
			var result:SQLResult = delegate.addFileDetails( fileDetail ); 
			
			if( model.bgDownloadFile.fileToDownload.length == 1 ) {
				 model.fileUploadStatus = true;
				if( model.loadPushedSwfFiles ) {
					model.bgDownloadFile.downloadComplete();
					model.loadPushedSwfFiles = false;
				}			
				
				var pdfInitEvent:PDFInitEvent;	
				
				if( model.loadSwfFiles ) {
					if( model.currentTasks.previousTask.fileObj ) {			
						var swfResult:SQLResult = delegate.getSwfFileDetails( model.currentTasks.previousTask.fileObj );
						var swfArray:Array = swfResult.data as Array;
						if( swfArray ) {
							model.pdfFileCollection = new ArrayCollection( swfArray );
							pdfInitEvent = new PDFInitEvent();
							pdfInitEvent.dispatch();
							model.loadSwfFiles = false;
						}
					}
					
					if( Utils.checkTemplateExist( model.indReaderMailTemplatesCollection, model.currentTasks.workflowtemplateFK.workflowTemplateId ) ) {
						var indResult:SQLResult = delegate.getIndFileDetails( model.currentTasks.fileObj );
						var indArray:Array = indResult.data as Array;
						if( indArray ) {
							model.pdfFileCollection = new ArrayCollection( indArray );
							pdfInitEvent = new PDFInitEvent();
							pdfInitEvent.dispatch();
							model.loadSwfFiles = false;
						}
					}
				}
				else if( model.loadComareTaskFiles ) {
					if( model.compareTask.fileObj ) {			
						var compareTaskResult:SQLResult = delegate.getSwfFileDetails( model.compareTask.fileObj );
						var compareTaskArray:Array = compareTaskResult.data as Array;
						if( compareTaskArray ) {							
							model.comaparePdfFileCollection = new ArrayCollection( compareTaskArray ); 
							pdfInitEvent = new PDFInitEvent();
							pdfInitEvent.dispatch();
							model.loadComareTaskFiles = false;
						}
					}
				}
				else if( model.loadMPVFiles ) { 
					var MPVResult:SQLResult = (model.currentPDFFile.extension !="pdf")?delegate.getNonSwfFileDetails( model.currentPDFFile ):delegate.getSwfFileDetails( model.currentPDFFile );
					var MPVArray:Array = MPVResult.data as Array;
					var tempFilePath:String = '';
					var currentSWF:FileDetails = new FileDetails();
					
					if( model.preloaderVisibility )	{
						model.preloaderVisibility = false;
					}
			
					if( MPVArray ) {
						currentSWF = MPVArray[ 0 ] as FileDetails;
						model.pdfDetailVO.localeBool = true;
						if( model.currentPDFFile.extension =="pdf" ){ 
							model.pdfFileCollection = new ArrayCollection( MPVArray )
							model.currentSwfFile = currentSWF;
							model.PopupOpenStatus = true;
							model.loadMPVFiles = false;
						 };
						
					}
				}
			}
			model.fileUploadStatus = false;
       	}     
       	
		private function onBgDownloadFileResult( rpcEvent:Object ):void {	
			var fileObj:File;
			
			if( downloadingFileObj.extension == "swf" ) {
				var fullPath:String = "DTFlex/" + String( downloadingFileObj.filePath ).split( model.parentFolderName )[ 1 ];         
        		fileObj = File.userDirectory.resolvePath( fullPath );
			}
			else {
				fileObj = File.desktopDirectory.resolvePath( downloadingFileObj.fileName );
			}
			
			var fileStre:FileStream = new FileStream();
			var SoM:SharedObjectManager = SharedObjectManager.instance;
			
			if( rpcEvent.result ) {
				
				fileStre.open( fileObj, FileMode.WRITE );
				fileStre.writeBytes( rpcEvent.result as ByteArray );
				fileStre.close();
				
				onDownLoadComplete( fileObj );
				
				if( model.bgDownloadFile.fileToDownload.length > 0 ) {
					model.bgDownloadFile.fileToDownload.removeItemAt( 0 );
				}	
				
				SoM.data.filesToBeDownload = model.bgDownloadFile.fileToDownload;
				
				if( model.bgDownloadFile.fileToDownload.length > 0 ) {
					downloadFile();
				}
			}
			else {
				if( model.bgDownloadFile.fileToDownload.length > 0 ) {
					model.bgDownloadFile.fileToDownload.removeItemAt( 0 );
				}	
				SoM.data = null;
				Alert.show( model.loc.getString( 'fileServerSync' ) );
			}
			super.result( rpcEvent );
		}
		
		private function bulkFileDownloadResult( rpcEvent:Object ):void {
			var SoM:SharedObjectManager = SharedObjectManager.instance;
			if( !rpcEvent.result ) {
				if( model.bgDownloadFile.fileToDownload.length > 0 ) {
					model.bgDownloadFile.fileToDownload.removeItemAt( 0 );
				}	
				SoM.data = null;
				Alert.show( model.loc.getString( 'fileServerSync' ) );
				return;
			}
			
			var fileObj:File;
			var fullPath:String = "DTFlex/" + String( downloadingFileObj.filePath ).split( model.parentFolderName )[ 1 ];         
        	fileObj = File.userDirectory.resolvePath( fullPath );
        	
        	if( duplicateZipCheck( downloadingFileObj.fileName ) ) {
        		var zipObject:Object = {};
	        	zipObject.name = downloadingFileObj.fileName;
	        	zipObject.data = rpcEvent.result as ByteArray;
	        	_bulkDownloadArray.push( zipObject );
	        	if( !fileObj.exists ) {
	        		var fileStream:FileStream = new FileStream();
	        		fileStream.openAsync( fileObj, FileMode.WRITE );
					fileStream.writeBytes( rpcEvent.result as ByteArray );
					fileStream.addEventListener( Event.CLOSE, onStremClose );
					fileStream.close();
	        	}
	        	else {
	        		makeZip();
	        	}
        	}
        	else {
        		makeZip();
        	}
		}
		
		private function duplicateZipCheck( fileName:String ):Boolean {
			for each( var item:Object in  _bulkDownloadArray ) {
				if( item.name == fileName ) {
					return false;
				}
			}
			return true;
		}
		
		private function onStremClose( event:Event ):void {
			makeZip();
		}
		
		private function makeZip():void {
			if( model.bgDownloadFile.fileToDownload.length > 0 ) {
				model.bgDownloadFile.fileToDownload.removeItemAt( 0 );
			}
			if( model.bgDownloadFile.fileToDownload.length != 0 ) {
				downloadFile();
			}
			else {
				zipFile = new ZipOutput();  
				for( var i:uint = 0; i < _bulkDownloadArray.length; i++) {  
			    	var zipEntry:ZipEntry = new ZipEntry( _bulkDownloadArray[ i ].name );  
					zipFile.putNextEntry( zipEntry );  
					zipFile.write( _bulkDownloadArray[ i ].data );  
					zipFile.closeEntry();  
				}  
				zipFile.finish();  
				saveZip();
			}
		}
		
		private function saveZip():void {
			var archiveFile:File = File.desktopDirectory.resolvePath( bulDowloadPrj.projectName + ".zip" );
			if( !archiveFile.exists ) {  
				var stream:FileStream = new FileStream();  
				stream.open( archiveFile, FileMode.WRITE );  
			    stream.writeBytes( zipFile.byteArray );  
				stream.close();  
			}
		}	
		
		private function thumbDownloadResult( rpcEvent:Object ):void {
			var fullPath:String = "DTFlex/" + String( FileNameSplitter.getDestinationPath( model.currentProjects, model.parentFolderName ) ).split( model.parentFolderName )[ 1 ] + "/" + downloadingFileObj.type + "/" + downloadingFileObj.fileName;
        	var copyToLocation:File = File.userDirectory.resolvePath( fullPath );
        	
        	if( !copyToLocation.exists ) {
        		var fileObj:File = File.userDirectory.resolvePath( fullPath );
        		var fileStre:FileStream = new FileStream();
				if( rpcEvent.result ) {
					fileStre.open( fileObj, FileMode.WRITE );
					fileStre.writeBytes( rpcEvent.result as ByteArray );
					fileStre.close();
				}	
        	}
        	if( model.bgDownloadFile.fileToDownload.length > 0 ) {
				model.bgDownloadFile.fileToDownload.removeItemAt( 0 );
			}	
			if( model.bgDownloadFile.fileToDownload.length > 0 ) {
				downloadFile();
			}
			else {
				model.thumbFiles.removeAll();
				if( model.thumbnailSet ) {
					model.thumbnailSet = false;
				}
				else {
					model.thumbnailSet = true;
				}
			}
		}
		
		private function getBasicFileDetailsResult( rpcEvent:Object ):void {	
			model.basicFileCollection = rpcEvent.result as ArrayCollection;
			var handler:IResponder = new Callbacks( result, fault );
		 	var filedetailsTaskEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_GET_TASKFILEDETAILS, handler );
			filedetailsTaskEvent.dispatch();
		} 
		
		private function getTaskFileDetailsResult( rpcEvent:Object ):void {
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.taskFileCollection = arrc;
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( "taskId" ) ];
            model.taskFileCollection.sort = sort;
            model.taskFileCollection.refresh();  
            
            var handler:IResponder = new Callbacks( result, fault );
            var filedetailsMessageEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_GET_MESSAGEFILEDETAILS, handler );
			filedetailsMessageEvent.dispatch();
  		}
		
		private function getMessageFileDetailsResult( rpcEvent:Object ):void {
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.messageFileCollection = arrc;
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( "taskId" ) ];
            model.messageFileCollection.sort = sort;
            model.messageFileCollection.refresh(); 
            
            super.result( rpcEvent );           
		} 
		
		private function getBasicMessageViewResult( rpcEvent:Object ):void {			
			super.result( rpcEvent );
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.modelBasicMessageCollect = arrc;
			var sort:Sort = new Sort(); 
            sort.fields = [ new SortField( "taskId" ) ];
            model.modelBasicMessageCollect.sort = sort;
            model.modelBasicMessageCollect.refresh();
  		}	 	
	}
}

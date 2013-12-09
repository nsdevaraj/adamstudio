package com.adams.dam.command
{
	import com.adams.dam.business.DelegateLocator;
	import com.adams.dam.business.delegates.LocalFileDetailsDAODelegate;
	import com.adams.dam.business.utils.FileNameSplitter;
	import com.adams.dam.business.utils.StringUtils;
	import com.adams.dam.event.FileDetailsEvent;
	import com.adams.dam.model.ModelLocator;
	import com.adams.dam.model.Pdf2SwfUtil;
	import com.adams.dam.model.so.SharedObjectManager;
	import com.adams.dam.model.vo.FileDetails;
	import com.adams.dam.model.vo.Projects;
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

	public class FileDetailsCommand extends AbstractCommand
	{
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		private var _fileDetailsEvent:FileDetailsEvent;
		private var handler:IResponder;
		private var bulDowloadPrj:Projects; 
		private var _bulkDownloadArray:Array;
		private var downloadingFileObj:FileDetails;
		private var uploadingFileObj:FileDetails;
		private var uploadingFileName:String;
		private var convertingFile:FileDetails;
		
		override public function execute( event:CairngormEvent ):void {
			super.execute( event );
			
			_fileDetailsEvent = FileDetailsEvent( event );
			delegate = DelegateLocator.getInstance().fileDetailsDelegate;
			
			switch( _fileDetailsEvent.type ) {
				case FileDetailsEvent.GET_ALL_FILES:
					handler = new Callbacks( onGetAllFilesResult, fault );
					delegate.responder = handler;
					delegate.findAll();
					break;
				case FileDetailsEvent.EVENT_CREATE_FILEDETAILS:
					delegate.responder = new Callbacks( createFileDetailsResult, fault );	
					delegate.bulkUpdate( _fileDetailsEvent.fdToCreate );
					break; 
				case FileDetailsEvent.EVENT_SELECT_FILEDETAILS:
					delegate.responder = new Callbacks( onSelectFileDetailsResult, fault );
					delegate.findByMailFileId( _fileDetailsEvent.fileDetails.remoteFileFk );
					break;
				case FileDetailsEvent.EVENT_UPDATE_FILEDETAILS:
					delegate.responder = new Callbacks( onFileDetailsUpdate, fault );
					delegate.update( _fileDetailsEvent.fileDetails );
					break;  
				case FileDetailsEvent.EVENT_BGDOWNLOAD_FILE:
					delegate = DelegateLocator.getInstance().fileUpDownDelegate;
					
					if( _fileDetailsEvent.bulkDownload ) {
						_bulkDownloadArray = [];
						bulDowloadPrj = model.project;
						delegate.responder = new Callbacks( bulkFileDownloadResult, fault );
					}
					else if( _fileDetailsEvent.thumbDownload ) {
						delegate.responder = new Callbacks( thumbDownloadResult, fault );
					}
					else {
						delegate.responder = new Callbacks( onBgDownloadFileResult, fault );
					}
					if( model.bgDownloadFile.fileToDownload.length > 0 ) {
						downloadingFileObj = model.bgDownloadFile.fileToDownload.getItemAt( 0 ) as FileDetails;
						if( downloadingFileObj ) {
							if( downloadingFileObj.downloadPath ) {
								delegate.doDownload( downloadingFileObj.downloadPath );
							}
							else {
								delegate.doDownload( downloadingFileObj.filePath );
							}
						}	
					}	
					break;
				case FileDetailsEvent.EVENT_BGUPLOAD_FILE:
					if( model.bgUploadFile.fileToUpload.length > 0 ) {	  
						uploadingFileObj = model.bgUploadFile.fileToUpload.getItemAt( 0 ) as FileDetails;      
						loadAndUploadFiles( uploadingFileObj );
					}
					break;
				case FileDetailsEvent.EVENT_CONVERT_FILE:
					delegate = DelegateLocator.getInstance().fileUpDownDelegate;
					delegate.responder = new Callbacks( conversionResult, fault ); 
					convertingFile = _fileDetailsEvent.fileDetails; 
					delegate.doConvert( _fileDetailsEvent.PDFfilepath, _fileDetailsEvent.PDFconversionexe );
					break;
				case FileDetailsEvent.EVENT_CREATE_SWFFILEDETAILS:
					delegate.responder = new Callbacks( createSwfFileDetailsResult, fault );
					delegate.bulkUpdate( model.swfFileDetailsToUpload );
					break; 
				default :
					break;
			}
		}	
		
		protected function onGetAllFilesResult( callResult:Object ):void {
			model.totalFileDetailsCollection = callResult.result as ArrayCollection; 
			super.result( callResult );
		}
		
		protected function createFileDetailsResult( callResult:Object ):void {	
			super.result( callResult );	
			
			var result:ArrayCollection = callResult.result as ArrayCollection;
			
			for each( var obj:FileDetails in model.fileDetailsToUpload ) {
				
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
				result.sort = sort;
				result.refresh(); 
				var cursor:IViewCursor =  result.createCursor();
				var found:Boolean = cursor.findAny(fileDetail);
				if( found ) {
					fileDetail.remoteFileFk = FileDetails( cursor.current ).fileId;
				} 
				fileDetail.taskId = obj.taskId;	
				fileDetail.categoryFK = obj.categoryFK;		
				fileDetail.filePath = obj.downloadPath;
				fileDetail.type = obj.type
				
				var result1:SQLResult = delegate.addFileDetails( fileDetail );
				
				if( obj.extension == "pdf" ) {
					model.pdfConversion = true;
					fileDetail.miscelleneous = obj.miscelleneous;
					Pdf2SwfUtil.doConvert( obj.filePath, fileDetail );
				}
			}
			
			model.filesToUpload.removeAll();
			model.fileDetailsToUpload.removeAll();
			
			var SoM:SharedObjectManager = SharedObjectManager.instance; 
			SoM.data.filesToUpload = model.bgUploadFile.fileToUpload
			SoM.data.fileDetailsToUpload = model.fileDetailsToUpload;
		}
		
		protected function onSelectFileDetailsResult( callResult:Object ):void {
			var fileDetailsObj:FileDetails = FileDetails( ArrayCollection( callResult.result ).getItemAt( 0 ) );
			if( fileDetailsObj ) {
				model.filesToDownload.addItem( fileDetailsObj );
				model.bgDownloadFile.idle = true;
				model.bgDownloadFile.fileToDownload.list = model.filesToDownload.list;
			}
			super.result( callResult );
		}
		
		protected function onFileDetailsUpdate( callResult:Object ):void {
			super.result( callResult ); 
		}
		
		protected function bulkFileDownloadResult( callResult:Object ):void {
			
		}
		
		protected function thumbDownloadResult( callResult:Object ):void {
			
		}
		
		protected function onBgDownloadFileResult( callResult:Object ):void {
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
			
			if( callResult.result ) {
				
				fileStre.open( fileObj, FileMode.WRITE );
				fileStre.writeBytes( callResult.result as ByteArray );
				fileStre.close();
				
				onDownLoadComplete( fileObj );
				
				if( model.bgDownloadFile.fileToDownload.length > 0 ) {
					model.bgDownloadFile.fileToDownload.removeItemAt( 0 );
				}	
				
				SoM.data.filesToDownload = model.bgDownloadFile.fileToDownload;
				
				if( model.bgDownloadFile.fileToDownload.length > 0 ) {
					downloadFile();
				}
			}
			else {
				if( model.bgDownloadFile.fileToDownload.length > 0 ) {
					model.bgDownloadFile.fileToDownload.removeItemAt( 0 );
				}	
				SoM.data = null;
				Alert.show( 'fileServerSync' );
			}
			super.result( callResult );
		}	
		
		protected function onDownLoadComplete( fileObj:File ):void {
			
			var downLoadedfile:File = fileObj;
			var path:String = downLoadedfile.name;
			var fullPath:String = "DTFlex/" + String( downloadingFileObj.filePath ).split( model.parentFolderName )[ 1 ];  
			var copyToLocation:File = File.userDirectory.resolvePath( fullPath );
			
			if( !copyToLocation.exists ) {
				downLoadedfile.copyTo( copyToLocation, true );
			}
			
			var localDelegate:LocalFileDetailsDAODelegate = new LocalFileDetailsDAODelegate();	
			
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
			
			var result:SQLResult = localDelegate.addFileDetails( fileDetail );
		} 
		
		protected function downloadFile():void {
			downloadingFileObj = model.bgDownloadFile.fileToDownload.getItemAt( 0 ) as FileDetails;
			if( downloadingFileObj ) {
				if( downloadingFileObj.downloadPath ) {
					delegate.doDownload( downloadingFileObj.downloadPath );
				}
				else {
					delegate.doDownload( downloadingFileObj.filePath );
				}
			}	
		}
		
		protected function loadAndUploadFiles( fileObj:FileDetails ):void {
			//model.uploadFileNumbers = model.bgUploadFile.fileToUpload.length;
			delegate = DelegateLocator.getInstance().fileUpDownDelegate;
			
			var fileToBeUpload:File = new File( fileObj.downloadPath );
			
			delegate.responder = new Callbacks( onBgUploadResult, fault );	
			fileToBeUpload.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onBgUploadResult, false, 0, true ); 
								
			fileObj.storedFileName = StringUtils.trimAll( fileObj.storedFileName );
			uploadingFileName = fileObj.storedFileName;
			
			var url:String = model.serverLocation + "uploadhandler";
			var request:URLRequest = new URLRequest( url );
			request.contentType = 'multipart/form-data; boundary=' + getBoundary();
			request.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
			request.method = URLRequestMethod.POST;
			
			var variables:URLVariables = new URLVariables(); 
			variables.userEncrptName = model.encryptorUserName; 
			variables.passEncrptName = model.encryptorPassword; 
			
			variables.filePath = fileObj.destinationpath + "/" + fileObj.type;
			variables.fileName = uploadingFileName; 
			
			request.data = variables; 
			
			fileToBeUpload.addEventListener( ProgressEvent.PROGRESS, onFileUploadProgress, false, 0, true );
			fileToBeUpload.addEventListener( IOErrorEvent.IO_ERROR, onFileUploadFailure, false, 0, true );
			fileToBeUpload.upload( request );
		}
		
		protected function getBoundary():String {
			var _boundary:String = "";
			if(_boundary.length == 0) {
				for (var i:int = 0; i < 0x20; i++ ) {
					_boundary += String.fromCharCode( int( 97 + Math.random() * 25 ) );
				}
			}
			return _boundary;
		}
		
		protected function onBgUploadResult( callResult:Object ):void {	
			super.result( callResult );
			
			if( model.bgUploadFile.fileToUpload.length > 0 ) {
				model.bgUploadFile.fileToUpload.removeItemAt( 0 );
			}				
			
			uploadingFileObj.storedFileName = uploadingFileName;
			uploadingFileObj.fileDate = model.time;
			uploadingFileObj.visible = ( !uploadingFileObj.visible ) ? true : uploadingFileObj.visible;
			uploadingFileObj.filePath = uploadingFileObj.destinationpath + "/" + uploadingFileObj.type + "/" + uploadingFileObj.storedFileName;
			uploadingFileObj.miscelleneous = FileNameSplitter.getFileIdGenerator();
			
			model.fileDetailsToUpload.addItem( uploadingFileObj );	
			
			var SoM:SharedObjectManager = SharedObjectManager.instance;
			SoM.data.filesToUpload = model.bgUploadFile.fileToUpload;
			SoM.data.fileDetailsToUpload = model.fileDetailsToUpload;
			
			if( model.bgUploadFile.fileToUpload.length > 0 ) {
				uploadingFileObj = model.bgUploadFile.fileToUpload.getItemAt( 0 ) as FileDetails;         
				loadAndUploadFiles( uploadingFileObj );	
			} 
			else {
				//model.uploadFileNumbers = 0;
				if( !model.uploadCompleted ) {
					model.uploadCompleted = true;
				}	
				else {
					model.uploadCompleted = false;
				}		
			}
		} 	
		
		protected function onFileUploadProgress( event:ProgressEvent ):void {
			//model.uploadingFileName = event.target.nativePath.substr( event.target.nativePath.lastIndexOf( File.separator ) + 1 );
			//model.uploadingFileBytesLoaded = event.bytesLoaded.toString();
			//model.uploadingFileBytesTotal = event.bytesTotal.toString(); 									
		}
		
		protected function onFileUploadFailure( event:IOErrorEvent ):void {
			/*var str:String = 'File Name:' + ( event.target as File ).name  + ' File Path :' +  ( event.target as File ).nativePath;	
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
			eventsEvent.dispatch();	*/		 
			
			onBgUploadResult( null ); 
		}
		
		private function conversionResult( rpcEvent:Object ):void 	{
			var returnStr:String = rpcEvent.result as String;
			
			if( returnStr.indexOf( 'OK:' ) != -1 ) {
				var lastind:int;
				( model.pdfServerDir.indexOf( '.sh' ) != -1 ) ?  ( lastind = 1 ) : ( lastind = 2 );
				
				var charspl:int;
				var findIndex:int = returnStr.indexOf( 'OK:' );
				( model.pdfServerDir.indexOf( '.sh' ) != -1 ) ?  ( charspl = ( 4 + findIndex ) ) : ( charspl = ( 5 + findIndex ) ); 
				
				var convertedSwf:String = returnStr.substring( charspl, ( returnStr.length - lastind ) );
				
				( model.pdfServerDir.indexOf( '.sh' ) != -1 ) ?  ( convertedSwf += ', ' ) : ( convertedSwf );
				
				var convertedSwfArr:Array = convertedSwf.split( "," );
				
				if( convertedSwfArr.length == 1 ) {
					Alert.show( "Files Conversion not done" );
				}  
				
				for( var i:int = 0; i < ( convertedSwfArr.length - 1 ); i++ ) {
					var fileObject:FileDetails = new FileDetails();
					fileObject.fileId = NaN;
					fileObject.fileName = getFileName( convertedSwfArr[ i ] );
					fileObject.storedFileName = fileObject.fileName;
					fileObject.taskId = convertingFile.taskId;
					fileObject.categoryFK = 0;
					fileObject.fileCategory = convertingFile.fileCategory;
					fileObject.fileDate = model.time;
					fileObject.visible = false;
					fileObject.downloadPath = convertingFile.downloadPath;
					fileObject.projectFK = convertingFile.projectFK;
					fileObject.filePath = StringUtils.trimSpace( convertedSwfArr[ i ] );
					fileObject.type = convertingFile.type;
					fileObject.miscelleneous = convertingFile.miscelleneous;
					
					fileObject.page = i+1;
					model.swfFileDetailsToUpload.addItem( fileObject );
					
					/*var thumbDetail:FileDetails = new FileDetails();
					var filePath:String = fileObject.filePath.split( fileObject.type )[ 0 ];
					thumbDetail.type = fileObject.type;
					thumbDetail.fileName = FileNameSplitter.splitFileName( fileObject.storedFileName ).filename + "_thumb.swf";
					thumbDetail.filePath = filePath + fileObject.type + '/' + thumbDetail.fileName;
					model.thumbFiles.addItem( thumbDetail );*/
				}
			}
			else {
				Alert.show( "Files Conversion not done" );
			}
			Pdf2SwfUtil.loopConvertSWF();
		}
		
		protected function getFileName( str:String ):String {
			var lastind:int = str.lastIndexOf( '/' ) + 1;
			return str.slice( lastind, str.length );
		}
		
		protected function createSwfFileDetailsResult( callResult:Object ):void {
			model.swfFileDetailsToUpload.removeAll();
			model.pdfConversion = false;
		}
	}
}
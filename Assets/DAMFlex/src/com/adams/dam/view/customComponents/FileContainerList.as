package com.adams.dam.view.customComponents
{
	import com.adams.dam.business.delegates.LocalFileDetailsDAODelegate;
	import com.adams.dam.business.utils.FileNameSplitter;
	import com.adams.dam.event.FileDetailsEvent;
	import com.adams.dam.model.ModelLocator;
	import com.adams.dam.model.vo.FileDetails;
	
	import flash.data.SQLResult;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.desktop.NativeDragOptions;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	
	import spark.components.Button;
	import spark.components.List;
	
	public class FileContainerList extends List
	{
		
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		private var _isDroppable:Boolean;
		private var tempFile:File;
		private var delegate:LocalFileDetailsDAODelegate;
		
		private var _fileCategory:String;
		public function get fileCategory():String {
			return _fileCategory;
		}
		public function set fileCategory( value:String ):void {
			_fileCategory = value;
		}
		
		private var _uploadCompleted:Boolean;
		public function get uploadCompleted():Boolean {
			return _uploadCompleted;
		}
		public function set uploadCompleted( value:Boolean ):void {
			_uploadCompleted = value;
			createFileDetails();
		}
		
		public function FileContainerList()
		{
			super();
			addEventListener( MouseEvent.MOUSE_DOWN, onDragBegin, false, 0, true );  
			addEventListener( NativeDragEvent.NATIVE_DRAG_COMPLETE, onDragComplete, false, 0, true );
		}
		
		override public function get dropEnabled():Boolean {
			return _isDroppable;
		}
		
		override public function set dropEnabled( value:Boolean ):void {
			_isDroppable = value;
			makeEventListeners();
		}
		
		protected function makeEventListeners():void {
			if( dropEnabled ) {
				if( !hasEventListener( NativeDragEvent.NATIVE_DRAG_ENTER ) ) {
					addEventListener( NativeDragEvent.NATIVE_DRAG_ENTER, onDragEnter, false, 0, true );
				}
				if( !hasEventListener( NativeDragEvent.NATIVE_DRAG_DROP ) ) {
					addEventListener( NativeDragEvent.NATIVE_DRAG_DROP, onDrop, false, 0, true );
				}
			}
			else {
				if( hasEventListener( NativeDragEvent.NATIVE_DRAG_ENTER ) ) {
					removeEventListener( NativeDragEvent.NATIVE_DRAG_ENTER, onDragEnter );
				}
				if( hasEventListener( NativeDragEvent.NATIVE_DRAG_DROP ) ) {
					removeEventListener( NativeDragEvent.NATIVE_DRAG_DROP, onDrop );
				}
			}
		}
		
		protected function onDragBegin( event:MouseEvent ):void {
			if( ( selectedItem ) && ( !( event.target is Button ) ) ) { 
				
				var clip:Clipboard = new Clipboard();
				clip.setDataHandler( ClipboardFormats.FILE_LIST_FORMAT, getfileArray );
				clip.setData( 'acceptableFiles', selectedItem );
				
				var dragOptions:NativeDragOptions = new NativeDragOptions();
				dragOptions.allowCopy = true;
				dragOptions.allowLink = false;
				dragOptions.allowMove = false;
				NativeDragManager.doDrag( event.currentTarget as InteractiveObject, clip, null, null, dragOptions );
			}
		}
		
		private function getfileArray():Array {
			return []; 
		}
		
		protected function onDragEnter( event:NativeDragEvent ):void {
			if( event.clipboard.hasFormat( ClipboardFormats.FILE_LIST_FORMAT ) ) {
				var files:Array = event.clipboard.getData( ClipboardFormats.FILE_LIST_FORMAT ) as Array;
				if( files ) { 
					if( files.length == 1 ) {
						if( !File( files[ 0 ] ).isDirectory && !isFileAvailableAlready( files[ 0 ].name ) && model.project ) {
							NativeDragManager.acceptDragDrop( this );
						}
					}	
					else {
						if( model.project ) {
							NativeDragManager.acceptDragDrop( this );
						}
					}
				}
				else {
					var droppedFile:FileDetails = event.clipboard.getData( 'acceptableFiles' ) as FileDetails;
					if( droppedFile ) {
						if( !isFileAvailableAlready( droppedFile.fileName ) && model.project ) {
							NativeDragManager.acceptDragDrop( this );
						}
					} 
				}
			}
		}
		
		protected function onDrop( event:NativeDragEvent ):void {			 
			if( event.clipboard.getData( 'acceptableFiles' ) ) {
				
				var obj:FileDetails = event.clipboard.getData( 'acceptableFiles' ) as FileDetails;
				obj.fileCategory = fileCategory;
				
				if( obj.fileId != 0 ) {
					var fileEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_UPDATE_FILEDETAILS );
					fileEvent.fileDetails = obj;
					fileEvent.dispatch();
				}
				dataProvider.addItem( obj );
			}
			else {
				var sourcefiles:Array = event.clipboard.getData( ClipboardFormats.FILE_LIST_FORMAT ) as Array;
				var dropFiles:Array = [];
				
				for each( var sourceFile:File in  sourcefiles ) {
					if( !sourceFile.isDirectory && !isFileAvailableAlready( sourceFile.name ) ) {
						dropFiles.push( sourceFile );
					}
				}
				
				for each ( var file:File in dropFiles ) {
					var uploadFileObj:FileDetails = new FileDetails();
					uploadFileObj.fileName = file.name;
					uploadFileObj.extension = file.extension;
					uploadFileObj.type = 'Basic';
					uploadFileObj.fileSizing = "Upload";	
					uploadFileObj.projectFK = model.project.projectId;
					uploadFileObj.fileCategory = fileCategory;
					
					var splitterObj:Object = FileNameSplitter.splitFileName( file.name );
					uploadFileObj.storedFileName = splitterObj.filename + FileNameSplitter.getFileIdGenerator() + '.' + splitterObj.extension;
					
					uploadFileObj.destinationpath = FileNameSplitter.getDestinationPath( model.project, model.parentFolderName );
					
					uploadFileObj.downloadPath = onUpload( uploadFileObj, file );
					updateItemOnDropAndSet( uploadFileObj );
					model.filesToUpload.addItem( uploadFileObj );
					dataProvider.addItem( uploadFileObj );
				}
				
				if( model.filesToUpload.length != 0 ) {
					model.bgUploadFile.idle = true;
					model.bgUploadFile.fileToUpload = model.filesToUpload;
					model.bgUploadFile.fileToUpload.refresh();
				}
			}  
		}
		
		private function onUpload( fileObj:FileDetails, obj:File ):String {			
			var uploadfile:File = obj;
			var fullPath:String = "DTFlex/" + String( fileObj.destinationpath ).split( model.parentFolderName )[ 1 ] + "/" + fileObj.type + "/" + uploadfile.name;
			var copyToLocation:File = File.userDirectory.resolvePath( fullPath );
			if( !copyToLocation.exists ) {
				uploadfile.copyTo( copyToLocation, true );
			}
			return copyToLocation.nativePath;
		}
		
		protected function onDragComplete( event:NativeDragEvent ):void {
			if( ( !event.relatedObject ) || ( event.relatedObject.name == model.mainClass.name ) ) {
				
				tempFile = File.desktopDirectory.resolvePath( "temp.txt" ); 
				
				if( !delegate ) {
					delegate = new LocalFileDetailsDAODelegate();
				}
				
				var result:SQLResult = delegate.getFileDetails( selectedItem as FileDetails );
				var array:Array = result.data as Array;
				
				if( array ) {
					var obj:FileDetails = array[ 0 ] as FileDetails;
					var downLoadedfile:File = new File( obj.filePath ); 
					if( downLoadedfile.exists ) { 
						onDownLoadComplete( obj );
					}
					else {
						var deleteResult:SQLResult = delegate.deleteFileDetails( selectedItem as FileDetails );
						getFilesFromRemote( obj );
					}
				}
				else {
					model.filesToDownload.addItem( selectedItem );
					model.bgDownloadFile.idle = true;
					model.bgDownloadFile.fileToDownload.list = model.filesToDownload.list;
				}
				if( tempFile.exists ) {
					tempFile.deleteFile();
				}
			} 
			else if( event.relatedObject && dropEnabled ) {
				if( event.dropAction != 'none' ) {
					dataProvider.removeItemAt( dataProvider.getItemIndex( selectedItem ) );
				}
			}
		}
		
		private function isFileAvailableAlready( namOfFile:String ):Boolean {
			for each( var fd:FileDetails in dataProvider ) {
				if( fd.fileName == namOfFile ) {
					return true;
				}
			}
			return false;
		}
		
		private function getFilesFromRemote( obj:FileDetails ):void {
			var fileEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_SELECT_FILEDETAILS );
			fileEvent.fileDetails = obj;
			fileEvent.dispatch();
		}
		
		private function onDownLoadComplete( fileObj:FileDetails ):void {
			var downLoadedfile:File = new File( fileObj.filePath ); 
			var copyToLocation:File = File.desktopDirectory.resolvePath( fileObj.fileName );
			downLoadedfile.copyTo( copyToLocation, true );     
		}
		
		protected function updateItemOnDropAndSet( item:FileDetails ):void {
			var extension:String = item.extension;
			var localFileExist:Boolean = false;				
			item.fileSizing = "Complete";
			
			if( item.fileId != 0 ) {
				if( !delegate ) {
					delegate = new LocalFileDetailsDAODelegate();
				}				
				
				if( extension == 'pdf' ) {
					var resultSWF:SQLResult = delegate.getSwfFileDetails( item ); 
					var arraySWF:Array = resultSWF.data as Array;
					if( arraySWF ) {
						item.swfPath = FileDetails( arraySWF[ 0 ] ).filePath;
					}
				}
				
				var result:SQLResult = delegate.getFileDetails( item );
				var array:Array = result.data as Array;
				if( array ) {
					localFileExist = true;
					item.downloadPath = FileDetails( array[ 0 ] ).filePath;
					if( extension == "jpg" || extension == "png") {
						item.swfPath = FileDetails( array[ 0 ] ).filePath;
					}		
				} 
			}
			switch( extension ) {
				/*case "ai":
					if( !localFileExist ) {
						item.imageSource = ImageResourceEmbedClass.AIimg;
					}
					else {
						item.imageSource = ImageResourceEmbedClass.AIimgNewup;
					}
					break;
				case "jpg":
					if( !localFileExist ) {
						item.imageSource = ImageResourceEmbedClass.AIimg;
					}
					else {
						item.imageSource = ImageResourceEmbedClass.AIimgNewup;
					}
					break;
				case "xls":
					if( !localFileExist ) {
						item.imageSource = ImageResourceEmbedClass.XLimg;
					}
					else {
						item.imageSource = ImageResourceEmbedClass.XLimgNewup;
					}
					break;*/
				case "pdf":
					item.thumbnailPath = getThumbnailPath( item );
					break;
				/*case "psd":
					if( !localFileExist ) {
						item.imageSource = ImageResourceEmbedClass.PSimg;
					}
					else {
						item.imageSource = ImageResourceEmbedClass.PSimgNewup;
					}
					break;*/
				default:
					/*if( !localFileExist ) {
						item.imageSource = ImageResourceEmbedClass.note;
					}
					else {
						item.imageSource = ImageResourceEmbedClass.noteNewup;
					}*/
					break;	
			}
		}
		
		protected function getThumbnailPath( item:FileDetails ):String {
			var fullPath:String = "DTFlex/" + String( FileNameSplitter.getDestinationPath( model.project, model.parentFolderName ) ).split( model.parentFolderName )[ 1 ] + "/" + item.type + "/" + FileNameSplitter.splitFileName( item.storedFileName ).filename + "-1_thumb.swf";
			var copyToLocation:File = File.userDirectory.resolvePath( fullPath );
			return copyToLocation.nativePath;
		}
		
		protected function createFileDetails():void {
			var fileEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_CREATE_FILEDETAILS );
			fileEvent.fdToCreate = model.fileDetailsToUpload;
			fileEvent.dispatch();
		}
	}
}
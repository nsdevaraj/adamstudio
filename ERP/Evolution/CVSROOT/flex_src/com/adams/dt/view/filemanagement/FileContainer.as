package com.adams.dt.view.filemanagement
{
	import com.adams.dt.business.LocalFileDetailsDAODelegate;
	import com.adams.dt.business.util.FileNameSplitter;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.event.fileManagement.RemoveFileEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.scheduler.util.DateUtil;
	import com.adams.dt.model.vo.FileDetails;
	
	import flash.data.SQLResult;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.desktop.NativeDragOptions;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.TileList;
	
	[Event( name="deleteItem", type="com.adams.dt.event.fileManagement.RemoveFileEvent")]
	[Event( name="showItem", type="com.adams.dt.event.fileManagement.RemoveFileEvent")]
	[Event( name="replaceItem", type="com.adams.dt.event.fileManagement.RemoveFileEvent")]
	public class FileContainer extends TileList
	{
		
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		/**
	     *  temp file to handle drag complete event
	     */
		private var tempFile:File;
		/**
	     *  dataProvide of this component which is initialized once
	     */
		private var dp:ArrayCollection = new ArrayCollection();
		/**
	     *  mediator to read the datas from the locally stored database
	     */
		private var delegate:LocalFileDetailsDAODelegate;
		/**
	     *  alternative for dropEnabled
	     */
		private var _isDroppable:Boolean;
		/**
	     *  @Boolean value for the visibility of delete button in the itemRenderer
	     */
		private var _deleteShow:Boolean = true;
		public function get deleteShow():Boolean {
			return _deleteShow;
		}
		public function set deleteShow( value:Boolean ):void {
			_deleteShow = value;
		}
		
		/**
	     *  @Boolean value for the visibility of replace button in the itemRenderer
	     */
		private var _replaceShow:Boolean = true;
		public function get replaceShow():Boolean {
			return _replaceShow;
		}
		public function set replaceShow( value:Boolean ):void {
			_replaceShow = value;
		}
		
		/**
	     *  @String value decides this container can hold this category of files
	     */
		private var _fileCategory:String;
		public function get fileCategory():String {
			return _fileCategory;
		}
		public function set fileCategory( str:String ):void {
			_fileCategory = str;
		}
		
		/**
	     *  @ArrayCollection value starting point of making dataprovider for the component
	     * accepts the collection of FileDetails Object
	     */
		private var _dataSource:ArrayCollection;
		public function get dataSource():ArrayCollection{
			return _dataSource;
		}
		
		public function set dataSource( value:ArrayCollection ):void {
			_dataSource = value;
			changeDataProvider();
		}
		
		private var _thumbSet:Boolean;
		public function set thumbSet( value:Boolean ):void {
			_thumbSet = value;
			for each( var item:FileDetails in dp ) {
				if( item.extension == 'pdf' ) {
					item.thumbnailPath = getThumbnailPath( item );
				 }
			}
			dp.refresh();
		}
			
		/**
	     *  Constructor.
	     *
	     *  set the itemRenderer
		 *  add the default eventlisteners
	     */
		public function FileContainer()
		{ 
			addEventListener( MouseEvent.MOUSE_DOWN, onDragBegin, false, 0, true );  
			addEventListener( NativeDragEvent.NATIVE_DRAG_COMPLETE, onDragComplete, false, 0, true );
		}
	    
	    /**
	     *  Overriding the getter of dropEnabled.
	     */
	    override public function get dropEnabled():Boolean {
	    	return _isDroppable;
	    }
	    
	    /**
	     *  Overriding the setter of dropEnabled which sets _isDroppable as an alternative for dropEnabled.
	     */
	    override public function set dropEnabled( value:Boolean ):void {
	    	_isDroppable = value;
	    	makeEventListeners();
	    }
	    
	    /**
	     *  add eventlisteners according to the dropEnable value
	     * @dropEnabled == true add dragEnter and dragDrop events.
	     * @dropEnabled == false remove dragEnter and dragDrop events.
	     */
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
	    
	    /**
	     *  Make the dataProvider of the component by checking the visible property of FileDetails VO
	     * Sets other missing properties before adding into the dp arrayCollection
	     */
		protected function changeDataProvider():void {
	    	dataProvider = null;
	    	dp.removeAll();
	    	
	    	for each( var fd:FileDetails  in dataSource ) {
	    		if( fd.visible != 0 ) {
					updateItemOnDropAndSet( fd );
					dp.addItem( fd );
	    		}
			}
			
			dp.refresh();
			dataProvider = dp;
	    }
	   
	   /**
	     *  Check wheather the ropped file is already available in the current dataProvider
	     */
	   private function isFileAvailableAlready( namOfFile:String ):Boolean {
			for each( var fd:FileDetails in dataProvider ) {
				if( fd.fileName == namOfFile ) {
					return true;
				}
			}
			return false;
		}
	   
	   /**
	     * @MouseEvent dispatched when the mousedown on the particular file item
	     * Sets the clipboard to indicate its dragging from inside the application
	     *  Sets the appropriate DragOptions values
	     */
		protected function onDragBegin( event:MouseEvent ):void {
     		if( ( selectedItem ) && ( !( event.target is Button ) ) ) { 
     			var clip:Clipboard = new Clipboard();
		        clip.setDataHandler( ClipboardFormats.FILE_LIST_FORMAT, getfileArray );
		        clip.setData( 'acceptableFiles', this.selectedItem );
		        var dragOptions:NativeDragOptions = new NativeDragOptions();
		        dragOptions.allowCopy = true;
		        dragOptions.allowLink = false;
		        dragOptions.allowMove = false;
		        NativeDragManager.doDrag( event.currentTarget as InteractiveObject, clip, null, null, dragOptions );
     	 	}
		}
		
		/**
	     * Array source for the clipboard data handler
	     */
		private function getfileArray():Array {
        	return []; 
        }
		
		/**
	     * @NativeDragEvent called during the dragEnter checks the initial conditions
	     * Accepts only when files with different name. 
	     */
		protected function onDragEnter( event:NativeDragEvent ):void {
			if( event.clipboard.hasFormat( ClipboardFormats.FILE_LIST_FORMAT ) ) {
				var files:Array = event.clipboard.getData( ClipboardFormats.FILE_LIST_FORMAT ) as Array;
				if( files ) { 
					if( files.length == 1 ) {
						if( !File( files[ 0 ] ).isDirectory && !isFileAvailableAlready( files[ 0 ].name ) ) {
							NativeDragManager.acceptDragDrop( this );
						}
					}	
					else {
						NativeDragManager.acceptDragDrop( this );
					}
				}
				else {
					var droppedFile:FileDetails = event.clipboard.getData( 'acceptableFiles' ) as FileDetails;
					if( droppedFile ) {
						if( !isFileAvailableAlready( droppedFile.fileName ) ) {
							NativeDragManager.acceptDragDrop( this );
						}
					} 
				}
			}
		} 
		
		/**
	     * @NativeDragEvent called during the dragDrop checks wheather the item is
	     * dragged from the internal container or operating system and creates the
	     * FileDetails VO to the dragged files. Sets the fileDetails to the upload Mediator.
	     */
		protected function onDrop( event:NativeDragEvent ):void {			 
			if( event.clipboard.getData( 'acceptableFiles' ) ) {
	 			var obj:FileDetails = event.clipboard.getData( 'acceptableFiles' ) as FileDetails;
				obj.fileCategory = fileCategory;
				
				if( obj.fileId != 0 ) {
					var fileEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_UPDATE_DETAILS );
					fileEvent.fileDetailsObj = obj;
					fileEvent.dispatch();
				}
				dp.addItem( obj );
				dp.refresh();
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
					uploadFileObj.projectFK= model.currentProjects.projectId;
					uploadFileObj.fileCategory = fileCategory;
					
					var splitterObj:Object = FileNameSplitter.splitFileName( file.name );
					uploadFileObj.storedFileName = splitterObj.filename + DateUtil.getFileIdGenerator() + '.' + splitterObj.extension;
										
					uploadFileObj.destinationpath = FileNameSplitter.getDestinationPath( model.currentProjects, model.parentFolderName );
					
					uploadFileObj.downloadPath = onUpload( uploadFileObj, file );
					updateItemOnDropAndSet( uploadFileObj );
					model.filesToUpload.addItem( uploadFileObj );
					dp.addItem( uploadFileObj );
					dp.refresh();
				}
			
				if( model.filesToUpload.length != 0 ) {
					model.bgUploadFile.idle = true;
					model.bgUploadFile.fileToUpload = model.filesToUpload;
					model.bgUploadFile.fileToUpload.refresh();
				}
			}  
		}
		
		/**
	     * @fileObj created FileDetails VO, @obj Dragged File
	     * Sets the local downloadpath for the fileDetails object
	     */
		private function onUpload( fileObj:FileDetails, obj:File ):String {			
        	var uploadfile:File = obj;
        	var fullPath:String = "DTFlex/" + String( fileObj.destinationpath ).split( model.parentFolderName )[ 1 ] + "/" + fileObj.type + "/" + uploadfile.name;
        	var copyToLocation:File = File.userDirectory.resolvePath( fullPath );
        	if( !copyToLocation.exists ) {
        		uploadfile.copyTo( copyToLocation, true );
        	}
        	return copyToLocation.nativePath;
   		}
		
		/**
	     * @NativeDragEvent called during the dragComplete checks wheather the item is
	     * dropped outside or inside the application. If it is dropped putside then it downloads
	     * the corresponding file from either local or server, if it is dropped inside it removes
	     * the currentfile from the container. 
	     * */
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
      				dp.removeItemAt( dp.getItemIndex( selectedItem ) );
      				dp.refresh();
      				this.dataProvider = dp;
      			}
      		}
      	}
        
        /**
		 * get the server file details
		 */ 
        private function getFilesFromRemote( obj:FileDetails ):void {
        	var fileEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_SELECT_FILEDETAILS );
        	fileEvent.fileDetailsObj = obj;
        	 fileEvent.dispatch();
        }
        
        /**
		 * copy the local filesystem to desktop
		 */
        private function onDownLoadComplete( fileObj:FileDetails ):void {
        	var downLoadedfile:File = new File( fileObj.filePath ); 
        	var copyToLocation:File = File.desktopDirectory.resolvePath( fileObj.fileName );
        	downLoadedfile.copyTo( copyToLocation, true );     
       	}
       	
       	/**
		 * @item created or dataProvider FileDetails VO Objects
		 * Sets the swfPath in order to show it in the PDFReader while clicking on
		 * the particular item.
		 */
        protected function updateItemOnDropAndSet( item:FileDetails ):void {
			var extension:String = item.extension.toLowerCase();
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
				case "ai":
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
				case "png":
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
					break;
				case "pdf":
					item.thumbnailPath = getThumbnailPath( item );
					break;
				case "psd":
					if( !localFileExist ) {
						item.imageSource = ImageResourceEmbedClass.PSimg;
					}
					else {
						item.imageSource = ImageResourceEmbedClass.PSimgNewup;
					}
					break;
				default:
					if( !localFileExist ) {
						item.imageSource = ImageResourceEmbedClass.note;
					}
					else {
						item.imageSource = ImageResourceEmbedClass.noteNewup;
					}
					break;	
			}
		}
		
		private function getThumbnailPath( item:FileDetails ):String {
			var os:String = flash.system.Capabilities.os.substr(0, 3);
			var finalPath:String;
			var fullPath:String;
			var copyToLocation:File
			if (os == "Win") {
	          	fullPath = "DTFlex/"+ String( FileNameSplitter.getDestinationPath( model.currentProjects, model.parentFolderName ) ).split( model.parentFolderName )[ 1 ] + "/" + item.type + "/" + FileNameSplitter.splitFileName( item.storedFileName ).filename + "-1_thumb.swf";
        		copyToLocation = File.userDirectory.resolvePath( fullPath );
        		finalPath = copyToLocation.nativePath;
	        } else if (os == "Mac") {
	        	finalPath = "file://"+File.userDirectory.nativePath+"/DTFlex/"+ String( FileNameSplitter.getDestinationPath( model.currentProjects, model.parentFolderName ) ).split( model.parentFolderName )[ 1 ] + "/" + item.type + "/" + FileNameSplitter.splitFileName( item.storedFileName ).filename + "-1_thumb.swf";
	        }
        	return finalPath;
		}
	}
}
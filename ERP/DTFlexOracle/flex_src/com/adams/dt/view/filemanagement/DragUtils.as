package com.adams.dt.view.filemanagement
{
	import com.adams.dt.business.LocalFileDetailsDAODelegate;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.event.fileManagement.RemoveFileEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.view.filemanagement.renderers.ImageRenderer;
	
	import flash.data.SQLResult;
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.desktop.NativeDragOptions;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.controls.TileList;
	import mx.core.ClassFactory;
	
	[Event( name="removeItem", type="com.adams.dt.event.fileManagement.RemoveFileEvent")]
	public class DragUtils extends TileList
	{
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		private var dp:ArrayCollection = new ArrayCollection();
		
		private var _fileCollection:ArrayCollection;
		private var _fileObject:FileDetails;
		private var tempObj:Object = {};
		private var draggingSource:TileList;
		private var cursor:IViewCursor;
		private var tempFile:File ;
		private var profile:String; 
		public var deleteReplaceHide:Boolean;
		/**
		 * listen the drag and drop events
		 */
		public function DragUtils()
		{
			this.addEventListener( NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn,false,0,true );
			this.addEventListener( NativeDragEvent.NATIVE_DRAG_COMPLETE, handleDragComplete,false,0,true );
			this.addEventListener( MouseEvent.MOUSE_DOWN, handleDragBegin,false,0,true );
			this.itemRenderer = new ClassFactory( ImageRenderer );
			this.dragEnabled = true;
			this.allowDragSelection = true;
			this.allowMultipleSelection = true;
			this.dataProvider = dp;
			this.columnCount = 1;
			profile = ( model.currentTasks ) ? model.currentTasks.workflowtemplateFK.profileObject.profileCode : model.person.profile.profileCode;
	    }
	    
	    private var imageFile:File;
	    private var _fileCategory:String;
	    /**
		 * set the file category
		 */
		public function set fileCategory( str:String ):void {
			_fileCategory = str;
		}
		
		/**
		 * get the file category
		 */
		public function get fileCategory():String {
			return _fileCategory;
		}
		
		/**
		 * on dragEnter event check the drop target
		 */
		private function onDragIn( event:NativeDragEvent ):void {
			NativeDragManager.acceptDragDrop( this );
		}
		
		/**
		 * on dragComplete check the file droped inside the Application are outside the Application
		 * IF its dropped outside 
		 * check the local database for file reference is exist 
		 * IF exist copy from local File system(IF file not exist in local file system 
		 			delete the file entry in local database and download the file from server) 
		 * ELSE download from server
		 */ 
		protected function handleDragComplete( event:NativeDragEvent ):void {
			if( ( !event.relatedObject ) || ( event.relatedObject.name == model.mainClass.name ) ) {
      			tempFile = File.desktopDirectory.resolvePath( "temp.txt" ); 
      			var delegate : LocalFileDetailsDAODelegate = new LocalFileDetailsDAODelegate();			
				var result:SQLResult = delegate.getFileDetails( this.selectedItem as FileDetails );
				var array:Array = result.data as Array;
				if( array ) {
					var obj:FileDetails = array[ 0 ] as FileDetails;
					var downLoadedfile:File = new File( obj.filePath ); 
					if( downLoadedfile.exists ) { 
						onDownLoadComplete( obj );
					}
					else {
						var deleteResult:SQLResult = delegate.deleteFileDetails( this.selectedItem as FileDetails );
						getFilesFromRemote( obj );
					}
				}
				else {
        			model.filesToDownload.addItem( this.selectedItem );
					model.bgDownloadFile.idle = true;
					model.bgDownloadFile.fileToDownload.list = model.filesToDownload.list;
				}
				if( tempFile.exists ) {
					tempFile.deleteFile();
				}
          	} 
        }
        
        /**
		 * get the server file details
		 */ 
       private function getFilesFromRemote(obj:FileDetails):void {
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
		 * set the empty file array for clipboard
		 */
       	 private function getfileArray():Array {
             	var fileArr:Array = [];
             	return fileArr; 
          }
        
        /**
         * On mouseDown
		 * set the fileobject to clipboard data
		 * initiate the doDraag function
		 */
         protected function handleDragBegin( event : MouseEvent ):void {
         	if( this.selectedItem ) {
				var clip : Clipboard = new Clipboard();
	          	clip.setDataHandler( ClipboardFormats.FILE_LIST_FORMAT, getfileArray );
	            clip.setData('localFileDetails',this.selectedItem);
	            var dragOptions : NativeDragOptions = new NativeDragOptions();
	            dragOptions.allowCopy = true;
	            dragOptions.allowLink = false;
	            dragOptions.allowMove = false;
	            NativeDragManager.doDrag( event.currentTarget as InteractiveObject, clip, null, null, dragOptions );
        	}
    	}
		
		/**
		 * get the file collection
		 */  
		[Bindable] 
		public function get fileCollection():ArrayCollection {
			return _fileCollection;
		}
		
		/**
		 * set the file collection
		 * intialize all variables
		 */
		public function set fileCollection( value:ArrayCollection ):void {
			value.filterFunction = removeInVisibleFiles;
			_fileCollection = value;
			dp = new ArrayCollection();
			updateTileList( value );
			for each(var obj:Object in model.filesToUpload ) {
				upDateDataProvider( dp, obj );
			}
			this.rowCount = dp.length;
		}
		
		public function removeInVisibleFiles( item:FileDetails ):Boolean {
			if( item.visible )  {
				return true
			}
			return false;
		}
		/**
		 * its for intenal drag and drop
		 * add the file to crosponding droped containers 
		 * based on the extension display the icon
		 * indicate the file download status
		 * remove the dropped file if the same file already exist
		 */ 
		public function updateTileList( arrC:ArrayCollection ):void {
			var bool:Boolean;			
			if( profile != "EPR" ) {
				bool = true;
			}
			else {
				bool = false;
			}

			for each( var item:FileDetails in arrC ) {	
				if( profile == "EPR" && item.miscelleneous=="FAB" || bool ) {
					var extension:String = item.extension;
					var localFileExist:Boolean = false;				
					item.sourcePath = item.filePath
					item.destinationpath = '';
					var delegate : LocalFileDetailsDAODelegate = new LocalFileDetailsDAODelegate();			
					var result:SQLResult = delegate.getFileDetails( item );
					var array:Array = result.data as Array;
					var resultSWF:SQLResult = delegate.getSwfFileDetails( item ); 
					if( extension == "jpg" || extension == "png" || extension == "swf" )  {
						item.swfPath = item.filePath;
					}
					var arraySWF:Array = resultSWF.data as Array;
					if(array!=null){
						localFileExist = true;
						if( extension == "jpg" || extension == "png")
							item.swfPath = ( array[ 0 ] as FileDetails ).filePath;
					}
					if( arraySWF ) {
						item.swfPath = ( arraySWF[ 0 ] as FileDetails ).filePath;
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
						case "xls":
								if( !localFileExist ) {
									item.imageSource = ImageResourceEmbedClass.XLimg;
								}
								else {
									item.imageSource = ImageResourceEmbedClass.XLimgNewup;
								}
						break;
						case "pdf":
								if( !localFileExist ) {
									item.imageSource = ImageResourceEmbedClass.PDFimg;
								}
								else {
									item.imageSource = ImageResourceEmbedClass.PDFimgNewup;
								}
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
					if( extension != "pdf" && extension != "jpg" && extension != "png" && extension != "swf" ) {
						//&& extension != "jpg" && extension != "png"  
						item.swfPath = null;
					}
					dp.addItem( item );
					this.dataProvider = dp;
					var removeEvent:RemoveFileEvent = new RemoveFileEvent( RemoveFileEvent.DO_REMOVE );
					removeEvent.doRemove = true;
					dispatchEvent( removeEvent );
				}
			}
		}		
		
		/**
		 * dropping the files from outside
		 * add the file to crosponding droped containers 
		 * based on the extension display the icon
		 * indicate the file download status
		 * remove the dropped file if the same file already exist
		 */ 
		private function upDateDataProvider( dataCollection:ArrayCollection, file:Object ):void {
			var bool:Boolean;
			if( profile != "EPR" ) {
				bool = true;
			}
			else {
				bool = false;
			}
			var fileUploaded:Boolean = false;
			_fileObject = new FileDetails();
			if( file is File ) {				
				_fileObject.fileName = file.name;
				_fileObject.projectFK = model.currentProjects.projectId;
				_fileObject.extension = file.extension;
				_fileObject.sourcePath = File(file).nativePath;
				_fileObject.destinationpath = '';
				_fileObject.type = 'Basic';
				fileUploaded = false;
			}
			else {
				_fileObject.fileName = file.name;
				_fileObject.projectFK = file.projectId;
				_fileObject.sourcePath = file.sourcePath;
				_fileObject.destinationpath = file.destinationpath;
				_fileObject.type = 'Basic';
			}		
			var str:String = _fileObject.extension;
			if( profile == "EPR" && _fileObject.miscelleneous == "FAB"|| bool ) {
				switch( str ) {
					case "ai":
						if( !fileUploaded ) {
							_fileObject.imageSource = ImageResourceEmbedClass.AIimgup;
						}
						else {
							_fileObject.imageSource = ImageResourceEmbedClass.AIimgNewup;
						}
					break;
					case "xls":
						if( !fileUploaded ) {
							_fileObject.imageSource = ImageResourceEmbedClass.XLimgup;
						}
						else {
							_fileObject.imageSource = ImageResourceEmbedClass.XLimgNewup;
						}
					break;
					case "pdf":
						if( !fileUploaded ) {
							_fileObject.imageSource = ImageResourceEmbedClass.PDFimgup;
						}
						else {
							_fileObject.imageSource = ImageResourceEmbedClass.PDFimgNewup;
						}
					break;
					case "psd":
						if( !fileUploaded ) {
							_fileObject.imageSource = ImageResourceEmbedClass.PSimgup;
						}
						else {
							_fileObject.imageSource = ImageResourceEmbedClass.PSimgNewup;
						}
					break;
					default:
						if( !fileUploaded ) {
							_fileObject.imageSource = ImageResourceEmbedClass.noteup;
						}
						else{
							_fileObject.imageSource = ImageResourceEmbedClass.noteNewup;
						}	
				}
				
				if( !Utils.checkDuplicateItem( _fileObject, dp, 'fileName' ) ) {
					dataCollection.addItem( _fileObject );
					var removeEvent:RemoveFileEvent = new RemoveFileEvent( RemoveFileEvent.DO_REMOVE );
					removeEvent.doRemove = true;
					dispatchEvent( removeEvent );
				}
				else {
					var doRemoveEvent:RemoveFileEvent = new RemoveFileEvent( RemoveFileEvent.DO_REMOVE );
					doRemoveEvent.doRemove = false;
					dispatchEvent( doRemoveEvent ); 
				}	
			}
		}
	}
}
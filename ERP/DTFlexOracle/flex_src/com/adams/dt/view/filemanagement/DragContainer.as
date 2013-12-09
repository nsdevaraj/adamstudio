package com.adams.dt.view.filemanagement
{
	import com.adams.dt.business.LocalFileDetailsDAODelegate;
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.business.util.StringUtils;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.event.fileManagement.RemoveFileEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.FileDetails;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.view.filemanagement.renderers.ImageRenderer;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	
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
	import mx.controls.Button;
	import mx.controls.TileList;
	import mx.core.ClassFactory;
	
	[Event( name="removeItem", type="com.adams.dt.event.fileManagement.RemoveFileEvent")]
	[Event( name="deleteItem", type="com.adams.dt.event.fileManagement.RemoveFileEvent")]
	[Event( name="showItem", type="com.adams.dt.event.fileManagement.RemoveFileEvent")]
	[Event( name="replaceItem", type="com.adams.dt.event.fileManagement.RemoveFileEvent")]
	public class DragContainer extends TileList
	{
		//dataprovide arraycollection
		[Bindable]
		public var dp:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var _fileCollection:ArrayCollection;
		private var _fileObject:FileDetails = new FileDetails();
		private var tempObj : Object = {};
		public var draggingSource:TileList = null;
		private var cursor:IViewCursor;
		private var model:ModelLocator = ModelLocator.getInstance();
		private var _fileCategory:String;
		private var tempFile:File;
		
		/**
		 * set the file category
		 */ 
		public function set fileCategory(str:String):void{
			_fileCategory = str;
		}
		/**
		 * get the file category
		 */
		public function get fileCategory():String{
			return _fileCategory;
		}
		
		
		/**
		 * listen the drag and drop events
		 */
		 
		public function DragContainer()
		{ 
			this.addEventListener( NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn,false,0,true);
		 	this.addEventListener( NativeDragEvent.NATIVE_DRAG_DROP, onDrop,false,0,true );
			this.addEventListener( NativeDragEvent.NATIVE_DRAG_COMPLETE, handleDragComplete,false,0,true );
			this.addEventListener( MouseEvent.MOUSE_DOWN, handleDragBegin,false,0,true );  
			this.itemRenderer = new ClassFactory( ImageRenderer );
			this.dragEnabled = true;
			this.allowDragSelection = true;
			this.allowMultipleSelection = true;
			this.dataProvider = dp;
	    }
	    private var imageFile:File;
	    /**
		 * on dragEnter event check the drop target
		 */
		private function onDragIn(event : NativeDragEvent) : void {
			if((event.clipboard.getData( 'localFileDetails' )) == null || (GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode == "FAB"))
			{
				NativeDragManager.acceptDragDrop( this );
			}
		} 
		/**
		 * on dragComplete check the file droped inside the Application are outside the Application
		 * IF its dropped outside 
		 * check the local database for file reference is exist 
		 * IF exist copy from local File system(IF file not exist in local file system 
		 			delete the file entry in local database and download the file from server) 
		 * ELSE download from server
		 */ 
		protected function handleDragComplete(event:NativeDragEvent):void {
			if(event.relatedObject==null||event.relatedObject.name==model.mainClass.name){
          			tempFile = File.desktopDirectory.resolvePath("temp.txt"); 
          			var delegate : LocalFileDetailsDAODelegate = new LocalFileDetailsDAODelegate();			
					var result:SQLResult = delegate.getFileDetails(this.selectedItem as FileDetails);
					var array:Array = result.data as Array;
					if(array!=null){
						var obj:FileDetails = array[0] as FileDetails;
						var downLoadedfile:File = new File(obj.filePath); 
						if(downLoadedfile.exists){ 
							onDownLoadComplete(obj)
						}else{
							var deleteResult:SQLResult = delegate.deleteFileDetails(this.selectedItem as FileDetails);
							getFilesFromRemote(obj)
						}
					}else{
            			model.filesToDownload.addItem(this.selectedItem);
						model.bgDownloadFile.idle = true;
						model.bgDownloadFile.fileToDownload.list = model.filesToDownload.list;
					}
					if(tempFile.exists)
					tempFile.deleteFile();
          		} 
        }
        private var fileNamesArr:Array = [];
        /**
		 * get the server file details
		 */ 
        private function getFilesFromRemote(obj:FileDetails):void{
        	var fileEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SELECT_FILEDETAILS)
        	fileEvent.fileDetailsObj = obj;
        	 fileEvent.dispatch();
        }
        /**
		 * copy the local filesystem to desktop
		 */
        private function onDownLoadComplete(fileObj:FileDetails):void {
        	var downLoadedfile:File = new File(fileObj.filePath); 
        	var copyToLocation:File = File.desktopDirectory.resolvePath(fileObj.fileName);
        	downLoadedfile.copyTo(copyToLocation,true);     
       	}
       	 /**
		 * set the empty file array for clipboard
		 */
       	private function getfileArray():Array{
             	var fileArr:Array = [];
             	return fileArr; 
         }
         
         /**
         * On mouseDown
		 * set the fileobject to clipboard data
		 * initiate the doDraag function
		 */
         protected function handleDragBegin( event:MouseEvent ):void {
	     	 if( ( this.selectedItem ) && ( !( event.target is Button ) ) ) { 
	     	 	 var fileArray : Array = [];
		         var clip:Clipboard = new Clipboard();
		         clip.setDataHandler( ClipboardFormats.FILE_LIST_FORMAT, getfileArray );
		         clip.setData( 'localFileDetails', this.selectedItem );
		         var dragOptions:NativeDragOptions = new NativeDragOptions();
		         dragOptions.allowCopy = true;
		         dragOptions.allowLink = false;
		         dragOptions.allowMove = false;
		         NativeDragManager.doDrag( event.currentTarget as InteractiveObject, clip, null, null, dragOptions );
         	 }
    	 }
		
		 private var fileRemove:Boolean = true;
		/**
		 * on Drop check the droped file object 
		 * IF its contain the filedetail object update the category in database(internal drag and drop)
		 * ELSE update the new file details in database(file draged from outside and dropped inside application)
		 */
		private function onDrop( event:NativeDragEvent ):void {			 
		 if( event.clipboard.getData( 'localFileDetails' ) ) {
		 		fileRemove = true;
				var arrc:ArrayCollection = new ArrayCollection();
				var obj:FileDetails = event.clipboard.getData('localFileDetails') as FileDetails;
				obj.fileCategory = fileCategory;
				if(obj.fileId!=0){
					var fileEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_UPDATE_DETAILS)
					fileEvent.fileDetailsObj = obj;
					CairngormEventDispatcher.getInstance().dispatchEvent(fileEvent);
				}
				arrc.addItem(obj);
				updateTileList(arrc);
			}else{
				fileRemove = false;				
				var dropfiles : Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				for each ( var file : File in dropfiles ) {
					_fileObject.fileName = file.name;
					uploadFileObj = new Object();
					uploadFileObj.name = file.name;
					uploadFileObj.storedName = file.name;
					uploadFileObj.projectId = model.currentProjects.projectId;
					uploadFileObj.fileCategory = fileCategory;					
					var domain:Categories = Utils.getDomains(model.currentProjects.categories);
					var cat1:Categories = model.currentProjects.categories.categoryFK;
					var cat2:Categories = model.currentProjects.categories;
					var project:Projects = model.currentProjects;
					uploadFileObj.destinationpath = model.parentFolderName+domain.categoryName+"/"+cat1.categoryName+"/"+cat2.categoryName+"/"+StringUtils.compatibleTrim(project.projectName);
					uploadFileObj.type = 'Basic';
					uploadFileObj.sourcePath = onUpload(uploadFileObj,file);//file.nativePath
					upDateDataProvider( dp, file,uploadFileObj );
				}
				
				if(model.filesToUpload.length!=0){
					model.bgUploadFile.idle = true;
					model.bgUploadFile.fileToUpload = model.filesToUpload;
					model.bgUploadFile.fileToUpload.refresh()
				}
			}  
		}
		
		private var uploadFileObj:Object; 
		/**
		 * on upload the file first copy that file into your local file system
		 * and update the local database finally upload the file by using this path
		 */ 
		private function onUpload(fileObj:Object,obj:File):String {			
        	var uploadfile:File = obj;
        	var fullPath:String = "DTFlex/"+String(fileObj.destinationpath).split(model.parentFolderName)[1]+"/"+fileObj.type+"/"+uploadfile.name;
        	var copyToLocation:File = File.userDirectory.resolvePath(fullPath);
        	if(!copyToLocation.exists) uploadfile.copyTo(copyToLocation,true);
        	return copyToLocation.nativePath;
       	}
		/**
		 * get the file collection
		 */ 
		public function get fileCollection():ArrayCollection{
			return _fileCollection;
		}
		/**
		 * set the file collection
		 * intialize all variables
		 */ 
		public function set fileCollection(value:ArrayCollection):void{
			_fileCollection = value;
			fileRemove = false;
			dp = new ArrayCollection();
			fileNamesArr = [];
			this.dataProvider = new ArrayCollection();
			updateTileList(value);
			for each(var obj:Object in model.filesToUpload){
				//upDateDataProvider(dp,obj,null)
			}
		}
		/**
		 * its for intenal drag and drop
		 * add the file to crosponding droped containers 
		 * based on the extension display the icon
		 * indicate the file download status
		 * remove the dropped file if the same file already exist
		 */ 
		public function updateTileList(arrC:ArrayCollection):void{
			
			for each(var item:FileDetails in arrC){
				
				var extension:String = item.extension;
				fileNamesArr.push(item.fileName);
				var localFileExist:Boolean = false;				
				item.sourcePath = item.filePath
				item.destinationpath = '';
				var delegate : LocalFileDetailsDAODelegate = new LocalFileDetailsDAODelegate();			
				var result:SQLResult = delegate.getFileDetails(item);
				var array:Array = result.data as Array;
				
				var resultSWF:SQLResult = delegate.getSwfFileDetails(item); 
				
				var arraySWF:Array = [];
				arraySWF = resultSWF.data as Array;
				item.fileSizing = "Complete";
				
				if(extension == "jpg" || extension == "png"  || extension == "swf")
				{
					item.swfPath = item.filePath;
				}
				if(array!=null){
					localFileExist = true;
					if( extension == "jpg" || extension == "png")
							item.swfPath = ( array[ 0 ] as FileDetails ).filePath;
				}
				if(arraySWF!=null){
					item.swfPath = (arraySWF[0] as FileDetails).filePath
				}
				switch(extension){
					case "ai":
						if(!localFileExist){
							item.imageSource = ImageResourceEmbedClass.AIimg;
						}else{
							item.imageSource = ImageResourceEmbedClass.AIimgNewup;
						}
					break;
					case "jpg":
						if(!localFileExist){
							item.imageSource = ImageResourceEmbedClass.AIimg;
						}else{
							item.imageSource = ImageResourceEmbedClass.AIimgNewup;
						}
					break;
					case "xls":
						if(!localFileExist){
							item.imageSource = ImageResourceEmbedClass.XLimg;
						}else{
							item.imageSource = ImageResourceEmbedClass.XLimgNewup;
						}
					break;
					case "pdf":
						if(!localFileExist){
							item.imageSource = ImageResourceEmbedClass.PDFimg;
						}else{
							item.imageSource = ImageResourceEmbedClass.PDFimgNewup;
						}
					break;
					case "psd":
						if(!localFileExist){
							item.imageSource = ImageResourceEmbedClass.PSimg;
						}else{
							item.imageSource = ImageResourceEmbedClass.PSimgNewup;
						}
					break;
					default:
					if(!localFileExist){
						item.imageSource = ImageResourceEmbedClass.note;
					}else{
						item.imageSource = ImageResourceEmbedClass.noteNewup;
					}	
				}
					if(extension != "pdf" && extension != "jpg" && extension != "png"  &&  extension != "swf")
					{
						//&& extension != "jpg" && extension != "png"
						item.swfPath = null;
					}
					if( !Utils.checkDuplicateItem( item, dp, 'fileName' ) ) {	
						dp.addItem( item );	
						this.dataProvider = dp;
						if(fileRemove){
							var removeEvent:RemoveFileEvent = new RemoveFileEvent( RemoveFileEvent.DO_REMOVE );
							removeEvent.doRemove = true;
							dispatchEvent( removeEvent );
						}
					}
					else {
						var doRemoveEvent:RemoveFileEvent = new RemoveFileEvent( RemoveFileEvent.DO_REMOVE );
						doRemoveEvent.doRemove = false;
						dispatchEvent( doRemoveEvent );  
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
		private function upDateDataProvider( dataCollection:ArrayCollection, file:Object, upFileObj:Object):void {	
			var fileUploaded:Boolean = false;
			_fileObject = new FileDetails();
			if(file!=null){
				if(file is File){				
					_fileObject.fileName = file.name;
					_fileObject.projectFK = model.currentProjects.projectId;
					_fileObject.extension = file.extension;
					_fileObject.sourcePath = File(file).nativePath;
					_fileObject.destinationpath = '';
					_fileObject.type = 'Basic';
					fileUploaded = false;
				}else{
					_fileObject.fileName = file.name;
					_fileObject.projectFK = file.projectId;
					_fileObject.sourcePath = file.sourcePath;
					_fileObject.destinationpath = file.destinationpath;
					_fileObject.type = 'Basic';
				}
				_fileObject.fileSizing = "Upload";	
			}	
			var str:String = _fileObject.extension;
			switch(str){
				case "ai":
					if(!fileUploaded){
						_fileObject.imageSource = ImageResourceEmbedClass.AIimgup;
					}else{
						_fileObject.imageSource = ImageResourceEmbedClass.AIimgNewup;
					}
				break;
				case "xls": 
					if(!fileUploaded){
						_fileObject.imageSource = ImageResourceEmbedClass.XLimgup;
					}else{
						_fileObject.imageSource = ImageResourceEmbedClass.XLimgNewup;
					}
				break;
				case "pdf":
					if(!fileUploaded){
						_fileObject.imageSource = ImageResourceEmbedClass.PDFimgup;
					}else{
						_fileObject.imageSource = ImageResourceEmbedClass.PDFimgNewup;
					}
				break;
				case "psd":
					if(!fileUploaded){
						_fileObject.imageSource = ImageResourceEmbedClass.PSimgup;
					}else{
						_fileObject.imageSource = ImageResourceEmbedClass.PSimgNewup;
					}
				break;
				default:
					if(!fileUploaded){
						_fileObject.imageSource = ImageResourceEmbedClass.noteup;
					}else{
						_fileObject.imageSource = ImageResourceEmbedClass.noteNewup;
					}
				break;	
			}
			var findName:String;
			if(file!=null)
				findName = file.name
			else
				findName = '';
				
			if(fileNamesArr.indexOf(findName)== -1){	
				fileNamesArr.push(_fileObject.fileName);
				model.filesToUpload.addItem(upFileObj)	
				dp.addItem( _fileObject );	
				this.dataProvider = dp;
				if(file is File){
				}else{
					//var removeEvent:RemoveFileEvent = new RemoveFileEvent( RemoveFileEvent.DO_REMOVE );
					//removeEvent.doRemove = true;
					//dispatchEvent( removeEvent );
				}
			}
			else {
			/* 	var doRemoveEvent:RemoveFileEvent = new RemoveFileEvent( RemoveFileEvent.DO_REMOVE );
				doRemoveEvent.doRemove = false;
				dispatchEvent( doRemoveEvent );  */
			}
			/* if( !Utils.checkDuplicateItem( _fileObject, dp, 'fileName' ) ) {
				model.filesToUpload.addItem(uploadFileObj)
				model.bgUploadFile.idle = true;
				model.bgUploadFile.fileToUpload.list = model.filesToUpload.list;	
				dp.addItem( _fileObject );	
				this.dataProvider = dp;
				if(file is File){
				}else{
					var removeEvent:RemoveFileEvent = new RemoveFileEvent( RemoveFileEvent.DO_REMOVE );
					removeEvent.doRemove = true;
					dispatchEvent( removeEvent );
				}
			}
			else {
				var doRemoveEvent:RemoveFileEvent = new RemoveFileEvent( RemoveFileEvent.DO_REMOVE );
				doRemoveEvent.doRemove = false;
				dispatchEvent( doRemoveEvent ); 
			} */	
		}
	}
}
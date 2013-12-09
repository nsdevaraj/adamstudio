package com.adams.scrum.views.components
{
	import com.adams.scrum.models.vo.FileReferenceVO;
	import com.adams.scrum.models.vo.Stories;
	import com.adams.scrum.utils.Utils;
	
	import flash.desktop.ClipboardFormats;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.TileList;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	
	import org.osflash.signals.Signal;
	
	
	public class NativeTileList extends TileList
	{		
		public static const SHOW_ITEM:String = "showItem";
		public static const COMPLETE_ITEM_UPLOAD:String = "completeItemUpload";
		public static const COMPLETE_ALL_UPLOAD:String = "completeAllUpload";
		public static const REPLACE_ITEM:String = "replaceItem";
		public static const CANCEL_ITEM:String = "cancelItem";
		public static const DELETE_ITEM:String = "deleteItem";
		public static const DELETE_INNER_ITEM:String = "deleteInnerItem";
		
		public var renderSignal:Signal = new Signal();
		
		public var serverPath:String;
		public var destinationPath:String;
		
		public var fileStoryID:int = 0;
		
		public var fileListDataProvider:ArrayCollection = new ArrayCollection();
		public var tempAc:ArrayCollection =  new ArrayCollection();
		
		private var currentUploadingObejct:Object = new Object();
		
		public const OLD_FILE:String = "oldFile";
		public const NEW_FILE:String = "newFile";
		
		private var imageExtensionArray:Array = ["jpg","jpeg","png","tiff","gif","bmp"];
		private var docExtensionArray:Array = ["doc","txt","rtf","docx","docm","odt","html"];
		private var zipExtensionArray:Array = [".7z",".rar",".zip",".zipx",".tgz",".taz"];
		private var dataExtensionArray:Array = [".xls",".ods"];
		private var audioExtensionArray:Array = [".aac",".wav",".wma",".mp3",".wave"];
		private var videoExtensionArray:Array = [".3gp",".avi",".wmv",".flv",".mov",".mpeg",".mpeg4"];
		private var monthName:Array = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
		
		[Embed(source="assets/swf/Icon.swf#imageIcon")]
		private var imageIcon:Class;
		[Embed(source="assets/swf/Icon.swf#audioIcon")]
		private var audioIcon:Class;
		[Embed(source="assets/swf/Icon.swf#otherIcon")]
		private var otherIcon:Class;
		[Embed(source="assets/swf/Icon.swf#zipIcon")]
		private var zipIcon:Class;
		[Embed(source="assets/swf/Icon.swf#videoIcon")]
		private var videoIcon:Class;
		[Embed(source="assets/swf/Icon.swf#pdfIcon")]
		private var pdfIcon:Class;
		[Embed(source="assets/swf/Icon.swf#xlsIcon")]
		private var xlsIcon:Class;
		[Embed(source="assets/swf/Icon.swf#xmlIcon")]
		private var xmlIcon:Class;
		[Embed(source="assets/swf/Icon.swf#psdIcon")]
		private var psdIcon:Class;
		[Embed(source="assets/swf/Icon.swf#swfIcon")]
		private var swfIcon:Class;
		[Embed(source="assets/swf/Icon.swf#flaIcon")]
		private var flaIcon:Class;
		[Embed(source="assets/swf/Icon.swf#aiIcon")]
		private var aiIcon:Class;
		[Embed(source="assets/swf/Icon.swf#docIcon")]
		private var docIcon:Class;
		
		private var fileRefList:FileReferenceList;
		
		public function NativeTileList()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE,initializationVariable);			
		}
		
		private function initializationVariable(event:FlexEvent):void{
			fileListDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onDataProviderChange);
			
			itemRenderer = Utils.getFileRenderer(Utils.IMAGERENDER);
			this.columnWidth = this.rowHeight = 50;
			
			fileRefList = new FileReferenceList();
			fileRefList.addEventListener(Event.SELECT, selectHandler);
			
			renderSignal.add(signalHandler);
		}
		private function selectHandler(event:Event):void
		{
			var files:FileReferenceList = FileReferenceList(event.target);
			var selectedFileArray:Array = files.fileList;
			for (var i:uint = 0; i < selectedFileArray.length; i++)
			{
				var file:FileReference = FileReference(selectedFileArray[i]);
				var f:FileReferenceVO = new FileReferenceVO();
				f.fileRefVO = file;
				f.name = file.name;
				f.extension = file.type;
				if(!isItemAvailable(f.fileRefVO ,this.dataProvider as ArrayCollection)){
					this.dataProvider.addItem({ fileId:0, storyFk:fileStoryID, file:f, filename:f.name, extension:f.extension, img:fileImageClass(f.extension), uploadPercentage:0, uploadStatus:"Not Done", fileDateTime:new Date(), fileStatus:NEW_FILE, uploadedPath:"" });
					tempAc.addItem({ fileId:0, storyFk:fileStoryID, file:f, filename:f.name, extension:f.extension, img:fileImageClass(f.extension), uploadPercentage:0, uploadStatus:"Not Done", fileDateTime:new Date(), fileStatus:NEW_FILE, uploadedPath:"" });
					/*this.dataProvider.addItem({ file:f, img:fileImageClass(f.extension), uploadPercentage:0, uploadStatus:"Not Done", uploadedPath:""});
					tempAc.addItem({file:f, img:fileImageClass(f.extension), uploadPercentage:0, uploadStatus:"Not Done", uploadedPath:""});*/
				}
			}
			/*if(tempAc.length>0 && !uploadOnProcess){
				uploadOnProcess = true;
				test();
			}*/
		}
		private function signalHandler( type:String,obj:Object = null ):void{
			if( type == DELETE_INNER_ITEM ){
				deleteFileItem(obj);
			}
			else if( type == CANCEL_ITEM ){
				cancelFileItem(obj);
			}else if( type == DELETE_ITEM ){
				this.dataProvider.removeItemAt(this.dataProvider.getItemIndex( obj ));
			}
		}			
		private function deleteFileItem( obj:Object ):void{	
			renderSignal.dispatch( NativeTileList.DELETE_ITEM, obj);
		}
		private function cancelFileItem( obj:Object ):void{			
			this.dataProvider.removeItemAt(this.dataProvider.getItemIndex(searchItemForUpdate( obj, this.dataProvider as ArrayCollection)));
			tempAc.removeItemAt(tempAc.getItemIndex(searchItemForUpdate( obj, tempAc)));
			if(fileObject != null){
				if(fileObject.name == obj.file.name){
					fileObject.cancel();
					if(tempAc.length>0)
					{
						currentUploadingObejct = tempAc.getItemAt(0);
						loadAndUploadFiles(tempAc.getItemAt(0).file.fileRefVO);
					}else{
						uploadOnProcess = false;
						renderSignal.dispatch( NativeTileList.COMPLETE_ALL_UPLOAD, null);
					}
				}
			}
		}
		private function onDataProviderChange( event:CollectionEvent ):void{
			onDataChange();
		}
		public function onDataChange():void
		{
			this.dataProvider = new ArrayCollection();
			for(var i:int=0;i<fileListDataProvider.length;i++){
				var f:FileReferenceVO = new FileReferenceVO();
				//trace(fileListDataProvider.getItemAt(i).);
				var path:String = fileListDataProvider.getItemAt(i).filepath;
				var extension:String = fileListDataProvider.getItemAt(i).extension;
				var filename:String = fileListDataProvider.getItemAt(i).filename;
				this.dataProvider.addItem({fileId:fileListDataProvider.getItemAt(i).fileId, storyFk:fileListDataProvider.getItemAt(i).storyFk, file:f, filename:filename, extension:extension, img:fileImageClass(extension), uploadPercentage:100, uploadStatus:"Done", fileDateTime:fileListDataProvider.getItemAt(i).filedate, fileStatus:OLD_FILE, uploadedPath:path  });
			}
		}
		public function resetUploader():void{
			this.dataProvider = new ArrayCollection();
			fileListDataProvider.removeAll();
			fileListDataProvider = new ArrayCollection();
			tempAc.removeAll();
			uploadOnProcess = false;
			fileObject = null;
		}
		/*private function onDragIn( e:NativeDragEvent ):void{
			if(e.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)){
				//get the array of files
				var files:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
				DragManager.acceptDragDrop(this);
			}			
		}
		private function onDragDrop( e:NativeDragEvent ):void{
			var arr:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			//tempAc = new ArrayCollection();
			for(var i:int=0;i<arr.length;i++){
				var f:File = File(arr[i]);
				if(!f.isDirectory && !isItemAvailable(f,this.dataProvider as ArrayCollection)){
					this.dataProvider.addItem({ fileId:0, storyFk:fileStoryID, file:f, img:fileImageClass(f.extension), uploadPercentage:0, uploadStatus:"Not Done", fileDateTime:new Date(), fileStatus:NEW_FILE });
					tempAc.addItem({ fileId:0, storyFk:fileStoryID, file:f, img:fileImageClass(f.extension), uploadPercentage:0, uploadStatus:"Not Done", fileDateTime:new Date(), fileStatus:NEW_FILE });
				}
			}
		}*/
		private function isItemAvailable( file:FileReference, ac:ArrayCollection ):Boolean{
			for(var i:int = 0;i<ac.length;i++){
				if(ac.getItemAt(i).filename == file.name )
					return true;
			}
			return false;
		}
		private function searchItemForUpdate( currentItem:Object, ac:ArrayCollection ):Object{
			for(var i:int = 0;i<ac.length;i++)
			{
				if((currentItem.filename) == (ac.getItemAt(i).filename))
				{
					return ac.getItemAt(i);
				}
			}
			return null;
		}
		private function fileImageClass( extension:String ):Class{
			extension = ( extension )?extension.toLowerCase():"Unknown";
			if(imageExtensionArray.join(",").indexOf( extension ) != -1){
				return imageIcon;
			}
			if(audioExtensionArray.join(",").indexOf( extension ) != -1){
				return audioIcon;
			}
			if(videoExtensionArray.join(",").indexOf( extension ) != -1){
				return videoIcon;
			}
			if(zipExtensionArray.join(",").indexOf( extension ) != -1){
				return zipIcon;
			}
			if(docExtensionArray.join(",").indexOf( extension ) != -1){
				return docIcon;
			}
			if(dataExtensionArray.join(",").indexOf( extension ) != -1){
				return xlsIcon;
			}
			if(extension == "pdf"){
				return pdfIcon;
			}
			if(extension == "xml"){
				return xmlIcon;
			}
			if(extension == "psd"){
				return psdIcon;
			}
			if(extension == "ai"){
				return aiIcon;
			}
			if(extension == "fla"){
				return flaIcon;
			}
			if(extension == "swf"){
				return swfIcon;
			}
			return otherIcon;
		}
		public function browseFiles():void
		{
			fileRefList.browse();	
		}
		public function uploadFiles( fileStory:Stories ):void{		
			if(tempAc.length>0 && !uploadOnProcess){
				fileStoryID = fileStory.storyId;
				uploadOnProcess = true;
				currentUploadingObejct = tempAc.getItemAt(0);
				loadAndUploadFiles(tempAc.getItemAt(0).file.fileRefVO);
			}
		}
		private var fileObject:FileReference;
		private var currentUploadedFilePath:String = "";
		private var uploadOnProcess:Boolean = false;
		private function loadAndUploadFiles( file:FileReference ):void {
			//C:\Documents and Settings\Administrator\DTFlex\CARREFOUR\2010\Jul\IB1001_HigherJet\Basic\audio.wavj
			fileObject = file;
			
			var data:ByteArray = new ByteArray();
			//fileObj.name = StringUtils.trimAll( file.name );
			var filename:String = file.name;
			
			var url:String = serverPath+"/uploadhandler";
			var request:URLRequest = new URLRequest( url );
			request.contentType = 'multipart/form-data; boundary=' + getBoundary();
			request.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
			request.method = URLRequestMethod.POST;
			
			var now:Date = new Date();
			var variables:URLVariables = new URLVariables();
			var ext:String = (file.type!=null)?file.type.substr(1):"Unknown";
			//variables.filePath = currentInstance.config.FileServer+"/Scrum/"+now.fullYear+"/"+monthName[now.month]+"/"+ext ;
			variables.filePath = destinationPath+"/Scrum/"+now.fullYear+"/"+monthName[now.month]+"/"+ext ;
			variables.fileName = filename; 
			currentUploadedFilePath = variables.filePath+"/"+variables.fileName;
			
			request.data = variables; 
			
			fileObject.addEventListener( ProgressEvent.PROGRESS, progressHandler );
			fileObject.addEventListener( Event.COMPLETE, completeHandler );
			fileObject.addEventListener( IOErrorEvent.IO_ERROR, faultHandler );
			fileObject.upload( request );
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
		private function completeHandler( event:Event ):void
		{
			var currentObject:Object = searchItemForUpdate(currentUploadingObejct, this.dataProvider as ArrayCollection);
			//var file:File = new File(currentUploadedFilePath);
			tempAc.removeItemAt(tempAc.getItemIndex(searchItemForUpdate(currentObject, tempAc)));
			currentObject.uploadedPath = currentUploadedFilePath;
			currentObject.uploadPercentage = 100;
			currentObject.storyFk = fileStoryID;
			currentObject.fileDateTime = new Date();
			currentObject.uploadStatus = "Done";
			this.dataProvider.itemUpdated(currentObject); 			
			var compeleteObject:Object = new Object();
			//compeleteObject.file = event.target as File;
			compeleteObject.uploadedPath = currentUploadedFilePath;
			//compeleteObject.file.nativePath = currentUploadedFilePath;
			compeleteObject.img = null;
			compeleteObject.storyFk = fileStoryID;
			compeleteObject.fileDateTime = new Date();
			compeleteObject.uploadPercentage = 100;
			compeleteObject.uploadStatus = "Done";
			this.renderSignal.dispatch( NativeTileList.COMPLETE_ITEM_UPLOAD, compeleteObject);
			if(tempAc.length>0)
			{
				currentUploadingObejct = tempAc.getItemAt(0);
				loadAndUploadFiles(tempAc.getItemAt(0).file.fileRefVO);
			}else{
				uploadOnProcess = false;
				this.renderSignal.dispatch( NativeTileList.COMPLETE_ALL_UPLOAD, null);
			}
		}
		
		private function progressHandler( event:ProgressEvent ):void {
			currentUploadingObejct.uploadPercentage = Math.round((event.bytesLoaded/event.bytesTotal)*100);
			var currentObject:Object = searchItemForUpdate(currentUploadingObejct, this.dataProvider as ArrayCollection);
			if(currentObject != null){
				currentObject.uploadPercentage = Math.round((event.bytesLoaded/event.bytesTotal)*100);
				this.dataProvider.itemUpdated(currentObject);
			}
		}
		private function faultHandler( event:IOErrorEvent ):void {
			
		}	
		
	}
}
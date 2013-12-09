/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.view.mediators
{ 
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.model.vo.*;
	import com.adams.dt.signal.ControlSignal;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.FileSkinView;
	import com.adams.dt.view.components.FileUploadTileList;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.ArrayUtil;
	import com.adams.swizdao.util.GetVOUtil;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.events.FlexEvent;
	
	
	public class FileViewMediator extends AbstractViewMediator
	{ 		 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject("filedetailsDAO")]
		public var filedetailsDAO:AbstractDAO;
		
		[Inject("Basic")]
		public var basicFileUploadTileList:FileUploadTileList;
		
		[Inject("Tasks")]
		public var taskFileUploadTileList:FileUploadTileList;
		
		[Inject("Release")]
		public var releaseFileUploadTileList:FileUploadTileList;
		
		private var tempFileCollection:ArrayCollection = new ArrayCollection();
		
		private var fileExt:String = ""; 
		
		private var compareFile:Boolean = false;
		
		private var _homeState:String;
		public function get homeState():String {
			return _homeState;
		}
		public function set homeState( value:String ):void {
			_homeState = value;
			if( value == Utils.FILE_INDEX ) {
				addEventListener( Event.ADDED_TO_STAGE, addedtoStage );
			}
		}
		
		protected function addedtoStage( ev:Event ):void {
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function FileViewMediator( viewType:Class=null )
		{
			super( FileSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():FileSkinView 	{
			return _view as FileSkinView;
		}
		
		[MediateView( "FileSkinView" )]
		override public function setView( value:Object ):void { 
			super.setView(value);	
		}  
		
		/**
		 * The <code>init()</code> method is fired off automatically by the 
		 * AbstractViewMediator when the creation complete event fires for the
		 * corresponding ViewMediator's view. This allows us to listen for events
		 * and set data bindings on the view with the confidence that our view
		 * and all of it's child views have been created and live on the stage.
		 */
		override protected function init():void {
			super.init();  
			fileListSettings();
			controlSignal.getProjectFilesSignal.dispatch( this, currentInstance.mapConfig.currentProject.projectId );
		}
		
		private function test( ev:Object = null ):void {
			if( taskFileUploadTileList.fileList ) {
				taskFileUploadTileList.fileList.renderSignal.add( fileHandler );
			}	
		}
		
		private function fileListSettings():void {
			view.previewFile.source = "";
			
			view.basicFileList.addElement( basicFileUploadTileList );
			view.taskFileList.addElement( taskFileUploadTileList );
			view.releaseFileList.addElement( releaseFileUploadTileList );
			
			taskFileUploadTileList.addEventListener( FlexEvent.CREATION_COMPLETE, test );
			
			basicFileUploadTileList.resetUploader();
			basicFileUploadTileList.componentType = "dashboard";
			
			if( basicFileUploadTileList.fileList ) {
				basicFileUploadTileList.fileList.renderSignal.add( fileHandler );
			}	
			
			taskFileUploadTileList.resetUploader();
			taskFileUploadTileList.componentType = "dashboard";
			
			releaseFileUploadTileList.resetUploader();
			releaseFileUploadTileList.componentType = "dashboard";
			
			if( currentInstance.mapConfig.currentVersionPDFFilePathID != 0 ) {
				view.previewFile.visible = false;
				view.otherFile.visible = false;
				view.pdfTool.visible = false;
				view.deafultText.visible = false; 
			}
			else {
				view.previewFile.visible = false;
				view.otherFile.visible = false;
				view.pdfTool.visible = false;
				view.deafultText.visible = true;
			}
		}
		
		private function resetForm():void{
			view.otherFileName.text = "";
			view.otherFileType.text = "";
			view.otherFileExt.text = "";
			view.notAvailableFile.text = "";
		}
		
		private var pdfFileAC:ArrayCollection;
		
		private function fileHandler( type:String, obj:Object = null ):void {
			if( type == FileUploadTileList.PREVIEW_ITEM ){				
				var swfFilePath:String = null;
				fileExt = obj.extension.toLowerCase(); 
				var fileId:int = -1;
				var fileReleaseVersion:int = 0;
				if( fileExt == "pdf"){
					if( tempFileCollection ){
						for each( var itemSwfFiles:FileDetails in tempFileCollection ) {
							if(!itemSwfFiles.visible){
								if(itemSwfFiles.miscelleneous == obj.miscelleneous){
									swfFilePath = itemSwfFiles.filePath;
									fileId = obj.fileId;
									fileReleaseVersion = itemSwfFiles.releaseStatus;
									
									break;
								}
							}
						}
						pdfFileAC = new ArrayCollection(); 
						for each(itemSwfFiles in tempFileCollection ) {
							if(!itemSwfFiles.visible){
								if(itemSwfFiles.miscelleneous == obj.miscelleneous){
									//"_thumb.swf";
									var fPath:String = String(itemSwfFiles.filePath);
									itemSwfFiles.thumbnailPath = fPath.substring(0,fPath.length-4)+"_thumb.swf"; 
									pdfFileAC.addItem(itemSwfFiles);
								}
							}
						}
					}
					if(swfFilePath!=null){
						resetForm();
						view.previewFile.visible = false;
						view.previewFile.includeInLayout = false;
						view.otherFile.visible = false;
						view.otherFile.includeInLayout = false;
						view.deafultText.visible = false; 
						view.pdfTool.visible = false;
						compareFile = false;
						controlSignal.downloadFileSignal.dispatch(this,swfFilePath, fileId, fileReleaseVersion);
					}else
					{
						resetForm();
						controlSignal.showAlertSignal.dispatch(null,Utils.FILESYNC,Utils.APPTITLE,1,null);
						view.previewFile.visible = false;
						view.previewFile.includeInLayout = false;
						view.otherFile.visible = false;
						view.otherFile.includeInLayout = false;
						view.deafultText.visible = true;
						view.pdfTool.visible = false;
					}
				}
				else if( fileExt == "jpg" || fileExt == "jpeg" || fileExt == "png" || fileExt == "gif" || fileExt == "swf") {
					swfFilePath = obj.filePath;
					
					resetForm();
					view.previewFile.visible = true;
					view.previewFile.includeInLayout = true;
					view.otherFile.visible = false;
					view.otherFile.includeInLayout = false;
					view.deafultText.visible = false;
					view.pdfTool.visible = false;
					
					controlSignal.downloadFileSignal.dispatch(this,swfFilePath, -1, 0);
				}
				else {					
					view.previewFile.visible = false;
					view.previewFile.includeInLayout = false;
					view.otherFile.visible = true;
					view.otherFile.includeInLayout = true;
					view.deafultText.visible = false;
					view.pdfTool.visible = false;
					
					view.otherFileName.text = obj.fileName;
					view.otherFileType.text = obj.type; 
					view.otherFileExt.text = obj.extension;
				}
			}
			if( type == FileUploadTileList.INFO_ITEM ){
				view.previewFile.visible = false;
				view.previewFile.includeInLayout = false;
				view.otherFile.visible = true;
				view.otherFile.includeInLayout = true;
				view.deafultText.visible = false;
				view.pdfTool.visible = false;
				
				view.otherFileName.text = obj.fileName;
				view.otherFileType.text = obj.type; 
				view.otherFileExt.text = obj.extension;				
			}
			if( type == FileUploadTileList.COMPARISION_ITEM ){
				var swfCompareFilePath:String = null;
				var compareFileId:int = -1
				var compareFileReleaseVersion:int = 0;
				fileExt = obj.extension.toLowerCase(); 
				
				if( fileExt == "pdf"){
					if( tempFileCollection ){
						for each( var itemSwfFile:FileDetails in tempFileCollection ) {
							if(!itemSwfFile.visible){
								if(itemSwfFile.miscelleneous == obj.miscelleneous){
									swfCompareFilePath = itemSwfFile.filePath;
									compareFileId = obj.fileId;
									compareFileReleaseVersion = itemSwfFile.releaseStatus;
									break;
								}
							}
						}
					}
					if(swfCompareFilePath!=null){
						resetForm();
						view.previewFile.visible = false;
						view.previewFile.includeInLayout = false;
						view.otherFile.visible = false;
						view.otherFile.includeInLayout = false;
						view.deafultText.visible = false; 
						view.pdfTool.visible = false;
						compareFile = true;
						controlSignal.downloadFileSignal.dispatch(this,swfCompareFilePath, compareFileId, compareFileReleaseVersion);
					}
					else
					{
						resetForm();
						controlSignal.showAlertSignal.dispatch(null,Utils.FILESYNC,Utils.APPTITLE,1,null);
						view.previewFile.visible = false;
						view.previewFile.includeInLayout = false;
						view.otherFile.visible = false;
						view.otherFile.includeInLayout = false;
						view.deafultText.visible = true;
						view.pdfTool.visible = false;
					}
				}else {
					controlSignal.showAlertSignal.dispatch(null,Utils.FILECOMPARISION_OTHER_FORMAT,Utils.APPTITLE,1,null);
				}
			}
		}
		
		private function resetDashboardFiles():void {
			controlSignal.getProjectFilesSignal.dispatch(this,currentInstance.mapConfig.currentProject.projectId);
			fileListSettings();
			controlSignal.getProjectFilesSignal.dispatch(this,currentInstance.mapConfig.currentProject.projectId);
		}
		
		protected function setDataProviders():void {	    
		}
		
		override protected function setRenderers():void {
			super.setRenderers();  
		} 
		
		override protected function serviceResultHandler( obj:Object, signal:SignalVO ):void { 
			if( signal.destination == Utils.FILEDETAILSKEY ) {				
				if( signal.action == Action.FIND_ID ) {	
					var projectBasicFileCollection:ArrayCollection = new ArrayCollection();
					var projectTaskFileCollection:ArrayCollection = new ArrayCollection();
					var projectReleaseFileCollection:ArrayCollection = new ArrayCollection();
					
					tempFileCollection = new ArrayCollection();
					tempFileCollection = ArrayCollection( signal.currentProcessedCollection );
					
					for each( var itemFiles:FileDetails in signal.currentProcessedCollection ) {
						if( itemFiles.visible ) {
							if( itemFiles.type == Utils.BASICFILETYPE ) {
								projectBasicFileCollection.addItem( itemFiles );
							}
							else if( itemFiles.type == Utils.TASKFILETYPE ) {
								projectTaskFileCollection.addItem( itemFiles );
							}
						}
						else {
							if( itemFiles.releaseStatus != 0 ) {
								var releaseItem:FileDetails = getReleaseFiles( signal.currentProcessedCollection, itemFiles.miscelleneous ); 
								if( releaseItem ) {
									projectReleaseFileCollection.addItem( releaseItem );
								}
							}
						}
					}
					
					basicFileUploadTileList.fileListDataProvider = projectBasicFileCollection;
					basicFileUploadTileList.fileListDataProvider.refresh();
					basicFileUploadTileList.onDataChange();
					
					taskFileUploadTileList.fileListDataProvider = projectTaskFileCollection;
					taskFileUploadTileList.fileListDataProvider.refresh();
					taskFileUploadTileList.onDataChange();
					
					if( projectReleaseFileCollection.length != 0 ) {
						releaseFileUploadTileList.fileListDataProvider = projectReleaseFileCollection;
						releaseFileUploadTileList.fileListDataProvider.refresh();
						releaseFileUploadTileList.onDataChange();
						view.releaseFileList.visible = true;
					}
					else {
						view.releaseFileList.visible = false;
					}
				}
				
				if( signal.action == Action.DELETE ) {
					var deleteFile:FileDetails = signal.valueObject as FileDetails;
				}				
			}
			if( signal.destination == ArrayUtil.PAGINGDAO && signal.action == Action.FILEDOWNLOAD ) {
				if( obj ) {
					var objBytes:ByteArray = obj as ByteArray;
					if( objBytes.length > 0 ) {
						if( fileExt != "pdf" ) {
							view.previewFile.source = objBytes;
						}
						else {
							if( compareFile ) {
								view.pdfTool.previousFileData( objBytes, signal.id, signal.startIndex );
							}
							else {
								if( objBytes.length > 0 ) {
									view.pdfTool.currentFileData( objBytes, signal.id, signal.startIndex, pdfFileAC );
								}
								else {
									controlSignal.showAlertSignal.dispatch( null, Utils.FILESYNC,Utils.APPTITLE, 1, null );
								}
							}
						}
					}
					else {
						controlSignal.showAlertSignal.dispatch( null, Utils.FILESYNC, Utils.APPTITLE, 1, null );
					}
				}
				else {
					view.pdfTool.currentFileData( new ByteArray(), -1, 0 );
					view.deafultText.visible = true;
					view.pdfTool.visible = false;
					controlSignal.showAlertSignal.dispatch( null, Utils.FILESYNC, Utils.APPTITLE, 1, null );
				}
			}			
		}		
		
		private function getReleaseFiles( sourceCollection:IList, miscellaneous:String ):FileDetails {
			for each( var item:FileDetails in sourceCollection ) {
				if( ( item.visible ) && ( item.miscelleneous == miscellaneous ) ) {
					return item;
				}
			}
			return null;
		}
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
		}
		override protected function pushResultHandler( signal:SignalVO ): void { 
		} 
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			super.cleanup( event ); 		
		} 
	}
}
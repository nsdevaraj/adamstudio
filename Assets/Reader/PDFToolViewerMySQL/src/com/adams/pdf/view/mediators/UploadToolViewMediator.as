/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   V.Kumar
@contact  kutti.kumar@gmail.com
@project  PDFTool

@internal 

*/
package com.adams.pdf.view.mediators
{ 
	import com.adams.pdf.model.AbstractDAO;
	import com.adams.pdf.model.vo.*;
	import com.adams.pdf.signal.ControlSignal;
	import com.adams.pdf.util.DateUtil;
	import com.adams.pdf.util.Utils;
	import com.adams.pdf.view.UploadSkinView;
	import com.adams.pdf.view.components.FileUploadTileList;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.ArrayUtil;
	import com.adams.swizdao.util.FileNameSplitter;
	import com.adams.swizdao.util.GetVOUtil;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.events.FlexEvent;
	
	
	public class UploadToolViewMediator extends AbstractViewMediator
	{ 		 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject("filedetailsDAO")]
		public var filedetailsDAO:AbstractDAO;
				
		[Inject("Basic")]
		public var fileUploadTileList:FileUploadTileList; 
		
		private var tempFileCollection:ArrayCollection = new ArrayCollection();
		
		private var fileExt:String = ""; 
		
		private var compareFile:Boolean = false;
		
		private var _homeState:String;
		public function get homeState():String {
			return _homeState;
		}
		public function set homeState( value:String ):void {
			_homeState = value;
			if( value == Utils.UPLOAD_INDEX ) {
				addEventListener( Event.ADDED_TO_STAGE, addedtoStage );
			}
		}
		
		protected function addedtoStage( ev:Event ):void {
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function UploadToolViewMediator( viewType:Class=null )
		{
			super( UploadSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():UploadSkinView 	{
			return _view as UploadSkinView;
		}
		
		[MediateView( "UploadSkinView" )]
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
			resetForm();
			makeCallLater();
			
			view.fileTile.addElement( fileUploadTileList );
			fileUploadTileList.componentType = "upload";
			fileUploadTileList.fileType = Utils.BASICFILETYPE; 
			callLater( fileUploadTileList.resetUploader );
		}
		
		/*private function test( ev:Object = null ):void {
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
		}*/
		
		private function resetForm():void{
			if(fileUploadTileList)fileUploadTileList.resetUploader(); 
		}
		protected function makeCallLater():void {			
			callLater( fileUploadTileList.resetUploader );
			BindingUtils.bindProperty( view.uploadButId, 'enabled', fileUploadTileList, 'uploadNotInProcess' );
		}
		
		protected function uploadValidation( event:MouseEvent ):void { 
			if( fileUploadTileList.currentListComp.dataProvider ) {
				if( fileUploadTileList.currentListComp.dataProvider.length == 0 ) {
					currentInstance.mapConfig.fileUploadCollection = new ArrayCollection();
				}
			}
			if(currentInstance.mapConfig.fileUploadCollection.length >0){
				controlSignal.progressStateSignal.dispatch(Utils.PROGRESS_ON);
				fileUpdation();	
			}else {
				controlSignal.changeStateSignal.dispatch( Utils.PDFTOOL_INDEX );
			}	
		}	
		
		private function fileUpdation():void{
			var arrc:ArrayCollection = new ArrayCollection();
			var toPath:String = currentInstance.config.FileServer;
			for each(var filesVo:FileDetails in currentInstance.mapConfig.fileUploadCollection){
				var filename:String = filesVo.fileName; 
				var splitObject:Object = FileNameSplitter.splitFileName( filesVo.fileName );			
				
				filesVo.storedFileName = filename;
				filesVo.filePath = toPath+filesVo.type+Utils.fileSplitter+filesVo.storedFileName;
				filesVo.miscelleneous = FileNameSplitter.getUId();
				arrc.addItem( filesVo );
				
			}
			currentInstance.mapConfig.fileUploadCollection = new ArrayCollection();
			controlSignal.moveFilesSignal.dispatch(null,arrc,toPath);
			controlSignal.bulkUpdateFilesSignal.dispatch(null,arrc);
		}
		
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
					}
					if(swfFilePath!=null){
						resetForm();						
						compareFile = false;
						controlSignal.downloadFileSignal.dispatch(this,swfFilePath, fileId, fileReleaseVersion);
					}else
					{
						resetForm();
						controlSignal.showAlertSignal.dispatch(null,Utils.FILESYNC,Utils.APPTITLE,1,null);						
					}
				}
				
			}			
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
				}
				
				if( signal.action == Action.DELETE ) {
					var deleteFile:FileDetails = signal.valueObject as FileDetails;
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
			view.uploadButId.addEventListener(MouseEvent.CLICK,uploadValidation, false, 0, true );
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
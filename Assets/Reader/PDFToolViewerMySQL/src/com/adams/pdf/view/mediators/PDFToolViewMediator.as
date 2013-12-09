/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  PDFTool

@internal 

*/
package com.adams.pdf.view.mediators
{ 
	import com.adams.pdf.model.AbstractDAO;
	import com.adams.pdf.model.vo.*;
	import com.adams.pdf.signal.ControlSignal;
	import com.adams.pdf.util.Utils;
	import com.adams.pdf.view.PDFToolSkinView;
	import com.adams.pdf.view.components.PDFTool.*;
	import com.adams.pdf.view.components.PDFTool.events.CommentCollectionEvent;
	import com.adams.swizdao.dao.PagingDAO;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.response.SignalSequence;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.ArrayUtil;
	import com.adams.swizdao.util.Description;
	import com.adams.swizdao.util.ObjectUtils;
	import com.adams.swizdao.views.components.NativeList;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayCollection;
	import mx.events.ResizeEvent;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.components.Group;
	import spark.events.IndexChangeEvent;
	
	
	public class PDFToolViewMediator extends AbstractViewMediator
	{ 		 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject("filedetailsDAO")]
		public var filedetailsDAO:AbstractDAO;
		
		[Bindable]
		public var imgWidth:Number = 0;
		
		[Bindable]
		public var imgHeight:Number = 0;
		
		[Bindable]
		public var doublePageView:Boolean = false;
		
		[Bindable]
		public var compareView:Boolean = false;
		
		[Bindable]
		public var compareMode:Boolean = false;
		
		[Bindable]
		public var isCompareModeFileAvailable:Boolean = false;
		
		[Bindable]
		public var shapeSelect:String = ShapeComponentFXG.NONE;
		
		[Bindable]
		public var regionPointerVisible:Boolean = false;
		
		[Bindable]
		public var previousTaskSWFPath:String = "";
		
		[Bindable]
		public var currentTaskSWFPath:String = "";
		
		private var currentVersionFileID:int = -1;
		private var previousVersionFileID:int = -1;
		
		private var commentBox:CommentBox;
		private var tempFileCollection:ArrayCollection = new ArrayCollection();
		
		public var page1XBindWatcher:ChangeWatcher;
		public var page1YBindWatcher:ChangeWatcher;
		
		public var page2XBindWatcher:ChangeWatcher;
		public var page2YBindWatcher:ChangeWatcher;
		
		public var compareImageXBindWatcher:ChangeWatcher;
		public var compareImageYBindWatcher:ChangeWatcher;
		
		public var pdfCommentListAC:ArrayCollection = new ArrayCollection();
		private var fileDetailsVO:FileDetails; 
		public var releaseVersionStatusValue:int = 0;
		
		private var currentActiveCommentBox:CommentBox;
		
		private var previousVersionPDFCommentListFetch:Boolean = false;
		private var currentVersionPDFCommentListLoadCompleted:Boolean = false;
		private var previousVersionPDFCommentListLoadCompleted:Boolean = false;
		
		private var pdfToggleTimer:Timer = new Timer(1500);
		private var isPDFToggle:Boolean = false;
		private var firstPDFSelect:Boolean = false;
		
		
		
		private var currentNote:CommentBox;
		
		private var _homeState:String;
		public function get homeState():String
		{
			return _homeState;
		}
		
		public function set homeState(value:String):void
		{
			_homeState = value;
			if(value==Utils.PDFTOOL_INDEX) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		
		protected function addedtoStage(ev:Event):void{
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function PDFToolViewMediator( viewType:Class=null )
		{
			super( PDFToolSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():PDFToolSkinView 	{
			return _view as PDFToolSkinView;
		}
		
		[MediateView( "PDFToolSkinView" )]
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
			viewState = Utils.PDFTOOL_INDEX;
			initWork(); 
		} 
		protected function setDataProviders():void {	    
		}
		override protected function setRenderers():void {
			super.setRenderers();  
		} 
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
			addAllEventListener();
		}
		override protected function pushResultHandler( signal:SignalVO ): void { 
		} 
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			super.cleanup( event ); 
			removeAllEventListener();	
		} 
		
		// PDF Tool Logic 
		
		override protected function serviceResultHandler( obj:Object,signal:SignalVO ):void { 
			if( signal.destination == ArrayUtil.PAGINGDAO && signal.action == Action.FILEDOWNLOAD ){
				if( obj ){
					var objBytes:ByteArray = obj as ByteArray;
					if(signal.id == currentVersionFileID){
						currentFileData(objBytes, signal.id, 1);
						resetWork();
					}
					else if(signal.id == previousVersionFileID){
						previousFileData(objBytes, signal.id, 1);
						resetWork();
					}
					
					if(isCompareModeFileAvailable)
					{
						isCompareModeFileAvailable = false;
						controlSignal.downloadFileSignal.dispatch(this,previousTaskSWFPath, previousVersionFileID);
					}
					
					if(view.pageListGrp.visible) view.pageListGrp.visible = false;
				} 
			}	
			if(signal.destination == Utils.COMMENTVOKEY && signal.action == Action.FINDBY_ID){
				pdfCommentListAC = ArrayCollection( signal.currentProcessedCollection );
				if(!currentVersionPDFCommentListLoadCompleted){
					commentCollectionUpdate(view.page2);
					currentVersionPDFCommentListLoadCompleted = true;
				}else if(!previousVersionPDFCommentListLoadCompleted){
					commentCollectionUpdate(view.page1);
					previousVersionPDFCommentListLoadCompleted = true;
				}
			}
			if(signal.destination == Utils.COMMENTVOKEY && (signal.action == Action.CREATE || signal.action == Action.DIRECTUPDATE || signal.action == Action.DELETE)){
				collectionAddUpdateRemove(ArrayCollection(signal.collection.items));
			} 
		}
		
		protected function initWork():void
		{
			getFileData();
			
			view.page1Layout.visible = false;
			view.page2Layout.visible = false;
			
			view.page1.visible = false;
			view.page2.visible = false;
			
			view.page1.width = 0;
			view.page1.height = 0;
			view.page2.width = 0;
			view.page2.height = 0;
			
			view.page1CommentBoxGroup.removeAllElements();
			view.page1.removeAllComments();
			view.page1CommentBoxGroup.graphics.clear();
			view.page2CommentBoxGroup.removeAllElements();
			view.page2.removeAllComments();
			view.page2CommentBoxGroup.graphics.clear();
			view.pdf1CommentList.removeAllComments();
			view.pdf2CommentList.removeAllComments();
			
			view.page1.shapeSelect = shapeSelect;
			view.page2.shapeSelect = shapeSelect;
			view.pdf1Btn.enabled = doublePageView;
			view.pdf2Btn.enabled = doublePageView;
			
			BindingUtils.bindProperty(view.page1, "shapeSelect", this, "shapeSelect");
			BindingUtils.bindProperty(view.page2, "shapeSelect", this, "shapeSelect");
			BindingUtils.bindProperty(view.comparedImage, "width", this, "imgWidth");
			BindingUtils.bindProperty(view.comparedImage, "height", this, "imgHeight");
			BindingUtils.bindProperty(view.compareLayout, "visible", this, "compareView");
			
			BindingUtils.bindProperty(view.page1, "regionPointerVisible", this, "regionPointerVisible");
			BindingUtils.bindProperty(view.page2, "regionPointerVisible", this, "regionPointerVisible");
			
			BindingUtils.bindSetter(regionPointerToggleBtnVisibleBindSetter, this, "compareView" );
			BindingUtils.bindSetter(doubleSingleViewStatusBindSetter, this, "doublePageView" );
			
			view.drawContainer.visible = true;
			view.pageNavTools.visible = true;
			view.comparePageAdjusmentTools.visible = false;
			
			view.page1Slider.dataTipFormatFunction = SliderTooltip;
			view.page2Slider.dataTipFormatFunction = SliderTooltip;
			view.compareImageSlider.dataTipFormatFunction = SliderTooltip;
		}
		
		protected function updateComment(isListItem:Boolean):void
		{
			if(!isListItem)
			{
				view.pdf2CommentList.updateComment(currentActiveCommentBox);
			}else
			{
				for(var i:int = 0;i<view.page2CommentBoxGroup.numElements;i++)
				{
					if(currentActiveCommentBox.commentItemName == (view.page2CommentBoxGroup.getElementAt(i) as CommentBox).commentItemName)
					{
						(view.page2CommentBoxGroup.getElementAt(i) as CommentBox).updateCollection(currentActiveCommentBox.historyCollection);
						break;
					}
				}
			}
		}
		
		public function currentFileData(value:ByteArray, fileId:int, fileReleaseVersion:int):void
		{
			if(fileId!=-1){
				currentVersionFileID = fileId;
				releaseVersionStatusValue = fileReleaseVersion;
				
				if(value.length>0){
					
					addAllEventListener();
					
					if(releaseVersionStatusValue!=0)
					{
						view.releaseVersionLbl.text =  "Release Version : "+String(releaseVersionStatusValue);
						view.releaseVersionLbl.visible = true;
					}
					else
					{
						view.releaseVersionLbl.text =  "0";
						view.releaseVersionLbl.visible = false;
					}
					
					view.page1.width = 0;
					view.page1.height = 0;
					view.page2.width = 0;
					view.page2.height = 0;
					
					view.commentListDisplayToggleBtn.selected = false;
					view.commentListContainer.width = 270;
					
					previousVersionPDFCommentListFetch = false;
					currentVersionPDFCommentListLoadCompleted = false;
					previousVersionPDFCommentListLoadCompleted = false;
					
					view.page1CommentBoxGroup.visible = true;
					view.page2CommentBoxGroup.visible = true;
					
					view.notesOnOffBtn.selected = true;
					view.notesExpandCollapseBtn.selected = false;
					
					isPDFToggle = false;
					pdfToggleTimer.stop();
					view.playPauseBtn.selected = false;
					
					// getPDFCommentsSignal Error
					controlSignal.getPDFCommentsSignal.dispatch(this,currentVersionFileID);
					
					view.page1Layout.visible = false;
					view.page2Layout.visible = false;
					
					view.pdfCommentListNavBar.visible = false;
					view.pdf1CommentListBtn.selected = false;
					view.pdf2CommentListBtn.selected = true;
					view.pdf1CommentList.visible = false;
					view.pdf2CommentList.visible = true;
					
					this.visible = false;
					
					view.page1CommentBoxGroup.removeAllElements();
					view.page1.removeAllComments();
					view.page1CommentBoxGroup.graphics.clear();
					view.page2CommentBoxGroup.removeAllElements();
					view.page2.removeAllComments();
					view.page2CommentBoxGroup.graphics.clear();
					view.pdf1CommentList.removeAllComments();
					view.pdf2CommentList.removeAllComments();
					
					view.page2.sourceByteArray = value;
					compareMode = false;
					view.compareViewTools.visible = false;
					
					/*view.pageListGrp.visible = false;
					view.backBtn.visible = false;
					
					if(pageAC!=null)
					{
					if(pageAC.length>1){
					view.pageListGrp.visible = true;
					view.backBtn.visible = true;
					view.pageListDG.dataProvider = pageAC;
					var colWidth:Number = ((pageAC.length > 2 && pageAC.length<5)?view.pageListDG.width/2:view.pageListDG.width/3)
					var rowHeight:Number = ((pageAC.length == 2)?view.pageListDG.height:view.pageListDG.height/2);
					view.pageTileLayout.columnWidth = colWidth - 80;
					view.pageTileLayout.rowHeight = rowHeight - 20;
					//var colWidth:Number = ((pageAC.length > 2 && pageAC.length<5)?2:3)
					//var rowHeight:Number = ((pageAC.length == 2)?1:2);
					//view.pageTileLayout.requestedColumnCount = colWidth;
					//view.pageTileLayout.requestedRowCount = rowHeight;
					}else{
					view.pageListGrp.visible = false;
					view.backBtn.visible = false;
					}
					}*/
				}
			}
		}
		
		public function previousFileData(value:ByteArray, fileId:int, fileReleaseVersion:int):void
		{
			if(fileId!=-1){
				previousVersionFileID = fileId;
				if(value.length>0){
					addAllEventListener();
					
					view.page1Layout.visible = false;
					view.page2Layout.visible = false;
					
					view.page1.width = 0;
					view.page1.height = 0;
					view.page2.width = 0;
					view.page2.height = 0;
					
					previousVersionPDFCommentListFetch = true;
					currentVersionPDFCommentListLoadCompleted = false;
					previousVersionPDFCommentListLoadCompleted = false;
					
					view.commentListDisplayToggleBtn.selected = false;
					view.commentListContainer.width = 270;
					
					// getPDFCommentsSignal Error
					controlSignal.getPDFCommentsSignal.dispatch(this,currentVersionFileID);
					
					
					view.pdfCommentListNavBar.visible = true;
					view.pdf1CommentListBtn.selected = false;
					view.pdf2CommentListBtn.selected = true;
					view.pdf1CommentList.visible = false;
					view.pdf2CommentList.visible = true;
					
					isPDFToggle = false;
					pdfToggleTimer.stop();
					view.playPauseBtn.selected = false;
					
					view.page1CommentBoxGroup.visible = true;
					view.page2CommentBoxGroup.visible = true;
					view.notesOnOffBtn.selected = true;
					view.notesExpandCollapseBtn.selected = false;
					
					this.visible = false;
					
					view.page1CommentBoxGroup.removeAllElements();
					view.page1.removeAllComments();
					view.page1CommentBoxGroup.graphics.clear();
					view.page2CommentBoxGroup.removeAllElements();
					view.page2.removeAllComments();
					view.page2CommentBoxGroup.graphics.clear();
					view.pdf1CommentList.removeAllComments();
					view.pdf2CommentList.removeAllComments();
					
					view.page1.sourceByteArray = value;
					compareMode = true;
					view.compareViewTools.visible = true;
					view.pageNavTools.visible = true;
				}
			} 
		}
		
		public function addAllEventListener():void
		{
			view.page1.addEventListener(SWFPage.PAGE_LOAD_COMPLETE, pageLoadCompleteHandler,false,0,true);
			view.page2.addEventListener(SWFPage.PAGE_LOAD_COMPLETE, pageLoadCompleteHandler,false,0,true);
			view.page2.addEventListener(SWFPage.SHAPE_DESELECT, shapeDeselectHandler,false,0,true);
			view.page2Layout.addEventListener(ResizeEvent.RESIZE, pageLayoutResizeHandler,false,0,true);
			
			view.pdf1Btn.addEventListener(MouseEvent.CLICK, pageViewClickHandler,false,0,true);
			view.pdf2Btn.addEventListener(MouseEvent.CLICK, pageViewClickHandler,false,0,true);
			
			view.pdf1CommentListBtn.addEventListener(MouseEvent.CLICK, commentListBtnClickHandler,false,0,true);
			view.pdf2CommentListBtn.addEventListener(MouseEvent.CLICK, commentListBtnClickHandler,false,0,true);
			
			view.page1.addEventListener(SWFPage.SCALE_PROPERTY_CHANGE, scalePropertyChangeHandler,false,0,true);
			view.page2.addEventListener(SWFPage.SCALE_PROPERTY_CHANGE, scalePropertyChangeHandler,false,0,true);
			view.comparedImage.addEventListener(ComparedPage.SCALE_PROPERTY_CHANGE, scalePropertyChangeHandler,false,0,true);
			
			view.page1.addEventListener(SWFPage.POSITION_PROPERTY_CHANGE, positionPropertyChangeHandler,false,0,true);
			view.page2.addEventListener(SWFPage.POSITION_PROPERTY_CHANGE, positionPropertyChangeHandler,false,0,true);
			
			view.page1.addEventListener(CommentCollectionEvent.COMMENT_COLLECTION_UPDATE, commentCollectionChangeHandler,false,0,true);
			view.page2.addEventListener(CommentCollectionEvent.COMMENT_COLLECTION_UPDATE, commentCollectionChangeHandler,false,0,true);
			
			view.lineBtn.addEventListener(MouseEvent.CLICK, shapeSelectHandler,false,0,true);
			view.rectBtn.addEventListener(MouseEvent.CLICK, shapeSelectHandler,false,0,true);
			view.ellipseBtn.addEventListener(MouseEvent.CLICK, shapeSelectHandler,false,0,true);
			view.pathBtn.addEventListener(MouseEvent.CLICK, shapeSelectHandler,false,0,true);
			view.normalNoteBtn.addEventListener(MouseEvent.CLICK, shapeSelectHandler,false,0,true);
			
			view.doubleSingleViewBtn.addEventListener(MouseEvent.CLICK, doubleSingleViewHandler,false,0,true);
			view.playPauseBtn.addEventListener(MouseEvent.CLICK, playPauseClickHandler,false,0,true);
			pdfToggleTimer.addEventListener(TimerEvent.TIMER, pdfToggleTimeHandler,false,0,true);
			
			view.commentListDisplayToggleBtn.addEventListener(MouseEvent.CLICK, commentListToggleBtnClickHandler,false,0,true);
			view.notesOnOffBtn.addEventListener(MouseEvent.CLICK, commentOnOffBtnClickHandler,false,0,true);
			view.notesExpandCollapseBtn.addEventListener(MouseEvent.CLICK, commentExpandCollapseBtnClickHandler,false,0,true);
			
			view.helpBtn.addEventListener(MouseEvent.MOUSE_OVER, helpBtnMouseActionHandler,false,0,true);
			view.helpBtn.addEventListener(MouseEvent.MOUSE_OUT, helpBtnMouseActionHandler,false,0,true);
			
			view.regionPointerSelectToggleBtn.addEventListener(MouseEvent.CLICK, regionPointerSelectHandler,false,0,true);
			view.compareBtn.addEventListener(MouseEvent.CLICK, compareImageHandler,false,0,true);
			
			view.page1Slider.addEventListener(Event.CHANGE, pagesAlphaSliderChangeHandler,false,0,true);
			view.page2Slider.addEventListener(Event.CHANGE, pagesAlphaSliderChangeHandler,false,0,true);
			view.compareImageSlider.addEventListener(Event.CHANGE, pagesAlphaSliderChangeHandler,false,0,true);
			
			view.pageListDG.addEventListener(IndexChangeEvent.CHANGE, pageListChangeHandler);
			view.backBtn.addEventListener(MouseEvent.CLICK, pageBackBtnClickHandler);
			
			//view.file1Btn.addEventListener(MouseEvent.CLICK, fileClickHandler);
			//view.file2Btn.addEventListener(MouseEvent.CLICK, fileClickHandler);
			
		}
		
		private function loadPages(pageAC:ArrayCollection):void
		{
			view.pageListGrp.visible = true;
			view.backBtn.visible = true;
			if(pageAC!=null)
			{
				if(pageAC.length>1){
					view.pageListGrp.visible = true;
					view.backBtn.visible = true;
					view.pageListDG.dataProvider = pageAC;
					var colWidth:Number = ((pageAC.length > 2 && pageAC.length<5)?view.pageListDG.width/2:view.pageListDG.width/3)
					var rowHeight:Number = ((pageAC.length == 2)?view.pageListDG.height:view.pageListDG.height/2);
					view.pageTileLayout.columnWidth = colWidth - 80;
					view.pageTileLayout.rowHeight = rowHeight - 20;
					/*var colWidth:Number = ((pageAC.length > 2 && pageAC.length<5)?2:3)
					var rowHeight:Number = ((pageAC.length == 2)?1:2);
					view.pageTileLayout.requestedColumnCount = colWidth;
					view.pageTileLayout.requestedRowCount = rowHeight;*/
				}/*else{
				view.pageListGrp.visible = false;
				view.backBtn.visible = false;
				}*/
			}
		}
		
		/**
		 * Remove any listeners we've created.
		 */
		
		private function removeAllEventListener():void
		{
			view.page1.removeEventListener(SWFPage.PAGE_LOAD_COMPLETE, pageLoadCompleteHandler);
			view.page2.removeEventListener(SWFPage.PAGE_LOAD_COMPLETE, pageLoadCompleteHandler);
			view.page2.removeEventListener(SWFPage.SHAPE_DESELECT, shapeDeselectHandler);
			view.page2Layout.removeEventListener(ResizeEvent.RESIZE, pageLayoutResizeHandler);
			
			view.pdf1Btn.removeEventListener(MouseEvent.CLICK, pageViewClickHandler);
			view.pdf2Btn.removeEventListener(MouseEvent.CLICK, pageViewClickHandler);
			
			view.pdf1CommentListBtn.removeEventListener(MouseEvent.CLICK, commentListBtnClickHandler);
			view.pdf2CommentListBtn.removeEventListener(MouseEvent.CLICK, commentListBtnClickHandler);
			
			view.page1.removeEventListener(SWFPage.SCALE_PROPERTY_CHANGE, scalePropertyChangeHandler);
			view.page2.removeEventListener(SWFPage.SCALE_PROPERTY_CHANGE, scalePropertyChangeHandler);
			view.comparedImage.removeEventListener(ComparedPage.SCALE_PROPERTY_CHANGE, scalePropertyChangeHandler);
			
			view.page1.removeEventListener(SWFPage.POSITION_PROPERTY_CHANGE, positionPropertyChangeHandler);
			view.page2.removeEventListener(SWFPage.POSITION_PROPERTY_CHANGE, positionPropertyChangeHandler);
			
			view.page1.removeEventListener(CommentCollectionEvent.COMMENT_COLLECTION_UPDATE, commentCollectionChangeHandler);
			view.page2.removeEventListener(CommentCollectionEvent.COMMENT_COLLECTION_UPDATE, commentCollectionChangeHandler);
			
			view.lineBtn.removeEventListener(MouseEvent.CLICK, shapeSelectHandler);
			view.rectBtn.removeEventListener(MouseEvent.CLICK, shapeSelectHandler);
			view.ellipseBtn.removeEventListener(MouseEvent.CLICK, shapeSelectHandler);
			view.pathBtn.removeEventListener(MouseEvent.CLICK, shapeSelectHandler);
			view.normalNoteBtn.removeEventListener(MouseEvent.CLICK, shapeSelectHandler);
			
			view.doubleSingleViewBtn.removeEventListener(MouseEvent.CLICK, doubleSingleViewHandler);
			view.playPauseBtn.removeEventListener(MouseEvent.CLICK, playPauseClickHandler);
			pdfToggleTimer.removeEventListener(TimerEvent.TIMER, pdfToggleTimeHandler);
			
			view.commentListDisplayToggleBtn.removeEventListener(MouseEvent.CLICK, commentListToggleBtnClickHandler);
			view.notesOnOffBtn.removeEventListener(MouseEvent.CLICK, commentOnOffBtnClickHandler);
			view.notesExpandCollapseBtn.removeEventListener(MouseEvent.CLICK, commentExpandCollapseBtnClickHandler);
			
			view.helpBtn.removeEventListener(MouseEvent.MOUSE_OVER, helpBtnMouseActionHandler);
			view.helpBtn.removeEventListener(MouseEvent.MOUSE_OUT, helpBtnMouseActionHandler);
			
			view.regionPointerSelectToggleBtn.removeEventListener(MouseEvent.CLICK, regionPointerSelectHandler);
			view.compareBtn.removeEventListener(MouseEvent.CLICK, compareImageHandler);
			
			view.page1Slider.removeEventListener(Event.CHANGE, pagesAlphaSliderChangeHandler);
			view.page2Slider.removeEventListener(Event.CHANGE, pagesAlphaSliderChangeHandler);
			view.compareImageSlider.removeEventListener(Event.CHANGE, pagesAlphaSliderChangeHandler);
			
			view.pageListDG.removeEventListener(IndexChangeEvent.CHANGE, pageListChangeHandler);
			view.backBtn.removeEventListener(MouseEvent.CLICK, pageBackBtnClickHandler);
		}
		
		protected function getFileData():void
		{
			if(currentInstance.mapConfig.firstCollection.length>0){
				isCompareModeFileAvailable = false;
				
				var pdfFileAC:ArrayCollection = new ArrayCollection();
				var tempFirstFileCollection:ArrayCollection = new ArrayCollection();
				tempFirstFileCollection = currentInstance.mapConfig.firstCollection;
				
				var tempSecondFileCollection:ArrayCollection = new ArrayCollection();
				tempSecondFileCollection = currentInstance.mapConfig.secondCollection;
				
				for each(var item:FileDetails in tempFirstFileCollection ) {
					//"_thumb.swf";
					var fPath:String = String(item.filePath);
					item.thumbnailPath = fPath.substring(0,fPath.length-4)+"_thumb.swf"; 
					pdfFileAC.addItem(item);
				}
				
				loadPages(pdfFileAC);
				view.pageListGrp.visible = ( pdfFileAC.length > 1 );
				view.backBtn.visible = ( pdfFileAC.length > 1 );
				//loadFiles((pdfFileAC.getItemAt(0)as FileDetails).fileId);
				currentTaskSWFPath = (pdfFileAC.getItemAt(0)as FileDetails).filePath;
				currentVersionFileID = (pdfFileAC.getItemAt(0)as FileDetails).fileId;
				
				if(tempSecondFileCollection.length!=0)
				{
					isCompareModeFileAvailable = true;
					previousVersionFileID = (tempSecondFileCollection.getItemAt(0)as FileDetails).fileId;
					previousTaskSWFPath = (tempSecondFileCollection.getItemAt(0)as FileDetails).filePath;
				}
				
				( pdfFileAC.length == 1 || (tempSecondFileCollection.length!=0))? controlSignal.downloadFileSignal.dispatch(this, currentTaskSWFPath, currentVersionFileID):"";
			}
		}
		
		protected function fileClickHandler(event:MouseEvent):void
		{ 
		}
		
		
		protected function loadFiles(file1ID:int, file2ID:int = -1):void
		{
			isCompareModeFileAvailable = (file2ID != -1)
			
			currentVersionFileID = file1ID;
			previousVersionFileID = file2ID;
			
			controlSignal.getProjectFilesSignal.dispatch(this,currentVersionFileID);
		}
		
		protected function resetWork():void
		{
			view.page1Layout.visible = false;
			view.page2Layout.visible = false;
			
			view.page1.visible = true;
			view.page2.visible = true; 
			
			view.drawContainer.visible = true;
			view.comparePageAdjusmentTools.visible = false;
			
			this.visible = true;
			compareView = false;
			
			
			view.page1.scaleX = 1
			view.page1.scaleY = 1
			
			view.page2.scaleX = 1
			view.page2.scaleY = 1
			
			view.page1.alpha = 1;
			view.page2.alpha = 1;
			
			view.comparedImage.scaleX = 1
			view.comparedImage.scaleY = 1
			
			view.page1.rotation = 0;
			view.page2.rotation = 0;
			view.comparedImage.rotation = 0;
			
			view.page1Slider.value = 1;
			view.page2Slider.value = 1;
			view.compareImageSlider.value = 1;
			
			shapeSelect = ShapeComponentFXG.NONE;
			shapeBtnsDeselect();
			
			regionPointerVisible = false;
			
			view.page2.movePage();
			
			if(compareMode){
				if(page1XBindWatcher == null || !page1XBindWatcher.isWatching()) 
					page1XBindWatcher = BindingUtils.bindProperty(view.page1, "pageX", view.page2, "pageX");
				if(page1YBindWatcher == null || !page1YBindWatcher.isWatching()) 
					page1YBindWatcher = BindingUtils.bindProperty(view.page1, "pageY", view.page2, "pageY");
				
				if(page2XBindWatcher == null || !page2XBindWatcher.isWatching()) 
					page2XBindWatcher = BindingUtils.bindProperty(view.page2, "pageX", view.page1, "pageX");
				if(page2YBindWatcher == null || !page2YBindWatcher.isWatching()) 
					page2YBindWatcher = BindingUtils.bindProperty(view.page2, "pageY", view.page1, "pageY");
				
				if(compareImageXBindWatcher == null || !compareImageXBindWatcher.isWatching()) 
					compareImageXBindWatcher = BindingUtils.bindProperty(view.page2, "pageX", view.comparedImage, "pageX");
				if(compareImageYBindWatcher == null || !compareImageYBindWatcher.isWatching()) 
					compareImageYBindWatcher = BindingUtils.bindProperty(view.page2, "pageY", view.comparedImage, "pageY");
			}else
			{
				if(page1XBindWatcher != null && page1XBindWatcher.isWatching()) 
					page1XBindWatcher.unwatch();
				if(page1YBindWatcher != null && page1YBindWatcher.isWatching()) 
					page1YBindWatcher.unwatch();
				
				if(page2XBindWatcher != null && page2XBindWatcher.isWatching()) 
					page2XBindWatcher.unwatch()
				if(page2YBindWatcher != null && page2YBindWatcher.isWatching()) 
					page2YBindWatcher.unwatch();
				
				if(compareImageXBindWatcher != null && compareImageXBindWatcher.isWatching()) 
					compareImageXBindWatcher.unwatch();
				if(compareImageYBindWatcher != null && compareImageYBindWatcher.isWatching()) 
					compareImageYBindWatcher.unwatch();
			}
			
			doublePageView = true;
			doublePageViewToggle();
			
			if(view.page2.pageLoadStatus)
				view.page2.alignPage();
		}
		
		protected function commentCollectionUpdate(page:SWFPage):void
		{
			var CommentGroup:Group = (page == view.page2)?view.page2CommentBoxGroup:view.page1CommentBoxGroup;
			var commentList:CommentList = (page == view.page2)?view.pdf2CommentList:view.pdf1CommentList;
			var historyAC:ArrayCollection = new ArrayCollection();
			
			var dataSortField:SortField = new SortField();
			dataSortField.name = "commentID";
			dataSortField.numeric = true;
			
			var numericDataSort:Sort = new Sort();
			numericDataSort.fields = [dataSortField];
			
			pdfCommentListAC.sort = numericDataSort;
			pdfCommentListAC.refresh();
			
			for(var commentCounter:int = 0;commentCounter<pdfCommentListAC.length;commentCounter++)
			{
				var commentVO:CommentVO = CommentVO(pdfCommentListAC.getItemAt(commentCounter)); 
				if(commentVO.history == 0){
					var commentBox:CommentBox = new CommentBox();
					commentBox.commentVO = commentVO;
					commentBox.historyCollection.addItem(commentVO);
					commentBox.x = commentVO.commentBoxX;
					commentBox.y = commentVO.commentBoxY;
					var desc:String =  String(commentVO.commentDescription).split(CommentBox.SHAPE_FIRST_NOTE_SPLITTER)[0];
					var commentName:String = page.shapeCommentContainer.textToString(desc);
					commentBox.title = commentVO.commentTitle;
					commentBox.description = String(commentVO.commentDescription).split(CommentBox.SHAPE_FIRST_NOTE_SPLITTER)[1];
					commentBox.commentItemName = commentName;
					commentBox.currentPersonID = Persons(currentInstance.mapConfig.currentPerson).personId
					//commentBox.sealed = (page == view.page2);
					commentBox.sealed = true;
					commentBox.addEventListener(CommentBox.COMMENT_BOX_MOVE, commentBoxMoveHandler,false,0,true);
					commentBox.addEventListener(CommentBox.COMMENT_CANCEL, commentChangesHandler,false,0,true);
					commentBox.addEventListener(CommentBox.COMMENT_REMOVE, commentChangesHandler,false,0,true);
					commentBox.addEventListener(CommentBox.COMMENT_ADD, commentChangesHandler,false,0,true);
					commentBox.addEventListener(CommentBox.COMMENT_UPDATE, commentChangesHandler,false,0,true);
					CommentGroup.addElement(commentBox);
					var commentListItem:CommentBox = new CommentBox();
					commentListItem.isInCommentList = true;
					commentListItem.commentVO = commentVO;
					commentListItem.historyCollection.addItem(commentVO);
					commentListItem.commentItemName = commentName;
					commentListItem.currentPersonID = Persons(currentInstance.mapConfig.currentPerson).personId
					//commentListItem.sealed = (page == view.page2);
					commentListItem.sealed = true;
					commentListItem.title = commentVO.commentTitle;
					commentListItem.description = String(commentVO.commentDescription).split(CommentBox.SHAPE_FIRST_NOTE_SPLITTER)[1];
					commentListItem.addEventListener(CommentBox.COMMENT_REMOVE, commentChangesHandler,false,0,true);
					commentListItem.addEventListener(CommentBox.COMMENT_ADD, commentChangesHandler,false,0,true);
					commentListItem.addEventListener(CommentBox.COMMENT_UPDATE, commentChangesHandler,false,0,true);
					commentList.addComment(commentListItem);
				}
				else
				{
					historyAC.addItem(commentVO);
				}
			}
			historyUpdate(historyAC, CommentGroup, commentList);
			linkFunction(CommentGroup);
			
			if(previousVersionPDFCommentListFetch){
				// getPDFCommentsSignal Error
				controlSignal.getPDFCommentsSignal.dispatch(this,previousVersionFileID);
				previousVersionPDFCommentListFetch = false;
			}
		} 
		
		protected function collectionAddUpdateRemove(collAC:ArrayCollection):void
		{
			/*
			var dataSortField:SortField = new SortField();
			dataSortField.name = "data";
			dataSortField.numeric = true;
			
			var numericDataSort:Sort = new Sort();
			numericDataSort.fields = [dataSortField];
			
			*/
			view.page1CommentBoxGroup.removeAllElements();
			view.page1CommentBoxGroup.graphics.clear();
			view.pdf1CommentList.removeAllComments();
			view.page1.removeAllComments();
			view.page2CommentBoxGroup.removeAllElements();
			view.page2CommentBoxGroup.graphics.clear();
			view.pdf2CommentList.removeAllComments();
			view.page2.removeAllComments();
			var historyAC:ArrayCollection = new ArrayCollection();
			for(var commentCounter:int = 0;commentCounter<collAC.length;commentCounter++)
			{
				var commentVO:CommentVO = CommentVO(collAC.getItemAt(commentCounter));
				if(commentVO.history == 0)
				{
					var commentBox:CommentBox = new CommentBox();
					commentBox.commentVO = commentVO;
					commentBox.x = commentVO.commentBoxX;
					commentBox.y = commentVO.commentBoxY;
					var desc:String =  String(commentVO.commentDescription).split(CommentBox.SHAPE_FIRST_NOTE_SPLITTER)[0];
					var commentName:String = ""; 
					if(commentVO.filefk == currentVersionFileID)
						commentName = view.page2.shapeCommentContainer.textToString(desc);
					else
						commentName = view.page1.shapeCommentContainer.textToString(desc);
					commentBox.commentItemName = commentName;
					commentBox.sealed = true;
					commentBox.currentPersonID = Persons(currentInstance.mapConfig.currentPerson).personId
					commentBox.addEventListener(CommentBox.COMMENT_BOX_MOVE, commentBoxMoveHandler,false,0,true);
					commentBox.addEventListener(CommentBox.COMMENT_CANCEL, commentChangesHandler,false,0,true);
					commentBox.addEventListener(CommentBox.COMMENT_REMOVE, commentChangesHandler,false,0,true);
					commentBox.addEventListener(CommentBox.COMMENT_ADD, commentChangesHandler,false,0,true);
					commentBox.addEventListener(CommentBox.COMMENT_UPDATE, commentChangesHandler,false,0,true);
					if(commentVO.filefk == currentVersionFileID)
						view.page2CommentBoxGroup.addElement(commentBox);
					else
						view.page1CommentBoxGroup.addElement(commentBox);
					commentBox.updateLastEntry(commentVO, "add");
					var commentListItem:CommentBox = new CommentBox();
					commentListItem.isInCommentList = true;
					commentListItem.commentVO = commentVO;
					commentListItem.commentItemName = commentName;
					commentListItem.currentPersonID = Persons(currentInstance.mapConfig.currentPerson).personId
					commentListItem.sealed = true;
					commentListItem.addEventListener(CommentBox.COMMENT_REMOVE, commentChangesHandler,false,0,true);
					commentListItem.addEventListener(CommentBox.COMMENT_ADD, commentChangesHandler,false,0,true);
					commentListItem.addEventListener(CommentBox.COMMENT_UPDATE, commentChangesHandler,false,0,true);
					if(commentVO.filefk == currentVersionFileID)
						view.pdf2CommentList.addComment(commentListItem);
					else
						view.pdf1CommentList.addComment(commentListItem);
					commentListItem.updateLastEntry(commentVO, "add");
				}
				else
				{
					historyAC.addItem(commentVO);
				}
			}
			historyUpdate(historyAC, view.page2CommentBoxGroup, view.pdf2CommentList);
			historyUpdate(historyAC, view.page1CommentBoxGroup, view.pdf1CommentList);
			linkFunction(view.page2CommentBoxGroup);
			linkFunction(view.page1CommentBoxGroup);
		}
		
		protected function historyUpdate(historyAC:ArrayCollection, commentGroup:Group, commentList:CommentList):void
		{
			for(var itemCounter:int = 0;itemCounter<historyAC.length;itemCounter++)
			{
				for(var commentCounter:int = 0;commentCounter<commentGroup.numElements;commentCounter++)
				{
					if(CommentVO(historyAC.getItemAt(itemCounter)).history == CommentBox(commentGroup.getElementAt(commentCounter)).commentVO.commentID)
					{
						CommentBox(commentGroup.getElementAt(commentCounter)).updateLastEntry(CommentVO(historyAC.getItemAt(itemCounter)),"add");
					}
				}
			}
			commentList.updateHistory(historyAC);
		}
		
		protected function helpBtnMouseActionHandler(event:MouseEvent):void
		{
			if(event.type == MouseEvent.MOUSE_OVER)
			{
				view.helpTipsContainer.visible = true; 
			}
			if(event.type == MouseEvent.MOUSE_OUT)
			{
				view.helpTipsContainer.visible = false; 
			}
		}
		
		protected function pagesAlphaSliderChangeHandler(event:Event):void
		{
			if(event.currentTarget == view.page1Slider)
			{
				view.page1.alpha = view.page1Slider.value;
			}
			else if(event.currentTarget == view.page2Slider)
			{
				view.page2.alpha = view.page2Slider.value;	
			}
			else if(event.currentTarget == view.compareImageSlider)
			{
				view.comparedImage.alpha = view.compareImageSlider.value;	
			}
		}
		
		protected function positionPropertyChangeHandler(event:Event):void
		{
			if(event.currentTarget == view.page1){
				linkFunction(view.page1CommentBoxGroup);
			}
			if(event.currentTarget == view.page2){
				linkFunction(view.page2CommentBoxGroup);
			}
		}
		
		protected function scalePropertyChangeHandler(event:Event):void
		{
			if(compareMode){
				if(event.currentTarget == view.page2){
					view.page2.pageX = event.currentTarget.x;
					view.page2.pageY = event.currentTarget.y;
					view.page1.scaleX = event.currentTarget.scaleX;
					view.page1.scaleY = event.currentTarget.scaleY;
					view.comparedImage.scaleX = event.currentTarget.scaleX;
					view.comparedImage.scaleY = event.currentTarget.scaleY;
					view.comparedImage.rotation = event.currentTarget.rotation;
				}
				if(event.currentTarget == view.page1){
					view.page2.scaleX = event.currentTarget.scaleX;
					view.page2.scaleY = event.currentTarget.scaleY;
					view.page1.pageX = event.currentTarget.x;
					view.page1.pageY = event.currentTarget.y;
					view.comparedImage.scaleX = event.currentTarget.scaleX;
					view.comparedImage.scaleY = event.currentTarget.scaleY;
					view.comparedImage.rotation = event.currentTarget.rotation;
				}
				if(event.currentTarget == view.comparedImage){
					view.comparedImage.pageX = event.currentTarget.x;
					view.comparedImage.pageY = event.currentTarget.y;
					view.page2.scaleX = event.currentTarget.scaleX;
					view.page2.scaleY = event.currentTarget.scaleY;
					view.page2.rotation = event.currentTarget.rotation;
					view.page1.scaleX = event.currentTarget.scaleX;
					view.page1.scaleY = event.currentTarget.scaleY;
					view.page1.rotation = event.currentTarget.rotation;
				}
			}
			linkFunction(view.page1CommentBoxGroup);
			linkFunction(view.page2CommentBoxGroup);
		}
		
		protected function doubleSingleViewStatusBindSetter(value:Boolean):void
		{
			view.pdf1Btn.enabled = !doublePageView;
			view.pdf2Btn.enabled = !doublePageView;
		}
		
		protected function regionPointerToggleBtnVisibleBindSetter(value:Boolean):void
		{
			view.regionPointerSelectToggleBtn.visible = !value;
		}
		
		protected function doubleSingleViewHandler(event:MouseEvent):void
		{
			doublePageViewToggle();
		}
		
		protected function doublePageViewToggle():void
		{
			if(doublePageView)
			{
				view.page1Layout.visible = false;
				view.page2Layout.visible = true;
				view.page1Layout.percentWidth = 100;
				view.page2Layout.percentWidth = 100;
				view.compareLayout.percentWidth = 100;
				regionPointerVisible = false;
			}
			else
			{
				view.page1Layout.visible = true;
				view.page2Layout.visible = true;
				view.page1Layout.percentWidth = 50;
				view.page2Layout.percentWidth = 50;
				view.compareLayout.percentWidth = 50;
				if(compareView)
				{
					compareViewToggle();
				}
			}
			doublePageView = !doublePageView;
			
		}
		
		protected function commentListToggleBtnClickHandler(event:MouseEvent):void
		{
			if(event.currentTarget.selected)
			{
				view.commentListContainer.width = 35;
			}else
			{
				view.commentListContainer.width = 270;
			}
		}
		
		protected function commentOnOffBtnClickHandler(event:MouseEvent):void
		{
			view.page1CommentBoxGroup.visible = event.currentTarget.selected;
			view.page2CommentBoxGroup.visible = event.currentTarget.selected;	
		}
		
		protected function commentExpandCollapseBtnClickHandler(event:MouseEvent):void
		{
			var i:int;
			for(i = 0;i<view.page1CommentBoxGroup.numElements;i++)
			{
				(view.page1CommentBoxGroup.getElementAt(i) as CommentBox).expandCollapse(event);
			}
			for(i = 0;i<view.page2CommentBoxGroup.numElements;i++)
			{
				(view.page2CommentBoxGroup.getElementAt(i) as CommentBox).expandCollapse(event);
			}
		}
		
		protected function playPauseClickHandler(event:MouseEvent):void
		{
			if(doublePageView){
				doublePageViewToggle();
			}
			if(event.currentTarget.selected)
			{
				pdfToggleTimer.start();
				isPDFToggle = true;
				firstPDFSelect = false;
			}else
			{
				pdfToggleTimer.stop();
				isPDFToggle = false; 
			}
		}
		
		protected function pdfToggleTimeHandler(event:TimerEvent):void{
			firstPDFSelect = !firstPDFSelect;
			if(firstPDFSelect)
			{
				view.pdf1Btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				linkFunction(view.page1CommentBoxGroup);
			}
			else
			{
				view.pdf2Btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));	
				linkFunction(view.page2CommentBoxGroup);
			}
		}
		
		protected function commentCollectionChangeHandler(event:CommentCollectionEvent):void
		{
			commentBox = new CommentBox();
			commentBox.isNewComment = true;
			(event.currentTarget == view.page2)?view.page2CommentBoxGroup.addElement(commentBox):view.page1CommentBoxGroup.addElement(commentBox);
			commentBox.x = Math.random() * (view.page2CommentBoxGroup.width/2)+50;
			commentBox.y = Math.random() * (view.page2CommentBoxGroup.height/2)+50;
			commentBox.commentVO = event.commentVO;
			commentBox.commentVO.createdby = Persons(currentInstance.mapConfig.currentPerson).personId;
			commentBox.commentVO.creationDate = new Date();
			commentBox.commentItemName = event.commentItemName;
			commentBox.commentVO.commentBoxX = commentBox.x;
			commentBox.commentVO.commentBoxY = commentBox.y;
			commentBox.updateLastEntry(commentBox.commentVO, "add");
			commentBox.addEventListener(CommentBox.COMMENT_BOX_MOVE, commentBoxMoveHandler,false,0,true);
			commentBox.addEventListener(CommentBox.COMMENT_CANCEL, commentChangesHandler,false,0,true);
			commentBox.addEventListener(CommentBox.COMMENT_ADD, commentChangesHandler,false,0,true);
			commentBox.addEventListener(CommentBox.COMMENT_UPDATE, commentChangesHandler,false,0,true);
			commentBox.addEventListener(CommentBox.COMMENT_REMOVE, commentChangesHandler,false,0,true);
			linkFunction(view.page1CommentBoxGroup);
			linkFunction(view.page2CommentBoxGroup);
		}
		
		protected function commentBoxMoveHandler(event:Event):void
		{
			(event.currentTarget as CommentBox).commentVO.commentBoxX = event.currentTarget.x;
			(event.currentTarget as CommentBox).commentVO.commentBoxY = event.currentTarget.y;
			linkFunction(event.currentTarget.parent);
		}
		
		// Comment Box ADD, Remove, Update functionality
		protected function commentChangesHandler(event:Event):void
		{
			var commentGroup:Group = event.currentTarget.parent;
			var page:SWFPage = (commentGroup == view.page2CommentBoxGroup)?view.page2:view.page1;
			var comVO:CommentVO;
			if(event.type == CommentBox.COMMENT_ADD)
			{
				comVO =  new CommentVO();
				comVO = (event.currentTarget as CommentBox).chatCommentVO;
				comVO.filefk = ((page == view.page2)?currentVersionFileID:previousVersionFileID);
				comVO.createdby = Persons(currentInstance.mapConfig.currentPerson).personId;
				comVO.creationDate = new Date();
				// createCommentSignal Error
				controlSignal.createCommentSignal.dispatch( this, comVO );
			}
			if(event.type == CommentBox.COMMENT_UPDATE)
			{
				comVO =  new CommentVO();
				comVO = (event.currentTarget as CommentBox).chatCommentVO;
				// updateCommentSignal Error
				controlSignal.updateCommentSignal.dispatch( this, comVO );
			}
			if(event.type == CommentBox.COMMENT_CANCEL)
			{
				removeCommentFromListAndGroup((event.currentTarget as CommentBox).commentItemName, page);
			}
			else if(event.type == CommentBox.COMMENT_REMOVE)
			{
				comVO =  new CommentVO();
				comVO = (event.currentTarget as CommentBox).chatCommentVO;
				// deleteCommentSignal Error
				controlSignal.deleteCommentSignal.dispatch( this, comVO );
			}
			linkFunction(view.page1CommentBoxGroup);
			linkFunction(view.page2CommentBoxGroup);
		}
		
		private function linkFunction(commentGroup:Group):void
		{
			commentGroup.graphics.clear()
			commentGroup.graphics.lineStyle(1,0xFF0000);
			commentGroup.graphics.beginFill(0xFF0000,0.5);
			var page:SWFPage = (commentGroup == view.page2CommentBoxGroup)?view.page2:view.page1;
			for(var i:int = 0;i<commentGroup.numElements;i++)
			{
				var x1:Number = (commentGroup.getElementAt(i) as CommentBox).x;
				var y1:Number = (commentGroup.getElementAt(i) as CommentBox).y;
				var x2:Number = 0;
				var y2:Number = 0;
				var scaleVal:Number = 1;
				scaleVal = page.scaleX;
				if(Math.round(page.rotation) == 0 || Math.round(page.rotation) == -180 || Math.round(page.rotation) == 180)
				{
					scaleVal = ((Math.round(page.rotation) == -180 || Math.round(page.rotation) == 180)?-1:1)*scaleVal;
					x2 = page.x + ((commentGroup.getElementAt(i) as CommentBox).commentVO.commentX*scaleVal);
					y2 = page.y + ((commentGroup.getElementAt(i) as CommentBox).commentVO.commentY*scaleVal);
				}
				else
				{
					x2 = page.x + ((commentGroup.getElementAt(i) as CommentBox).commentVO.commentY * (((Math.round(page.rotation) == 90)?-1:1))*scaleVal);
					y2 = page.y + ((commentGroup.getElementAt(i) as CommentBox).commentVO.commentX * (((Math.round(page.rotation) == -90)?-1:1))*scaleVal);
				}
				commentGroup.graphics.moveTo(x1,y1);
				commentGroup.graphics.lineTo(x2,y2);
				commentGroup.graphics.drawCircle(x2, y2, 5);
			}
		}
		
		private function removeCommentFromListAndGroup(commentItemName:String, page:SWFPage ,isRemove:Boolean = false):void
		{
			page.removeComment(commentItemName);
			var pageGroup:Group = (page == view.page2)?view.page2CommentBoxGroup:view.page1CommentBoxGroup;
			for(var i:int = 0;i<pageGroup.numElements;i++){
				if((pageGroup.getElementAt(i) as CommentBox).commentItemName == commentItemName)
				{
					pageGroup.removeElement(pageGroup.getElementAt(i));
					break;
				}
			}
			/*if(isRemove)
			{
			view.pdf2CommentList.removeComment(commentItemName);
			}*/
		}
		
		protected function shapeDeselectHandler(event:Event):void
		{
			shapeSelect = ShapeComponentFXG.NONE;
			shapeBtnsDeselect();
		}
		
		protected function shapeBtnsDeselect():void
		{
			view.normalNoteBtn.selected = false;
			view.lineBtn.selected = false;
			view.rectBtn.selected = false;
			view.ellipseBtn.selected = false;
			view.pathBtn.selected = false;
		}
		
		protected function SliderTooltip(val : String) : String
		{
			return String('Alpha : ' + Math.round(Number(val) * 100) + '%');
		}
		
		protected function shapeSelectHandler(event:MouseEvent):void
		{
			if(event.currentTarget.selected){
				shapeBtnsDeselect()
				event.currentTarget.selected = true;
				switch(event.currentTarget){
					case view.lineBtn :
						shapeSelect =  ShapeComponentFXG.LINE;
						break;
					case view.rectBtn :
						shapeSelect =  ShapeComponentFXG.RECT;
						break;
					case view.ellipseBtn :
						shapeSelect =  ShapeComponentFXG.ELLIPSE;
						break;
					case view.pathBtn :
						shapeSelect =  ShapeComponentFXG.PATH;
						break;
					case view.normalNoteBtn :
						shapeSelect =  ShapeComponentFXG.NORMAL_RECT;
						break;
					
				}
			}
			else{
				shapeSelect =  ShapeComponentFXG.NONE;
			}
		}
		
		protected function pageLoadCompleteHandler(event:Event):void
		{
			if(compareMode){
				if(view.page1.pageLoadStatus && view.page2.pageLoadStatus)
				{
					imgWidth = (view.page1.imgWidth > view.page2.imgWidth)?view.page1.imgWidth:view.page2.imgWidth
					imgHeight = (view.page1.imgHeight > view.page2.imgHeight)?view.page1.imgHeight:view.page2.imgHeight
					view.page1.pageWidth = imgWidth
					view.page2.pageWidth = imgWidth
					view.page1.pageHeight = imgHeight
					view.page2.pageHeight = imgHeight
					pageAlign();
				}
			}
			else
			{
				imgWidth = view.page2.imgWidth;
				imgHeight = view.page2.imgHeight;
				view.page2.pageWidth = imgWidth
				view.page2.pageHeight = imgHeight
				pageAlign();
			}
			
			resetWork();
		}
		
		protected function pageLayoutResizeHandler(event:ResizeEvent):void
		{
			pageAlign();
		}
		
		protected function pageViewClickHandler(event:MouseEvent):void
		{
			if(event.currentTarget == view.pdf1Btn){
				view.page1Layout.visible = true;
				view.page2Layout.visible = false;
				pdfCommentListDisplay(true);
			}
			else if(event.currentTarget == view.pdf2Btn){
				view.page1Layout.visible = false;
				view.page2Layout.visible = true;
				pdfCommentListDisplay(false);
			}
		}
		
		protected function commentListBtnClickHandler(event:MouseEvent):void
		{
			event.currentTarget.selected = true;
			var value:Boolean = (event.currentTarget == view.pdf1CommentListBtn);
			(value)?view.pdf1Btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK)):view.pdf2Btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		private function pdfCommentListDisplay(value:Boolean):void
		{
			view.pdf1CommentList.visible = value;
			view.pdf2CommentList.visible = !value;
			view.pdf1CommentListBtn.selected = value;
			view.pdf2CommentListBtn.selected = !value;
			linkFunction(view.page1CommentBoxGroup);
			linkFunction(view.page2CommentBoxGroup);
		}
		
		private function pageAlign():void
		{
			view.page2.alignPage();
			
			linkFunction(view.page1CommentBoxGroup);
			linkFunction(view.page2CommentBoxGroup);
		}
		
		private function pageListChangeHandler(event:IndexChangeEvent):void
		{
			// New Page Load script....!
			if(view.pageListDG.selectedIndex != -1){
				var fileDetail:FileDetails = (view.pageListDG.selectedItem as FileDetails)
				var swfFilePath:String = fileDetail.filePath.toString();
				swfFilePath = Utils.trimFront(swfFilePath);
				swfFilePath = Utils.trimBack(swfFilePath);
				var fileId:int = fileDetail.fileId;
				currentVersionFileID = fileId;
				//var fileReleaseVersion:int = fileDetail.releaseStatus;
				this.visible = false;
				view.pageListDG.selectedIndex = -1;
				// downloadFileSignal Error
				controlSignal.downloadFileSignal.dispatch(this,swfFilePath, fileId);
				view.pageListGrp.visible = false;
			}
		}
		
		private function pageBackBtnClickHandler(event:MouseEvent):void
		{
			view.pageListGrp.visible = true;
		}
		
		protected function regionPointerSelectHandler(event:MouseEvent):void
		{
			if(!doublePageView){
				doublePageViewToggle();
			}
			regionPointerVisible = event.currentTarget.selected;
			if((view.page2Layout.width<(view.page2.width*view.page2.scaleX)) && (view.page2Layout.height<(view.page2.height*view.page2.scaleY)))
			{
				view.page2.regionPointerXPos = Math.abs(view.page2.x/view.page2.scaleX)+((view.page2Layout.width/view.page2.scaleX)/2);
				view.page2.regionPointerYPos = Math.abs(view.page2.y/view.page2.scaleY)+((view.page2Layout.height/view.page2.scaleY)/2);
				view.page1.regionPointerXPos = Math.abs(view.page1.x/view.page1.scaleX)+((view.page1Layout.width/view.page1.scaleX)/2);
				view.page1.regionPointerYPos = Math.abs(view.page1.y/view.page1.scaleY)+((view.page1Layout.height/view.page1.scaleY)/2);
			}else
			{
				view.page2.regionPointerXPos = view.page2.width/2;
				view.page2.regionPointerYPos = view.page2.height/2;
				view.page1.regionPointerXPos = view.page1.width/2;
				view.page1.regionPointerYPos = view.page1.height/2;
			}
		}
		
		protected function compareImageHandler(event:MouseEvent):void
		{
			compareViewToggle();
		}
		protected function compareViewToggle():void
		{
			compareView = !compareView;
			if(compareView)
			{
				view.page1CommentBoxGroup.visible = false;
				view.page2CommentBoxGroup.visible = false;
				view.regionPointerSelectToggleBtn.selected = false;
				if(isPDFToggle)
				{
					isPDFToggle = false;
					pdfToggleTimer.stop();
					view.playPauseBtn.selected = false;
				}
				if(doublePageView){
					doublePageViewToggle();
				}
				view.drawContainer.visible = false;
				view.pageNavTools.visible = false;
				view.comparePageAdjusmentTools.visible = true;
				view.page1Layout.visible = true;
				view.page2Layout.visible = true;
				view.page1.alpha = view.page1Slider.value = 0;
				view.page2.alpha = view.page2Slider.value = 0;
				view.commentListContainer.visible = false;
				view.comparedImage.alpha = view.compareImageSlider.value = 1;
				var img1BitmapData:BitmapData = new BitmapData(imgWidth, imgHeight);
				img1BitmapData.draw(view.page1.pageContent);
				var img2BitmapData:BitmapData = new BitmapData(imgWidth, imgHeight);
				if(view.page1.regionPointerXPos != view.page2.regionPointerXPos || view.page1.regionPointerYPos != view.page2.regionPointerYPos)
				{
					var xVal:Number = view.page1.regionPointerXPos - view.page2.regionPointerXPos;
					var yVal:Number = view.page1.regionPointerYPos - view.page2.regionPointerYPos; 
					var tempBitmapData:BitmapData = regionBitmapData(xVal, yVal);
					img2BitmapData.draw(tempBitmapData);
				}
				else{
					img2BitmapData.draw(view.page2.pageContent);
				}
				if(img1BitmapData.compare(img2BitmapData) != 0)
				{
					view.comparedImage.source = new Bitmap(BitmapData(img1BitmapData.compare(img2BitmapData)));
				}else
				{
					// showAlertSignal Error
					//controlSignal.showAlertSignal.dispatch(null,Utils.COMPARE_NO_DIFFERENCE_MSG,Utils.APPTITLE,1,null);
					view.comparedImage.source = null;
				}
			}else{
				view.drawContainer.visible = true;
				view.pageNavTools.visible = true;
				view.comparePageAdjusmentTools.visible = false;
				view.page1.alpha = 1;
				view.page2.alpha = 1;
				view.comparedImage.alpha = 1;
				view.page1Layout.visible = false;
				view.page2Layout.visible = true;
				view.page1CommentBoxGroup.visible = view.notesOnOffBtn.selected;
				view.page2CommentBoxGroup.visible = view.notesOnOffBtn.selected;
				view.comparedImage.source = null
				view.page2.movePage();
				view.page1.regionPointerXPos = 0;
				view.page1.regionPointerYPos = 0;
				view.page2.regionPointerXPos = 0;
				view.page2.regionPointerYPos = 0;
				view.commentListContainer.visible = true;
			}
		}
		
		public function regionBitmapData(xVal:Number = 0, yVal:Number = 0):BitmapData
		{
			view.page2.movePage(xVal, yVal);
			var regionCompareImgBitmapData:BitmapData = new BitmapData(imgWidth, imgHeight);
			var x1:Number = (xVal > 0)?0:Math.round(Math.abs(xVal));
			var x2:Number = (xVal > 0)?(imgWidth - Math.round(Math.abs(xVal))):imgWidth;
			var y1:Number = (yVal > 0)?0:Math.round(Math.abs(yVal));
			var y2:Number = (yVal > 0)?(imgHeight - Math.round(Math.abs(yVal))):imgHeight;
			var xPos:Number = (xVal > 0)?Math.round(Math.abs(xVal)):Math.round(Math.abs(xVal)) * -1;
			var yPos:Number = (yVal > 0)?Math.round(Math.abs(yVal)):Math.round(Math.abs(yVal)) * -1;
			var content:BitmapData= new BitmapData(imgWidth, imgHeight);
			content.draw(view.page2.pageContent);
			for(var i:Number=x1;i<=x2;i++){
				for(var j:Number=y1;j<=y2;j++){
					regionCompareImgBitmapData.setPixel(i+xPos,j+yPos,content.getPixel(i,j));
				}
			}
			return regionCompareImgBitmapData;
		}
		
		// PDF Tool Logic 
		
	}
}
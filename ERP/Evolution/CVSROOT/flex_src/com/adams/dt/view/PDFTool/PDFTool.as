package com.adams.dt.view.PDFTool
{ 
	import com.adams.dt.business.util.InternalPNGEncoder;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.view.PDFTool.cl.huerta.pdf.PDFi;
	import com.adams.dt.view.PDFTool.events.GotoCommentEvent;
	import com.adams.dt.view.PDFTool.events.ToolBoxEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.DropShadowFilter;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.HSlider;
	import mx.controls.Image;
	import mx.effects.Resize;
	import mx.effects.easing.Circular;
	import mx.events.SliderEvent;
	import mx.graphics.ImageSnapshot;
	
	import org.alivepdf.data.GridColumn;
	import org.alivepdf.layout.Align;

	public class PDFTool extends Canvas
	{
		private var myCanvas:Canvas=new Canvas();
		[Bindable]
		private var model : ModelLocator = ModelLocator.getInstance();
		
		private var preloaderImg:PreloaderImg = new PreloaderImg();
		
		private var masterLayoutHBox:HBox = new HBox();
		private var toolBoxLayoutHBox:HBox = new HBox();
		private var doubleViewBtn:Button = new Button();
		private var togglePDFBtn:Button = new Button();
		private var selectPDFBtn:Button = new Button();
		private var compareBtn:Button = new Button();
		private var noteOnOff:Button = new Button();
		private var regionCompareSelectBtn:Button = new Button();
		private var regionPointerBtn:Button = new Button();
		private var regionResetBtn:Button = new Button();
		private var compareImageAlphaControllerHBox:HBox = new HBox();
		private var firstPDFImg:Image = new Image();
		private var secondPDFImg:Image = new Image();
		private var diffPDFImg:Image = new Image();
		private var rotateClockwiseBtn:Button = new Button();
		private var rotateCounterClockwiseBtn:Button = new Button();
		private var zoomInBtn:Button = new Button();
		private var zoomOutBtn:Button = new Button();
		private var pdfDownloadBtn:Button = new Button();
		/*******/
		
		
			import org.alivepdf.fonts.FontFamily;
			import com.adams.dt.view.PDFTool.cl.huerta.pdf.PDFi;
			import org.alivepdf.images.ImageFormat;
			import org.alivepdf.saving.Method;
			import org.alivepdf.layout.Unit;
			import org.alivepdf.layout.Size;
			import org.alivepdf.layout.Orientation;
			import org.alivepdf.pdf.PDF;
			import flash.filesystem.File;
			private var myPDF:PDFi;
		/ * **/
		
		
		private var firstPDFHSlider:HSlider = new HSlider();
		private var secondPDFHSlider:HSlider = new HSlider();
		private var diffPDFHSlider:HSlider = new HSlider();
		
		public var masterCanvas:MasterContainer = new MasterContainer();
		public var masterCanvas1:MasterContainer = new MasterContainer(); 
		public var toolBox:ToolBox = new ToolBox();
		
		public var commentList:CommentList = new CommentList();
		private var commentListLayoutHBox:HBox = new HBox();
		private var commentListToggleBtn:Button = new Button();
		
		private var sharedObjectForNotes:SharedObject;
		
		private var compareMode:Boolean = false;
		
		[Bindable]
		private var doubleViewStatus:Boolean = false;
		
		[Bindable]
		private var togglePDFStatus:Boolean = false;
		
		[Bindable]
		private var compareStatus:Boolean = false;
		
		[Bindable]
		private var regionCompareStatus:Boolean = false;
		
		[Bindable]
		private var regionResetStatus:Boolean = false;
		
		[Bindable]
		public var miniReaderPropertyStatus:Boolean = false;
		
		public var pdfURL:String;
		
		public static const pdfToolNotesSOName:String = "pdfToolNotesSO";
		
		private var _img1URL:String;
		[Bindable]
		public function set img1URL (value:String):void
		{
			_img1URL = value;
			trace("Path1 : "+value);
			
			if((value.indexOf(".swf")!=-1)){
				compareMode = true;
				masterCanvas.img1URL= value;
				masterCanvas1.img1URL= value;
			}
			else
			{
				masterCanvas.img1URL= "";
				masterCanvas1.img1URL= "";
				compareMode = false;
			}
			// "iN" stands for isNew. This data is used for check whetherthis first time 
			
			resetAll();
			toolVisibleStatus(compareMode);
			//masterCanvas.img1URL= value;
			//masterCanvas1.img1URL= value;
		}

		public function get img1URL ():String
		{
			return _img1URL;
		}
		
		private var pdfName:String="";
		
		private var _img2URL:String;
		[Bindable]
		public function set img2URL (value:String):void
		{
			trace("Path2 : "+value);
			if(value!=""){
				_img2URL = value;
				resetAll();
				//trace("Path2 : "+value+" ::: "+model.currentTasks.taskFilesPath+" :: "+model.currentTasks.previousTask.taskFilesPath);
				pdfName = value;
				preloaderImg.visible = true;
				masterCanvas.externalCanvas.visible = false;
				masterCanvas.singlePage.visible = false;
				masterCanvas1.externalCanvas.visible = false;
				masterCanvas1.singlePage.visible = false;
				masterCanvas.img2URL= value;
				masterCanvas1.img2URL= value; 
				masterCanvas1.singlePage.focusAction = SinglePageCanvas.NONE;
			}
		}
		public function get img2URL ():String
		{
			return _img2URL;
		}
		
		private var _dataProvider:ArrayCollection=new ArrayCollection();
		[Bindable]
		public function set dataProvider (value:ArrayCollection):void
		{
			resetAll();
			preloaderImg.visible = false;
			masterCanvas.externalCanvas.visible = true;
			masterCanvas.singlePage.visible = true;
			masterCanvas1.externalCanvas.visible = true;
			masterCanvas1.singlePage.visible = true;
			_dataProvider.list = value.list;
		}

		public function get dataProvider ():ArrayCollection
		{
			return _dataProvider;
		}
		
		public function PDFTool()
		{
			super();
			
		}
		override protected function createChildren():void
		{
			super.createChildren();
						
			addChild(masterLayoutHBox);
			addChild(commentListLayoutHBox);
			addChild(toolBoxLayoutHBox);
			
			toolBoxLayoutHBox.addChild(toolBox);
			toolBoxLayoutHBox.addChild(noteOnOff);
			toolBoxLayoutHBox.addChild(doubleViewBtn);
			toolBoxLayoutHBox.addChild(togglePDFBtn);
			toolBoxLayoutHBox.addChild(selectPDFBtn);
			toolBoxLayoutHBox.addChild(compareBtn);
			toolBoxLayoutHBox.addChild(regionCompareSelectBtn);
			toolBoxLayoutHBox.addChild(regionPointerBtn);
			toolBoxLayoutHBox.addChild(regionResetBtn);
			toolBoxLayoutHBox.addChild(compareImageAlphaControllerHBox);
			toolBoxLayoutHBox.addChild(rotateClockwiseBtn);
			toolBoxLayoutHBox.addChild(rotateCounterClockwiseBtn);
			toolBoxLayoutHBox.addChild(zoomInBtn);
			toolBoxLayoutHBox.addChild(zoomOutBtn);
			toolBoxLayoutHBox.addChild(pdfDownloadBtn);
			
			compareImageAlphaControllerHBox.addChild(firstPDFImg);
			compareImageAlphaControllerHBox.addChild(firstPDFHSlider);
			compareImageAlphaControllerHBox.addChild(secondPDFImg);
			compareImageAlphaControllerHBox.addChild(secondPDFHSlider);
			compareImageAlphaControllerHBox.addChild(diffPDFImg);
			compareImageAlphaControllerHBox.addChild(diffPDFHSlider);
			
			masterLayoutHBox.addChild(masterCanvas);
			masterLayoutHBox.addChild(masterCanvas1);
			
			masterLayoutHBox.setStyle("horizontalGap","0");
			
			//masterLayoutHBox.percentHeight = 100;
			
			commentListLayoutHBox.addChild(commentListToggleBtn);
			commentListLayoutHBox.addChild(commentList);
			
			addChild(preloaderImg);
			commentListLayoutHBox.percentHeight = 100;
			commentListLayoutHBox.setStyle("horizontalGap","0");
			commentListLayoutHBox.setStyle("right","0");
			commentListLayoutHBox.setStyle("horizontalAlign","right");
			commentListToggleBtn.styleName = "NoteListOpenClose";
			commentListToggleBtn.toggle = true;
			commentListToggleBtn.selected = true;
			useHandCursorAction(commentListToggleBtn);
			
			commentList.addEventListener(CommentList.TAB_CHANGE, onCommentListTabChange,false,0,true);
			commentList.addEventListener(GotoCommentEvent.GOTO_COMMENT, onGotoComment,false,0,true);	 
			commentListToggleBtn.addEventListener(MouseEvent.CLICK,onCommentListOpenCloseAction,false,0,true); 
			
			var dropShadow:DropShadowFilter = new DropShadowFilter(8,135, 0, 0.5, 8 ,8);
			commentListLayoutHBox.filters = [dropShadow]; 
			
			masterCanvas.percentWidth=0;
			masterCanvas.percentHeight=100;
			masterCanvas1.percentWidth=100;
			masterCanvas1.percentHeight=100;
			
			masterCanvas.selectPDF = SinglePageCanvas.PDF1;
			masterCanvas1.selectPDF = SinglePageCanvas.PDF2;
			
			commentList.width = 250;
			
			toolBoxLayoutHBox.percentWidth = 100;
			toolBoxLayoutHBox.height = 50;
			
			toolBoxLayoutHBox.setStyle("bottom", "0");
			toolBoxLayoutHBox.setStyle("paddingRight", 10);
			toolBoxLayoutHBox.setStyle("horizontalAlign", "right");
 			toolBoxLayoutHBox.setStyle("verticalAlign", "middle"); 
 			toolBoxLayoutHBox.styleName = "toolBoxLayoutHBoxStyle";
			//toolBoxLayoutHBox.setStyle("backgroundColor","#BABABA"); 
			
			noteOnOff.styleName = "CommentOnOffBtn";
			noteOnOff.toggle = true;
			useHandCursorAction(noteOnOff, "Note On/Off");
			
			doubleViewBtn.styleName = "doublePageView";
			doubleViewBtn.toggle = true;
			useHandCursorAction(doubleViewBtn, "Double View");
			
			togglePDFBtn.styleName = "PlayPauseSkin";
			togglePDFBtn.toggle = true;
			useHandCursorAction(togglePDFBtn, "Play/Pause");
			
			selectPDFBtn.styleName = "selectPDFSkin";
			selectPDFBtn.toggle = true;
			useHandCursorAction(selectPDFBtn, "Select PDF");
			
			pdfDownloadBtn.styleName = "SaveToolSkin";
			useHandCursorAction(pdfDownloadBtn, "Save PDF");
			
			compareBtn.styleName = "NormalCompareSkin";
			compareBtn.toggle = true;
			useHandCursorAction(compareBtn, "Compare");
			
			regionCompareSelectBtn.styleName = "RegionCompareSelectSkin";
			regionCompareSelectBtn.toggle = true;
			useHandCursorAction(regionCompareSelectBtn, "Region Compare Select");
			
			regionPointerBtn.styleName = "dotSkin";
			useHandCursorAction(regionPointerBtn, "Region Pointer");
			regionPointerBtn.visible = regionPointerBtn.includeInLayout = false;
			
			regionResetBtn.styleName = "RegionResetSkin";
			useHandCursorAction(regionResetBtn, "Region Reset");
			regionResetBtn.visible = regionResetBtn.includeInLayout = false;
			
			rotateClockwiseBtn.styleName = "rotateClockwiseSkin";
			rotateCounterClockwiseBtn.styleName = "rotateCounterclockwiseSkin";
			zoomInBtn.styleName = "zoomInSkin";
			zoomOutBtn.styleName = "zoomOutSkin";
			
			rotateClockwiseBtn.id = "rotateClockwiseBtn";
			rotateCounterClockwiseBtn.id = "rotateCounterClockwiseBtn";
			zoomInBtn.id = "zoomInBtn";
			zoomOutBtn.id = "zoomOutBtn";
			pdfDownloadBtn.id= "pdfDownloadBtn";
			
			
			rotateClockwiseBtn.addEventListener(MouseEvent.CLICK,onRotate,false,0,true);
			rotateCounterClockwiseBtn.addEventListener(MouseEvent.CLICK,onRotate,false,0,true);
			zoomInBtn.addEventListener(MouseEvent.MOUSE_DOWN,onZoom,false,0,true);
			zoomOutBtn.addEventListener(MouseEvent.MOUSE_DOWN,onZoom,false,0,true);
			pdfDownloadBtn.addEventListener(MouseEvent.MOUSE_DOWN,downloadPdf,false,0,true);
			
			useHandCursorAction(rotateClockwiseBtn, "Rotate Clockwise");
			useHandCursorAction(rotateCounterClockwiseBtn, "Rotate Counter Clockwise");
			useHandCursorAction(zoomInBtn, "Zoom In");
			useHandCursorAction(zoomOutBtn, "Zoom Out");
			
			BindingUtils.bindProperty(masterCanvas, "dataProvider", this, "dataProvider");
			BindingUtils.bindProperty(masterCanvas1, "dataProvider",this, "dataProvider");
			BindingUtils.bindProperty(commentList, "dataProvider",this, "dataProvider");
			
			BindingUtils.bindProperty(masterCanvas1.singlePage, "regionXpos", masterCanvas.singlePage, "regionXpos");
			BindingUtils.bindProperty(masterCanvas1.singlePage, "regionYpos", masterCanvas.singlePage, "regionYpos");
			
			BindingUtils.bindProperty(masterCanvas.singlePage, "x", masterCanvas1, "imgX");
			BindingUtils.bindProperty(masterCanvas.singlePage, "y", masterCanvas1, "imgY");
			BindingUtils.bindProperty(masterCanvas.singlePage, "rotation", masterCanvas1, "rotateValue");
			
			BindingUtils.bindProperty(masterCanvas1.singlePage, "x", masterCanvas, "imgX");
			BindingUtils.bindProperty(masterCanvas1.singlePage, "y", masterCanvas, "imgY");
			BindingUtils.bindProperty(masterCanvas1.singlePage, "rotation", masterCanvas, "rotateValue");
			BindingUtils.bindSetter(commentListWidthChange , commentList,"width");
			BindingUtils.bindSetter(thisWidthChange , this,"width");
			BindingUtils.bindSetter(thisHeightChange , this,"height");
			
			masterCanvas1.addEventListener(MasterContainer.ZOOM_IN, onZoomIn,false,0,true);
			masterCanvas1.addEventListener(MasterContainer.ZOOM_OUT, onZoomOut,false,0,true);
			
			masterCanvas.addEventListener(MasterContainer.ZOOM_IN, onZoomInFirst,false,0,true);
			masterCanvas.addEventListener(MasterContainer.ZOOM_OUT, onZoomOutFirst,false,0,true); 
			
			masterCanvas.addEventListener(MasterContainer.IMAGE_LOADING_COMPLETE, onImageLoadComplete,false,0,true); 
			masterCanvas1.addEventListener(MasterContainer.IMAGE_LOADING_COMPLETE, onImageLoadComplete,false,0,true);
			
			toolBox.addEventListener(ToolBoxEvent.SELECTED_TOOL, onToolSelect,false,0,true);
			noteOnOff.addEventListener(MouseEvent.CLICK, onCommentOnOff,false,0,true);
			doubleViewBtn.addEventListener(MouseEvent.CLICK, onDoubleView,false,0,true);
			togglePDFBtn.addEventListener(MouseEvent.CLICK, onTogglePDF,false,0,true);
			selectPDFBtn.addEventListener(MouseEvent.CLICK, onSelectPDF,false,0,true);
			compareBtn.addEventListener(MouseEvent.CLICK, onNormalCompare,false,0,true);
			regionCompareSelectBtn.addEventListener(MouseEvent.CLICK, onRegionCompareSelect,false,0,true);
			regionPointerBtn.addEventListener(MouseEvent.CLICK, onRegionPointer,false,0,true);
			regionResetBtn.addEventListener(MouseEvent.CLICK, onRegionReset,false,0,true);
			
			compareImageAlphaControllerHBox.width = 0;
			compareImageAlphaControllerHBox.percentHeight = 100;
			
			compareImageAlphaControllerHBox.horizontalScrollPolicy = "off";
			compareImageAlphaControllerHBox.verticalScrollPolicy = "off";
			
			compareImageAlphaControllerHBox.setStyle("verticalAlign","middle");
			
			var resize:Resize = new Resize();
			
			resize.easingFunction = Circular.easeInOut;
			resize.duration = 100;
			
			compareImageAlphaControllerHBox.setStyle("resizeEffect",resize);
			
			selectPDFBtn.toolTip = "Select First PDF";
			
			firstPDFImg.source = ImageResourceEmbedClass.FIRST_PDF_ICON;
			secondPDFImg.source = ImageResourceEmbedClass.SECOND_PDF_ICON;
			diffPDFImg.source = ImageResourceEmbedClass.DIFF_PDF_ICON
			
			firstPDFHSlider.minimum = secondPDFHSlider.minimum = diffPDFHSlider.minimum = 0;
			firstPDFHSlider.maximum = secondPDFHSlider.maximum = diffPDFHSlider.maximum = 1;
			
			firstPDFHSlider.width = secondPDFHSlider.width = diffPDFHSlider.width = 50;
			firstPDFHSlider.tickInterval = secondPDFHSlider.tickInterval = diffPDFHSlider.tickInterval = 0.1;
			firstPDFHSlider.liveDragging = secondPDFHSlider.liveDragging = diffPDFHSlider.liveDragging = true;
			firstPDFHSlider.dataTipFormatFunction = secondPDFHSlider.dataTipFormatFunction = diffPDFHSlider.dataTipFormatFunction = SliderTooltip;
			
			firstPDFHSlider.addEventListener(SliderEvent.CHANGE, onFirstHSChange,false,0,true);
			secondPDFHSlider.addEventListener(SliderEvent.CHANGE, onSecondHSChange,false,0,true);
			diffPDFHSlider.addEventListener(SliderEvent.CHANGE, onDiffHSChange,false,0,true);
			
			masterCanvas1.setStyle("right","0");
			//setStyle("backgroundColor","#000000");
			//setStyle("backgroundColor","#ECECEC");
			styleName = "pdfToolStyle";
			
			this.percentWidth=100;
			this.percentHeight=100;
			
			var dropShadow1:DropShadowFilter = new DropShadowFilter(8,-90,0,0.5,8,8,1,1);
			toolBoxLayoutHBox.filters = [dropShadow1];
		}		
		private function onToolSelect(event:ToolBoxEvent):void
		{
			masterCanvas1.commentType = event.selectedTool;
		}
		private function onZoomIn(event:Event):void
		{
			masterCanvas.singlePage.scaleAt(6/5, masterCanvas1.mouseX, masterCanvas1.mouseY, "Manual");
			masterCanvas.singlePage.x=masterCanvas1.singlePage.x;
			masterCanvas.singlePage.y=masterCanvas1.singlePage.y;
			if(noteOnOff.selected){
				masterCanvas.commentVisible();
				masterCanvas1.commentVisible();
			}
		}
		private function onZoomOut(event:Event):void
		{
			masterCanvas.singlePage.scaleAt(5/6, masterCanvas1.mouseX, masterCanvas1.mouseY, "Manual");
			masterCanvas.singlePage.x=masterCanvas1.singlePage.x;
			masterCanvas.singlePage.y=masterCanvas1.singlePage.y;
			if(noteOnOff.selected){
				masterCanvas.commentVisible();
				masterCanvas1.commentVisible();
			}
		}
		private function onZoomInFirst(event:Event):void
		{
			masterCanvas1.singlePage.scaleAt(6/5, masterCanvas.mouseX, masterCanvas.mouseY, "Manual");
			masterCanvas1.singlePage.x=masterCanvas.singlePage.x;
			masterCanvas1.singlePage.y=masterCanvas.singlePage.y;
			if(noteOnOff.selected){
				masterCanvas.commentVisible();
				masterCanvas1.commentVisible();
			}
		}
		private function onZoomOutFirst(event:Event):void
		{
			masterCanvas1.singlePage.scaleAt(5/6, masterCanvas.mouseX, masterCanvas.mouseY, "Manual");
			masterCanvas1.singlePage.x=masterCanvas.singlePage.x;
			masterCanvas1.singlePage.y=masterCanvas.singlePage.y;
			if(noteOnOff.selected){
				masterCanvas.commentVisible();
				masterCanvas1.commentVisible();
			}
		}
		private function toolVisibleStatus(value:Boolean):void
		{
			//noteOnOff.visible = noteOnOff.includeInLayout = value;
			
			doubleViewBtn.visible = doubleViewBtn.includeInLayout = value;
			togglePDFBtn.visible = togglePDFBtn.includeInLayout = value;
			selectPDFBtn.visible = selectPDFBtn.includeInLayout = value;
			compareBtn.visible = compareBtn.includeInLayout = value;
			regionCompareSelectBtn.visible = regionCompareSelectBtn.includeInLayout = value;
			commentList.compareMode = value;
			commentList.pdffile = SinglePageCanvas.PDF2;
		}
		private function onCommentListTabChange(event:Event):void
		{
			masterCanvas1.selectPDF = commentList.pdffile;
			if(commentList.pdffile == SinglePageCanvas.PDF1)
			{
				selectPDFBtn.selected = true;
				selectPDFBtn.toolTip = "Select Second PDF";
				if(toolBox.toolBoxExpand)
				{
					toolBox.close();
				}
				toolBox.visible = false;
				masterCanvas.singlePage.focusAction = SinglePageCanvas.NONE;
				masterCanvas1.singlePage.focusAction = SinglePageCanvas.NONE;
			}
			else
			{
				selectPDFBtn.selected = false;
				selectPDFBtn.toolTip = "Select First PDF";
				masterCanvas1.singlePage.focusAction = SinglePageCanvas.NONE;
				toolBox.visible = true;
			}
		}
		private function onGotoComment(event:GotoCommentEvent):void
		{
			//event.commentVO.commentX 
			//event.commentVO.commentY
			//event.commentVO.commentPDFfile
			trace(event.commentVO.commentWidth+' >>>-0->>> '+event.commentVO.commentHeight);
			 if(masterCanvas1.width > (masterCanvas1.singlePage.imgWidth*masterCanvas1.singlePage.rotateScaleValue()) && masterCanvas1.height > (masterCanvas1.singlePage.imgHeight*masterCanvas1.singlePage.rotateScaleValue()))
			{ 
				masterCanvas1.singlePage.resetAll();
			}
			
			//trace("Scale Value : "+masterCanvas1.singlePage.rotateScaleValue());
			trace("Rotation : "+Math.round(masterCanvas1.singlePage.rotation));
			var wValue:Number = (Number(event.commentVO.commentWidth)== 5)?0:(Number(event.commentVO.commentWidth)*masterCanvas1.singlePage.rotateScaleValue())/2;
			var hValue:Number = (Number(event.commentVO.commentHeight)== 5)?0:(Number(event.commentVO.commentHeight)*masterCanvas1.singlePage.rotateScaleValue())/2;
			if(Math.round(masterCanvas1.singlePage.rotation)==0){
				masterCanvas1.singlePage.x = -((event.commentVO.commentX)*masterCanvas1.singlePage.rotateScaleValue()-masterCanvas1.width/2+wValue);
				masterCanvas1.singlePage.y = -((event.commentVO.commentY)*masterCanvas1.singlePage.rotateScaleValue()-masterCanvas1.height/2+hValue);
			}
			if(Math.round(masterCanvas1.singlePage.rotation)==180 || Math.round(masterCanvas1.singlePage.rotation)==-180 ){
				masterCanvas1.singlePage.x = ((event.commentVO.commentX)*masterCanvas1.singlePage.rotateScaleValue()+masterCanvas1.width/2+wValue);
				masterCanvas1.singlePage.y = ((event.commentVO.commentY)*masterCanvas1.singlePage.rotateScaleValue()+masterCanvas1.height/2+hValue);
			}
			if(Math.round(masterCanvas1.singlePage.rotation)==-90){
				masterCanvas1.singlePage.x = -((event.commentVO.commentY)*masterCanvas1.singlePage.rotateScaleValue()-masterCanvas1.width/2+hValue);
				masterCanvas1.singlePage.y = ((event.commentVO.commentX)*masterCanvas1.singlePage.rotateScaleValue()+masterCanvas1.height/2+wValue);
			}
			if(Math.round(masterCanvas1.singlePage.rotation)==90){
				masterCanvas1.singlePage.x = ((event.commentVO.commentY)*masterCanvas1.singlePage.rotateScaleValue()+masterCanvas1.width/2+hValue);
				masterCanvas1.singlePage.y = -((event.commentVO.commentX)*masterCanvas1.singlePage.rotateScaleValue()-masterCanvas1.height/2+wValue);
			}
			masterCanvas.linkFunc();
			masterCanvas1.linkFunc();
			
		}
		private var firstTime:Boolean = true;
		private function resetAll():void
		{
			sharedObjectForNotes = SharedObject.getLocal(pdfToolNotesSOName);
			sharedObjectForNotes.clear();
			trace("Clear Task Started");
			sharedObjectForNotes.data.iN = 1
			sharedObjectForNotes.flush();
			
			if(!commentList.openStatus)
			{
				if(!miniReaderPropertyStatus)
					commentListToggleBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}else
			{
				if(commentList.openStatus && miniReaderPropertyStatus)
				{
					commentListToggleBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
					
				}
				
			}
			if(miniReaderPropertyStatus)
			{
				firstTime = false;	
			}
			commentListLayoutHBox.visible = commentListLayoutHBox.includeInLayout = true;
			if(toolBox.toolBoxExpand)
			{
				toolBox.close();
			}
			if(doubleViewStatus)
			{
				doubleViewBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			if(togglePDFStatus)
			{
				togglePDFBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			if(regionCompareStatus){
				regionCompareSelectBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			if(regionResetStatus){
				regionResetBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			if(compareStatus){
				compareBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			noteOnOff.selected = false;
			toolBox.arrowBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			regionPointerBtn.visible = regionPointerBtn.includeInLayout = false;
			masterCanvas.singlePage.regionPointer.visible = false;
			masterCanvas1.singlePage.regionPointer.visible = false;
			masterCanvas.linkFunc();
			masterCanvas1.linkFunc();
		
		}
		private function SliderTooltip(val : String) : String
		{
			return String('Alpha : ' + Math.round(Number(val) * 100) + '%');
		}
		private function onCommentListOpenCloseAction(event:MouseEvent):void
		{
			var resizeEff:Resize = new Resize();
			resizeEff.easingFunction = Circular.easeInOut;
			resizeEff.duration = 500;
			commentList.setStyle("resizeEffect",resizeEff);
			if(commentList.openStatus){
				commentList.width = 0;
			}else
			{
				commentList.width = 250;
				firstTime = true;
				masterCanvas.externalCanvas.visible = true;
				masterCanvas1.externalCanvas.visible = true;
			}
			commentList.openStatus = !commentList.openStatus;
		}
		private function commentListWidthChange(val:Number):void
		{
			masterLayoutHBox.width = this.width - val;
		}
		private function thisWidthChange (val:Number):void
		{
			masterLayoutHBox.width = val - commentList.width;
		}  
		private function thisHeightChange (val:Number):void
		{
			masterLayoutHBox.height = val - toolBoxLayoutHBox.height;
			commentList.height = val - toolBoxLayoutHBox.height;
		}
		private function onZoom(event:MouseEvent):void
		{
			if(event.target.id == "zoomInBtn")
			{
				masterCanvas1.singlePage.onZoom();	
			}
			if(event.target.id == "zoomOutBtn")
			{
				masterCanvas1.singlePage.onZoom(false);
			}
			if(noteOnOff.selected){
				masterCanvas.commentVisible();
				masterCanvas1.commentVisible();
			}
		}
		private function onRotate(event:MouseEvent):void
		{
			if(event.target.id == "rotateClockwiseBtn")
			{
				masterCanvas1.singlePage.onRotate();	
			}
			if(event.target.id == "rotateCounterClockwiseBtn")
			{
				masterCanvas1.singlePage.onRotate(false);
			}
			if(noteOnOff.selected){
				masterCanvas.commentVisible();
				masterCanvas1.commentVisible();
			}
		}
	
		private function downloadPdf(event:MouseEvent):void{ 
				//var myPDF : PDFi = new PDFi ( Orientation.PORTRAIT, Unit.POINT, new Size([masterCanvas1.singlePage.img2.imgWidth, masterCanvas1.singlePage.img2.imgHeight],"Custom",[],[]) );
				var myPDF : MyPDF = new MyPDF ( Orientation.PORTRAIT, Unit.POINT, new Size([masterCanvas1.singlePage.img2.imgWidth, masterCanvas1.singlePage.img2.imgHeight+70],"Custom",[],[]) );
				//myPDF.setAutoPageBreak(true, 0);
				model.preloaderVisibility = true
				myPDF.headerText = new File(File.desktopDirectory.resolvePath(pdfName.substring(pdfName.lastIndexOf('\\')+1,pdfName.length-4)).nativePath).name;
				myPDF.footerRight = model.currentTime.toString();
				myPDF.footerLeft = model.person.personFirstname+" "+model.person.personLastname;
			    myPDF.addPage();
			      
				masterCanvas1.singlePage.makeMarkersVisible();
     
				var image:ImageSnapshot = ImageSnapshot.captureImage(masterCanvas1.singlePage.img2, 300, new InternalPNGEncoder());
 				myPDF.addImageStream(image.data,0,35,masterCanvas1.singlePage.img2.imgWidth, masterCanvas1.singlePage.img2.imgHeight);
 				
 				masterCanvas1.singlePage.removeMarkers();
				
 				
 				myPDF.addPage();
 				
 				var image1:ImageSnapshot = ImageSnapshot.captureImage(masterCanvas1.singlePage, 300, new InternalPNGEncoder());
 				myPDF.addImageStream(image1.data,0,35,masterCanvas1.singlePage.img2.imgWidth, masterCanvas1.singlePage.img2.imgHeight);
 				
			   var objectArray:Array = getObjectArray( masterCanvas1.commentsPdf ); 
	           if(masterCanvas1.commentsPdf.length>0){
	           	{
	           	//myPDF.addPage();
	           	var msg:String = "";
	           	var idCounter:Number = 0;
	           	for(var i:Number = 0; i<masterCanvas1.commentsPdf.length; i++)
	           	{
	           		var currentID:String = "";
	           		if(masterCanvas1.commentsPdf[i].Id != 0){
	           			idCounter++;
		           		/* myPDF.textStyle( new RGBColor(uint(0x898989)), 1 );  
		           		myPDF.setFont( FontFamily.ARIAL, Style.ITALIC, 10 );
		           		msg = "\n"+(idCounter)+")";
		           		msg += "\n"+"Ref. ID : "
		           		myPDF.writeText(18, msg); */
		           		
		           		currentID = masterCanvas1.commentsPdf[i].CommentID;
		           		
		           		/* myPDF.textStyle( new RGBColor(uint(0)), 1 );  
		           		myPDF.setFont( FontFamily.ARIAL, Style.NORMAL, 10 );
		           		msg =  masterCanvas1.commentsPdf[i].CommentID;
		           		
		           		myPDF.writeText(18, msg); */
		           		
		           		//myPDF.textStyle( new RGBColor(uint(0x336699)), 1 );  
		           		//myPDF.setFont( FontFamily.ARIAL, Style.BOLD_ITALIC, 10 );
		           		msg = "\n"+"Author: "+ masterCanvas1.commentsPdf[i].CreatedBy+"\t ";
		           		//msg += masterCanvas1.commentsPdf[i].Date.toString();
		           		//myPDF.writeText(18, msg);
		           		
		           		//myPDF.textStyle( new RGBColor(uint(0x898989)), 1 );  
		           		//myPDF.setFont( FontFamily.ARIAL, Style.ITALIC, 10 );
		           		
		           		msg += "Subject: "
		           		msg += (masterCanvas1.commentsPdf[i].Type!=null)?((masterCanvas1.commentsPdf[i].Type!='')?masterCanvas1.commentsPdf[i].Type+"\t":"\t"):''+"\t";
		           				           		
		           		msg += "Date: "
		           		msg += masterCanvas1.commentsPdf[i].Date.toString()+"\n";
		           		
		           		msg += "---------------------------------------------------\n";
		           		
		           		msg += masterCanvas1.commentsPdf[i].Comment + "\n\n";
		           		
		           		
						
		           		//myPDF.writeText(18, msg);
		           			           		
		           		/* myPDF.textStyle( new RGBColor(uint(0)), 1 );  
		           		myPDF.setFont( FontFamily.ARIAL, Style.NORMAL, 10 );
						myPDF.writeText(18, msg); */
						/* 
						myPDF.textStyle( new RGBColor(uint(0x898989)), 1 );  
		           		myPDF.setFont( FontFamily.ARIAL, Style.ITALIC, 10 );
		           		msg = "\n"+"Comments : "
		           		myPDF.writeText(18, msg);
		           		
		           		myPDF.textStyle( new RGBColor(uint(0)), 1 );  
		           		myPDF.setFont( FontFamily.ARIAL, Style.NORMAL, 10 );
						msg = masterCanvas1.commentsPdf[i].Comment;
						myPDF.writeText(18, msg);
						 */
						
						
						for(var j:Number = 0; j<masterCanvas1.commentsPdf.length; j++)
	           			{
	           				if(currentID == masterCanvas1.commentsPdf[j].CommentID && masterCanvas1.commentsPdf[j].Id == '0')
	           				{
	           					/* myPDF.textStyle( new RGBColor(uint(0x898989)), 1 );   
				           		myPDF.setFont( FontFamily.ARIAL, Style.ITALIC, 10 );
								msg = "\n"+"       ------ ~ ------ ";
								myPDF.writeText(18, msg);
								
	           					myPDF.textStyle( new RGBColor(uint(0x898989)), 1 );  
				           		myPDF.setFont( FontFamily.ARIAL, Style.ITALIC, 10 );
				           		msg = "\n"+"Title : "
				           		myPDF.writeText(18, msg);
				           			           		
				           		myPDF.textStyle( new RGBColor(uint(0)), 1 );  
				           		myPDF.setFont( FontFamily.ARIAL, Style.NORMAL, 10 );
								msg = masterCanvas1.commentsPdf[j].Type;
								myPDF.writeText(18, msg);
								
								myPDF.textStyle( new RGBColor(uint(0x898989)), 1 );  
				           		myPDF.setFont( FontFamily.ARIAL, Style.ITALIC, 10 );
				           		msg = "\n"+"Comments : "
				           		myPDF.writeText(18, msg);
				           		
				           		myPDF.textStyle( new RGBColor(uint(0)), 1 );  
				           		myPDF.setFont( FontFamily.ARIAL, Style.NORMAL, 10 );
								msg = masterCanvas1.commentsPdf[j].Comment;
								myPDF.writeText(18, msg);
								
								myPDF.textStyle( new RGBColor(uint(0x336699)), 1 );  
				           		myPDF.setFont( FontFamily.ARIAL, Style.BOLD_ITALIC, 10 );
				           		msg = "\n"+"-"+ masterCanvas1.commentsPdf[j].CreatedBy+", ";
				           		msg += masterCanvas1.commentsPdf[j].Date.toString();
				           		myPDF.writeText(18, msg); */
				           		
				           		msg += "\n"+"    Author: "+ masterCanvas1.commentsPdf[j].CreatedBy+"\t ";
				           		//msg += masterCanvas1.commentsPdf[i].Date.toString();
				           		//myPDF.writeText(18, msg);
				           		
				           		//myPDF.textStyle( new RGBColor(uint(0x898989)), 1 );  
				           		//myPDF.setFont( FontFamily.ARIAL, Style.ITALIC, 10 );
				           		msg += "Subject: "
				           		msg += (masterCanvas1.commentsPdf[j].Type!=null)?((masterCanvas1.commentsPdf[j].Type!='')?masterCanvas1.commentsPdf[j].Type+"\t":"\t"):''+"\t";
				           		           		
				           		msg += "Date: "
				           		msg += masterCanvas1.commentsPdf[j].Date.toString()+"\n";
				           		
				           		msg += "    -----------------------------------------------\n";
				           		
				           		msg += "    "+masterCanvas1.commentsPdf[j].Comment + "\n";
				           		
	           				}
	           			}
	           			
	           			trace("msg ::: " + msg);
		           		
		           		
	           			
	           			/* myPDF.textStyle( new RGBColor(uint(0x898989)), 1 );   
		           		myPDF.setFont( FontFamily.ARIAL, Style.ITALIC, 10 );
						msg = "\n"+"  ---------------- ~ ---------------- ";
						myPDF.writeText(18, msg); */
						
						myPDF.addTextNote(masterCanvas1.commentsPdf[i].posX-10, masterCanvas1.commentsPdf[i].posY+20, 200, 200, msg);
	           		}
	           	}
	            
	           /*  //msg += "<br/>"+(i+1)+")";
           		msg += "<br/><font size='10' color='#989898'><i>"+"Ref. ID : </i></font>"
           		msg +=  masterCanvas1.commentsPdf[i].CommentID;
           		msg += "<br/><font size='10' color='#989898'><i>"+"Title : </i></font>"
				msg += masterCanvas1.commentsPdf[i].Type;
           		msg += "<br/><font size='10' color='#989898'><i>"+"Comments : </i></font>"
				msg += masterCanvas1.commentsPdf[i].Comment;
           		msg += "<br/><font size='10' color='#336699'><i>";
           		msg += "<b>-"+ masterCanvas1.commentsPdf[i].CreatedBy+"</b>,  "+masterCanvas1.commentsPdf[i].Date;
           		msg += "</i></font>"
				msg += "<br/>"+"    --- ~ ---"; */
	            
				/* var grid:Grid = new Grid( objectArray, masterCanvas1.singlePage.imgHeight, masterCanvas1.singlePage.imgHeight, new RGBColor( 0x666666 ), new RGBColor( 0xCCCCCC ), new RGBColor( 0 ), true, new RGBColor( 0x0 ), 1, Joint.MITER );
	            grid.columns = getPdfGridColumns(masterCanvas1.commentsGrid.columns);
	            myPDF.addGrid( grid, 0, 0); */
	            
	            }
	            //myPDF.setFontSize( 12 );
	           }
				gBytes = myPDF.save( Method.LOCAL ); 
				if( model.preloaderVisibility )	model.preloaderVisibility = false;
	            var cFile:File = new File();
	            cFile = File.desktopDirectory.resolvePath(pdfName.substring(pdfName.lastIndexOf('\\')+1,pdfName.length-4)+".pdf");
	            cFile.addEventListener( Event.SELECT, onSelectSave,false,0,true );
	            cFile.browseForSave( "Technical Report" );  
	            
			}
			
			private var gBytes:ByteArray = new ByteArray();
			private function onSelectSave( event:Event ):void {
		        var cFile:File = event.target as File;
		        var cFS:FileStream = new FileStream();
		        cFile.removeEventListener( Event.SELECT, onSelectSave );
		        try{
			        cFS.open( cFile, FileMode.WRITE );
			        cFS.writeBytes( gBytes );
		        }
		        catch ( pError:Error ){}
		        cFS.close();
		        gBytes.length = 0;
		    } 

			 private function getObjectArray( value:ArrayCollection ):Array {
		    	var resultarray:Array = [];
		    	for each( var item:Object in value ) {
		    		resultarray.push( item );
		    	}
		    	return resultarray;
		    } 
			private function getPdfGridColumns( value:Array):Array { 
		    	var resultarray:Array = [];
		    	for( var i:int = 0; i <  value.length; i++ ) {
		    		var pdfGridColumn:GridColumn = new GridColumn( value[i].headerText, value[i].dataField, 90, Align.LEFT, Align.LEFT );
            		resultarray.push( pdfGridColumn );
		    	}
		    	return resultarray;
		    }
		
		private function onFirstHSChange(event:SliderEvent):void
		{
			masterCanvas1.singlePage.pdfAlphaControl(event.target.value,secondPDFHSlider.value,diffPDFHSlider.value);
		}
		private function onSecondHSChange(event:SliderEvent):void
		{
			masterCanvas1.singlePage.pdfAlphaControl(firstPDFHSlider.value,event.target.value,diffPDFHSlider.value);
		}
		private function onDiffHSChange(event:SliderEvent):void
		{
			masterCanvas1.singlePage.pdfAlphaControl(firstPDFHSlider.value, secondPDFHSlider.value, event.target.value);	
		}
		private function onCommentOnOff(event:MouseEvent):void
		{
			masterCanvas.commentShowStatus = !Button(event.currentTarget).selected;
			masterCanvas1.commentShowStatus = !Button(event.currentTarget).selected;
			masterCanvas.commentVisible(!Button(event.currentTarget).selected);
			masterCanvas1.commentVisible(!Button(event.currentTarget).selected);
			
			
		}
		private function onDoubleView(event:MouseEvent):void
		{
			trace("Double View Status : "+compareStatus)
			var resizeEff:Resize = new Resize();
			resizeEff.easingFunction = Circular.easeInOut;
			resizeEff.duration = 500;
			masterCanvas.setStyle("resizeEffect",resizeEff);
			var resizeEff1:Resize = new Resize();
			resizeEff1.easingFunction = Circular.easeInOut;
			resizeEff1.duration = 500;
			masterCanvas1.setStyle("resizeEffect",resizeEff1);
			if(doubleViewStatus){
				masterCanvas.percentWidth = 0;
				masterCanvas1.percentWidth = 100;
				masterCanvas1.selectPDF = SinglePageCanvas.PDF2;
				selectPDFBtn.selected = false;
				selectPDFBtn.toolTip = "Select First PDF";
				selectPDFBtn.visible = selectPDFBtn.includeInLayout = true;
				togglePDFBtn.visible = togglePDFBtn.includeInLayout = true;
				commentListLayoutHBox.visible = commentListLayoutHBox.includeInLayout = true;
				masterCanvas.singlePage.regionPointer.visible = false;
				masterCanvas1.singlePage.regionPointer.visible = false;
				if(regionCompareStatus && compareStatus){
					regionCompareSelectBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
			}else{
				if(togglePDFStatus)
				{
					togglePDFBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
				if(commentList.openStatus)
				{
					commentListToggleBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
				masterCanvas.percentWidth = 50;
				masterCanvas1.percentWidth = 50;
				masterCanvas.selectPDF = SinglePageCanvas.PDF1;
				masterCanvas1.selectPDF = SinglePageCanvas.PDF2;
				selectPDFBtn.visible = selectPDFBtn.includeInLayout = false;
				togglePDFBtn.visible = togglePDFBtn.includeInLayout = false;
				commentListLayoutHBox.visible = commentListLayoutHBox.includeInLayout = false;
				commentList.pdffile =  SinglePageCanvas.PDF2;
				noteOnOff.selected = false;
				masterCanvas.commentShowStatus = true;
				masterCanvas1.commentShowStatus = true
			}
			if(toolBox.toolBoxExpand)
			{
				toolBox.close();
			}
			masterCanvas.singlePage.focusAction = SinglePageCanvas.NONE;
			masterCanvas1.singlePage.focusAction = SinglePageCanvas.NONE;
			doubleViewStatus = !doubleViewStatus;
		} 
		private function onSelectPDF(event:MouseEvent):void
		{
			if(!selectPDFBtn.selected)
			{
				masterCanvas1.selectPDF = SinglePageCanvas.PDF2;
				selectPDFBtn.toolTip = "Select First PDF";
				toolBox.visible = true;
			}
			else
			{
				masterCanvas1.selectPDF = SinglePageCanvas.PDF1;
				selectPDFBtn.toolTip = "Select Second PDF";
				masterCanvas1.singlePage.focusAction = SinglePageCanvas.NONE;
			}
			commentList.pdffile = masterCanvas1.selectPDF;
			if(noteOnOff.selected){
				masterCanvas.commentVisible();
				masterCanvas1.commentVisible();
			}
		}
		
		private function onTogglePDF(event:MouseEvent):void
		{
			if(togglePDFStatus)
			{
				// Toggle Page Stop 
				masterCanvas1.singlePage.togglePDF( false );
				if(!noteOnOff.selected)
				{
					masterCanvas1.commentVisible(true);
				}
				if(masterCanvas1.singlePage.selectPDF == SinglePageCanvas.PDF2){
					selectPDFBtn.selected = false;
					selectPDFBtn.toolTip = "Select First PDF";
					commentList.pdffile = SinglePageCanvas.PDF2;
					toolBox.visible = true;
				}
				else{
					selectPDFBtn.selected = true;
					selectPDFBtn.toolTip = "Select Second PDF";
					commentList.pdffile = SinglePageCanvas.PDF1;
					toolBox.visible = false;
				}
				selectPDFBtn.visible = selectPDFBtn.includeInLayout = true;
				commentListLayoutHBox.visible = commentListLayoutHBox.includeInLayout = true;
				// End-- Toggle Page Stop 
			}
			else
			{
				// Toggle Page Start
				masterCanvas1.singlePage.togglePDF( true );
				masterCanvas1.commentVisible();
				selectPDFBtn.visible = selectPDFBtn.includeInLayout = false;
				if(toolBox.toolBoxExpand)
				{
					toolBox.close();
				}
				toolBox.visible = false;
				if(commentList.openStatus)
				{
					commentListToggleBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
				commentListLayoutHBox.visible = commentListLayoutHBox.includeInLayout = false;
			}
			togglePDFStatus = !togglePDFStatus;
			// End-- Toggle Page Start 
		}
		private function onNormalCompare(event:MouseEvent):void
		{
			compareStatus = compareBtn.selected;
			if(compareBtn.selected){
				if(!regionCompareStatus){
					masterCanvas1.singlePage.onNormalCompare();	
				}
				else
				{
					
					var xVal:Number = masterCanvas.singlePage.regionXpos - masterCanvas1.singlePage.regionXpos;
					var yVal:Number = masterCanvas.singlePage.regionYpos - masterCanvas1.singlePage.regionYpos;  
					masterCanvas1.singlePage.onRegionCompare(xVal, yVal);
					masterCanvas.singlePage.regionPointer.visible = false;
					masterCanvas1.singlePage.regionPointer.visible = false;
					regionResetStatus = true;
					regionPointerBtn.visible = regionPointerBtn.includeInLayout = false;
					regionResetBtn.visible = regionResetBtn.includeInLayout = true;
				}
				if(doubleViewStatus)
				{
					doubleViewBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
				if(togglePDFStatus)
				{
					togglePDFBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
				compareImageAlphaControllerHBox.width = 280;
				firstPDFHSlider.value = secondPDFHSlider.value = 0;
				diffPDFHSlider.value = 1;
				masterCanvas1.commentVisible();
				if(toolBox.toolBoxExpand)
				{
					toolBox.close();
				}
				masterCanvas1.singlePage.focusAction = SinglePageCanvas.NONE;
				toolBox.visible = false;
				if(commentList.openStatus)
				{
					commentListToggleBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}
				selectPDFBtn.visible = selectPDFBtn.includeInLayout = false;
				commentListLayoutHBox.visible = commentListLayoutHBox.includeInLayout = false;
				noteOnOff.visible = noteOnOff.includeInLayout = false;
				doubleViewBtn.visible = doubleViewBtn.includeInLayout = false;
				togglePDFBtn.visible = togglePDFBtn.includeInLayout = false;
				regionCompareSelectBtn.visible = regionCompareSelectBtn.includeInLayout = false;
				regionPointerBtn.visible = regionPointerBtn.includeInLayout = false;
				regionResetBtn.visible = regionResetBtn.includeInLayout = false;
				regionCompareSelectBtn.selected = false;
				
			}
			else
			{
				masterCanvas1.selectPDF = SinglePageCanvas.PDF2;
				selectPDFBtn.visible = selectPDFBtn.includeInLayout = true;
				selectPDFBtn.selected = false;
				selectPDFBtn.toolTip = "Select First PDF";
				masterCanvas1.commentVisible(true);
				compareImageAlphaControllerHBox.width = 0;
				noteOnOff.visible = noteOnOff.includeInLayout = true;
				doubleViewBtn.visible = doubleViewBtn.includeInLayout = true;
				togglePDFBtn.visible = togglePDFBtn.includeInLayout = true;
				regionCompareSelectBtn.visible = regionCompareSelectBtn.includeInLayout = true;
				masterCanvas1.singlePage.onNormalCompare(false);
				toolBox.visible = true;
				noteOnOff.selected = false;
				commentListLayoutHBox.visible = commentListLayoutHBox.includeInLayout = true;
			}
			
			masterCanvas1.compareStatus = compareBtn.selected;
		}
		private function onRegionCompareSelect(event:MouseEvent):void
		{
			//regionResetBtn.visible = regionResetBtn.includeInLayout = true;
			if(!doubleViewStatus)
			{
				doubleViewBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			if(toolBox.toolBoxExpand)
			{
				toolBox.close();
			}
			masterCanvas1.singlePage.focusAction = SinglePageCanvas.NONE;
			//if(compareBtn.selected) compareBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			if(regionResetStatus)
			{
				regionPointerBtn.visible = regionPointerBtn.includeInLayout = false;
				regionResetBtn.visible = regionResetBtn.includeInLayout = regionCompareSelectBtn.selected;
				masterCanvas1.singlePage.focusAction = SinglePageCanvas.NONE;
				masterCanvas.singlePage.regionPointer.visible = false;
				masterCanvas1.singlePage.regionPointer.visible = false;
				
			}
			else{
				masterCanvas.singlePage.regionPointer.visible = true;
				masterCanvas1.singlePage.regionPointer.visible = true;
				masterCanvas.singlePage.regionXpos = masterCanvas1.singlePage.regionXpos = 0;
				masterCanvas.singlePage.regionYpos = masterCanvas1.singlePage.regionYpos = 0;
				regionPointerBtn.visible = regionPointerBtn.includeInLayout = regionCompareSelectBtn.selected;
				regionResetBtn.visible = regionResetBtn.includeInLayout = false;
			}
			toolBox.visible = !regionCompareSelectBtn.selected;
			regionCompareStatus = regionCompareSelectBtn.selected;
			 if(!regionCompareSelectBtn.selected) 
			{
				masterCanvas.singlePage.regionPointer.visible = false;
				masterCanvas1.singlePage.regionPointer.visible = false;	
			}
			else
			{
				masterCanvas.singlePage.regionPointer.visible = !regionResetStatus;
				masterCanvas1.singlePage.regionPointer.visible = !regionResetStatus;
			} 
		}
		private function onRegionPointer(event:MouseEvent):void
		{
			masterCanvas.singlePage.regionXpos = masterCanvas.singlePage.regionYpos = 0;
			masterCanvas1.singlePage.regionXpos = masterCanvas1.singlePage.regionYpos = 0;
			masterCanvas.singlePage.regionPointer.visible = true;
			masterCanvas1.singlePage.regionPointer.visible = true;
			masterCanvas1.singlePage.focusAction = SinglePageCanvas.NONE;
		}
		private function onRegionReset(event:MouseEvent):void
		{
			regionResetStatus = false;
			regionPointerBtn.visible = regionPointerBtn.includeInLayout = true;
			regionResetBtn.visible = regionResetBtn.includeInLayout = false;
			regionPointerBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			masterCanvas1.singlePage.onRegionReset();
			/* if(!doubleViewStatus)
			{
				doubleViewBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			if(compareBtn.selected)
			{
				compareBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			} */
			commentListLayoutHBox.visible = commentListLayoutHBox.includeInLayout = false;
		}
		private function useHandCursorAction(target:Button, toolTipStr:String = "", value:Boolean=true):void
		{ 
			target.buttonMode = value;
			target.useHandCursor = value;
			target.tabEnabled = false;
			target.focusEnabled = false;
			target.toolTip = toolTipStr
		}
		private function onImageLoadComplete(event:Event):void
		{
			preloaderImg.visible = false;
			masterCanvas.externalCanvas.visible = firstTime;
			masterCanvas.singlePage.visible = true;
			masterCanvas1.externalCanvas.visible = firstTime;
			masterCanvas1.singlePage.visible = true;
			masterCanvas.linkFunc();
			masterCanvas1.linkFunc();
			trace("onImageLoadComplete")
		}
	}
}
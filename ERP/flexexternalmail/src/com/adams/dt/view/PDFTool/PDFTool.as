package com.adams.dt.view.PDFTool
{
	import com.adams.dt.business.util.InternalPNGEncoder;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.view.PDFTool.events.ToolBoxEvent;
	
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
	
	import org.alivepdf.colors.RGBColor;
	import org.alivepdf.data.Grid;
	import org.alivepdf.data.GridColumn;
	import org.alivepdf.drawing.Joint;
	import org.alivepdf.fonts.FontFamily;
	import org.alivepdf.fonts.Style;
	import org.alivepdf.layout.Align;
	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	import org.alivepdf.saving.Method;
	
	import com.adams.dt.business.util.InternalPNGEncoder;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.model.ModelLocator;
	
	import com.adams.dt.view.PDFTool.events.ToolBoxEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.FileReference;
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
	
	import org.alivepdf.colors.RGBColor;
	import org.alivepdf.data.Grid;
	import org.alivepdf.data.GridColumn;
	import org.alivepdf.drawing.Joint;
	import org.alivepdf.fonts.FontFamily;
	import org.alivepdf.fonts.Style;
	import org.alivepdf.layout.Align;
	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.saving.Method;

	public class PDFTool extends Canvas
	{
		
		[Bindable]
		private var model : ModelLocator = ModelLocator.getInstance();
		
		private var masterLayoutHBox:HBox = new HBox();
		private var toolBoxLayoutHBox:HBox = new HBox();
		private var doubleViewBtn:Button = new Button();
		private var togglePDFBtn:Button = new Button();
		private var selectPDFBtn:Button = new Button();
		private var compareBtn:Button = new Button();
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
		
		private var firstPDFHSlider:HSlider = new HSlider();
		private var secondPDFHSlider:HSlider = new HSlider();
		private var diffPDFHSlider:HSlider = new HSlider();
		
		public var masterCanvas:MasterContainer = new MasterContainer();
		public var masterCanvas1:MasterContainer = new MasterContainer(); 
		public var toolBox:ToolBox = new ToolBox();
		
		public var commentList:CommentList = new CommentList();
		private var commentListLayoutHBox:HBox = new HBox();
		private var commentListToggleBtn:Button = new Button();
		
		private var fileReferenceimp:FileReference;  
		
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
		
		
		
		private var _img1URL:String;
		[Bindable]
		public function set img1URL (value:String):void
		{
			_img1URL = value;
			trace("Path1 : "+value);
			pdfName = value; 
				compareMode = false;
			resetAll();  
			
			doubleViewBtn.visible = doubleViewBtn.includeInLayout = false;
			togglePDFBtn.visible = togglePDFBtn.includeInLayout = false;
			selectPDFBtn.visible = selectPDFBtn.includeInLayout = false;
			compareBtn.visible = compareBtn.includeInLayout = false;
			regionCompareSelectBtn.visible = regionCompareSelectBtn.includeInLayout = false;
			commentList.compareMode = false;
			commentList.pdffile = SinglePageCanvas.PDF2;
			
			masterCanvas.img1URL= value;
			masterCanvas1.img1URL= value;
		}
		private var pdfName:String="MailPDF";
		
		public function get img1URL ():String
		{
			return _img1URL;
		}

		private var _img2URL:String;
		[Bindable]
		public function set img2URL (value:String):void
		{
			_img2URL = value;
			resetAll();
			pdfName = value;
			trace("Path2 : "+value+" ::: "+model.currentTasks.taskFilesPath+" :: "+model.currentTasks.previousTask.taskFilesPath);
			masterCanvas.img2URL= value;
			masterCanvas1.img2URL= value; 
			masterCanvas1.singlePage.focusAction = SinglePageCanvas.NONE;
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
			
			commentListLayoutHBox.addChild(commentListToggleBtn);
			commentListLayoutHBox.addChild(commentList);
			commentListLayoutHBox.percentHeight = 100;
			commentListLayoutHBox.setStyle("horizontalGap","0");
			commentListLayoutHBox.setStyle("right","0");
			commentListLayoutHBox.setStyle("horizontalAlign","right");
			commentListToggleBtn.styleName = "NoteListOpenClose";
			commentListToggleBtn.toggle = true;
			commentListToggleBtn.selected = true;
			useHandCursorAction(commentListToggleBtn);
			
			commentList.addEventListener(CommentList.TAB_CHANGE, onCommentListTabChange);			 
			commentListToggleBtn.addEventListener(MouseEvent.CLICK,onCommentListOpenCloseAction); 
			
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
			toolBoxLayoutHBox.setStyle("backgroundColor","#222222"); 
			
			doubleViewBtn.styleName = "doublePageView";
			doubleViewBtn.toggle = true;
			useHandCursorAction(doubleViewBtn);
			
			togglePDFBtn.styleName = "PlayPauseSkin";
			togglePDFBtn.toggle = true;
			useHandCursorAction(togglePDFBtn);
			
			selectPDFBtn.styleName = "selectPDFSkin";
			selectPDFBtn.toggle = true;
			useHandCursorAction(selectPDFBtn);
			
			pdfDownloadBtn.styleName = "SaveToolSkin";
			useHandCursorAction(pdfDownloadBtn);
			
			compareBtn.styleName = "NormalCompareSkin";
			compareBtn.toggle = true;
			useHandCursorAction(compareBtn);
			
			regionCompareSelectBtn.styleName = "RegionCompareSelectSkin";
			regionCompareSelectBtn.toggle = true;
			useHandCursorAction(regionCompareSelectBtn);
			
			regionPointerBtn.styleName = "dotSkin";
			useHandCursorAction(regionPointerBtn);
			regionPointerBtn.visible = regionPointerBtn.includeInLayout = false;
			
			regionResetBtn.styleName = "RegionResetSkin";
			useHandCursorAction(regionResetBtn);
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
			
			rotateClockwiseBtn.addEventListener(MouseEvent.CLICK,onRotate);
			rotateCounterClockwiseBtn.addEventListener(MouseEvent.CLICK,onRotate);
			zoomInBtn.addEventListener(MouseEvent.MOUSE_DOWN,onZoom);
			zoomOutBtn.addEventListener(MouseEvent.MOUSE_DOWN,onZoom);
			pdfDownloadBtn.addEventListener(MouseEvent.MOUSE_DOWN,downloadPdf);
			
			useHandCursorAction(rotateClockwiseBtn);
			useHandCursorAction(rotateCounterClockwiseBtn);
			useHandCursorAction(zoomInBtn);
			useHandCursorAction(zoomOutBtn);
			
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
			
			masterCanvas1.addEventListener(MasterContainer.ZOOM_IN, onZoomIn);
			masterCanvas1.addEventListener(MasterContainer.ZOOM_OUT, onZoomOut);
			
			masterCanvas.addEventListener(MasterContainer.ZOOM_IN, onZoomInFirst);
			masterCanvas.addEventListener(MasterContainer.ZOOM_OUT, onZoomOutFirst); 
			
			toolBox.addEventListener(ToolBoxEvent.SELECTED_TOOL, onToolSelect);
			doubleViewBtn.addEventListener(MouseEvent.CLICK, onDoubleView);
			togglePDFBtn.addEventListener(MouseEvent.CLICK, onTogglePDF);
			selectPDFBtn.addEventListener(MouseEvent.CLICK, onSelectPDF);
			compareBtn.addEventListener(MouseEvent.CLICK, onNormalCompare);
			regionCompareSelectBtn.addEventListener(MouseEvent.CLICK, onRegionCompareSelect);
			regionPointerBtn.addEventListener(MouseEvent.CLICK, onRegionPointer);
			regionResetBtn.addEventListener(MouseEvent.CLICK, onRegionReset);
			
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
			
			firstPDFImg.source = null;//ImageResourceEmbedClass.FIRST_PDF_ICON;
			secondPDFImg.source = null;// ImageResourceEmbedClass.SECOND_PDF_ICON;
			diffPDFImg.source =  null;//ImageResourceEmbedClass.DIFF_PDF_ICON
			
			firstPDFHSlider.minimum = secondPDFHSlider.minimum = diffPDFHSlider.minimum = 0;
			firstPDFHSlider.maximum = secondPDFHSlider.maximum = diffPDFHSlider.maximum = 1;
			
			firstPDFHSlider.width = secondPDFHSlider.width = diffPDFHSlider.width = 50;
			firstPDFHSlider.tickInterval = secondPDFHSlider.tickInterval = diffPDFHSlider.tickInterval = 0.1;
			firstPDFHSlider.liveDragging = secondPDFHSlider.liveDragging = diffPDFHSlider.liveDragging = true;
			firstPDFHSlider.dataTipFormatFunction = secondPDFHSlider.dataTipFormatFunction = diffPDFHSlider.dataTipFormatFunction = SliderTooltip;
			
			firstPDFHSlider.addEventListener(SliderEvent.CHANGE, onFirstHSChange);
			secondPDFHSlider.addEventListener(SliderEvent.CHANGE, onSecondHSChange);
			diffPDFHSlider.addEventListener(SliderEvent.CHANGE, onDiffHSChange);
			
			masterCanvas1.setStyle("right","0");
			setStyle("backgroundColor","#000000");
			toolVisibleStatus(compareMode);
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
		}
		private function onZoomOut(event:Event):void
		{
			masterCanvas.singlePage.scaleAt(5/6, masterCanvas1.mouseX, masterCanvas1.mouseY, "Manual");
			masterCanvas.singlePage.x=masterCanvas1.singlePage.x;
			masterCanvas.singlePage.y=masterCanvas1.singlePage.y;
		}
		private function onZoomInFirst(event:Event):void
		{
			masterCanvas1.singlePage.scaleAt(6/5, masterCanvas.mouseX, masterCanvas.mouseY, "Manual");
			masterCanvas1.singlePage.x=masterCanvas.singlePage.x;
			masterCanvas1.singlePage.y=masterCanvas.singlePage.y;
		}
		private function onZoomOutFirst(event:Event):void
		{
			masterCanvas1.singlePage.scaleAt(5/6, masterCanvas.mouseX, masterCanvas.mouseY, "Manual");
			masterCanvas1.singlePage.x=masterCanvas.singlePage.x;
			masterCanvas1.singlePage.y=masterCanvas.singlePage.y;
		}
		private function toolVisibleStatus(value:Boolean):void
		{
			value = false;
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
		private function resetAll():void
		{
			if(!commentList.openStatus)
			{
				commentListToggleBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
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
			toolBox.arrowBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			regionPointerBtn.visible = regionPointerBtn.includeInLayout = false;
			masterCanvas.singlePage.regionPointer.visible = false;
			masterCanvas1.singlePage.regionPointer.visible = false;
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
		}
		private function onTogglePDF(event:MouseEvent):void
		{
			if(togglePDFStatus)
			{
				// Toggle Page Stop 
				masterCanvas1.singlePage.togglePDF( false );
				masterCanvas1.commentVisible(true);
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
				doubleViewBtn.visible = doubleViewBtn.includeInLayout = true;
				togglePDFBtn.visible = togglePDFBtn.includeInLayout = true;
				regionCompareSelectBtn.visible = regionCompareSelectBtn.includeInLayout = true;
				masterCanvas1.singlePage.onNormalCompare(false);
				toolBox.visible = true;
				commentListLayoutHBox.visible = commentListLayoutHBox.includeInLayout = true;
			}
			
			masterCanvas1.compareStatus = compareBtn.selected;
		}
		private function onRegionCompareSelect(event:MouseEvent):void
		{
			if(!doubleViewStatus)
			{
				doubleViewBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			if(toolBox.toolBoxExpand)
			{
				toolBox.close();
			}
			masterCanvas1.singlePage.focusAction = SinglePageCanvas.NONE; 
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
		private function useHandCursorAction(target:Button, value:Boolean=true):void
		{
			target.buttonMode = value;
			target.useHandCursor = value;
		}
		private function downloadPdf(event:MouseEvent):void{
			
			var myPDF : PDF = new PDF ( Orientation.PORTRAIT, Unit.POINT, new Size([masterCanvas1.singlePage.img2.imgWidth, masterCanvas1.singlePage.img2.imgHeight],"Custom",[],[]) );
			myPDF.addPage();
			      
			masterCanvas1.singlePage.makeMarkersVisible();
     
			var image:ImageSnapshot = ImageSnapshot.captureImage(masterCanvas1.singlePage.img2, 300, new InternalPNGEncoder());
 			myPDF.addImageStream(image.data,0,0,masterCanvas1.singlePage.img2.imgWidth, masterCanvas1.singlePage.img2.imgHeight);
  			masterCanvas1.singlePage.removeMarkers();
			 
				
			var objectArray:Array = getObjectArray( masterCanvas1.commentsPdf ); 
	        if(masterCanvas1.commentsPdf.length>0){
	           	myPDF.addPage();
	            myPDF.textStyle( new RGBColor(0), 1 );  
	            myPDF.setFont( FontFamily.ARIAL, Style.NORMAL, 6 );
				var grid:Grid = new Grid( objectArray, masterCanvas1.singlePage.imgHeight, masterCanvas1.singlePage.imgHeight, new RGBColor( 0x666666 ), new RGBColor( 0xCCCCCC ), new RGBColor( 0 ), true, new RGBColor( 0x0 ), 1, Joint.MITER );
	            grid.columns = getPdfGridColumns(masterCanvas1.commentsGrid.columns);
	            myPDF.addGrid( grid, 0, 0); 
	        }
			gBytes = myPDF.save( Method.LOCAL ); 
				  
	        pdfName = model.modelFileDetailsVo.fileName;
	        pdfName = pdfName.substr(0,pdfName.length-4);
	        var fr:FileReference = new FileReference( );
			fr.save( gBytes, pdfName+'.pdf' );
			 
		}
		 private var gBytes:ByteArray = new ByteArray(); 
			 
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
		public function indSaveMessage():void
		{	      		
      		if(model.modelINDPreviewByteArrray!=null && model.modelINDPreviewFileVo!=null)  {
      			fileReferenceimp = new FileReference(); 
      			fileReferenceimp.save(model.modelINDPreviewByteArrray,model.modelINDPreviewFileVo.fileName);
      		}       		
			
		} 
	}
}
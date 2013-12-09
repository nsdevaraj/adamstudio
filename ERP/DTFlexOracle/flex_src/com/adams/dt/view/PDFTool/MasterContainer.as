package com.adams.dt.view.PDFTool
{
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.PDFTool.CommentVO;
	
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.DataGrid;
	import mx.events.CollectionEvent;
	import mx.events.EffectEvent;
	import mx.events.ResizeEvent;
	[Event(name="zoomIn", type="flash.events.Event")]
	[Event(name="zoomOut", type="flash.events.Event")]
	[Event(name="imgLoadingComplete", type="flash.events.Event")]

	public class MasterContainer extends Canvas
	{
		
		[Bindable]
		private var model : ModelLocator = ModelLocator.getInstance();
		
		[Bindable]
		public var commentShowStatus:Boolean = true;
		
		public static const ZOOM_IN:String="zoomIn";
		public static const ZOOM_OUT:String="zoomOut";
		public static const IMAGE_LOADING_COMPLETE:String="imgLoadingComplete";
				
		public var singlePage:SinglePageCanvas = new SinglePageCanvas();
		public var externalCanvas:Canvas = new Canvas();
		
		[Bindable]
		public var compareStatus:Boolean = false;
		
		private var _img1URL:String;
		[Bindable]
		public function set img1URL (value:String):void
		{ 
			_img1URL = value;
			singlePage.img1URL = value;
		}
		
		public function get img1URL ():String
		{
			return _img1URL;
		}

		private var _img2URL:String;
		[Bindable]
		public function set img2URL (value:String):void
		{
			_img2URL = value;
			singlePage.img2URL = value;
		}

		public function get img2URL ():String
		{
			return _img2URL;
		}
		
		
		private var _selectPDF:Number;
		[Bindable]
		public function set selectPDF (value:Number):void
		{
			_selectPDF = value;
			if(commentShowStatus){
				linkFunc();
			}
			singlePage.selectPDF = value;
		}

		public function get selectPDF ():Number
		{
			return _selectPDF;
		}
		
		
		private var _togglePDF:Boolean=false;
		[Bindable]
		public function set togglePDF (value:Boolean):void
		{
			_togglePDF = value;
			singlePage.togglePDF( value );
		}

		public function get togglePDF ():Boolean
		{
			return _togglePDF;
		}
		
		private var _imgX:Number=0;
		[Bindable]
		public function set imgX (value:Number):void
		{
			_imgX = value;
		}

		public function get imgX ():Number
		{
			return _imgX;
		}
		
		private var _imgY:Number=0;
		[Bindable]
		public function set imgY (value:Number):void
		{
			_imgY = value;
		}

		public function get imgY ():Number
		{
			return _imgY;
		}

		
		private var _rotateValue:Number=0;
		[Bindable]
		public function set rotateValue (value:Number):void
		{
			_rotateValue = value;
		}

		public function get rotateValue ():Number
		{
			return _rotateValue;
		}
		
		private var _scaleValue:Number=1;
		[Bindable]
		public function set scaleValue (value:Number):void
		{
			_scaleValue = value;
		}

		public function get scaleValue ():Number
		{
			return _scaleValue;
		}
		
		private var _commentType:String;
		[Bindable]
		public function set commentType (value:String):void
		{
			_commentType = value;
		}

		public function get commentType ():String
		{
			return _commentType;
		}
		
		private var _dataProvider:ArrayCollection=new ArrayCollection();
		[Bindable]
		public function set dataProvider (value:ArrayCollection):void
		{
			trace("Welcome MasterCanvas")
			//singlePage.resetAll();
			_dataProvider.list = value.list;
		}

		public function get dataProvider ():ArrayCollection
		{
			return _dataProvider;
		}
		
		public function MasterContainer()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			addChild(singlePage);
			addChild(externalCanvas);
			//addChild(commentCanvas);
			
			
			externalCanvas.percentWidth = 100;
			externalCanvas.percentHeight = 100;
			
			externalCanvas.mouseChildren = true;
			externalCanvas.mouseEnabled = true;
			
			singlePage.addEventListener(SinglePageCanvas.PAGE_ASSETS_PROPERTIES_CHANGE, onPagePropertiesChange,false,0,true);
			singlePage.addEventListener(SinglePageCanvas.ZOOM_IN, onZoomIn,false,0,true);
			singlePage.addEventListener(SinglePageCanvas.ZOOM_OUT, onZoomOut,false,0,true);
			singlePage.addEventListener(SinglePageCanvas.IMAGE_LOADING_COMPLETE, onImageLoadComplete,false,0,true);
			dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onDataProviderChange,false,0,true);
			BindingUtils.bindProperty(singlePage, "commentType", this, "commentType");

			this.horizontalScrollPolicy = externalCanvas.horizontalScrollPolicy ="off";
			this.verticalScrollPolicy = externalCanvas.verticalScrollPolicy = "off";
			
			setStyle("backgroundColor","#424242");
			setStyle("backgroundAlpha","1");
			
			this.addEventListener(EffectEvent.EFFECT_END, onEffectEnd,false,0,true);
			this.addEventListener(ResizeEvent.RESIZE, onResizeAction,false,0,true);
			
			singlePage.commentCanvas 
			
			var dropShadow:DropShadowFilter = new DropShadowFilter(8,45,0,0.5,8,8,1,1,true);
			
			filters = [dropShadow];
			
			
			
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			if(!compareStatus && commentShowStatus){
				linkFunc();
			}
			
		}
		private function onResizeAction(event:ResizeEvent):void
		{
			/* 
			centerPosition()
			if(!compareStatus){
				linkFunc();
			}  */	
		}
		
		private function centerPosition():void
		{
			singlePage.x = this.width/2 - (singlePage.imgWidth*singlePage.rotateScaleValue())/2;
		}
		private var historyTempCollection:ArrayCollection;
		public var commentsPdf:ArrayCollection=new ArrayCollection();
		public var commentsGrid:DataGrid = new DataGrid();
		private function onDataProviderChange(event:CollectionEvent):void
		{
			singlePage.img2.pdfCommentList.removeAllChildren();
			singlePage.commentCanvas.removeAllChildren();
			externalCanvas.removeAllChildren();
			externalCanvas.graphics.clear();
			var markerIndex:Number=1;
 			singlePage.NoteNumbers=1;
			singlePage.drawingCanvas.graphics.clear();
			var i:int;
			var j:int;
			historyTempCollection = new ArrayCollection();
			
			commentsPdf = new ArrayCollection();
			for(i=0;i<event.target.length; i++)
			{
				var commentobj:Object = new Object();
				commentobj.Type ="";
				commentobj.Comment = "";
				// External Comment Box Adding
				var commentDetail : CommentVO =  model.pdfDetailVO.commentListArrayCollection.getItemAt(i) as CommentVO;
				trace("commentDetail ID : "+commentDetail.commentID)
				var cPDF:Number = Number((commentDetail.filefk == model.currentSwfFile.remoteFileFk)?"2":"1");
				if(commentDetail.history == 0){
					
					var cType:String = ((Number(commentDetail.commentType)==SinglePageCanvas.RECTANGLE_NOTE_INT)?SinglePageCanvas.RECTANGLE_NOTE:(Number(commentDetail.commentType)==SinglePageCanvas.VERTICAL_NOTE_INT)?SinglePageCanvas.VERTICAL_NOTE:(Number(commentDetail.commentType)==SinglePageCanvas.HORIZONTAL_NOTE_INT)?SinglePageCanvas.HORIZONTAL_NOTE:SinglePageCanvas.SHAPE_NOTE);
					if(cType != SinglePageCanvas.SHAPE_NOTE){
						var commentBox:CommentBox = new CommentBox();
						commentBox.x = commentDetail.commentBoxX;
						commentBox.y = commentDetail.commentBoxY;
						//commentBox.addEventListener(CommentItem.COMMENT_MOVE, function (event:Event):void{ trace('Move');linkFunc(); },false,0,true);
						commentBox.addEventListener(CommentItem.COMMENT_MOVE, function (event:Event):void{ trace('Move');linkFunc(); });
						externalCanvas.addChild(commentBox);	
						// Comment Item Adding in Page
						var commentItem:CommentItem = new CommentItem();
						commentBox.commentTargetName = commentItem.name;
						commentBox.commentVO = commentDetail;
						commentBox.pdf = cPDF;
						commentBox.title = commentDetail.commentTitle;
						commentBox.description =""+String(commentDetail.commentDescription);
						commentBox.profile = commentDetail.misc;
						commentBox.historyCollection.addItem(commentDetail);
						commentItem.pdf = cPDF;
						if(singlePage.isLastCommentIsNew && (i==(event.target.length-1))){
							commentBox.editFirstTime();
							singlePage.isLastCommentIsNew = false;
						}
						
						commentItem.commentVO = commentDetail;
						commentItem.x = commentDetail.commentX;
						commentItem.y = commentDetail.commentY;
						commentItem.fillColor = commentDetail.commentColor;
						commentItem.commentWidth = commentDetail.commentWidth;
						commentItem.commentHeight = commentDetail.commentHeight;
						commentItem.commentType = cType;
						
						
						if(cPDF!=SinglePageCanvas.PDF1){
							commentItem.addEventListener(CommentItem.COMMENT_MOVE, function (event:Event):void{ linkFunc(); },false,0,true);
						}
						
						singlePage.commentCanvas.addChild(commentItem);
						
						if(cPDF == SinglePageCanvas.PDF2){
							singlePage.drawFromString(String(commentDetail.commentDescription), drawingItem);
							singlePage.DrawNoteCircle(commentDetail.commentX, commentDetail.commentY,1);
						}
						
						commentobj.Comment += String(commentDetail.commentDescription);
					}
					else{
						
						var drawingItem:DrawingSprite = new DrawingSprite();
						drawingItem.commentID = commentDetail.commentID;
						drawingItem.pdf = cPDF;
						singlePage.commentCanvas.addChild(drawingItem);  
						singlePage.drawFromString(String(commentDetail.commentDescription), drawingItem);
						var commentBox:CommentBox = new CommentBox();
						commentBox.x = commentDetail.commentBoxX;
						commentBox.y = commentDetail.commentBoxY;
						trace("Comm commentBoxX : "+commentDetail.commentBoxX+' >>> '+commentDetail.commentBoxX);
						
						trace("Comm : "+commentDetail.commentX+' >>> '+commentDetail.commentBoxY+' >>> ' +commentDetail.commentType);
						
						//commentBox.addEventListener(CommentItem.COMMENT_MOVE, function (event:Event):void{ trace('Move');linkFunc(); },false,0,true);
						commentBox.addEventListener(CommentItem.COMMENT_MOVE, function (event:Event):void{ trace('Move');linkFunc(); });
						externalCanvas.addChild(commentBox);	
						// Comment Item Adding in Page
						var commentItem:CommentItem = new CommentItem();
						commentBox.commentTargetName = commentItem.name;
						commentBox.commentVO = commentDetail;
						commentBox.pdf = cPDF;
						commentBox.title = commentDetail.commentTitle;
						commentBox.description =""+String(commentDetail.commentDescription);
						commentBox.profile = commentDetail.misc;
						commentBox.historyCollection.addItem(commentDetail);
						commentobj.Comment += String(commentDetail.commentDescription).split(SinglePageCanvas.SHAPE_FIRST_NOTE_SPLITTER)[1];
					}
					if(cPDF == SinglePageCanvas.PDF2){
						commentobj.Id = markerIndex;
						commentobj.CommentID = commentDetail.commentID;
						commentobj.Type = commentDetail.commentTitle;
						commentobj.Date = commentDetail.creationDate.toDateString();
						commentobj.CreatedBy = GetVOUtil.getPersonObject(commentDetail.createdby).personFirstname;
						markerIndex++;
					}
				}
				else{
					historyTempCollection.addItem(commentDetail);
					commentobj.Id = 0;
					commentobj.Type = commentDetail.commentTitle;
					commentobj.CommentID = commentDetail.history;
					commentobj.Comment += String(commentDetail.commentDescription) 
					commentobj.CreatedBy =  GetVOUtil.getPersonObject(commentDetail.createdby).personFirstname;
					commentobj.Date = commentDetail.creationDate.toDateString();
				}
				if(cPDF == SinglePageCanvas.PDF2){
					commentsPdf.addItem(commentobj);
				}
			}
			for(i=0;i<externalCanvas.numChildren;i++){
				for(j=0;j<historyTempCollection.length;j++){
					if(CommentBox(externalCanvas.getChildAt(i)).commentVO.commentID == CommentVO(historyTempCollection.getItemAt(j)).history){
						CommentBox(externalCanvas.getChildAt(i)).historyCollection.addItem(historyTempCollection.getItemAt(j));
					}
				}
			} 
			linkFunc();
			commentsGrid.percentHeight =100;
			commentsGrid.percentWidth =100;
			if(commentsPdf.length>0){
				commentsGrid.dataProvider = commentsPdf;
			}
			else{
				commentsGrid.dataProvider = null;
			}
			dispatchEvent(new Event(IMAGE_LOADING_COMPLETE));
		}
		
		public function commentVisible(value:Boolean = false):void
		{
			if(value){
				linkFunc();	
			}
			else
			{
				externalCanvas.graphics.clear();
				for(var j:Number=0;j<externalCanvas.numChildren;j++)
				{
					externalCanvas.getChildAt(j).visible = false;
				}
				for(var k:Number=0;k<singlePage.commentCanvas.numChildren;k++)
				{
					singlePage.commentCanvas.getChildAt(k).visible = false;
				}	
			}
		}
		public function linkFunc():void
		{
				
			externalCanvas.graphics.clear();
			externalCanvas.graphics.lineStyle(1,0xFF0000);
			externalCanvas.graphics.beginFill(0xFF0000,0.5);
			for(var j:Number=0;j<externalCanvas.numChildren;j++)
			{
				externalCanvas.getChildAt(j).visible = false;
			}
			for(var k:Number=0;k<singlePage.commentCanvas.numChildren;k++)
			{
				if(singlePage.commentCanvas.getChildAt(k) is CommentItem)
				{
					CommentItem(singlePage.commentCanvas.getChildAt(k)).visible = (CommentItem(singlePage.commentCanvas.getChildAt(k)).pdf == this.selectPDF);
				}
				if(singlePage.commentCanvas.getChildAt(k) is DrawingSprite)
				{
					DrawingSprite(singlePage.commentCanvas.getChildAt(k)).visible = (DrawingSprite(singlePage.commentCanvas.getChildAt(k)).pdf == this.selectPDF);
				} 
			}
			for(var i:Number=0;i<externalCanvas.numChildren;i++)
			{
				if(CommentBox(externalCanvas.getChildAt(i)).pdf == this.selectPDF){
					var scaleVal:Number = 1;
					var rotateVal:Number = singlePage.rotation;
					var xPos:Number = 0;
					var yPos:Number = 0; 
					CommentBox(externalCanvas.getChildAt(i)).visible = true;
					scaleVal= singlePage.rotateScaleValue();
					if(CommentBox(externalCanvas.getChildAt(i)).commentVO.commentType == SinglePageCanvas.SHAPE_NOTE_INT){
						trace("Link Func Shape Type ::: >")
						trace(CommentBox(externalCanvas.getChildAt(i)).commentVO.commentX)
						trace(CommentBox(externalCanvas.getChildAt(i)).commentVO.commentY)
					}
					if(Math.round(rotateVal) == 0 || Math.round(rotateVal) == -180 || Math.round(rotateVal) == 180)
					{
						scaleVal = ((Math.round(rotateVal) == -180 || Math.round(rotateVal) == 180)?-1:1)*scaleVal;
						//scaleVal= singlePage.rotateScaleValue();
						trace("singlePage.commentCanvas.getChildByName(CommentBox(externalCanvas.getChildAt(i)).commentTargetName) :\n"+singlePage.commentCanvas.getChildByName(CommentBox(externalCanvas.getChildAt(i)).commentTargetName))
						if(CommentBox(externalCanvas.getChildAt(i)).commentVO.commentType != SinglePageCanvas.SHAPE_NOTE_INT){
							xPos = singlePage.x+singlePage.commentCanvas.getChildByName(CommentBox(externalCanvas.getChildAt(i)).commentTargetName).x * scaleVal;
							yPos = singlePage.y+singlePage.commentCanvas.getChildByName(CommentBox(externalCanvas.getChildAt(i)).commentTargetName).y * scaleVal;
						}
						else{
							xPos = singlePage.x+CommentBox(externalCanvas.getChildAt(i)).commentVO.commentX * scaleVal;
							yPos = singlePage.y+CommentBox(externalCanvas.getChildAt(i)).commentVO.commentY * scaleVal;
						}
					}else{
						if(CommentBox(externalCanvas.getChildAt(i)).commentVO.commentType != SinglePageCanvas.SHAPE_NOTE_INT){
							xPos = singlePage.x+singlePage.commentCanvas.getChildByName(CommentBox(externalCanvas.getChildAt(i)).commentTargetName).y * ((((Math.round(rotateVal) == 90)?-1:1))*scaleVal);
							yPos = singlePage.y+singlePage.commentCanvas.getChildByName(CommentBox(externalCanvas.getChildAt(i)).commentTargetName).x * ((((Math.round(rotateVal) == -90)?-1:1))*scaleVal);
						}
						else{
							xPos = singlePage.x+CommentBox(externalCanvas.getChildAt(i)).commentVO.commentY * ((((Math.round(rotateVal) == 90)?-1:1))*scaleVal);
							yPos = singlePage.y+CommentBox(externalCanvas.getChildAt(i)).commentVO.commentX * ((((Math.round(rotateVal) == -90)?-1:1))*scaleVal);
						}
					}
					
					var x2:Number = xPos;
					var y2:Number = yPos;
					
					externalCanvas.graphics.moveTo(externalCanvas.getChildAt(i).x,externalCanvas.getChildAt(i).y+10);
					externalCanvas.graphics.lineTo(x2,y2);
					externalCanvas.graphics.drawCircle(x2,y2,5);
				}
			}
		}
		
		private function onEffectEnd(event:EffectEvent):void
        {
        	clearStyle("resizeEffect");
        }
        
		private function onPagePropertiesChange( event:Event ):void
		{
			imgX = singlePage.x;
			imgY = singlePage.y;
			rotateValue = singlePage.rotation;
			scaleValue = singlePage.scaleValue;
			if(!compareStatus && commentShowStatus){
			 linkFunc(); 
			}
		}
		
		private function onZoomIn(event:Event):void
		{
			dispatchEvent(new Event(ZOOM_IN));
		}
		
		private function onZoomOut(event:Event):void
		{
			dispatchEvent(new Event(ZOOM_OUT));
		}
		private function onImageLoadComplete(event:Event):void
		{
			dispatchEvent(new Event(IMAGE_LOADING_COMPLETE));
		}
	}
}
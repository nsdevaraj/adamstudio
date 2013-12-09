package com.adams.dt.view.PDFTool
{
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.PDFTool.CommentVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.events.CollectionEvent;
	import mx.events.ResizeEvent;
	
	public class PDFMainContainer extends Canvas
	{
		public static const PDF1:int=1;
		public static const PDF2:int=2;
		
		public static const NONE:int=0;
		public static const PAN:int=1;
		public static const NOTE:int=2;
		
		public static const SVG_DRAW:int=3;
		public static const ALTER_NOTE:int=4;
		
		public static const REGION_COMPARE:int=5;
		
		public static const CLOCKWISE:int=0;
		public static const COUNTER_CLOCKWISE:int=1;
		
		public static const  RECTANGLE:int=0;
		public static const HORIZONTAL:int=1;
		public static const  VERTICAL:int=2;
		
		private var img1:ImageSWF;
		private var img2:ImageSWF;
		private var svg1:SVGDrawTool;
		private var svg2:SVGDrawTool;
		public var note1:Canvas;
		public var note2:Canvas;
		public var imgCompare:Image;
		private var tempwidth:Number;
		private	var tempheight:Number
		private var SVGNotFirstTime:Boolean=false;
		private var commentColor:uint;
		
		public var externalCommentStatus:Boolean=true;
		
		[Bindable]
		private var model : ModelLocator = ModelLocator.getInstance();
		
		private var infoImage:Number = 1;
		
		[Bindable]
		public var panSelected:Boolean=true;
		
		private var _img1URL:String;
		public function set img1URL (value:String):void
		{
			_img1URL = value;
			if(value.toLowerCase().indexOf("swf")!=-1)
			{
				img1.source=value;
				infoImage=1;
				COMPARE_MODE=true;
				compareStatus=true;
			}else{
				COMPARE_MODE=false;
				compareStatus=false;
			}
			//trace("Image Loading");
			imgAlphaSet();
			//if(COMPARE_MODE)
			PDFToolSimpleArc(this.parentDocument).doubleViewCon.resetPage();
		}
		
		[Bindable]
		public var exterCommentClear:Boolean=false;

		public function get img1URL ():String
		{
			return _img1URL;
		}

		private var _img2URL:String;
		public function set img2URL (value:String):void
		{
			_img2URL = value;
			if(value.toLowerCase().indexOf("swf")!=-1)
			{
				img2.source=value;
				infoImage=2;
			}
			imgAlphaSet();
			PDFToolSimpleArc(this.parentDocument).doubleViewCon.resetPage();
		}

		public function get img2URL ():String
		{
			return _img2URL;
		}
		private function ToolKeyDown(evt : KeyboardEvent) : void
		{
			if(evt.keyCode == 32)
			{
				toggleFunc();
			}
		}
		public function toggleFunc():void
		{
			if(this.FOCUS_ACTION==PAN){
				panSelected=false;
				this.FOCUS_ACTION=ALTER_NOTE;
			}else{
				this.FOCUS_ACTION=PAN;
				panSelected=true;
			}
		}
		[Bindable]
		private var _selectedPDF:Number;
		private var linkNoteCreated:Boolean=false;
		public function set selectedPDF (value:Number):void
		{
			_selectedPDF = value;
			if(value == PDF1){
				img2.visible=!(img1.visible=true);
				svg2.visible=!(svg1.visible=true);
				note2.visible=!(note1.visible=true);
				if(this.FOCUS_ACTION==NOTE || this.FOCUS_ACTION==SVG_DRAW) FOCUS_ACTION=NONE;
			}
			if(value == PDF2){
				img1.visible=!(img2.visible=true);
				svg1.visible=!(svg2.visible=true);
				note1.visible=!(note2.visible=true);
			}
			if(!externalCommentStatus) this.note1.visible=this.note2.visible=false;
			this.img1.alpha=this.img2.alpha=this.svg1.alpha=this.svg2.alpha=this.note1.alpha=this.note2.alpha=1;
			this.imgCompare.alpha=0; 
			this.imgCompare.source=null;
			
			if(linkNoteCreated) linkNoteFunc();
			linkNoteCreated=true;
		} 
		[Bindable]
		public function get selectedPDF ():Number
		{
			return _selectedPDF;
		}
		
		
		private var _dataProvider:ArrayCollection=new ArrayCollection();
		public function set dataProvider (value:ArrayCollection):void
		{
			_dataProvider.list = value.list;
		}

		public function get dataProvider ():ArrayCollection
		{
			return _dataProvider;
		}

		
		private var _DRAW:Number;
		public function set DRAW (value:Number):void
		{
			_DRAW = value;
			FOCUS_ACTION=SVG_DRAW;
			svg2.DRAW = value;
		}

		public function get DRAW ():Number
		{
			return _DRAW;
		}
		
		
		private var _COMPARE_MODE:Boolean;
		public function set COMPARE_MODE (value:Boolean):void
		{
			_COMPARE_MODE = value;
		}
		[Bindable]
		public function get COMPARE_MODE ():Boolean
		{
			return _COMPARE_MODE;
		}
		[Bindable]
		public var compareStatus:Boolean;
		
		private var _FOCUS_ACTION:Number;
		[Bindable]
		public function set FOCUS_ACTION (value:Number):void
		{
			_FOCUS_ACTION = value;
			SetFocusStatus();
		}

		public function get FOCUS_ACTION ():Number
		{
			return _FOCUS_ACTION;
		}
		
		
		private var _rotateMe:Number;
		public function set rotateMe (value:Number):void
		{
			_rotateMe = value;
			if(value==CLOCKWISE) this.img1.rotation=this.img2.rotation=this.svg1.rotation=this.svg2.rotation=this.note1.rotation=this.note2.rotation=this.imgCompare.rotation+=90;
			if(value==COUNTER_CLOCKWISE) this.img1.rotation=this.img2.rotation=this.svg1.rotation=this.svg2.rotation=this.note1.rotation=this.note2.rotation=this.imgCompare.rotation-=90;
			rotateMeFunc();
		}

		public function get rotateMe ():Number
		{
			return _rotateMe;
		}
		
		
		private var _selectedNote:Number;
		public function set selectedNote (value:Number):void
		{
			_selectedNote = value;
			this.FOCUS_ACTION=NOTE;
			
		}

		public function get selectedNote ():Number
		{
			return _selectedNote;
		}
		
		[Bindable]
		private var _img1Alpha:Number;
		public function set img1Alpha (value:Number):void
		{
			_img1Alpha = value;
			img1.alpha= _img1Alpha;
			svg1.alpha= _img1Alpha;
			note1.alpha= _img1Alpha;
		}

		public function get img1Alpha ():Number
		{
			return _img1Alpha;
		}
		
		[Bindable]
		private var _img2Alpha:Number;
		public function set img2Alpha (value:Number):void
		{
			_img2Alpha = value;
			img2.alpha=_img2Alpha;
			svg2.alpha= _img1Alpha;
			note2.alpha= _img1Alpha;
		}

		public function get img2Alpha ():Number
		{
			return _img2Alpha;
		}
		
		[Bindable]
		private var _imgDiffAlpha:Number;
		public function set imgDiffAlpha (value:Number):void
		{
			_imgDiffAlpha = value;
			imgCompare.alpha=_imgDiffAlpha;
			
		}
		[Bindable]
		public var externalComment:ExternalCommentCanvas=new ExternalCommentCanvas();

		public function get imgDiffAlpha ():Number
		{
			return _imgDiffAlpha;
		}
		
		public function PDFMainContainer()
		{
			super();
			this.horizontalScrollPolicy="off";
			this.verticalScrollPolicy="off";
			this.addEventListener(ResizeEvent.RESIZE,resizeContainer);
			this.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,dataProviderChangeEvent);
			img1=new ImageSWF();
			img2=new ImageSWF();
			svg1=new SVGDrawTool();
			svg2=new SVGDrawTool();
			note1=new Canvas();
			note2=new Canvas();
			imgCompare=new Image();
			timer = new Timer(1000);
			SVGNotFirstTime=false;
			commentColor=0xFFFF00;
		}
		override protected function createChildren():void {
			super.createChildren();
			
			this.addChild(img1);
			this.addChild(img2);
			
			this.addChild(svg1);
			this.addChild(svg2);
			
			this.addChild(note1);
			this.addChild(note2);
			
			this.addChild(imgCompare);
			
			this.img1.horizontalScrollPolicy="off";
			this.img1.verticalScrollPolicy="off";
			
			this.img2.horizontalScrollPolicy="off";
			this.img2.verticalScrollPolicy="off";
			
			this.note1.horizontalScrollPolicy="off";
			this.note1.verticalScrollPolicy="off";
			
			this.note2.horizontalScrollPolicy="off";
			this.note2.verticalScrollPolicy="off";
			
			this.svg1.horizontalScrollPolicy="off";
			this.svg1.verticalScrollPolicy="off";
			
			this.svg2.horizontalScrollPolicy="off";
			this.svg2.verticalScrollPolicy="off";
			
			this.svg1.fillAlpha=this.svg2.fillAlpha=0.5;
			this.svg1.DRAW=SVGDrawTool.NONE;
			
			this.note1.mouseEnabled=this.note1.mouseChildren=false;
			
			this.svg1.mouseEnabled=this.svg1.mouseChildren=false;
			
			this.selectedPDF=PDF2;
			this.FOCUS_ACTION=PAN;
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL,mouseAction);
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseAction);
			this.addEventListener(MouseEvent.MOUSE_OVER,mouseAction);
			this.parent.addEventListener(ResizeEvent.RESIZE,parentResizeEvent);
			this.addEventListener(KeyboardEvent.KEY_DOWN , ToolKeyDown , false , 0 , true);
			timer.addEventListener(TimerEvent.TIMER , onTimer , false , 0 , true);
		}
		private function resizeContainer(event:ResizeEvent):void{
			this.invalidateDisplayList();
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			if(action==0){
				//this.scaleX=this.scaleY=1;
			}
			var tempImg:ImageSWF=((infoImage==1)?img1:img2);
			var sX:Number=1;
			sX=this.parent.height/tempImg.height;
			sX=Number("0"+String(sX).substr(String(sX).indexOf("."),2));
			if(isNaN(sX)) sX=1;
			//trace("This Parent :: "+this.parent.width+" ::: "+this.parent.height+" :: "+sX);
			this.width=((tempImg.width)*this.scaleX);
			this.height=((tempImg.height)*this.scaleY);
			
			this.svg1.displayUIComp.width=this.svg2.displayUIComp.width=this.svg1.width=this.svg2.width=this.note1.width=this.note2.width=((tempImg.width/tempImg.scaleX));
			this.svg1.displayUIComp.height=this.svg2.displayUIComp.height=this.svg1.height=this.svg2.height=this.note1.height=this.note2.height=((tempImg.height/tempImg.scaleX)); 
		 
		//	trace("this.svg1.scaleX :: "+this.svg1.scaleX);
			this.svg1.scaleX=(tempImg.scaleX);
			this.svg2.scaleX=(tempImg.scaleX);
			this.note1.scaleX=(tempImg.scaleX);
			this.note2.scaleX=(tempImg.scaleX);
			this.svg1.scaleY=this.svg2.scaleY=this.note1.scaleY=this.note2.scaleY=(tempImg.scaleY); 
			if(tempImg.rotation==90 || tempImg.rotation==-90){
				this.width=tempImg.height*this.scaleX;
				this.height=tempImg.width*this.scaleY;
			}
			if(action==0 || action==3){
					this.x=(this.parent.width/2)-(this.width/2);
					this.y=(this.parent.height/2)-(this.height/2);
			}
			
			if(action==4){
				rotationPosition();
			}
			linkNoteFunc();
			
		}
		private function rotationPosition():void{
			//trace("Old : "+oldx+" ::: "+oldy);
			newx=0;
			newy=0;
			var tempImg:ImageSWF=((infoImage==1)?img1:img2);
			switch(tempImg.rotation){
				case 0:
					if(this.rotateMe==CLOCKWISE){
						newx=-(this.width-(this.parent.width+(oldy*-1))+(this.parent.width-this.parent.height));
						newy=oldx;	
					}
					if(this.rotateMe==COUNTER_CLOCKWISE){
						newx=oldy;
						newy=-(this.height-(this.parent.width+(oldx*-1)));
					}
				break;
				case 90:
					if(this.rotateMe==CLOCKWISE){
						newx=-(this.width-(this.parent.width+(oldy*-1)));
						newy=oldx;	
					}
					if(this.rotateMe==COUNTER_CLOCKWISE){
						newx=oldy+(this.parent.width-this.parent.height);
						newy=-(this.height-(this.parent.width+(oldx*-1)));
					}
				break;
				case 180:
					if(this.rotateMe==CLOCKWISE){
						newx=-(this.width-(this.parent.width+(oldy*-1)));
						newy=oldx-(this.parent.width-this.parent.height);	
					}
					if(this.rotateMe==COUNTER_CLOCKWISE){
						newx=oldy+(this.parent.width-this.parent.height);
						newy=-(this.height-(this.parent.height+(oldx*-1)));
					}
				break;
				case -180:
					if(this.rotateMe==CLOCKWISE){
						newx=-(this.width-(this.parent.width+(oldy*-1)));
						newy=oldx-(this.parent.width-this.parent.height);	
					}
					if(this.rotateMe==COUNTER_CLOCKWISE){
						newx=oldy+(this.parent.width-this.parent.height);
						newy=-(this.height-(this.parent.height+(oldx*-1)));
					}
				break;
				case -90:
					if(this.rotateMe==CLOCKWISE){
						newx=-((this.width-(this.parent.width+(oldy*-1)))+(this.parent.width-this.parent.height));
						newy=oldx-(this.parent.width-this.parent.height);	
					}
					if(this.rotateMe==COUNTER_CLOCKWISE){
						newx=oldy;
						newy=-(this.height-(this.parent.height+(oldx*-1)));
					}
				break;
			}
			this.x=newx;
			this.y=newy;
		}
		private function dataProviderChangeEvent(event:CollectionEvent):void{
			if(!externalComment)externalComment=new ExternalCommentCanvas();
			var i:int;
			var tempDraw:int=svg2.DRAW;
			if(SVGNotFirstTime)svg1.DRAW=svg2.DRAW=SVGDrawTool.CLEAR;
			else SVGNotFirstTime=true;
			exterCommentClear=true;
			this.note1.removeAllChildren();
			this.note2.removeAllChildren();
			for(i=0;i<ArrayCollection(event.target).length;i++){
				
				var commentDetail : CommentVO =  model.pdfDetailVO.commentListArrayCollection.getItemAt(i) as CommentVO;
				commentDetail.commentPDFfile = (commentDetail.filefk == model.currentSwfFile.remoteFileFk)?"2":"1";
				if(commentDetail.commentType==3){
				 	if(commentDetail.commentPDFfile == "1")
						this.svg1.drawFromString(String(commentDetail.commentDescription),commentDetail.commentID);
					else
						this.svg2.drawFromString(String(commentDetail.commentDescription),commentDetail.commentID);
				}else{
						var comment:CommentIconItem=new CommentIconItem();
						comment.width=commentDetail.commentWidth;
						comment.height=commentDetail.commentHeight;
						comment.fillColor=commentDetail.commentColor;
						comment.type=commentDetail.commentType;
						comment.x=commentDetail.commentX; 
						comment.y=commentDetail.commentY;
						comment.title = commentDetail.commentTitle;
						comment.desc = String(commentDetail.commentDescription);
						comment.commentID=commentDetail.commentID;
						comment.PDF=(commentDetail.editable)?Number(commentDetail.commentPDFfile):1;
						comment.invalidateDisplayList();
						var commDesc:CommentDescBox=new CommentDescBox();
						commDesc.width=220;
						//commDesc.height=150;
						commDesc.maximize=commentDetail.commentMaximize;
						commDesc.x=commentDetail.commentBoxX;
						commDesc.y=commentDetail.commentBoxY;
						commDesc.target=comment;
						commDesc.title=commentDetail.commentTitle;
						commDesc.desc=String(commentDetail.commentDescription);
						comment.target=commDesc;
						if(commentDetail.commentPDFfile == "1")
						{this.note1.addChild(comment);}
						else
						{this.note2.addChild(comment);}
						//PDFToolSimpleArc(this.parentDocument).externelComments.addChild(commDesc);
						externalComment.addChild(commDesc);
						commDesc.PDF=(commentDetail.editable)?Number(commentDetail.commentPDFfile):1;
						//trace("commentDetail Mise: "+commentDetail.misc);
						commDesc.title=commentDetail.commentTitle;
						commDesc.profile=commentDetail.misc;
						commDesc.desc=String(commentDetail.commentDescription);
						commDesc.update_lbl="Edit";
						commDesc.cancel_lbl="Remove";
						commDesc.mouseArea.addEventListener(MouseEvent.MOUSE_DOWN,externalCommentMouseAction);
					}
			}
			linkNoteFunc(); 
			exterCommentClear=false;
			svg2.DRAW=tempDraw;
		}
		public function zoomFromExternal(delta:int):void{
			action=3;
			if(delta>0){
				if((this.scaleX+0.5) <= 14){
					this.scaleX+=.5;
					this.scaleY+=.5;
				}
			}else{
				if((this.scaleX-0.5)>=0.5){ 
					this.scaleX-=.5;
					this.scaleY-=.5;
				}
			}
				
		}
		public function zoomFromExternalSlider():void{
			action=3;
		}
		public function linkNoteFunc():void{
			externalComment.graphics.clear();
			var tempImg:ImageSWF=((infoImage==1)?img1:img2);
			//trace("Trace ::: "+this.parentDocument)
			for(var i:int=0;i<externalComment.numChildren;i++){
				  if(externalCommentStatus){  
					if(CommentDescBox(externalComment.getChildAt(i)).PDF==PDFMainContainer(this.parent.getChildByName("img1")).selectedPDF){
					
					var tarX:int=CommentDescBox(externalComment.getChildAt(i)).target.x;
					var tarY:int=CommentDescBox(externalComment.getChildAt(i)).target.y;
					
					var tarWidth:int=tempImg.width/tempImg.scaleX;
					var tarHeight:int=tempImg.height/tempImg.scaleY;
					
					var tarXNew:int;
					var tarYNew:int;
					tarXNew=(tempImg.rotation==90)?tarHeight-tarY:(tempImg.rotation==180 || tempImg.rotation==-180)?tarWidth-tarX:(tempImg.rotation==-90)?tarY:tarX;
					tarYNew=(tempImg.rotation==90)?tarX:(tempImg.rotation==180 || tempImg.rotation==-180)?tarHeight-tarY:(tempImg.rotation==-90)?tarWidth-tarX:tarY;
					
					tarXNew*=this.parent.getChildByName("img1").scaleX;
					tarYNew*=this.parent.getChildByName("img1").scaleY;
										 
					var x1:int=CommentDescBox(externalComment.getChildAt(i)).x;
					var y1:int=CommentDescBox(externalComment.getChildAt(i)).y+20;
					//var y1:int=CommentDescBox(externalComment.getChildAt(i)).y+(CommentDescBox(Canvas(this.parent.getChildByName("externelComments")).getChildAt(i)).height/2);
					
					
					/* var x2:int=(this.parent.getChildByName("img1").x+(tarXNew)*tempImg.scaleX);
					var y2:int=(this.parent.getChildByName("img1").y+(tarYNew)*tempImg.scaleX); */
					var x2:int=(this.parent.getChildByName("img1").x)+tarXNew*tempImg.scaleX;
					var y2:int=(this.parent.getChildByName("img1").y)+tarYNew*tempImg.scaleY;
					
					if(x1+CommentDescBox(externalComment.getChildAt(i)).width<x2) x1=x1+CommentDescBox(externalComment.getChildAt(i)).width;
					externalComment.graphics.lineStyle(0.8,0xFF0000,0.8);
					externalComment.graphics.moveTo(x1,y1);
					externalComment.graphics.lineTo(x1,y1);
					externalComment.graphics.lineTo(x2,y2);
					externalComment.graphics.beginFill(0xFF0000,0.5);
				    externalComment.graphics.drawEllipse(x2-5,y2-5,10,10);
				    externalComment.graphics.endFill(); 
					CommentDescBox(externalComment.getChildAt(i)).visible=true;
					}else{
						CommentDescBox(externalComment.getChildAt(i)).visible=false;
					}
				  }
				else{
					CommentDescBox(externalComment.getChildAt(i)).visible=false;
				}
			}
		}
		//-------------- Mouse Event --------------
		private var x1:int=0;
		private var y1:int=0;
		private var x2:int=0;
		private var y2:int=0;
		private function mouseAction(event:MouseEvent):void{
			if(event.type==MouseEvent.MOUSE_WHEEL){
				action=1;
				var newX:Number;
				var newY:Number
				if(event.delta>0){
					if((this.scaleX+0.5) <= 14){
						this.scaleX+=.5;
						this.scaleY+=.5;
						newX=this.mouseX*.5;
						newY=this.mouseY*.5;
						this.x-=this.mouseX-newX;
						this.y-=this.mouseY-newY;
					}
				}else{
					if((this.scaleX-0.5)>=0.5){ 
						this.scaleX-=.5;
						this.scaleY-=.5;
						newX=this.mouseX*.5;
						newY=this.mouseY*.5;
						this.x+=this.mouseX-newX;
						this.y+=this.mouseY-newY;
					}
				}
			}
			if(event.type==MouseEvent.MOUSE_DOWN){
				action=2;
				
				this.addEventListener(MouseEvent.MOUSE_UP,mouseAction);
				this.addEventListener(MouseEvent.MOUSE_MOVE,mouseAction);
				x1=this.note2.mouseX;
				y1=this.note2.mouseY;
				if(FOCUS_ACTION==PAN)
				this.startDrag(false,new Rectangle(0,0,this.parent.width-this.width,this.parent.height-this.height));
			}
			if(event.type==MouseEvent.MOUSE_MOVE){
				var dx:int=this.note2.mouseX;
					var dy:int=this.note2.mouseY
					this.note2.graphics.clear();
					this.note2.graphics.lineStyle(1, 0x000000);
					this.note2.graphics.moveTo(x1,y1);
					this.note2.graphics.lineTo(x1,y1);
				if(this.FOCUS_ACTION==NOTE){
					
					if(this.selectedNote==HORIZONTAL) this.note2.graphics.lineTo(dx,y1);
					if(this.selectedNote==VERTICAL) this.note2.graphics.lineTo(x1,dy);
					if(this.selectedNote==RECTANGLE) {
						this.note2.graphics.drawRect(dx,dy,(x1-dx),(y1-dy));
						this.note2.graphics.endFill();
					}
					
				}
				if(this.FOCUS_ACTION==REGION_COMPARE)
				{
					this.note2.graphics.drawRect(dx,dy,(x1-dx),(y1-dy));
						this.note2.graphics.endFill();
				}
				linkNoteFunc();
				if(!event.buttonDown){
					this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
				}
			}
			if(event.type==MouseEvent.MOUSE_UP){
				this.stopDrag();
				x2=this.note2.mouseX;
				y2=this.note2.mouseY;
				if(this.FOCUS_ACTION==NOTE) this.DrawNote();
				this.note2.graphics.clear();
				this.removeEventListener(MouseEvent.MOUSE_MOVE,mouseAction);
				this.removeEventListener(MouseEvent.MOUSE_UP,mouseAction);
				linkNoteFunc();  
			}
			if(event.type==MouseEvent.MOUSE_OVER){
				if(!event.buttonDown){
					this.stopDrag();
					this.removeEventListener(MouseEvent.MOUSE_UP,mouseAction);
				}
			}
		}
		private var timer:Timer;
		[Bindable]
		public var playPauseSelected:Boolean=false;
		public function playPauseFunc(event:MouseEvent):void{
			if (!Button(event.target).selected)
			{
				if((this.parentDocument as PDFToolSimpleArc).noteListOpen){
					(this.parentDocument as PDFToolSimpleArc).notelistBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK)); 
				}
				this.selectedPDF == PDF1;
				timer.start();
				playPauseSelected=true;
				
			}else
			{
				timer.stop();
				playPauseSelected=false;
				if(selectedPDF==PDF1) this.note1.visible=!(this.note2.visible=false);
				if(selectedPDF==PDF2) this.note1.visible=!(this.note2.visible=true);
				//externalCommentStatus=true;
				linkNoteFunc();
			}	
		} 
		private function onTimer(event:TimerEvent) : void
		{
			if(this.selectedPDF == PDF1) 
				this.selectedPDF=PDF2;
			else 
				this.selectedPDF=PDF1;
		}
		private function DrawNote():void{
			var comment:CommentIconItem=new CommentIconItem();
			comment.width=Math.abs(x1-x2);
			comment.height=Math.abs(y1-y2);
			comment.fillColor=this.commentColor;
			//0xFFFF00;
			comment.type=selectedNote;
			comment.x=(x1<x2)?x1:x2; 
			comment.y=(y1<y2)?y1:y2;
			//comment.title = ArrayCollection(event.target).getItemAt(i).title;
			//comment.desc = ArrayCollection(event.target).getItemAt(i).desc;
			comment.invalidateDisplayList();
			var commDesc:CommentDescBox=new CommentDescBox();
			commDesc.width=220;
			//commDesc.height=150;
			commDesc.maximize=true;
			commDesc.x=Math.random()*150;
			commDesc.y=Math.random()*250;
			commDesc.PDF=PDFMainContainer.PDF2;
			commDesc.target=comment;
			comment.target=commDesc;
			commDesc.update_lbl="Save";
			commDesc.cancel_lbl="Cancel";
			commDesc.profile=GetVOUtil.getProfileObject(model.person.defaultProfile).profileLabel;
			this.note2.addChild(comment);
			//this.FOCUS_ACTION=ALTER_NOTE;
			externalComment.addChild(commDesc);
			commDesc.mouseArea.addEventListener(MouseEvent.MOUSE_DOWN,externalCommentMouseAction);
			commDesc.editComment();
			//linkNoteFunc();
		} 
		private function SetFocusStatus():void{
			this.svg2.mouseEnabled=this.svg2.mouseChildren=false;
			this.note2.mouseEnabled=this.note2.mouseChildren=false;
			if(this.FOCUS_ACTION==NOTE) this.note2.mouseEnabled=true;
			if(this.FOCUS_ACTION==ALTER_NOTE) this.note2.mouseChildren=true;
			if(this.FOCUS_ACTION==SVG_DRAW) this.svg2.mouseEnabled=this.svg2.mouseChildren=true;
			if(this.FOCUS_ACTION==NOTE || this.FOCUS_ACTION==SVG_DRAW) this.selectedPDF=PDF2;
		}
		private function parentResizeEvent(event:ResizeEvent):void{
			action=0;
			this.img1.rotation=this.img2.rotation=this.svg1.rotation=this.svg2.rotation=this.note1.rotation=this.note2.rotation=this.imgCompare.rotation=0;
			this.img1.x=this.img2.x=this.svg1.x=this.svg2.x=this.note1.x=this.note2.x=this.imgCompare.x=0;
			this.img1.y=this.img2.y=this.svg1.y=this.svg2.y=this.note1.y=this.note2.y=this.imgCompare.y=0;
			if(this.parent.width>this.width && this.parent.height>this.height){
				this.x=(this.parent.width/2)-(this.width/2);
				this.y=(this.parent.height/2)-(this.height/2);
			}
			linkNoteFunc();
		}
		//-------------- Mouse Event --------------
		//-------------- Rotation -----------------
		private var action:Number;
		private var oldx:int;
		private var oldy:int;
		private var newx:int;
		private var newy:int;

		public function rotateMeFunc():void{
			oldx=this.x;
			oldy=this.y;
			
			var tempImg:ImageSWF=((infoImage==1)?img1:img2);
			action=(this.scaleX>1)?4:0;
			switch(tempImg.rotation){
				case 0:
				this.img1.y=this.img2.y=this.svg1.y=this.svg2.y=this.note1.y=this.note2.y=this.imgCompare.y=0;
				this.img1.x=this.img2.x=this.svg1.x=this.svg2.x=this.note1.x=this.note2.x=this.imgCompare.x=0;
				this.invalidateDisplayList();
				break;
				case 90:
				this.img1.y=this.img2.y=this.svg1.y=this.svg2.y=this.note1.y=this.note2.y=this.imgCompare.y=0;
				this.img1.x=this.img2.x=this.svg1.x=this.svg2.x=this.note1.x=this.note2.x=this.imgCompare.x=tempImg.height;
				this.invalidateDisplayList();
				break;
				case 180:
				this.img1.y=this.img2.y=this.svg1.y=this.svg2.y=this.note1.y=this.note2.y=this.imgCompare.y=tempImg.height;
				this.img1.x=this.img2.x=this.svg1.x=this.svg2.x=this.note1.x=this.note2.x=this.imgCompare.x=tempImg.width;
				this.invalidateDisplayList();
				break;
				case -180:
				this.img1.y=this.img2.y=this.svg1.y=this.svg2.y=this.note1.y=this.note2.y=this.imgCompare.y=tempImg.height;
				this.img1.x=this.img2.x=this.svg1.x=this.svg2.x=this.note1.x=this.note2.x=this.imgCompare.x=tempImg.width;
				this.invalidateDisplayList();
				break;
				case -90:
				this.img1.y=this.img2.y=this.svg1.y=this.svg2.y=this.note1.y=this.note2.y=this.imgCompare.y=tempImg.width;
				this.img1.x=this.img2.x=this.svg1.x=this.svg2.x=this.note1.x=this.note2.x=this.imgCompare.x=0;
				this.invalidateDisplayList();
				break;
			}
			
		}
		private function externalCommentMouseAction(event:MouseEvent):void{
			/* if(event.target is CommentDescBox){ */
				if(event.type==MouseEvent.MOUSE_DOWN){
					event.target.parent.startDrag(false,new Rectangle(0,0,CommentDescBox(event.target.parent).parent.width-CommentDescBox(event.target.parent).width,CommentDescBox(event.target.parent).parent.height-CommentDescBox(event.target.parent).height));
					event.target.addEventListener(MouseEvent.MOUSE_MOVE,externalCommentMouseAction);
					event.target.addEventListener(MouseEvent.MOUSE_OUT,externalCommentMouseAction);
					event.target.addEventListener(MouseEvent.MOUSE_UP,externalCommentMouseAction);
				}
				 if(event.type==MouseEvent.MOUSE_MOVE){
					linkNoteFunc();
				}
				if(event.type==MouseEvent.MOUSE_UP || event.type==MouseEvent.MOUSE_OUT){
					event.target.parent.stopDrag();
					if(CommentDescBox(event.target.parent).PDF==2){
						CommentDescBox(event.target.parent).edit_btn.label="Update";
						CommentDescBox(event.target.parent).editComment();
					}
					//trace("Get Index ::: "+event.target.parent.getChildIndex(event.target))
					event.target.removeEventListener(MouseEvent.MOUSE_MOVE,externalCommentMouseAction);
					event.target.removeEventListener(MouseEvent.MOUSE_OUT,externalCommentMouseAction);
					event.target.removeEventListener(MouseEvent.MOUSE_UP,externalCommentMouseAction);
				} 
			/* } */
		}
		//-------------- Rotation -----------------
		//------------Image Compare----------------
		public function imageCompareFunc():void{
			imgCompare = new Image();
			this.addChild(imgCompare);
			if(playPauseSelected){
				timer.stop();
				playPauseSelected=false;
			} 
			 tempwidth=(img1.imgWidth<img2.imgWidth)?img1.imgWidth:img2.imgWidth;
			tempheight=(img1.imgHeight<img2.imgHeight)?img1.imgHeight:img2.imgHeight;
			
			var bmd1 : BitmapData = new BitmapData(tempwidth, tempheight);
			var bmd2 : BitmapData = new BitmapData(tempwidth, tempheight);
			var content1:BitmapData= img1.imgBitmapData;
			 bmd1.draw(content1 , UIMatrix);
			var content2 : BitmapData= img2.imgBitmapData;
			var UIMatrix : Matrix = new Matrix();
			bmd2.draw(content2 , UIMatrix);
			
			if(bmd1.compare(bmd2) != 0)
			{
				var compareX:Number = tempwidth
				var compareY:Number = tempheight
				var content3:BitmapData= BitmapData(bmd1.compare(bmd2));;
				var bmd3 : BitmapData = new BitmapData(compareX, compareY);
				 bmd3.draw(content3 , UIMatrix);
				imgCompare.source = new Bitmap(bmd3);
								
			}else
			{
				imgCompare.source = null;
			}
			
			externalCommentStatus=false;
			linkNoteFunc();
			
			this.img1.alpha=this.img2.alpha=this.svg1.alpha=this.svg2.alpha=this.note1.alpha=this.note2.alpha=0;
			this.imgCompare.scaleX=this.imgCompare.scaleY=img1.scaleX;
			this.imgCompare.alpha=1;
			this.imgCompare.width  = tempwidth
			this.imgCompare.height = tempheight
			this.img1.visible=this.img2.visible=this.imgCompare.visible=true;
			
		}
		private function imgAlphaSet():void{
			action=0;
			this.scaleX=this.scaleY=1;
			this.img1.rotation=this.img2.rotation=this.svg1.rotation=this.svg2.rotation=this.note1.rotation=this.note2.rotation=this.imgCompare.rotation=0;
			this.img1.x=this.img2.x=this.svg1.x=this.svg2.x=this.note1.x=this.note2.x=this.imgCompare.x=0;
			this.img1.y=this.img2.y=this.svg1.y=this.svg2.y=this.note1.y=this.note2.y=this.imgCompare.y=0;
			this.img1.alpha=this.img2.alpha=this.svg1.alpha=this.svg2.alpha=this.note1.alpha=this.note2.alpha=1;
			imgCompare.alpha=0; 
			imgCompare.source=null;
			this.selectedPDF=PDF2;
			externalCommentStatus=true;
			this.svg2.DRAW=NONE;
			this.FOCUS_ACTION=PAN;
			trace("Doc Img Alpha");
			PDFToolSimpleArc(this.parentDocument).deselectAllComponent();
			
			if(GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode=="FAB"){
				this.svg1.strokeColor=0xCC0000;
				this.svg1.fillColor=0xFF6600;
				this.svg1.highlightColor=0xFF0000;
				this.svg2.strokeColor=0xCC0000;
				this.svg2.fillColor=0xFF6600;
				this.svg2.highlightColor=0xFF0000;
				this.commentColor=0xEECC33;
			}
			if(GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode=="CLT"){
				this.svg1.strokeColor=0x006600;
				this.svg1.fillColor=0xFF0000;
				this.svg1.highlightColor=0x006699;
				this.svg2.strokeColor=0x006600;
				this.svg2.fillColor=0xFF0000;
				this.svg2.highlightColor=0x006699;
				this.commentColor=0xFFFF00;
			}
			if(GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode=="OPE"){
				this.svg1.strokeColor=0xCC6600;
				this.svg1.fillColor=0x5E8DA2;
				this.svg1.highlightColor=0x006699;
				this.svg2.strokeColor=0xCC6600;
				this.svg2.fillColor=0x5E8DA2;
				this.svg2.highlightColor=0x336699;
				this.commentColor=0xFA995A;
			}
			
			linkNoteFunc();
			if(PDFToolSimpleArc(this.parentDocument).compare.selected) PDFToolSimpleArc(this.parentDocument).compare.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			if(PDFToolSimpleArc(this.parentDocument).doubleView.selected) PDFToolSimpleArc(this.parentDocument).doubleView.selected = false;
			
			
			/* PDFToolSimpleArc(this.parentDocument).doubleViewCon.img1.scaleValue=1;
			PDFToolSimpleArc(this.parentDocument).doubleViewCon.img2.scaleValue=1;
			PDFToolSimpleArc(this.parentDocument).doubleViewCon.img1.xPos=0;
			PDFToolSimpleArc(this.parentDocument).doubleViewCon.img2.xPos=0;
			PDFToolSimpleArc(this.parentDocument).doubleViewCon.img1.yPos=0;
			PDFToolSimpleArc(this.parentDocument).doubleViewCon.img2.yPos=0;
			PDFToolSimpleArc(this.parentDocument).doubleViewCon.img1.rotationValue=0;
			PDFToolSimpleArc(this.parentDocument).doubleViewCon.img2.rotationValue=0; */
		}
		//------------Image Compare----------------
	}
}
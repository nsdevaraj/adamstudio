package com.adams.dt.view.PDFTool
{
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.event.PDFTool.CommentEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.PDFTool.CommentVO;
	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.events.CollectionEvent;
	import mx.events.ResizeEvent;
	

	[Event(name="RegionSelectComplete", type="flash.events.Event")]
	 
	public class PDFSinglePageMainContainer extends Canvas
	{
		private var img:ImageSWF;
		private var svg:SVGDrawTool;
		private var note:Canvas;
		private var regionCompareCanvas:Canvas;
		private var RegionContainer:Canvas;

		
		[Bindable]
		private var model : ModelLocator = ModelLocator.getInstance();
		
		private var _imgURL:String;
		[Bindable]
		public function set imgURL (value:String):void
		{
			_imgURL = value;
			img.source = value;
			imgAlphaSet();
			trace("URL : "+value);
		}
		public function get imgURL ():String
		{
			return _imgURL;
		} 
		
		 private var _selectPDF:String;
		[Bindable]
		public function set selectPDF (value:String):void
		{
			_selectPDF = value;
			
			if(value=="1"){
				this.svg.mouseEnabled=this.svg.mouseChildren=false;
				this.note.mouseEnabled=this.note.mouseChildren=false;
				this.regionCompareCanvas.setStyle("backgroundColor","#FF0000");
			}else{
				this.regionCompareCanvas.setStyle("backgroundColor","#FFFF00");
			}
		}
		public function get selectPDF ():String
		{
			return _selectPDF;
		}  
		
		public var _xPos:Number;
		[Bindable]
		public function set xPos (value:Number):void
		{
			_xPos = value;
			this.x=value;
			
		}
		public function get xPos ():Number
		{
			return _xPos;
		}
		
		public var _yPos:Number;
		[Bindable]
		public function set yPos (value:Number):void
		{
			_yPos = value;
			this.y=value;
			
		}
		public function get yPos ():Number
		{
			return _yPos;
		}
		
		public var _rotationValue:Number;
		[Bindable]
		public function set rotationValue (value:Number):void
		{
			_rotationValue = value;
			
		}
		public function get rotationValue():Number
		{
			return _rotationValue;
		}
		
		
		public var _scaleValue:Number;
		[Bindable]
		public function set scaleValue (value:Number):void
		{
			_scaleValue = value;
			this.scaleX=value;
			this.scaleY=value;
		}
		public function get scaleValue ():Number
		{
			return _scaleValue;
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
		[Bindable]
		public function set DRAW (value:Number):void
		{
			_DRAW = value;
			if(selectPDF=="2"){
				FOCUS_ACTION=SVG_DRAW;
				svg.DRAW = value;
			}
		}

		public function get DRAW ():Number
		{
			return _DRAW;
		}

		public function PDFSinglePageMainContainer()
		{
			super();
			this.creationPolicy="all";
			img=new ImageSWF();
			note=new Canvas();
			svg=new SVGDrawTool(); 
			regionCompareCanvas=new SVGDrawTool();
			RegionContainer=new Canvas();
			this.xPos=0;
			this.yPos=0;
			this.scaleValue=1;
			
			this.addEventListener(MouseEvent.MOUSE_WHEEL,mouseAction);
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseAction);		 	
			this.addEventListener(MouseEvent.MOUSE_UP,mouseAction);
			this.regionCompareCanvas.addEventListener(MouseEvent.MOUSE_DOWN,compareMouseAction);		 	
			this.regionCompareCanvas.addEventListener(MouseEvent.MOUSE_UP,compareMouseAction);
			this.dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,dataProviderChangeEvent);
		}
		override protected function createChildren():void 
		{
			super.createChildren();
			
		 	this.addChild(img);
			this.addChild(note);
			this.addChild(svg);
			this.addChild(RegionContainer);
			this.RegionContainer.addChild(regionCompareCanvas);
			
			this.horizontalScrollPolicy="off";
			this.verticalScrollPolicy="off";
			
			this.img.horizontalScrollPolicy="off";
			this.img.verticalScrollPolicy="off";
			
			this.regionCompareCanvas.horizontalScrollPolicy="off";
			this.regionCompareCanvas.verticalScrollPolicy="off";
			this.regionCompareCanvas.setStyle("backgroundAlpha","0.5");
			//this.RegionContainer.setStyle("backgroundColor","#0000FF");
			//this.RegionContainer.setStyle("backgroundAlpha","0.5");
			
			this.regionCompareCanvas.visible=false;
			
			this.note.horizontalScrollPolicy="off";
			this.note.verticalScrollPolicy="off";
			
			this.svg.horizontalScrollPolicy="off";
			this.svg.verticalScrollPolicy="off"; 
			
			this.svg.DRAW=NONE;
			
			this.parent.addEventListener(ResizeEvent.RESIZE,parentResizeEvent);	
		}
		[Bindable]
		public var sX:Number=1;
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			//sX=this.parent.height/img.height;
			//sX=Number("0"+String(sX).substr(String(sX).indexOf("."),2));
			/* img.width=this.parent.width;
			img.height=this.parent.height; */
			if(isNaN(sX)) sX=1;
			this.width=((img.width)*this.scaleX);
			this.height=((img.height)*this.scaleY);
			
			this.svg.displayUIComp.width=this.svg.width=this.RegionContainer.width=this.note.width=((img.width/img.scaleX));
			this.svg.displayUIComp.height=this.svg.height=this.RegionContainer.height=this.note.height=((img.height/img.scaleY));
			
			this.svg.scaleX=this.note.scaleX=this.RegionContainer.scaleX=(img.scaleX); 
			this.svg.scaleY=this.note.scaleY=this.RegionContainer.scaleY=(img.scaleY);
			 if(img.rotation==90 || img.rotation==-90){
				this.width=img.height*this.scaleX;
				this.height=img.width*this.scaleY;
			} 
			 if(action==0 || action==3){
					this.x=(this.parent.width/2)-(this.width/2);
					this.y=(this.parent.height/2)-(this.height/2);
			}
			
			if(action==4){
				rotationPosition();
			}  
			trace("Update Property is accessable "+this.name+" Scale "+this.scaleX+"======="+sX+"======="+this.parent.height+"======="+img.height)
		} 
		private function parentResizeEvent(event:ResizeEvent):void{
			action=0;
			//scaleValue=1;
			this.img.rotation=this.svg.rotation=this.note.rotation=0;
			this.img.x=this.svg.x=this.note.x=0;
			this.img.y=this.svg.y=this.note.y=0;
			if(this.parent.width>this.width && this.parent.height>this.height){
				this.x=(this.parent.width/2)-(this.width/2);
				this.y=(this.parent.height/2)-(this.height/2);
			} 
			this.invalidateDisplayList();	
			trace("Resize : "+this.name+" ::::: >>  "+event.target.name);
			
		}
		private function dataProviderChangeEvent(event:CollectionEvent):void{
			var tempDraw:int=svg.DRAW;
			svg.DRAW=SVGDrawTool.CLEAR;
			this.note.removeAllChildren();
			for(var i:int=0;i<ArrayCollection(event.target).length;i++){
				
				var commentDetail : CommentVO =  model.pdfDetailVO.commentListArrayCollection.getItemAt(i) as CommentVO;
				commentDetail.commentPDFfile = (commentDetail.filefk == model.currentSwfFile.remoteFileFk)?"2":"1";
				if(commentDetail.commentType==3){
				 	if(commentDetail.commentPDFfile == selectPDF)
					this.svg.drawFromString(String(commentDetail.commentDescription),commentDetail.commentID);
					
				}else{
					if(commentDetail.commentPDFfile == selectPDF){
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
						commDesc.PDF=(commentDetail.editable)?Number(commentDetail.commentPDFfile):1;
						//trace("commentDetail Mise: "+commentDetail.misc);
						commDesc.title=commentDetail.commentTitle;
						commDesc.profile=commentDetail.misc;
						commDesc.desc=String(commentDetail.commentDescription);
						commDesc.update_lbl="Edit";
						commDesc.cancel_lbl="Remove";  
						this.note.addChild(comment);
						}
					
				}
			}
			//trace("Note size : "+this.note.numChildren)
			svg.DRAW=tempDraw;
		}
		
		//-------------- Rotation -----------------
		public static const CLOCKWISE:int=0;
		public static const COUNTER_CLOCKWISE:int=1;
		private var _rotateMe:Number;
		
		public function set rotateMe (value:Number):void
		{
			_rotateMe = value;
			if(value==CLOCKWISE) this.img.rotation=this.svg.rotation=this.note.rotation+=90;
			if(value==COUNTER_CLOCKWISE) this.img.rotation=this.svg.rotation=this.note.rotation-=90;
			rotateMeFunc();
		}

		public function get rotateMe ():Number
		{
			return _rotateMe;
		}
		
		public static const NONE:int=0;
		public static const PAN:int=1;
		public static const NOTE:int=2;
		
		public static const SVG_DRAW:int=3;
		public static const ALTER_NOTE:int=4;
		
		public static const REGION_COMPARE:int=5;
		
		public static const  RECTANGLE:int=0;
		public static const HORIZONTAL:int=1;
		public static const  VERTICAL:int=2;
		
		
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
		
		
		[Bindable]
		public var action:Number;
		private var oldx:int;
		private var oldy:int;
		private var newx:int;
		private var newy:int;

		public function rotateMeFunc():void{
			oldx=this.x;
			oldy=this.y;
			
			var tempImg:ImageSWF=img;
			action=(this.scaleX>1)?4:0;
			switch(tempImg.rotation){
				case 0:
				this.img.y=this.svg.y=this.note.y=0;
				this.img.x=this.svg.x=this.note.x=0;
				this.invalidateDisplayList();
				break;
				case 90:
				this.img.y=this.svg.y=this.note.y=0;
				this.img.x=this.svg.x=this.note.x=tempImg.height;
				this.invalidateDisplayList();
				break;
				case 180:
				this.img.y=this.svg.y=this.note.y=tempImg.height;
				this.img.x=this.svg.x=this.note.x=tempImg.width;
				this.invalidateDisplayList();
				break;
				case -180:
				this.img.y=this.svg.y=this.note.y=tempImg.height;
				this.img.x=this.svg.x=this.note.x=tempImg.width;
				this.invalidateDisplayList();
				break;
				case -90:
				this.img.y=this.svg.y=this.note.y=tempImg.width;
				this.img.x=this.svg.x=this.note.x=0;
				this.invalidateDisplayList();
				break;
			}
			
		}
		private function SetFocusStatus():void{
			this.svg.mouseEnabled=this.svg.mouseChildren=false;
			this.note.mouseEnabled=this.note.mouseChildren=false;
			if(this.FOCUS_ACTION==NOTE) this.note.mouseEnabled=true;
			if(this.FOCUS_ACTION==ALTER_NOTE) this.note.mouseChildren=true;
			if(this.FOCUS_ACTION==SVG_DRAW) this.svg.mouseEnabled=this.svg.mouseChildren=true;
		}
		private function rotationPosition():void{
			trace("Old : "+oldx+" ::: "+oldy);
			newx=0;
			newy=0;
			var tempImg:ImageSWF=img;
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
		private var x1:int=0;
		private var y1:int=0;
		private var x2:int=0;
		private var y2:int=0;
		
		private var x1_this:int=0;
		private var y1_this:int=0;
		private var x2_this:int=0;
		private var y2_this:int=0;
		
		public var compareBoxX:Number=0;
		public var compareBoxY:Number=0;
		public var compareBoxWidth:Number=0;
		public var compareBoxHeight:Number=0;
		
		private var _selectedNote:Number;
		[Bindable]
		public function set selectedNote (value:Number):void
		{
			_selectedNote = value;
			this.FOCUS_ACTION=NOTE;
		}

		public function get selectedNote ():Number
		{
			return _selectedNote;
		}
		
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
				xPos=this.x;
				yPos=this.y;
				scaleValue=this.scaleX;
			}
			var dx:int=this.note.mouseX;
					var dy:int=this.note.mouseY
			if(event.type==MouseEvent.MOUSE_DOWN){
				x1=this.note.mouseX;
				y1=this.note.mouseY;
				x1_this=this.note.mouseX;
				y1_this=this.note.mouseY;
				if(FOCUS_ACTION==PAN){
				this.startDrag(false,new Rectangle(0,0,this.parent.width-this.width,this.parent.height-this.height));
				
				}
				this.addEventListener(MouseEvent.MOUSE_MOVE,mouseAction);
			}
			if(event.type==MouseEvent.MOUSE_MOVE){
				this.xPos=this.x;
				this.yPos=this.y;
				
					this.note.graphics.clear();
					this.note.graphics.lineStyle(1, 0x000000);
					this.note.graphics.moveTo(x1,y1);
					this.note.graphics.lineTo(x1,y1);
				if((this.FOCUS_ACTION==NOTE && selectPDF=="2")){
					
					if(this.selectedNote==HORIZONTAL) this.note.graphics.lineTo(dx,y1);
					if(this.selectedNote==VERTICAL) this.note.graphics.lineTo(x1,dy);
					if(this.selectedNote==RECTANGLE) {
						this.note.graphics.drawRect(dx,dy,(x1-dx),(y1-dy));
						this.note.graphics.endFill();
					}
					
					
				}
				if(this.FOCUS_ACTION==REGION_COMPARE){
						this.note.graphics.drawRect(dx,dy,(x1-dx),(y1-dy));
						this.note.graphics.endFill();
					}
			}
			if(event.type==MouseEvent.MOUSE_UP){
				x2=this.note.mouseX;
				y2=this.note.mouseY;
				x2_this=this.note.mouseX;
				y2_this=this.note.mouseY;
				if(this.FOCUS_ACTION==REGION_COMPARE){
					this.regionCompareCanvas.visible=true;
					compareBoxX=this.regionCompareCanvas.x=(x1_this<x2_this)?x1_this:x2_this;
					compareBoxY=this.regionCompareCanvas.y=(y1_this<y2_this)?y1_this:y2_this;
					compareBoxWidth=this.regionCompareCanvas.width=Math.abs(x1_this-x2_this);
					compareBoxHeight=this.regionCompareCanvas.height=Math.abs(y1_this-y2_this);
					this.FOCUS_ACTION=NONE;
					dispatchEvent(new Event("RegionSelectComplete"));
				}
				if(this.FOCUS_ACTION==NOTE && selectPDF=="2") this.DrawNote();
				this.note.graphics.clear();
				this.removeEventListener(MouseEvent.MOUSE_MOVE,mouseAction);
				this.stopDrag();
			}
		}
		public function compareBoxPosition(xVal:Number,yVal:Number,widthVal:Number,heightVal:Number):void{
			this.regionCompareCanvas.visible=true;
			this.regionCompareCanvas.x=xVal;
			this.regionCompareCanvas.y=yVal;
			this.regionCompareCanvas.width=widthVal;
			this.regionCompareCanvas.height=heightVal;
			this.FOCUS_ACTION=NONE;
		}
		private function compareMouseAction(event:MouseEvent):void{
			if(event.type==MouseEvent.MOUSE_DOWN){
				trace("This Region Width and Height : "+this.RegionContainer.width+" ::: "+this.RegionContainer.height);
				trace("Region Width and Height : "+regionCompareCanvas.width+" ::: "+regionCompareCanvas.height);
				event.target.startDrag(false,new Rectangle(0,0,this.RegionContainer.width-regionCompareCanvas.width,this.RegionContainer.height-regionCompareCanvas.height));
			}
			if(event.type==MouseEvent.MOUSE_UP){
				trace(this.regionCompareCanvas.scaleX)
				event.target.stopDrag();
			}
		} 
		private var commentColor:uint;
		private function imgAlphaSet():void{
			//this.scaleX=this.scaleY=1;
			//resetPage();
			this.svg.DRAW=NONE;
			if(GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode=="FAB"){
				this.svg.strokeColor=0xCC0000;
				this.svg.fillColor=0xFF6600;
				this.svg.highlightColor=0xFF0000;
				this.commentColor=0xEECC33;
			}
			if(GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode=="CLT"){
				this.svg.strokeColor=0x006600;
				this.svg.fillColor=0xFF0000;
				this.svg.highlightColor=0x006699;
				this.commentColor=0xFFFF00;
			}
			if(GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode=="OPE"){
				this.svg.strokeColor=0xCC6600;
				this.svg.fillColor=0x5E8DA2;
				this.svg.highlightColor=0x006699;
				this.commentColor=0xFA995A;
			}
			//resetPage();
		}
		
		public function resetPage(value:Number=1):void{
			if(value){
			this.img.x=this.svg.x=this.note.x=0;
			this.img.y=this.svg.y=this.note.y=0;
			this.img.rotation=this.svg.rotation=this.note.rotation=0;
			this.xPos=this.yPos=0;
			this.scaleValue=1;
			this.invalidateDisplayList();
			}else{	
				this.img.sourceLoadInfo=1;
				this.img.invalidateDisplayList();
			}
		}
		private function DrawNote():void{
			var commentEvent:CommentEvent;
			commentEvent = new CommentEvent(CommentEvent.ADD_COMMENT, null, "", "",String((x1<x2)?x1:x2),String((y1<y2)?y1:y2),String(Math.abs(x1-x2)),String(Math.abs(y1-y2)),String(this.commentColor),"2", String(this.selectedNote), false, Math.random()*150, Math.random()*120, true,GetVOUtil.getProfileObject(model.person.defaultProfile).profileLabel);
			commentEvent.dispatch();
		}
	}
}
package com.adams.dt.view.components.PDFTool
{
	
	import com.adams.dt.model.vo.CommentVO;
	import com.adams.dt.util.ProcessUtil;
	import com.adams.dt.view.components.PDFTool.events.CommentCollectionEvent;
	
	import flash.display.MovieClip;
	import flash.errors.IOError;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.xml.XMLDocument;
	
	import mx.core.UIComponent;
	import mx.geom.RoundedRectangle;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import mx.rpc.xml.SimpleXMLDecoder;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.primitives.Ellipse;
	import spark.primitives.Line;
	import spark.primitives.Path;
	import spark.primitives.Rect;
	import spark.primitives.supportClasses.StrokedElement;
	
	[Event (type="commentCollectionUpdate",type="com.adams.dt.view.components.PDFTool.events.CommentCollectionEvent")]
	public class ShapeComponentFXG extends Group
	{
		public static const LINE:String="Line";
		public static const ELLIPSE:String="Ellipse";
		public static const RECT:String="Rect";
		public static const NORMAL_RECT:String="NormalRect";
		public static const PATH:String="Path";
		public static const NONE:String="None";
		
		private var _shapeSelected:String;
		public function get shapeSelected():String
		{
			return _shapeSelected;
		}
		[Bindable]
		public function set shapeSelected(value:String):void
		{
			_shapeSelected = value;
		}
		[Bindable]
		public var FillColor:uint;
		[Bindable]
		public var StrokeColor:uint;
		[Bindable]
		public var NormalFillColor:uint = 0xFFFF00;
		[Bindable]
		public var NormalStrokeColor:uint = 0x000000;
		public var x1:Number;
		public var y1:Number;
		public var x2:Number;
		public var y2:Number;
		public var strXML:XMLList;
		public var linel:Line = new Line;
		public var recta:Rect = new Rect;
		public var normalRect:Rect = new Rect;
		public var img:Image;
		public var rorect:RoundedRectangle = new RoundedRectangle;
		public var circle:Ellipse = new Ellipse;
		public var shapeGroupUI:CommentItem = new CommentItem;
		[Embed(source="assets/swf/additionalAssetsReader.swf#noteIcon")]
		private var noteIcon:Class;
		//public var shapecanvasUI:Canvas= new Canvas;
		public var shapestro:SolidColorStroke = new SolidColorStroke();
		public var shapefill:SolidColor = new SolidColor();
		public var pathBrush:Path;
		public var fxgData:String="";
		public var svgData:String="";
		public var pathData:String="";
		[Bindable]
		public var TextStringConver:String="";
		[ Bindable ] 
		public var _arrowSize:int = 0;
		[Bindable]
		public var StrokeWeightSlider:Number=2;
		[Bindable]
		public var StrokeAlphaColorSlider:Number=0.5;
		[Bindable]
		public var AlphaSlider:Number=0.5;
		private var _deleteItem:Boolean;
		public function ShapeComponentFXG()
		{
			super();
			this.clipAndEnableScrolling = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseAction);
		}
		
		public function get deleteItem():Boolean
		{
			return _deleteItem;
		}
		
		public function set deleteItem(value:Boolean):void
		{
			_deleteItem = value;
		}
		
		private function mouseAction(event:MouseEvent):void
		{
			var buttonReleased:Boolean = false;
			if(!event.buttonDown)
			{
				buttonReleased = true;
			}
			x2=(!buttonReleased)?event.localX:x2;
			y2=(!buttonReleased)?event.localY:y2;
			var xVal:Number = (x1<x2)?x1:x2;
			var yVal:Number = (y1<y2)?y1:y2;
			var widthVal:Number = Math.abs(x1-x2);
			var heightVal:Number = Math.abs(y1-y2);
			fxgData ="";
			if(event.type == "mouseDown")
			{
				x1=event.localX;
				y1=event.localY;
				this.addEventListener(MouseEvent.MOUSE_UP,mouseAction);
				this.addEventListener(MouseEvent.MOUSE_MOVE,mouseAction);
				shapeGroupUI = new CommentItem();
				//shapecanvasUI = new Canvas();
				switch(shapeSelected){
					case LINE:
						linel = new Line();
						shapeGroupUI.addElement(linel);
						break;
					
					case ELLIPSE:
						
						circle = new Ellipse();
						shapeGroupUI.addElement(circle);
						break;
					
					case RECT:
						
						recta = new Rect();
						shapeGroupUI.addElement(recta);
						break;
					
					
					case PATH:
						
						pathData = " M"+x1+' '+y1;
						pathBrush = new Path();
						shapeGroupUI.addElement(pathBrush);
						shapestro = new SolidColorStroke(StrokeColor);
						pathBrush.stroke = shapestro;
						break;
					
					
					case NORMAL_RECT:
						
						//normalRect = new Rect();
						img = new Image();
						img.source = noteIcon;
						img.mouseChildren = false;
						img.mouseEnabled = false;
						img.x = x1 - 7;
						img.y = y1 - 7;
						img.smooth = true;
						//shapeGroupUI.addElement(normalRect);
						shapeGroupUI.addElement(img);
						
						break;
					
				}
				//shapecanvasUI.addElement(shapeGroupUI);
				this.addElement(shapeGroupUI);
				shapeGroupUI.id = shapeGroupUI.name;
				//shapecanvasUI.addEventListener(MouseEvent.CLICK,removeDrawing);
			}
			
			if(event.type == "mouseMove")
			{
				//x2=event.localX;
				//y2=event.localY;
				switch(shapeSelected){
					
					case LINE:
						
						shapestro.caps ="square";
						linel.xFrom = x1;
						linel.yFrom = y1;
						linel.xTo = x2;
						linel.yTo = y2;
						shapestro = new SolidColorStroke(StrokeColor,StrokeWeightSlider,StrokeAlphaColorSlider);
						linel.stroke= shapestro;
						break;
					
					case ELLIPSE:
						
						circle.width = x2-x1;
						circle.height = y2-y1;
						circle.x = x1;
						circle.y = y1;
						shapestro = new SolidColorStroke(StrokeColor,StrokeWeightSlider,StrokeAlphaColorSlider);
						shapefill = new SolidColor(FillColor,AlphaSlider);
						circle.stroke = shapestro;
						circle.fill = shapefill;
						break;
					
					case RECT: 
						
						recta.width = x2-x1;
						recta.height = y2-y1;
						recta.x = x1;
						recta.y = y1;
						shapestro = new SolidColorStroke(StrokeColor,StrokeWeightSlider,StrokeAlphaColorSlider);
						shapefill = new SolidColor(FillColor,AlphaSlider);
						recta.stroke = shapestro;
						recta.fill = shapefill;
						break;
					
					case NORMAL_RECT:
						
						/*normalRect.width = x2-x1;
						normalRect.height = y2-y1;
						normalRect.x = x1;
						normalRect.y = y1;
						img.x = ((x1<x2)?x1:x2)-10;
						img.y = ((y1<y2)?y1:y2)-10;
						shapestro = new SolidColorStroke(NormalStrokeColor,StrokeWeightSlider,StrokeAlphaColorSlider);
						shapefill = new SolidColor(NormalFillColor,AlphaSlider);
						normalRect.stroke = shapestro;
						normalRect.fill = shapefill;*/
						break;
					
					
					case PATH:
						
						x2 = event.localX;
						y2 = event.localY;
						shapestro = new SolidColorStroke(StrokeColor,StrokeWeightSlider,StrokeAlphaColorSlider);
						pathBrush.stroke = shapestro;
						pathData += " L"+x2+' '+y2; 
						pathBrush.data = pathData;
						break;
				}
				if(buttonReleased)
				{
					this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
				}
			}
			
			if(event.type == "mouseUp") {
				var xPosition:Number = 0;
				var yPosition:Number = 0;
				if(shapeSelected == LINE)
				{
					xPosition = x1;
					yPosition = y1;
					fxgData += ' <s:Group><s:'+shapeSelected+' xFrom ="'+x1+'" yFrom ="'+y1+'" xTo ="'+x2+'" yTo ="'+y2+'"><s:stroke><s:SolidColorStroke color = "#'+convertToRGB(this.StrokeColor)+'" weight="'+StrokeWeightSlider+'" alpha="'+StrokeAlphaColorSlider+'"/></s:stroke></s:'+shapeSelected+'></s:Group>';
					svgData = ' <'+shapeSelected+ ' style="stroke:#'+convertToRGB(this.StrokeColor)+'" x1="'+x1+'" y1="'+y1+'" x2="'+x2+'" y2="'+y2+'"/>';
				}
				
				if(shapeSelected == RECT)
				{
					xPosition = xVal;
					yPosition = yVal;
					fxgData += ' <s:Group><s:'+shapeSelected+' x="'+xVal+'" y="'+yVal+'" width="'+widthVal+'" height="'+heightVal+'"><s:fill><s:SolidColor color = "#'+convertToRGB(this.FillColor)+'" alpha="'+AlphaSlider+'"/></s:fill><s:stroke><s:SolidColorStroke color = "#'+convertToRGB(this.StrokeColor)+'" weight="'+StrokeWeightSlider+'" alpha="'+StrokeAlphaColorSlider+'"/></s:stroke></s:'+shapeSelected+'></s:Group>';
					svgData = ' <'+shapeSelected+ ' fill="#'+convertToRGB(this.FillColor)+'" style="stroke:#'+convertToRGB(this.StrokeColor)+'" x="'+xVal+'" y="'+yVal+'" width="'+widthVal+'" height="'+heightVal+'"/>';
				}
				if(shapeSelected == NORMAL_RECT)
				{
					xPosition = x1;
					yPosition = y1;
					fxgData += ' <s:Group><s:'+RECT+' x="'+x1+'" y="'+y1+'" width="0" height="0"><s:fill><s:SolidColor color = "#'+convertToRGB(this.NormalFillColor)+'" alpha="'+AlphaSlider+'"/></s:fill><s:stroke><s:SolidColorStroke color = "#'+convertToRGB(this.NormalStrokeColor)+'" weight="'+StrokeWeightSlider+'" alpha="'+StrokeAlphaColorSlider+'"/></s:stroke></s:'+RECT+'></s:Group>';
					svgData = ' <'+RECT+ ' fill="#'+convertToRGB(this.NormalFillColor)+'" style="stroke:#'+convertToRGB(this.NormalStrokeColor)+'" x="'+x1+'" y="'+y1+'" width="0" height="0"/>';
				}
				if(shapeSelected == ELLIPSE)
				{
					xPosition = xVal;
					yPosition = yVal+(heightVal/2);
					fxgData += ' <s:Group><s:'+shapeSelected+' x="'+xVal+'" y="'+yVal+'" width="'+widthVal+'" height="'+heightVal+'"><s:fill><s:SolidColor color = "#'+convertToRGB(this.FillColor)+'"alpha="'+AlphaSlider+'"/></s:fill><s:stroke><s:SolidColorStroke color = "#'+convertToRGB(this.StrokeColor)+'" weight="'+StrokeWeightSlider+'" alpha="'+StrokeAlphaColorSlider+'"/></s:stroke></s:'+shapeSelected+'></s:Group>';
					svgData = ' <'+shapeSelected+ ' fill="#'+convertToRGB(this.FillColor)+'" style="stroke:#'+convertToRGB(this.StrokeColor)+'" cx="'+(xVal+(widthVal/2))+'" cy="'+(yVal+(heightVal/2))+'" rx="'+widthVal/2+'" ry="'+heightVal/2+'"/>';
				}
				if(shapeSelected == PATH)
				{
					xPosition = xVal;
					yPosition = yVal;
					fxgData += ' <s:Group><s:'+shapeSelected+' x="'+xVal+'" y="'+yVal+'" data="'+pathData+'"><s:stroke><s:SolidColorStroke color = "#'+convertToRGB(this.StrokeColor)+'" weight="'+StrokeWeightSlider+'" alpha="'+StrokeAlphaColorSlider+'"/></s:stroke></s:'+shapeSelected+'></s:Group>';
					svgData = ' <'+shapeSelected+ ' fill="#'+convertToRGB(this.FillColor)+'" style="stroke:#'+convertToRGB(this.StrokeColor)+'" d="'+pathData+'"/>'; 
				}
				this.removeEventListener(MouseEvent.MOUSE_MOVE,mouseAction);
				this.removeEventListener(MouseEvent.MOUSE_UP, mouseAction);
				if(shapeSelected != NONE)
				{
					var commentVO:CommentVO = new CommentVO();
					commentVO.commentTitle = shapeSelected;
					commentVO.commentTitle = shapeSelected;
					commentVO.commentDescription = ProcessUtil.convertToByteArray(fxgData);
					commentVO.commentX = xPosition;
					commentVO.commentY = yPosition;
					/*commentVO.commentHeight = heightVal;
					commentVO.commentWidth = widthVal;*/
					commentVO.commentHeight = 0;
					commentVO.commentWidth = 0;
					yPosition = yVal;
					dispatchEvent(new CommentCollectionEvent(CommentCollectionEvent.COMMENT_COLLECTION_UPDATE,commentVO, shapeGroupUI.name));
				}
			}
		}
		
		public function drawFromList(xml:XMLList):void
		{
			removeAllElements();
			for(var i:int = 0;i<xml.length();i++)
			{
				var Obj:Object = xmlToObject(xml[i]);
				if(Obj.item.commentDescription)
				{
					var commentName:String = textToString(Obj.item.commentDescription);
				}
			}
			
		}
		
		public function removeComment(commentName:String):void
		{
			var commentItem:CommentItem;
			for(var commentCounter:int = 0;commentCounter<this.numElements;commentCounter++){
				
				if((getElementAt(commentCounter) as CommentItem).name == commentName)
					commentItem = (getElementAt(commentCounter) as CommentItem)
			}
			removeElement(commentItem);
		}
		
		private function xmlToObject(xml:XML):Object
		{
			var xmlDoc:XMLDocument = new XMLDocument(xml);
			var simpleXMLDecoder:SimpleXMLDecoder = new SimpleXMLDecoder(true);
			var resulrObj:Object = simpleXMLDecoder.decodeXML(xmlDoc);
			return resulrObj;		
		}
		
		public function textToString(TextStringConver:String):String
		{
			var str:String = TextStringConver;
			if(str != "" && str.indexOf('<s:Group>')!=-1){
				try{
					strXML = XML(replaceStringInEntireParagraph(str, "s:","")).children();
					var elementString:String = strXML.name();
					shapeGroupUI = new CommentItem();
					//shapecanvasUI = new Canvas();
					switch(elementString){
						
						case LINE:
							
							var linedraw:Line = new Line;
							str= TextStringConver;
							shapestro = new SolidColorStroke(uint("0x"+String(strXML..SolidColorStroke.@color).substr(1)),Number(strXML..SolidColorStroke.@weight),Number(strXML..SolidColorStroke.@alpha));
							linedraw.xFrom = Number(strXML.@xFrom);
							linedraw.yFrom = Number(strXML.@yFrom);
							linedraw.xTo = Number(strXML.@xTo);
							linedraw.yTo = Number(strXML.@yTo);
							linedraw.stroke = shapestro;
							shapeGroupUI.addElement(linedraw);
							break;
						
						case RECT:
							shapestro = new SolidColorStroke(uint("0x"+String(strXML..SolidColorStroke.@color).substr(1)),Number(strXML..SolidColorStroke.@weight),Number(strXML..SolidColorStroke.@alpha));
							shapefill = new SolidColor(uint("0x"+String(strXML..SolidColor.@color).substr(1)),Number(strXML..SolidColor.@alpha));
							if(shapestro.color == NormalStrokeColor && shapefill.color == NormalFillColor){
								img = new Image();
								img.source = noteIcon;
								img.mouseChildren = false;
								img.mouseEnabled = false;
								img.x = Number(strXML.@x) - 7;
								img.y = Number(strXML.@y) - 7;
								img.smooth = true;
								shapeGroupUI.addElement(img);
							}
							else{
								var rectdraw:Rect = new Rect;
								str= TextStringConver;
								rectdraw.x = Number(strXML.@x);
								rectdraw.y = Number(strXML.@y);
								rectdraw.width = Number(strXML.@width);
								rectdraw.height = Number(strXML.@height);
								rectdraw.stroke = shapestro;
								rectdraw.fill = shapefill;
								shapeGroupUI.addElement(rectdraw);
							}
							break;
						
						case ELLIPSE:
							
							var circledraw:Ellipse = new Ellipse;
							str= TextStringConver;
							shapestro = new SolidColorStroke(uint("0x"+String(strXML..SolidColorStroke.@color).substr(1)),Number(strXML..SolidColorStroke.@weight),Number(strXML..SolidColorStroke.@alpha));
							shapefill = new SolidColor(uint("0x"+String(strXML..SolidColor.@color).substr(1)),Number(strXML..SolidColor.@alpha));
							circledraw.x = Number(strXML.@x);
							circledraw.y = Number(strXML.@y);
							circledraw.width = Number(strXML.@width);
							circledraw.height = Number(strXML.@height);
							circledraw.stroke = shapestro;
							circledraw.fill = shapefill;
							shapeGroupUI.addElement(circledraw);
							break;
						
						case PATH:
							
							var pathBrushdraw:Path = new Path;
							str= TextStringConver;
							shapestro = new SolidColorStroke(uint("0x"+String(strXML..SolidColorStroke.@color).substr(1)),Number(strXML..SolidColorStroke.@weight),Number(strXML..SolidColorStroke.@alpha));
							pathBrushdraw.data = String(strXML.@data);
							pathBrushdraw.stroke = shapestro;
							shapeGroupUI.addElement(pathBrushdraw);
							break;
					}
					//shapecanvasUI.addElement(shapeGroupUI);
					this.addElement(shapeGroupUI);
					return shapeGroupUI.name;
					//shapecanvasUI.addEventListener(MouseEvent.CLICK,removeDrawing);
				}
				catch(err:Error){
					trace("Please give the Proper String","Invalid");
				}
			}
			else
			{
				trace("Please give the Proper String","Invalid");
			}
			return "";
		}
		public static function replaceStringInEntireParagraph(str:String, p:*, repl:*):String
		{
			var isStringChanged:Boolean = true;
			var newfxg:String;
			while ( isStringChanged )
			{
				newfxg = str.replace(p, repl);
				if ( newfxg != str )
					str= newfxg;
				else
					isStringChanged = false;
			}
			return newfxg;
		}
		public function removeDrawing(event:MouseEvent):void
		{
			/*if(event.currentTarget is Canvas && _deleteItem){
				this.removeElement(Canvas(event.currentTarget));
			}*/
		}
		public function clearScreen():void{
			this.removeAllElements();
		}
		private function convertToRGB(drawColor:uint):String {
			var hexColor:String=drawColor.toString(16);
			if (hexColor.length == 1) {
				hexColor="000000";
			}
			else if (hexColor.length == 2) 
			{
				hexColor="0000"+hexColor;
			}
			else if (hexColor.length == 4) 
			{
				hexColor="00"+hexColor;
			}
			return hexColor;
		}
		
	}
}
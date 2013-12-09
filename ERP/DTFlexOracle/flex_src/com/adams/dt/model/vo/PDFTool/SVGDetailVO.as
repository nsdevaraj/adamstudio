package com.adams.dt.model.vo.PDFTool
{
	import com.adobe.cairngorm.vo.ValueObject;
	
	[Bindable]
	public class SVGDetailVO implements ValueObject
	{
		
		public static const LINE : String = "LINE";
		public static const BRUSH : String = "BRUSH";
		public static const HIGHLIGHT : String = "HIGHLIGHT";
		public static const RECTANGLE : String = "RECT"; 
		public static const OVAL : String = "OVAL";
		public static const ERASE : String = "ERASE";
		public static const CLEAR : String = "CLEAR"; 
		public static const UNDO : String = "UNDO";
		public static const REDO : String = "REDO";
		public static const SVG_BEGIN : String = '<?xml version="1.0" standalone="no"?>\n<svg version="1.1" xmlns="http://www.w3.org/2000/svg">';
		public static const SVG_TERMINATOR:String = '\n</svg>';
		
		
		public function SVGDetailVO()
		{

			// Initial Value Assignment
			drawingShape = BRUSH;
			svgData = "";

		}
		
		// Select Drawing Tool variable 
		private var _drawingShape:String;
		public function set drawingShape (value:String):void
		{
			_drawingShape = value;
		}

		public function get drawingShape ():String
		{
			return _drawingShape;
		}
		
		// SVG Data without Beginning Tag and Ending Tag
		private var _svgData:String;
		public function set svgData (value:String):void
		{
			_svgData = value;
		}

		public function get svgData ():String
		{
			return _svgData;
		}
		
		private var _svgDetailData:String;
		public function set svgDetailData (value:String):void
		{
			_svgDetailData = value;
		}

		public function get svgDetailData ():String
		{
			return _svgDetailData;
		}
		
	}
}
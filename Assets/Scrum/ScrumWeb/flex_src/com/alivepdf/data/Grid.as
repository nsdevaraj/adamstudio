package com.alivepdf.data
{
	import flash.utils.ByteArray;
	
	import com.alivepdf.colors.IColor;
	import com.alivepdf.export.CSVExport;
	import com.alivepdf.export.Export;
	import com.alivepdf.serializer.ISerializer;
	
	public class Grid
	{
		private var _data:Array;
		private var _width:Number;
		private var _height:Number;
		private var _x:int;
		private var _y:int;
		private var _columns:Array;
		private var _borderColor:IColor;
		private var _borderAlpha:Number;
		private var _joints:String;
		private var _backgroundColor:IColor;
		private var _headerColor:IColor;
		private var _cellColor:IColor;
		private var _alternateRowColor:Boolean;
		private var _serializer:ISerializer;
		
		public function Grid( data:Array, width:Number, height:Number, headerColor:IColor, cellColor:IColor, alternateRowColor:Boolean, borderColor:IColor, borderAlpha:Number=1, joints:String="0 j", columns:Array=null)
		{
			_data = data;
			_width = width;
			_height = height;
			_borderColor = borderColor;
			_borderAlpha = borderAlpha;
			_joints = joints;
			_headerColor = headerColor;
			_cellColor = cellColor;
			_alternateRowColor = alternateRowColor;	
			if ( columns != null )
				this.columns = columns; 
		}
		
		public function export ( type:String="csv" ):ByteArray
		{
			if ( type == Export.CSV ) 
				_serializer = new CSVExport(_data, _columns);
			return _serializer.serialize();
		}
		
		public function get columns ():Array
		{
			return _columns;
		}
		
		public function set columns ( columns:Array ):void
		{
			_columns = columns;
		}
		
		public function get width ():Number
		{
			return _width;	
		}
		
		public function get height ():Number
		{
			return _height;	
		}
		
		public function get x ():int
		{
			return _x;	
		}
		
		public function get y ():int
		{
			return _y;	
		}
		
		public function set x ( x:int ):void
		{
			_x = x;	
		}
		
		public function set y ( y:int ):void
		{
			_y = y;
		}
		
		public function get borderColor ():IColor
		{
			return _borderColor;	
		}
		
		public function get borderAlpha ():Number
		{
			return _borderAlpha;	
		}
		
		public function get joints ():String
		{
			return _joints;	
		}
		
		public function get headerColor ():IColor
		{
			return _headerColor;	
		}
		
		public function get cellColor ():IColor
		{
			return _cellColor;	
		}
		
		public function get alternateRowColor ():Boolean
		{	
			return _alternateRowColor;	
		}
		
		public function get dataProvider ():Array
		{
			return _data;	
		}
		
		public function toString ():String 
        {
            return "[Grid cells="+_data.length+" alternateRowColor="+_alternateRowColor+" x="+x+" y="+y+"]";    
        } 
	}
}
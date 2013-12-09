package com.adams.pdf.util
{
	import com.adams.pdf.model.vo.*;
	
	import flash.utils.ByteArray;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	public class ProcessUtil
	{
		public static const PONDYTIME:String ='http://www.earthtools.org/timezone/11.976188/79.785461';
		public static const LIMOGESTIME:String ='http://www.earthtools.org/timezone/0.056869/0.104628';
		public static var interval:uint;
		public static var timeDiff:int;
		public static var isCLT:Boolean;
		public static var isIndia:Boolean;
		public static var existFileSelection:Boolean = false;

		public static var month:Array =  ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","sep","Oct","Nov","Dec"]; 
		public static function getFileName( str:String ):String {
			var lastind:int = str.lastIndexOf( '/' ) + 1;
			return str.slice( lastind, str.length );
		}		
		
		public static function startTimerFunction(func:Function,timer:int):void{
			stopTimerFunction();
			interval = setInterval(func, timer);
		}
		
		public static function stopTimerFunction():void{
			if (interval)clearInterval(interval);
		}
		
		public static function convertToByteArray( str:String ):ByteArray {
			var _byteArray:ByteArray = new ByteArray();
			_byteArray.writeUTFBytes( str );
			return _byteArray;
		}		
	}
}
/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  PDFTool

@internal 

*/
package com.adams.pdf.util
{  
	import com.adams.pdf.model.AbstractDAO;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;

	public class Utils
	{  	  
		// todo: add view index
		public static const MAIN_INDEX:String='Main';
		// todo: add key
		public static const PERSONSKEY  :String='personId';
		public static const COMMENTVOKEY  :String='commentID';
		public static const FILEDETAILSKEY  :String='fileId';
		
		// todo: add dao
       public static const PDFTOOL_INDEX:String='PDFTool';
		public static const PERSONSDAO  :String='personsDAO'; 
		public static const COMMENTVODAO  :String='commentvoDAO'; 
		public static const FILEDETAILSDAO  :String='filedetailsDAO'; 
		public static var fileSplitter:String =  '/';
		public static const ALERT_YES:int = 0;
		public static const ALERT_NO:int = 1;
		public static const ALERT_OK:int = 2;
		public static const PROGRESS_INDEX:String='Progress';
		public static const PROGRESS_ON:String = "progressOn"; 
		public static const PROGRESS_OFF:String = "progressOff"; 
		
		public static const LOGIN_INDEX:String = 'Login';
		public static const UPLOAD_INDEX:String = 'Upload';
		
		public static const BASICFILETYPE:String ="Basic";
		public static const TASKFILETYPE:String ="Tasks";
		public static const RELEASEFILETYPE:String ="Release";
		
		public static const APPTITLE : String = "PDFToolViewer";
		public static const FILESYNC : String = "File does not exist";
		public static const PDFCONVERSIONFAILED : String = "Files Conversion not done";
		public static const FILEID_WRONG:String = "Invalid File Id"; 
		public static var existFileSelection:Boolean = false;
		
		public static function addArrcStrictItem( item:Object, arrc:ArrayCollection, sortString:String, modified:Boolean =false ):void{
			var returnValue:int = -1;
			var sort:Sort = new Sort(); 
			sort.fields = [ new SortField( sortString ) ];
			if(arrc.sort==null) arrc.sort = sort;
			arrc.refresh(); 
			var cursor:IViewCursor = arrc.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				returnValue = arrc.getItemIndex( cursor.current );
			} 	
			if( returnValue == -1 ) {
				arrc.addItem(item);
			}else{
				if(modified){
					arrc.removeItemAt(returnValue);
					arrc.addItemAt(item, returnValue);
				}
			}
		}
		public static function removeArrcItem(item:Object,arrc:ArrayCollection, sortString:String):void{
			var returnValue:int = -1;
			var sort:Sort = new Sort(); 
			sort.fields = [ new SortField( sortString ) ];
			if(arrc.sort==null) arrc.sort = sort;
			arrc.refresh(); 
			var cursor:IViewCursor = arrc.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				returnValue = arrc.getItemIndex( cursor.current );
			} 	
			if( returnValue != -1 ) {
				arrc.removeItemAt(returnValue);
			}
		} 
		
		public static function convertToByteArray( str:String ):ByteArray {
			var _byteArray:ByteArray = new ByteArray();
			_byteArray.writeUTFBytes( str );
			return _byteArray;
		}
		
		// Remove "space" from front 
		public static function trimFront(value:String):String
		{
			if(value.charAt(0) == " ")
			{
				value = trimFront(value.substr(1));
			}
			return value;
		}
		
		// Remove "space" from end
		public static function trimBack(value:String):String
		{
			if(value.charAt(value.length-1) == " ")
			{
				value = trimBack(value.substring(0,value.length-1));
			}
			return value;
		}
	}
}
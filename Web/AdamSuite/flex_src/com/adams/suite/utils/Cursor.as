package com.adams.suite.utils
{
	import mx.collections.*; 
	public class Cursor
	{ 
		//navigation constants
		public static const FIRST:String = 'first';
		public static const NEXT:String = 'next';
		public static const BACK:String = 'back';
		public static const LAST:String = 'last';
		public static const SEEK:String = 'seek';
		//IViewcursor 
		public var myCursor:IViewCursor;
		public function Cursor(XMLC:XMLListCollection)
		{
			myCursor = XMLC.createCursor();
		}
		//next element of cursor
 		private function nextCollection():void {
			if(! myCursor.afterLast) {
			   myCursor.moveNext(); 
			}
   	    }
   	    //previous element of cursor
	    private function backCollection():void {
			if(!myCursor.beforeFirst) {
				myCursor.movePrevious(); 
			}
	    }
	    //first element of cursor
	    private function firstCollection():void {
			myCursor.seek(CursorBookmark.FIRST); 
	    }
	    //last element of cursor
	    private function lastCollection():void {
			myCursor.seek(CursorBookmark.LAST); 
	    }
	    //find element of cursor
		private function seekCollection():void { 	
			var mark:CursorBookmark=myCursor.bookmark;
			while (myCursor.moveNext()) { 
			}
			myCursor.seek(mark);
		} 
		//navigate based on case
		public function navigate(caseStr:String):void {
			switch(caseStr) {
				case FIRST:
				  firstCollection();
				  break;
				case BACK:
				  backCollection();
				  break;
				case NEXT:
				  nextCollection();
				  break;
				case LAST:
				  lastCollection();
				  break;
				case SEEK:
				  seekCollection();
				  break;
	       } 		 
	  	}
	}
}
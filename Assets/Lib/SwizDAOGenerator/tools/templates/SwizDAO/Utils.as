/*

Copyright (c) @year@ @company.name@, All Rights Reserved 

@author   @author.name@
@contact  @author.email@
@project  @project.name@

@internal 

*/
package @namespace@.util
{  
	import @namespace@.model.AbstractDAO;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	public class Utils
	{  	  
		// todo: add view index
		public static const MAIN_INDEX:String='Main';
		// todo: add key
		 
		// todo: add dao
		public static var fileSplitter:String =  '/';
		public static const ALERT_YES:int = 0;
		public static const ALERT_NO:int = 1;
		public static const ALERT_OK:int = 2;
		public static const PROGRESS_INDEX:String='Progress';
		public static const PROGRESS_ON:String = "progressOn"; 
		public static const PROGRESS_OFF:String = "progressOff"; 	 
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
	}
}
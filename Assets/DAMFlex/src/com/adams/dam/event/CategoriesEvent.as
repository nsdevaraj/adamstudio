package com.adams.dam.event
{
	import com.adams.dam.model.vo.Categories;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;

	public class CategoriesEvent extends UMEvent
	{
		
		public static const EVENT_GET_ALL_CATEGORIES:String = 'getAllCategories';
		
		public var categories:Categories; 
		
		public function CategoriesEvent( pType:String, handlers:IResponder = null, bubbles:Boolean = true, cancelable:Boolean = false, pCategories:Categories = null ) {			
			categories= pCategories;
			super( pType, handlers, true, false, categories );			
		}		 
	}
}
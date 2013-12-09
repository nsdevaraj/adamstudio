/**
 * Article
 * 
 * This class represents a blog article: its id, title, date, category, and content, among other
 * things. 
 */
package com.adams.blog.data
{
	import flash.events.EventDispatcher;
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	
	[Bindable]
	public class Article extends EventDispatcher
	{
		public var id:String;
		public var title:String;
		public var date:Date;
		public var category:String;
		public var categoryCode:String;
		public var published:Boolean;
		
		public var content:String;
		
		/**
		 * createArticle
		 * 
		 * Creates a new Article from the given data and returns it.
		 */
		static public function createArticle( id:String, title:String, date:Date, category:String, categoryCode:String, content:String, published:int ) : Article
		{
			var a:Article = new Article();
			a.id = id;
			a.title = title;
			a.date = date;
			a.category = category;
			a.categoryCode = categoryCode;
			a.content = content;
			a.published = (published == 1);
			
			return a;
		}
		
	}
}
/**
 * ArticleSWF
 * 
 * This class encapsulates the information about an attached image or swf.
 */
package com.adams.blog.data
{
	import flash.events.EventDispatcher;

	[Bindable]
	public class ArticleSWF extends EventDispatcher
	{
		public var id:String;
		public var label:String;
		public var URL:String;
		
		/**
		 * createArticleSWF
		 * 
		 * Creates a new ArticleSWF from the given data and returns it.
		 */
		static public function createArticleSWF( label:String, url:String ) : ArticleSWF
		{
			var result:ArticleSWF = new ArticleSWF();
			result.label = label;
			result.URL = url;
			return result;
		}
	}
}
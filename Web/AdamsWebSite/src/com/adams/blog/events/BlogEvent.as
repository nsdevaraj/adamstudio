/**
 * BlogEvent
 * 
 * This is a multi-purpose event class for this blog project. It may be a bit too 
 * overloaded given the various types of events it services, but for now it works
 * well enough.
 */
package com.adams.blog.events
{
	import flash.events.Event;
	import com.adams.blog.data.Article;
	import mx.collections.ArrayCollection;

	public class BlogEvent extends Event
	{
		public static const ADD_LINK:String = "addLink";
		public static const DELETE_LINK:String = "deleteLink";
		public static const UPLOAD_BEGIN:String = "uploadBegin";
		public static const UPLOAD_COMPLETE:String = "uploadComplete";
		public static const INSERT_LINK:String = "insertLink";
		public static const INSERT_SWF:String = "insertSWF";
		public static const IMAGE_UPDATE:String = "imageUpdate";
		public static const SAVE_ARTICLE:String = "saveArticle";
		public static const EDIT_ARTICLE:String = "editArticle";
		public static const DELETE_ARTICLE:String = "deleteArticle";
		public static const PUBLISH_ARTICLE:String = "publishArticle";
		public static const UNPUBLISH_ARTICLE:String = "unpublishArticle";
		public static const DATE_PICK:String = "datePick";
		
		public function BlogEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * linkLabel and linkUR are set when event is ADD_LINK, DELETE_LINK, or INSERT_LINK
		 */
		public var linkLabel:String;
		public var linkURL:String;
		
		/**
		 * swfURL/Align/Width/Height are set when the event is INSERT_SWF
		 */
		public var swfURL:String;
		public var swfAlign:String;
		public var swfWidth:String;
		public var swfHeight:String;

		/**
		 * uploadURL is set when the event is UPLOAD_COMPLETE
		 */
		public var uploadURL:String;
		
		/**
		 * article set when the event is EDIT_ARTICLE, DELETE_ARTICLE, PUBLISH_ARTICLE, and UNPUBLISH_ARTICLE
		 */
		public var article:Article;
		
		/**
		 * categoryCode, articleId, articleTitle, and articleContent are set whe the event
		 * type is SAVE_ARTICLE
		 */
		public var categoryCode:String;
		public var articleId:String;
		public var articleTitle:String;
		public var articleContent:String;
		
		/**
		 * selectedDate is set when the event type is DATE_PICK
		 */
		public var selectedDate:Date;
	}
}
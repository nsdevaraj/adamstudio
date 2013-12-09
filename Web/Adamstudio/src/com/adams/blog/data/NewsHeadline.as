/**
 * NewsHeadline
 * 
 * A news headline is stored as an Article, but with the category of News. Newsheadlines appear
 * in a separate section on the Blog Reader.
 */
package com.adams.blog.data
{
	public class NewsHeadline
	{
		public var id:String;
		public var date:Date;
		
		public var content:String;
		
		/**
		 * createNewsHeadline
		 * 
		 * Creates a new NewsHeadline from the given data and returns it.
		 */
		static public function createNewsHeadline( id:String, date:Date, content:String ) : NewsHeadline
		{
			var n:NewsHeadline = new NewsHeadline();
			
			n.id = id;
			n.date = date;
			n.content = content;
			
			return n;
		}
	}
}
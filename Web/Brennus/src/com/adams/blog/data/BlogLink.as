/**
 * BlogLink
 * 
 * This class encapsulates a link on the blog. A BlogLink is the data behind the Link buttons on the
 * Blog Reader - typically links to others' blogs.
 */
package com.adams.blog.data
{
	public class BlogLink
	{
		public var url:String;
		public var label:String;
		
		/**
		 * createBlogLink
		 * 
		 * Creates a new BlogLink from the given data and returns it.
		 */
		static public function createBlogLink( url:String, label:String ) : BlogLink
		{
			var b:BlogLink = new BlogLink();
			b.url = url;
			b.label = label;
			
			return b;
		}
	}
}
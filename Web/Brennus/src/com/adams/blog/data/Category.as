/**
 * Category
 * 
 * This class encapsulates the definition of a blog article Category.
 */
package com.adams.blog.data
{
	public class Category
	{
		public var code:String;
		public var label:String;
		
		/**
		 * createCategory
		 * 
		 * Creates a new Category from the given data and returns it.
		 */
		static public function createCategory( code:String, label:String ) : Category
		{
			var c:Category = new Category();
			c.code = code;
			c.label = label;
			
			return c;
		}
	}
}
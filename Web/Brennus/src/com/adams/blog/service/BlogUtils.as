package com.adams.blog.service
{
	public class BlogUtils
	{
		/**
		 * parseNumber
		 * 
		 * This function takes a String like 100% and returns 100.
		 */
		static public function parseNumber(s:String) : Number
		{
			var n:Number = Number(s);
			if( isNaN(n) ) {
				var percent:Number = s.indexOf("%");
				if( percent < 0 ) return n;
				n = Number( s.substr(0,percent) );
			}
			return n;
		}
		
		/**
		 * isPercent
		 * 
		 * Returns true if the string ends with a %
		 */
		static public function isPercent(s:String): Boolean
		{
			var percent:Number = s.lastIndexOf("%");
			return percent >= 0;
		}
	}
}
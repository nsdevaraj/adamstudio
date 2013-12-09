package com.universalmind.cairngorm.vo
{
  /**
    * This class replaces the com.adobe.cairngorm.vo interface to 
    * require all VO implementations to have copyFrom() and clone()
    * functionality
    */
	public interface IValueObject {

      /** 
        * Allows any value object (complex or simple) to compare itself 
        * to a "source" object. This allows business logic to easily perform
        * comparisons to even tree-like data structures by simply comparing
        * the root nodes. [Of course the equals() implementation must ask the
        * children to compare themselves also...]
        * 
        * @src This is another value object that should be compared for equality.
        * An easy check is to see if the runtime datatype is of the same class type.
        * Note: that this allows comparisons of complex data types to scalar values...
        * if the developer wishes to support such "polymorphic" method overrides.
        */	
	  function equals(src:*):Boolean;

	  /**
	    * This method allows VOs to easily initialize themselved based on
	    * values within other instances.
	    */
		function copyFrom(src:*):*;
		
		/**
		  * This method allows VOs to easily clone themselves; allows developers
		  * to quickly create local copies, presever master references, and bypass
		  * issues related to Flex's "pass-by-reference".
		  */
		function clone():*;
	
	}
}
/*
Copyright (c) 2008, Universal Mind
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the 
    * documentation and/or other materials provided with the distribution.
    * Neither the name of the Universal Mind nor the names of its contributors may be used to endorse or promote products derived from 
    * this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY UNIVERSAL MIND AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Thomas Burleson, Principal Architect
        ThomasB@UniversalMind.com
                
@ignore
*/

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
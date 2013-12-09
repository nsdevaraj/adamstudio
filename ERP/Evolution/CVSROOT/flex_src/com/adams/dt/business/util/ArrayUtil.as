package com.adams.dt.business.util 
{
	import __AS3__.vec.Vector;
	
     public class ArrayUtil
    {
         public static function addElement(element:*, source:Array):*
        {
            source.push(element);
            return element;
        }
       
         public static function addElementAt(element:*, index:int, source:Array):*
        {
            if (index < 0) {
                index += source.length;
            }
           
            if (index < 0 || source.length < index) {
                throw new RangeError('index');
            }
           
            source.splice(index, 0, element);
           
            return element;
        } 
        public static function addObjectAtIndex( array: Array, object: Object, index: int ): void
		{
			if( 0 == index )
				array.unshift( object );
			else
			if( array.length == index )
				array.push( object );
			else
				array.splice( index, 0, object );
		}
         public static function getElementAt(index:int, source:Array):*
        {
            if (index < 0) {
                index += source.length;
            }
           
            if (index < 0 || source.length <= index) {
                throw new RangeError('index');
            }
           
            return source[index];
        }
       
 
        public static function getElementIndex(element:*, source:Array):int
        {
            return source.indexOf(element);
        }
        
        public static function removeElement(element:*, source:Array):*
        {
            var index:int = source.indexOf(element);
            if (index < 0) {
                throw new ArgumentError('element');
            }
           
            source.splice(index, 1);
           
            return element;
        }
        
        public static function removeElementAt(index:int, source:Array):*
        {
            if (index < 0) {
                index += source.length;
            }
           
            if (index < 0 || source.length <= index) {
                throw new RangeError('index');
            }
           
            return source.splice(index, 1)[0];
        } 
        public static function setElementIndex(element:*, index:int, source:Array):void
        {
            if (index < 0) {
                index += source.length;
            }
           
            if (index < 0 || source.length <= index) {
                throw new RangeError('index');
            }
           
            var oldIndex:int = source.indexOf(element);
            if (oldIndex < 0) {
                throw new ArgumentError('element');
            }
           
            source.splice(oldIndex, 1);
            source.splice(index, 0, element);
        }
        
        public static function swapElements(element1:*, element2:*, source:Array):void
        {
            var index1:int = source.indexOf(element1);
            if (index1 < 0) {
                throw new ArgumentError('element1');
            }
           
            var index2:int = source.indexOf(element2);
            if (index2 < 0) {
                throw new ArgumentError('element2');
            }
           
            source[index1] = element2;
            source[index2] = element1;
        }
        
        public static function swapElementsAt(index1:int, index2:int, source:Array):void
        {
            if (index1 < 0) {
                index1 += source.length;
            }
            if (index1 < 0 || source.length <= index1) {
                throw new RangeError('index1');
            }
           
            if (index2 < 0) {
                index2 += source.length;
            }
            if (index2 < 0 || source.length <= index2) {
                throw new RangeError('index2');
            }
           
            var temp:* = source[index1];
            source[index1] = source[index2];
            source[index2] = temp;
        }
        public static function arraysAreEqual(arr1:Array, arr2:Array):Boolean
		{
		        if(arr1.length != arr2.length)
		        {
		                return false;
		        }
		       
		        var len:Number = arr1.length;
		       
		        for(var i:Number = 0; i < len; i++)
		        {
		                if(arr1[i] !== arr2[i])
		                {
		                        return false;
		                }
		        }
		       
		        return true;
		}
		
		public static function copyArray(arr:Array):Array
		{       
		        return arr.slice();
		}   
		public static function createUniqueCopy(a:Array):Array
		{
		        var newArray:Array = new Array();
		       
		        var len:Number = a.length;
		        var item:Object;
		       
		        for (var i:uint = 0; i < len; ++i)
		        {
		                item = a[i];
		               
		                if(ArrayUtil.arrayContainsValue(newArray, item))
		                {
		                        continue;
		                }
		               
		                newArray.push(item);
		        }
		       
		        return newArray;
		}                     
		public static function arrayContainsValue(arr:Array, value:Object):Boolean
		{
		        return (arr.indexOf(value) != -1);
		}   

    }
}
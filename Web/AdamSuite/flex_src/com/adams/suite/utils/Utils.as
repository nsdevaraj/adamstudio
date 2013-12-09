/*
* Copyright 2010 @nsdevaraj
* 
* Licensed under the Apache License, Version 2.0 (the "License"); you may not
* use this file except in compliance with the License. You may obtain a copy of
* the License. You may obtain a copy of the License at
* 
* http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
* License for the specific language governing permissions and limitations under
* the License.
*/
package com.adams.suite.utils
{  
	import com.adams.suite.models.vo.*; 
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.core.ClassFactory;
	
	public class Utils
	{  	 
		
		public static const HOME_INDEX:int=0;  
		//xml file path
		public static const  XMLPATH:String = 'aceQuestions.xml';
		public static const ALERTHEADER:String='AdamSuite'; 
		public static const SORTQUESTION:String='@id';
		public static const E4X:String='e4x';
		public static const CHAPTER:String= '_chapter';
		public static const ARRSTR:String='Arr';
		public static const CHAPTITLE:String='CHAP';
		public static const PASSPERCENTAGE:int = 67;
		// tree xml for questions
		public static var treeData:XML;
		public static const finalChapQsArr:Array =  [20,10,12,8,9];   //[131,67,109,54,50];
		//number of questions per chapter
		public static const chapQsArr:Array =  [20,10,12,8,9];  //[131,67,109,54,50];
		// Chapter Titles
		public static const CHAP1:String = "UI";
		public static const CHAP2:String = "Architecture and Design";
		public static const CHAP3:String = "Programming Actionscript";
		public static const CHAP4:String = "Data Source and Servers";
		public static const CHAP5:String = "AIR";
		public static const ttH:int = 1;
		public static const ttM:int = 30;
		public static const ttS:int = 1;
		
		public static var FileSeparator:String='//';
		public static const VIEW_INDEX_ARR:Array = ['com'+FileSeparator+'adams'+FileSeparator+'suite'+FileSeparator+'views'+FileSeparator+'modules'+FileSeparator+'HomeViewModule.swf'];
		
		public static function StrToByteArray(str:String):ByteArray{
			var by:ByteArray = new ByteArray();
			by.writeUTFBytes(str);
			return by;
		}
		public static function removeArrcItem(item:Object,arrc:ArrayCollection, sortString:String):void{
			var returnValue:int = -1;
			var sort:Sort = new Sort(); 
			sort.fields = [ new SortField( sortString ) ];
			if(arrc.sort==null) arrc.sort = sort;
			arrc.refresh(); 
			var cursor:IViewCursor = arrc.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				returnValue = arrc.getItemIndex( cursor.current );
			} 	
			if( returnValue != -1 ) {
				arrc.removeItemAt(returnValue);
			}
		} 
		public static function findObject( item:Object, arrc:ArrayCollection, sortString:String ):Object{
			var returnValue:int = -1;
			var returnObject:Object = new Object();
			var sort:Sort = new Sort(); 
			sort.fields = [ new SortField( sortString ) ];
			if(arrc.sort==null) arrc.sort = sort;
			arrc.refresh(); 
			var cursor:IViewCursor = arrc.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				returnValue = arrc.getItemIndex( cursor.current );
			} 	
			if( returnValue != -1 ) { 
				returnObject = arrc.getItemAt(returnValue);
			}
			return returnObject;
		}
		public static function addArrcStrictItem( item:Object, arrc:ArrayCollection, sortString:String, modified:Boolean =false ):void{
			var returnValue:int = -1;
			var sort:Sort = new Sort(); 
			sort.fields = [ new SortField( sortString ) ];
			if(arrc.sort==null) arrc.sort = sort;
			arrc.refresh(); 
			var cursor:IViewCursor = arrc.createCursor();
			var found:Boolean = cursor.findAny( item );	
			if( found ) {
				returnValue = arrc.getItemIndex( cursor.current );
			} 	
			if( returnValue == -1 ) {
				arrc.addItem(item);
			}else{
				if(modified){
					arrc.removeItemAt(returnValue);
					arrc.addItemAt(item, returnValue);
				}
			}
		} 
		/**
		 * @item //The New Item to be added
		 * @source //The  Array in which the new item is to be added
		 * @sortString //The property of the item by which the comparison takes place
		 * Checks wheather the item to be added already exists in the array, if so replaces it
		 * otherwise just pushes the new object and returns the source array
		 */
		public static function pushNewItem( item:Object, source:Array, sortString:String ):Array {
			var findIndex:int = -1;
			
			for( var i:int = 0; i < source.length; i++ ) {
				if( source[ i ][ sortString ] == item[ sortString ] ) {
					findIndex = i;
					break;
				}
			}
			
			if( findIndex != -1 ) {
				source[ findIndex ] = item;
			}
			else {
				source.push( item );
			}
			
			return source;
		} 
	}
}
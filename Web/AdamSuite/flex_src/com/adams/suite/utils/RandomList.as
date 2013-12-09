package com.adams.suite.utils
{
	import mx.collections.XMLListCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	public class RandomList
	{ 
		//XML List to be returned
		private static var _chapterList:XMLList;
		public static function RandomizeList(list:XMLList,chapLength:int):XMLList{
			var item:XML;
		    _chapterList = new XMLList();
		    for each(item in list) {
		    	// parent node of the element
		    	_chapterList +=XMLList(item.parent());
		    }
		    var _tempArr:Array = new Array();
			var _tempchapter:XMLList = new XMLList(); 
			for(var i:int=0; i<chapLength; i++){
				//Array of index picked
				_tempArr = pickIndex(_chapterList.length(), _tempArr);
				_tempchapter  +=XMLList(_chapterList[[_tempArr[i]]]);		//[_tempArr[i]]		
			}
			var _tempXMLC:XMLListCollection = new XMLListCollection(_tempchapter);
			var sort:Sort = new Sort();  
			sort.fields = [new SortField('@id', true,false,true)];
			// sorting based on ID
			_tempXMLC.sort=sort;				
			_chapterList = XMLList(_tempXMLC);	
			return _chapterList;
		} 
		private static function pickIndex(length:int, pushArr:Array):Array{
			var tempInd:int =  new int(Math.floor(Math.random()*length));
			//avoid repeation by recursion 
			pushArr.indexOf(tempInd) == -1 ? pushArr.push(tempInd) :  pickIndex(length, pushArr);
		 	return pushArr;
		}
	}
}
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
package com.adams.swizdao.util
{ 
	import mx.utils.UIDUtil;
	
	public class FileNameSplitter
	{ 
		public static function splitFileName(str:String):Object{
			var obj:Object = new Object();
			var strlength:int = str.length;
			var splitter:int=0;
			for (var i:int=strlength;i>=0;i--){			
				if(str.charAt(i)=="."){
					splitter = i;
					break;
				}
			}
			
			var filename:String = str.substr(0,splitter);
			var extension:String = str.substr(splitter+1,str.length-1);
			obj.filename = filename;
			obj.extension = extension;
			return obj;
		}
		
		public static function getUId():String{
			return UIDUtil.createUID();
		}
		
	}
}
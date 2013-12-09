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
	import com.adams.swizdao.model.vo.IValueObject;
	
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	import org.osflash.signals.Signal;
	
	import spark.components.DropDownList;
	import spark.components.Form;
	import spark.components.FormItem;
	import spark.components.Label;
	import spark.components.TextArea;
	import spark.components.TextInput;
	
	public class ObjectUtils
	{ 
		public static var buddySignal : Signal = new Signal();
		
		public static function hasOwnProperties( target:Object, propNames:Array/* of String */ ):Boolean {
			var len:int = propNames.length;
			for ( var i:int = 0; i < len; i++ ) {
				if ( !target.hasOwnProperty( propNames[ i ] ) ) return false;
			}
			return true;
		}
		
		public static function propLength( target:Object ):int {
			return getPropNames( target ).length;
		}
		
		public static function toArray( target:Object, propNames:Array = null /* of String */ ):Array {
			var a:Array = [];
			if ( propNames ) {
				for each( var val:String in propNames ) {
					a.push( target[ val ] );
				}
			}
			else {
				a = getPropValues( target );
			}
			return a;
		}
		
		public static function getPropNames( target:Object ):Array {
			var a:Array = [];
			var classAsXML:XML = describeType( target );
			var list:XMLList = classAsXML.*;
			var item:XML;
			
			for each ( item in list ) {
				var itemName:String = item.name().toString();
				switch( itemName ) {
					case "variable":
						a.push( item.@name.toString() );
						break;
					case "accessor":
						var access:String = item.@access;
						if( ( access == "readwrite" ) || ( access == "writeonly" ) ) {
							a.push( item.@name.toString() );
						}
						break;
				}
			}
			
			return a;
		}
		
		public static function getPropValues( target:Object ):Array {
			var propArray:Array = getPropNames( target );
			var a:Array = [];
			for each( var val:String in propArray )  {
				a.push( target[ val ] );	
			}
			return a;
		}
		
		public static function getPropTypes( target:Object ):Array {
			var a:Array = [];
			var classAsXML:XML = describeType( target );
			var list:XMLList = classAsXML.*;
			var item:XML;
			
			for each ( item in list ) {
				var itemName:String = item.name().toString();
				switch( itemName ) {
					case "variable":
						a.push( item.@type.toString() );
						break;
					case "accessor":
						var access:String = item.@access;
						if( ( access == "readwrite" ) || ( access == "writeonly" ) ) {
							a.push( item.@type.toString() );
						}
						break;
				}
			}
			
			return a;
		}
		public static function getPropertyNames(target:Object):Array
		{
			var a:Array = [];
			for (var val:String in target) a.push(val);
			return a;
		}
		
		public static function getCastObject(source:Object,target:IValueObject):IValueObject
		{
			var propArr : Array = getPropertyNames(source);
			for each(var str:String in propArr){ 
				try{
					target[str] = source[str];
				}catch(er:Error){
					try{
						target[str] = new Date(source[str]);
					}catch(er:Error){
						if(Object(target).hasOwnProperty(str))
							target[str]= StrToByteArray(source[str]);
					}
				} 
			}
			return target;
		}
		
		//@TODO
		public static function StrToByteArray(str:String):ByteArray{
			var by:ByteArray = new ByteArray();
			by.writeUTFBytes(str);
			return by;
		}
		public static function setUpForm(obj:Object,taskForm:spark.components.Form):void {
			for (var i: int =0; i<taskForm.numElements; i++){
				if(taskForm.getElementAt(i) is spark.components.FormItem){
					var uiComp:Object = spark.components.FormItem(taskForm.getElementAt(i)).getElementAt(0) as Object;
					if(uiComp is spark.components.TextInput || uiComp is spark.components.TextArea ||  uiComp is Label ){
						try{
							uiComp.text = obj[uiComp.id];
							throw new Error("Not a Text");
						}catch(er:Error){
							if(obj.hasOwnProperty([uiComp.id]))
								if(obj[uiComp.id])uiComp.text = obj[uiComp.id].toString(); 
						}
					} 
				}
			}
		}
		public static function getDropListObject(source:DropDownList,target:IValueObject):IValueObject
		{
			if(source.dataProvider)if(source.dataProvider.length>0)if(source.selectedIndex!=-1)
				target[source.id] = source.dataProvider.getItemAt(source.selectedIndex)[source.name]; 
			return target;
		} 
	}
}
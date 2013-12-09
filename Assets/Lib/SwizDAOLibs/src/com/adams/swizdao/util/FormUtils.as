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
	
	import flash.utils.describeType;
	
	import spark.components.Form;
	import spark.components.FormItem;
	import spark.components.Label;
	import spark.components.TextArea;
	import spark.components.TextInput;
	
	public class FormUtils
	{
		public static function getFormObject(taskForm:Object,target:IValueObject):IValueObject
		{
			var formArr:Array=[];
			for (var i: int =0; i<taskForm.numElements; i++){
				if(taskForm.getElementAt(i) is spark.components.FormItem){
					var uiComp:Object = FormItem(taskForm.getElementAt(i)).getElementAt(0) as Object;
					if(uiComp is spark.components.TextInput || uiComp is spark.components.TextArea ||  uiComp is Label ){
						formArr[uiComp.id]=uiComp;
					}
				}
			}
			var propArr : Array = getPropNames(target);
			for each(var str:String in propArr){
				if(formArr[str] is spark.components.TextInput || formArr[str] is spark.components.TextArea){
					try{
						target[str] = formArr[str].text;
					}catch(er:Error){
						try{
							target[str] = new Date(formArr[str].value);
						}catch(er:Error){
							if(Object(target).hasOwnProperty(str))
								target[str]= ObjectUtils.StrToByteArray(formArr[str].text);
						}
					} 
				}  
			}
			return target;
		}
		//To retrieve form values into target Object
		public static function getCastObject(taskForm:Object,target:IValueObject):IValueObject
		{
			var propArr : Array = getPropNames(target);
			for each(var str:String in propArr){
				try{
					if(taskForm[str] is TextInput){
						target[str] = taskForm[str].text;
					}/*else if(taskForm[str] is DropDownList){ 
					var selectedIndex:int = DropDownList(taskForm[str]).selectedIndex
					var objIndex:Array = DropDownList(taskForm[str]).dataProvider.getItemAt(selectedIndex) as Array;
					target[str] = objIndex[1];
					}*/
				}catch(er:Error){
					
				}
			}
			return target;
		}
		//Get the property names of any required Object
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
		//To assign the property values to a form based on the Object parameters
		public static function setUpForm(obj:Object,taskForm:Form):void {
			for (var i: int =0; i<taskForm.numElements; i++){
				if(taskForm.getElementAt(i) is FormItem){
					var uiComp:Object = FormItem(taskForm.getElementAt(i)).getElementAt(0) as Object;
					if(uiComp is spark.components.TextInput || uiComp is spark.components.TextArea ||  uiComp is Label ){
						try{
							uiComp.text = obj[uiComp.id];
						}catch(er:Error){
							if(obj.hasOwnProperty([uiComp.id]))
								if(obj[uiComp.id])uiComp.text = obj[uiComp.id].toString();
						}
					}/*if(uiComp is DropDownList){
					try{
					if(obj[uiComp.id] is int){
					var indexValue:int = obj[uiComp.id] as int;
					var selectedObj:Array;
					for(var j:int =0; j<DropDownList(uiComp).dataProvider.length; j++){
					var objIndex:Array = DropDownList(uiComp).dataProvider.getItemAt(j) as Array;
					if(objIndex[1] == indexValue){
					selectedObj = objIndex;
					break;
					}
					}	
					DropDownList(uiComp).selectedItem = selectedObj;
					} 
					}catch(er:Error){
					DropDownList(uiComp).selectedIndex = 0;
					}finally{
					DropDownList(uiComp).validateNow();
					}
					}*/
				}
			}
		} 
	}
}
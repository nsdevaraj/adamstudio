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
package com.adams.dt.util
{ 
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Propertiespj;
	import com.adams.dt.model.vo.Propertiespresets;
	import com.adams.dt.model.vo.Proppresetstemplates;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.view.components.PriorityComponent;
	import com.adams.dt.view.components.TextEditor;
	import com.adams.dt.view.components.TimeController;
	import com.adams.dt.view.components.autocomplete.AutoCompleteView;
	import com.adams.dt.view.components.autocomplete.PropertyCompleteView;
	import com.adams.swizdao.model.collections.ICollection;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.DropDownList;
	import spark.components.FormItem;
	import spark.components.Label;
	import spark.components.TextArea;
	import spark.components.TextInput;
	
	public class PropertyUtil
	{
		
		public static var readerRequired:Boolean;
		public static var formModified:Boolean;
		public static var formModifiedArr:Array;
		public static function propertyUpdate( item:Object, propertyCollection:Array,propfieldNames:Array, 
											   propertiespresetsColl:ICollection,propPresettemplateColl:ICollection, prj:Projects=null):void {
			for( var i:int = 0; i < propertyCollection.length; i++ ) {
				var property:String = propertyCollection[i] as String;
				if(prj)item[ property ] = reportLabelFuction( prj, property, propertiespresetsColl, propfieldNames);
				if(propfieldNames.indexOf(property)!=-1) findPropTempValue( item, property, propertiespresetsColl, propPresettemplateColl);
			}
		} 
		
		public static function getFormIDs(taskForm:Object):Array
		{
			var formArr:Array=[];
			for (var i: int =0; i<taskForm.numElements; i++){
				if(taskForm.getElementAt(i) is spark.components.FormItem){
					var uiComp:Object = FormItem(taskForm.getElementAt(i)).getElementAt(0) as Object;
					formArr.push(uiComp.id);
				}
			}
			return formArr;
		}
		
		public static function assignPropertValues(task:Tasks, collection:ICollection):Object{
			var obj:Object = new Object();
			var item:Projects = task.projectObject;
			for each(var propPj:Propertiespj in item.propertiespjSet){
				var property:String =''
				if(propPj.fieldValue){
					property = propPj.fieldValue;
					var getpropPresetItem:Propertiespresets = new Propertiespresets();
					getpropPresetItem.propertyPresetId = propPj.propertyPresetFk;
					var propPreset:Propertiespresets = collection.findExistingItem(getpropPresetItem) as Propertiespresets;
					propPreset.fieldName!='brand' ? obj[propPreset.fieldName] = property  : obj[propPreset.fieldName] = propPreset.fieldOptionsValue.split(',')[property];
				}
			}
			obj['task'] = task;
			return obj;
		}
		
		private static function reportLabelFuction( item:Object, property:String, collection:ICollection, propfieldNames:Array):String {
			var propertyValue:String = '';
			if(propfieldNames.indexOf(property)!=-1){
				propertyValue = getPropertyValue( item as Projects, property, collection);
			} else{
				property == 'refId' ? propertyValue = item.projectName : propertyValue = item.categories.domain.categoryName;
			} 
			return propertyValue;
		}
		
		private static function getPropertyValue(prj:Projects,prop:String, collection:ICollection):String{
			var returnValue:String = '';
			var getpropPresetItem:Propertiespresets = new Propertiespresets();
			getpropPresetItem.fieldName = prop;
			var propPreset:Propertiespresets = collection.findExistingPropItem(getpropPresetItem,'fieldName') as Propertiespresets;
			
			if(prj){
				var prjPropList:ArrayCollection = prj.propertiespjSet; 
				var currentPropPj:Propertiespj
				for each(var pjprop:Propertiespj in prjPropList){
					if(propPreset.propertyPresetId == pjprop.propertyPresetFk){
						currentPropPj = pjprop;
						break;
					}
				}
				if(propPreset.fieldType =='textfield' && currentPropPj){
					if(currentPropPj.fieldValue == '0') currentPropPj.fieldValue = '';
					return currentPropPj.fieldValue;
				}else if(propPreset.fieldOptionsValue){
					var tempArray:Array = propPreset.fieldOptionsValue.toString().split( "," );
					return tempArray[ pjprop.fieldValue ];
				} 
			}
			return returnValue;	
		}
		
		public static function getFormValues(formFields:Array,viewForm:Object,projPjSet:ArrayCollection):ArrayCollection
		{
			formModifiedArr = [];
			var propColl:ArrayCollection = new ArrayCollection();
			for (var i: int =0; i<viewForm.numElements; i++){
				if(viewForm.getElementAt(i) is FormItem){
					var uiComp:Object = FormItem(viewForm.getElementAt(i)).getElementAt(0) as Object;
					var formID:String = uiComp.id;
					if(formFields.indexOf(formID)!=-1){
						propColl.addItem(getFormObjectValue(uiComp,formID,projPjSet));
					}
				}
			}
			return propColl;			
		}
		
		private static function findPropPjItem(propPresetFk:int, projPjSet:ArrayCollection):Propertiespj
		{
			var getPropertiespj:Propertiespj = new Propertiespj()
			getPropertiespj.propertyPresetFk = propPresetFk;
			for each(var propPj:Propertiespj in projPjSet){
				if(propPj.propertyPresetFk == propPresetFk){
					return propPj;
				}
			}
			return getPropertiespj;
		}
		
		private static function getFormObjectValue(uiComp:Object,str:String,projPjSet:ArrayCollection):Propertiespj
		{ 
			var target:Propertiespj;
			target = findPropPjItem(uiComp.name,projPjSet);
			if(uiComp is TextInput || uiComp is TextArea){
				try{
					if(uiComp.text=='') uiComp.text = "  ";
					target = setPropValue(target,str,uiComp.text)
				}catch(er:Error){
					try{
						target = setPropValue(target,str,new Date(uiComp[str].value).toDateString())
					}catch(er:Error){
						if(Object(target).hasOwnProperty(str))
							target = setPropValue(target,str,uiComp[str].text)
					}
				} 
			}   
			if(uiComp is AutoCompleteView ){
				var valueStr:String = AutoCompleteView(uiComp).specificText.toString();
				var options:Array=[];
				for each(var itemStr:Object in AutoCompleteView(uiComp).dataProvider.source){
					options.push(itemStr[Utils.OPTIONS_PROP]);
				}
				target = setPropValue(target,str,valueStr);
			}	
			if(uiComp is PriorityComponent){
				var priorityInt:int = PriorityComponent(uiComp).selectedIndex;
				target = setPropValue(target,str,priorityInt.toString());
			}
			if(uiComp is TimeController){
				var selectedDate:Date = TimeController(uiComp).selectedDate;
				target = setPropValue(target,str,selectedDate.toString());
			}
			if(uiComp is PropertyCompleteView ){
				var valueStrs:String = PropertyCompleteView(uiComp).text.toString();
				var optionsProp:Array=[];
				for each(var itemStrs:Object in PropertyCompleteView(uiComp).dataProvider.source){
					optionsProp.push(itemStrs[Utils.OPTIONS_PROP]);
				}
				target = setPropValue(target,str,valueStrs);
			}	
			return target;
		} 
		
		private static function setPropValue(result:Propertiespj,prop:String, value:String):Propertiespj{
			if(!(result.fieldValue==value || value =="")){
				result.fieldValue = value;
				formModifiedArr.push( result );
				formModified =true;
			}
			return result;
		}
		
		private static function findPropTempValue(  item:Object, property:String, propertiespresetsColl:ICollection,propPresettemplateColl:ICollection):void{
			var getpropPresetItem:Propertiespresets = new Propertiespresets();
			getpropPresetItem.fieldName = property;
			var propPresets:Propertiespresets = propertiespresetsColl.findExistingPropItem(getpropPresetItem,'fieldName') as Propertiespresets;
			var getpropPresetTempItem:Proppresetstemplates = new Proppresetstemplates();
			getpropPresetTempItem.propertypresetFK = propPresets.propertyPresetId;
			var propPresetTemp:Proppresetstemplates= propPresettemplateColl.findExistingPropItem(getpropPresetTempItem,'propertypresetFK') as Proppresetstemplates;
			item[property+Utils.OPTIONS_PROP] = propPresetTemp.fieldOptionsValue
			item[property+Utils.DEFAULT_PROP] = propPresets.fieldDefaultValue
			item[property+'name'] = propPresets.propertyPresetId;
		}
		
		//To assign the property values to a form based on the Object parameters
		public static function setUpForm(obj:Object,viewForm:Object, propArr:Array):void {
			for (var i: int =0; i<viewForm.numElements; i++){
				if(viewForm.getElementAt(i) is FormItem){
					var uiComp:Object = FormItem(viewForm.getElementAt(i)).getElementAt(0) as Object;
					var formID:String = uiComp.id;
					var propertyValue:String = obj[formID];
					var propertyDefaultValue:String = obj[formID+Utils.DEFAULT_PROP];
					var propertyOptionsValue:String = obj[formID+Utils.OPTIONS_PROP];
					var propertyPresetID:int = obj[formID+'name'];
					var dataProvider:ArrayCollection = new ArrayCollection();
					var optionsArr:Array =[];	
					if(propertyOptionsValue) optionsArr= propertyOptionsValue.split(',');
					for each(var itemStr:String in optionsArr){
						if( itemStr != '' ) {
							var objProp:Object = {};
							objProp[Utils.OPTIONS_PROP] =itemStr;
							dataProvider.addItem(objProp);
						}
					}
					if(propArr.indexOf(formID)!=-1) {
						uiComp.name = propertyPresetID;
						
						if(uiComp is spark.components.TextInput || uiComp is spark.components.TextArea ||  uiComp is Label || uiComp is TextEditor){
							try{
								if(propArr.indexOf(formID)!=-1)uiComp.text = propertyValue;
							}catch(er:Error){
								if(obj.hasOwnProperty(formID))
									if(propertyValue){
										if(propArr.indexOf(formID)!=-1)uiComp.text = propertyValue.toString() 
									}else if(propertyDefaultValue){
										if(propArr.indexOf(formID)!=-1)uiComp.text = propertyDefaultValue.toString();	
									}
							}
						}if(uiComp is DropDownList){
							try{ 
								if(DropDownList(uiComp).labelField){
									var labelField:String = DropDownList(uiComp).labelField;
									var selectedObj:Object
									for(var j:int =0; j<DropDownList(uiComp).dataProvider.length; j++){
										var objData:Object = DropDownList(uiComp).dataProvider.getItemAt(j);
										if(objData[labelField] == propertyValue){
											selectedObj = objData;
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
						}
						if(uiComp is AutoCompleteView || uiComp is PriorityComponent || uiComp is PropertyCompleteView ) {
							if(propArr.indexOf(formID)!=-1 ) {
								uiComp.dataProvider = dataProvider;
								if(uiComp is PriorityComponent && propertyValue){ 
									PriorityComponent(uiComp).selectedState = propertyValue;
								}else if(uiComp is AutoCompleteView && propertyValue){
									AutoCompleteView(uiComp).specificText =propertyValue;
								}
								else if(uiComp is PropertyCompleteView && propertyValue){
									PropertyCompleteView(uiComp).text = propertyValue;
								}
							}
						}
						if(uiComp is TimeController){
							if(propertyValue)
								TimeController(uiComp).selectedDate = new Date(propertyValue);
						}
					}
				}
			}
		}
		
		public static function createPropertyPj(fieldname:String, collection:ICollection):Propertiespj{
			var batDatePropPj:Propertiespj = new Propertiespj();
			var getBatPropPresetItem:Propertiespresets = new Propertiespresets();
			getBatPropPresetItem.fieldName = fieldname;
			var batPropPreset:Propertiespresets = collection.findExistingPropItem(getBatPropPresetItem,'fieldName') as Propertiespresets;
			batDatePropPj.fieldValue = 'NULL';
			batDatePropPj.propertyPresetFk = batPropPreset.propertyPresetId;
			return batDatePropPj;
		}
	}
}
package com.adams.dt.model.vo
{ 
	import com.adams.dt.utils.GetVOUtil;
	
	 
	[RemoteClass(alias = "com.adams.dt.pojo.Proppresetstemplates")]	
	[Bindable]
	public final class Proppresetstemplates implements IValueObject
	{
		private var _presetsTemplateObject:Presetstemplates;
		private var _propertyPresetsObject:Propertiespresets;
		private var _proppresetstemplatesId : int;

		public function get presetsTemplateObject():Presetstemplates
		{
			if(_presetsTemplateObject ==null)
			_presetsTemplateObject =  GetVOUtil.getVOObject(_presetstemplatesFk,GetVOUtil.presetTemplateList,'presetstemplateId',Presetstemplates) as Presetstemplates;
			return _presetsTemplateObject;
		}

		public function set presetsTemplateObject(value:Presetstemplates):void
		{
			_presetsTemplateObject = value;
			_presetstemplatesFk = value.presetstemplateId;
		}

		public function get propertyPresetsObject():Propertiespresets
		{
			if(_propertyPresetsObject == null)
			_propertyPresetsObject =  GetVOUtil.getVOObject(_propertypresetFK,GetVOUtil.propertyPresetList,'propertyPresetId',Propertiespresets) as Propertiespresets;
			return _propertyPresetsObject;
		}

		public function set propertyPresetsObject(value:Propertiespresets):void
		{
			_propertyPresetsObject = value;
			_propertypresetFK = value.propertyPresetId;
		}

		public function set proppresetstemplatesId (value : int) : void
		{
			_proppresetstemplatesId = value;
		}

		public function get proppresetstemplatesId () : int
		{
			return _proppresetstemplatesId;
		} 
		 
		private var _propertypresetFK : int;
		public function set propertypresetFK (value : int) : void
		{
			_propertypresetFK = value;
			propertyPresetsObject =  GetVOUtil.getVOObject(value,GetVOUtil.propertyPresetList,'propertyPresetId',Propertiespresets) as Propertiespresets;
		}

		public function get propertypresetFK() : int
		{
			return _propertypresetFK;
		} 
		
		private var _presetstemplatesFk : int;
		public function set presetstemplatesFk (value : int) : void
		{
			_presetstemplatesFk = value;
			presetsTemplateObject =  GetVOUtil.getVOObject(value,GetVOUtil.presetTemplateList,'presetstemplateId',Presetstemplates) as Presetstemplates;
		}

		public function get presetstemplatesFk () : int
		{
			return _presetstemplatesFk;
		}
		private var _presetstemplatesField :  String ;
		public function set presetstemplatesField (value : String) : void
		{
			_presetstemplatesField = value;
		}

		public function get presetstemplatesField () : String
		{
			return _presetstemplatesField;
		}  
		
		private var _fieldLabel : String;
		public function set fieldLabel (value : String) : void
		{
			_fieldLabel = value;
		}

		public function get fieldLabel () : String
		{
			return _fieldLabel;
		}

		private var _fieldOptionsValue : String;
		public function set fieldOptionsValue (value : String) : void
		{
			_fieldOptionsValue = value;
		}

		public function get fieldOptionsValue () : String
		{
			return _fieldOptionsValue;
		}
 		public function Proppresetstemplates()
		{
		}
	}
}

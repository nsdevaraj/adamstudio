package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject; 
	
	import mx.collections.ArrayCollection;
	[RemoteClass(alias = "com.adams.dt.pojo.Propertiespresets")]	
	[Bindable]
	public final class Propertiespresets implements IValueObject
	{
		private var _editablepropertyPreset : Boolean;
		public function set editablePropertyPreset (value : Boolean) : void
		{
			_editablepropertyPreset = value;
		}

		public function get editablePropertyPreset () : Boolean
		{
			return _editablepropertyPreset;
		}
		
		private var _propertyPresetId : int;
		public function set propertyPresetId (value : int) : void
		{
			_propertyPresetId = value;
		}

		public function get propertyPresetId () : int
		{
			return _propertyPresetId;
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

		private var _fieldName : String;
		public function set fieldName (value : String) : void
		{
			_fieldName = value;
		}

		public function get fieldName () : String
		{
			return _fieldName;
		}

		private var _fieldType : String;
		public function set fieldType (value : String) : void
		{
			_fieldType = value;
		}
		
		public function get fieldType () : String
		{
			return _fieldType;
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

		private var _fieldDefaultValue : String;
		public function set fieldDefaultValue (value : String) : void
		{
			_fieldDefaultValue = value;
		}

		public function get fieldDefaultValue () : String
		{
			return _fieldDefaultValue;
		}

		private var _propertiespjSet : ArrayCollection;
		public function set propertiespjSet (value : ArrayCollection) : void
		{
			_propertiespjSet = value;
		}

		public function get propertiespjSet () : ArrayCollection
		{
			return _propertiespjSet;
		} 
 
		public function Propertiespresets()
		{
		}
	}
}

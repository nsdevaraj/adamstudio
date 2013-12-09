package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.collections.ArrayCollection;
	[RemoteClass(alias = "com.adams.dt.pojo.Propertiespj")]	
	[Bindable]
	public final class Propertiespj implements IValueObject
	{
		private var _propertyPreset : Propertiespresets = new Propertiespresets();
		public function set propertyPreset (value : Propertiespresets) : void
		{
			_propertyPreset = value;
		}

		public function get propertyPreset () : Propertiespresets
		{
			return _propertyPreset;
		}

		private var _propertyPjId : int;
		public function set propertyPjId (value : int) : void
		{
			_propertyPjId = value;
		}

		public function get propertyPjId () : int
		{
			return _propertyPjId;
		}

		private var _projectFk : int;
		public function set projectFk (value : int) : void
		{
			_projectFk = value;
		}

		public function get projectFk () : int
		{
			return _projectFk;
		}

		private var _propertyPresetFk : int;
		public function set propertyPresetFk (value : int) : void
		{
			_propertyPresetFk = value;
		}

		public function get propertyPresetFk () : int
		{
			return _propertyPresetFk;
		}

		private var _fieldValue : String;
		public function set fieldValue (value : String) : void
		{
			_fieldValue = value;
		}

		public function get fieldValue () : String
		{
			return _fieldValue;
		}
 


		public function Propertiespj()
		{
		}
	}
}

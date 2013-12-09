package com.adams.dt.model.vo
{
	import com.adams.dt.business.util.GetVOUtil;
	import com.adobe.cairngorm.vo.IValueObject;
	[RemoteClass(alias = "com.adams.dt.pojo.Propertiespj")]	
	[Bindable]
	public final class Propertiespj implements IValueObject
	{
		private var _propertyPreset : Propertiespresets = new Propertiespresets();
		public function set propertyPreset (value : Propertiespresets) : void
		{
			_propertyPresetFk = value.propertyPresetId;
			_propertyPreset = value;
		}

		public function get propertyPreset () : Propertiespresets
		{
			if(_propertyPreset == null)
			_propertyPreset =  GetVOUtil.getPropertiesPresetObject(_propertyPresetFk);
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

		private var _propertyPresetFk : int;
		public function set propertyPresetFk (value : int) : void
		{
			_propertyPresetFk = value;
			_propertyPreset =  GetVOUtil.getPropertiesPresetObject(value);
		}

		public function get propertyPresetFk () : int
		{
			return _propertyPresetFk;
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
 
		private var _fieldValue : String;
		public function set fieldValue (value : String) : void
		{
			_fieldValue = value;
		}

		public function get fieldValue () : String
		{
			return _fieldValue;
		}
 
		private var _accordeon : String;
		public function set accordeon (value : String) : void
		{
			_accordeon = value;
		}

		public function get accordeon () : String
		{
			return _accordeon;
		}
 

		public function Propertiespj()
		{
		}
	}
}

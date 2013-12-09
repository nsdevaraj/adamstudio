package com.adams.dt.model.vo
{
	import com.adams.swizdao.model.vo.AbstractVO;

	[RemoteClass(alias = "com.adams.dt.pojo.Propertiespj")]	
	[Bindable]
	public final class Propertiespj extends AbstractVO
	{
		
		private var _propertyPresetFk:int;
		public function get propertyPresetFk():int {
			return _propertyPresetFk;
		}
		public function set propertyPresetFk( value:int ):void {
			if( _propertyPreset ) {
				_propertyPreset = null;
			}
			_propertyPresetFk = value;
		}
		
		private var _propertyPreset:Propertiespresets;
		public function get propertyPreset():Propertiespresets {
			return _propertyPreset;
		}
		public function set propertyPreset( value:Propertiespresets ):void {
			if( !_propertyPreset ) {
				_propertyPreset = value;
			}
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

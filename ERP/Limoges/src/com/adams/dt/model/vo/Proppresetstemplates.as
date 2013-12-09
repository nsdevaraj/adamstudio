package com.adams.dt.model.vo
{ 
	import com.adams.swizdao.model.vo.AbstractVO;
	 
	[RemoteClass(alias = "com.adams.dt.pojo.Proppresetstemplates")]	
	[Bindable]
	public final class Proppresetstemplates extends AbstractVO
	{
		private var _propertiesPresets : Propertiespresets;
		private var _proppresetstemplatesId : int;

		public function get propertiesPresets():Propertiespresets
		{
			return _propertiesPresets;
		}

		public function set propertiesPresets(value:Propertiespresets):void
		{
			_propertiesPresets = value;
		}

		public function set proppresetstemplatesId (value : int) : void
		{
			_proppresetstemplatesId = value;
		}

		public function get proppresetstemplatesId () : int
		{
			return _proppresetstemplatesId;
		} 

		private var _companyFK : int;
		public function set companyFK (value : int) : void
		{
			_companyFK = value;
		}

		public function get companyFK () : int
		{
			return _companyFK;
		} 
		 
		private var _propertypresetFK : int;
		public function set propertypresetFK (value : int) : void
		{
			_propertypresetFK = value;
		}

		public function get propertypresetFK() : int
		{
			return _propertypresetFK;
		} 
		
		private var _presetstemplatesFk : int;
		public function set presetstemplatesFk (value : int) : void
		{
			_presetstemplatesFk = value;
		}

		public function get presetstemplatesFk () : int
		{
			return _presetstemplatesFk;
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

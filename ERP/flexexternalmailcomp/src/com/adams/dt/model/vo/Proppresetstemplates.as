package com.adams.dt.model.vo
{ 
	import com.adobe.cairngorm.vo.IValueObject;
	 
	[RemoteClass(alias = "com.adams.dt.pojo.Proppresetstemplates")]	
	[Bindable]
	public final class Proppresetstemplates implements IValueObject
	{
		private var _proppresetstemplatesId : int;
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

		private var _fieldDefaultValue : String;
		public function set fieldDefaultValue (value : String) : void
		{
			_fieldDefaultValue = value;
		}

		public function get fieldDefaultValue () : String
		{
			return _fieldDefaultValue;
		}

		
		public function Proppresetstemplates()
		{
		}
	}
}

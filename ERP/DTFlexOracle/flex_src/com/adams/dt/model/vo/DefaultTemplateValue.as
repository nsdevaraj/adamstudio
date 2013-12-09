package com.adams.dt.model.vo 
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	[Bindable]
	[RemoteClass(alias='com.adams.dt.pojo.DefaultTemplateValue')]
	public class DefaultTemplateValue implements IValueObject
	{ 
		private var _defaultTemplateValueId:int;
		public function set defaultTemplateValueId ( value : int ) : void
		{
			_defaultTemplateValueId = value;
		}

		public function get defaultTemplateValueId () : int
		{
			return _defaultTemplateValueId;
		}
		
		private var _defaultTemplateValue:String;
		public function set defaultTemplateValue ( value : String ) : void
		{
			_defaultTemplateValue = value;
		}

		public function get defaultTemplateValue () : String
		{
			return _defaultTemplateValue;
		}
		
		private var _propertiesPresetFK:int;
		public function set propertiesPresetFK ( value : int ) : void
		{
			_propertiesPresetFK = value;
		}

		public function get propertiesPresetFK () : int
		{
			return _propertiesPresetFK;
		}
		
		private var _defaultTemplateFK:int;
		public function set defaultTemplateFK ( value : int ) : void
		{
			_defaultTemplateFK = value;
		}

		public function get defaultTemplateFK () : int
		{
			return _defaultTemplateFK;
		}
		
		public function DefaultTemplateValue()
		{
			super()
		}
	}
}
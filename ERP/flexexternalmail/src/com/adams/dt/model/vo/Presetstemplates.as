package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.collections.ArrayCollection;
	
	[RemoteClass(alias = "com.adams.dt.pojo.Presetstemplates")]	
	[Bindable]
	public final class Presetstemplates implements IValueObject
	{
		private var _presetstemplateId : int;
		public function set presetstemplateId (value : int) : void
		{
			_presetstemplateId = value;
		}

		public function get presetstemplateId () : int
		{
			return _presetstemplateId;
		}
		private var _impremiurfk : int;
		public function set impremiurfk (value : int) : void
		{
			_impremiurfk = value;
		}

		public function get impremiurfk () : int
		{
			return _impremiurfk;
		}
 		private var _presetTemplateLabel : String;
		public function set presetTemplateLabel (value : String) : void
		{
			_presetTemplateLabel = value;
		}

		public function get presetTemplateLabel () : String
		{
			return _presetTemplateLabel;
		}
		
		private var _propertiesPresetSet : ArrayCollection = new ArrayCollection();
		public function set propertiesPresetSet (value : ArrayCollection) : void
		{
			_propertiesPresetSet = value;
		}

		public function get propertiesPresetSet () : ArrayCollection
		{
			return _propertiesPresetSet;
		}
		
 		public function Presetstemplates()
		{
		}
	}
}

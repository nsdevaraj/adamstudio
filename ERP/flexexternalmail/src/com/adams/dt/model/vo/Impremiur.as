package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.collections.ArrayCollection;
	
	[RemoteClass(alias = "com.adams.dt.pojo.Impremiur")]	
	[Bindable]
	public final class Impremiur implements IValueObject
	{
		private var _impremiurId : int;
		public function set impremiurId (value : int) : void
		{
			_impremiurId = value;
		}

		public function get impremiurId () : int
		{
			return _impremiurId;
		}
		  
		 
 		private var _impremiurLabel : String;
		public function set impremiurLabel (value : String) : void
		{
			_impremiurLabel = value;
		}

		public function get impremiurLabel () : String
		{
			return _impremiurLabel;
		}
		[ArrayElementType("com.adams.dt.model.vo.Presetstemplates")]
		private var _presetstemplateSet : ArrayCollection;
		public function set presetstemplateSet (value : ArrayCollection) : void
		{
			_presetstemplateSet = value;
		}

		public function get presetstemplateSet () : ArrayCollection
		{
			return _presetstemplateSet;
		}
 
		public function Impremiur()
		{
		}
	}
}

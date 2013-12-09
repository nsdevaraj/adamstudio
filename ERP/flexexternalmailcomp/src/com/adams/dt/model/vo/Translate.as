package com.adams.dt.model.vo
{
	import com.adobe.cairngorm.vo.IValueObject;
	[Bindable]
	public final class Translate
	{
		private var _frenchText : String;
		public function set frenchText (value : String) : void
		{
			_frenchText = value;
		}

		public function get frenchText () : String
		{
			return _frenchText;
		}

		private var _englishText : String;
		public function set englishText (value : String) : void
		{
			_englishText = value;
		}

		public function get englishText () : String
		{
			return _englishText;
		}

		public var sourceLanguage : String;
		public function Translate()
		{
		}
	}
}

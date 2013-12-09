package com.adams.scrum.views.renderers
{
	
	import spark.components.TextInput;
	public class TextInputSave extends TextInput
	{
		[Bindable]
		public var textBorderValue:Boolean;
		
		[Bindable]
		public var textAddBtn:Boolean;
		
		public function TextInputSave()
		{
			super();
		}
	}
}
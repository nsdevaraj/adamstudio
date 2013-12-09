package com.adams.dt.view.components.todolistscreens
{
	import mx.controls.NumericStepper;
	/**
	 * purpose set the text property for NumericStepper
	 */
	public final class TextNumericStepper extends NumericStepper
	{
		public function TextNumericStepper()
		{
			super();
		}
		public var dataText : String;
		private var _text : String;
		/**
		 * get the text value
		 */ 
		public function get text() : String
		{
			return String(value);
		}
		/**
		 * set the text value
		 * assign the text to value property
		 */ 
		public function set text(value : String) : void
		{
			this.value = Number(value);
		}
	}
}

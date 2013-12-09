package com.adams.dt.view.components.todolistscreens
{
	import mx.controls.NumericStepper;
	public final class TextNumericStepper extends NumericStepper
	{
		public function TextNumericStepper()
		{
			super();
		}

		private var _text : String;
		public function get text() : String
		{
			return String(value);
		}

		public function set text(value : String) : void
		{
			this.value = Number(value);
		}
	}
}

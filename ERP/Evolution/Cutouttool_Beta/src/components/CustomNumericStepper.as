package components
{
	import mx.controls.NumericStepper;
	import mx.core.mx_internal;
	use namespace mx_internal;
	public class CustomNumericStepper extends NumericStepper
	{
		private var _editable:Boolean = true;
		private var _nextVisi:Boolean = true;
		private var _prevVisi:Boolean = true;
		public function CustomNumericStepper()
		{
			super();	
		}
				
		public function set editable(bool:Boolean):void{
			_editable = bool;
		}
		public function get editable():Boolean{
			return _editable; 
		}
		override protected function createChildren():void{
			super.createChildren();
			inputField.editable = editable;
			nextButton.visible = editable;
			prevButton.visible = editable;
		}
		override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight)
			inputField.editable = editable;
			nextButton.visible = editable;
			prevButton.visible = editable;
		}
	}
}
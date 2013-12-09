package components
{
	import flash.events.Event;
	
	import mx.controls.DateField;
	import mx.core.mx_internal;
	use namespace mx_internal;
	public class CustomDateField extends DateField
	{
		private var _changeToLabel:Boolean;
		private var __changeToLabelChanged:Boolean = false;
		public function CustomDateField()
		{
			super();
		}
		public function set changeToLabel(bool:Boolean):void{
			_changeToLabel = bool;
			__changeToLabelChanged = true;
			close();
			dispatchEvent(new Event("changeToLabelChanged"));
		}
		[Bindable(event="changeToLabelChanged",  type="flash.events.Event")] 
   		[Inspectable(category="General", enumeration="true,false", defaultValue="true")]
		public function get changeToLabel():Boolean{
			return _changeToLabel;
		}
		override protected function createChildren():void{
			super.createChildren();
			if(__changeToLabelChanged){
				downArrowButton.enabled = changeToLabel;
				downArrowButton.visible = changeToLabel;
			}
		}
		override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			if(__changeToLabelChanged){
				downArrowButton.enabled = changeToLabel;
				downArrowButton.visible = changeToLabel;
			}
		}
		
		
	}
}
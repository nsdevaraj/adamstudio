package com.adams.scrum.views.components
{
	import assets.skins.TextArrInputSkin;
	
	
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
	
	import org.osflash.signals.Signal;
	
	import spark.components.Button;
	import spark.components.TextInput;
	import spark.events.TextOperationEvent;
	
	
	
	public class CustomTextInput extends TextInput
	{
		
		
		[SkinPart(required="true")]
		public var closeButton:Button;
		
		public var deletedSignal:Signal =new Signal(IVisualElement , String )
		public function CustomTextInput()
		{
			super();
			
		}
		
		
		
		private function textInputClicked( event :MouseEvent ) :void
		{
			//trace(event.currentTarget)
			deletedSignal.dispatch(this,this.text);
			
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			if (instance == closeButton) {
				closeButton.addEventListener(MouseEvent.CLICK , textInputClicked)
			}
		
		}
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
						
		}
		public function header_clickHandler( event :MouseEvent ) :void
		{
			trace("HItted")
		}
	}	
}

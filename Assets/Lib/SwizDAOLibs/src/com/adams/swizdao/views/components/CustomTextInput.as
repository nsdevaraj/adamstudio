/*
* Copyright 2010 @nsdevaraj
* 
* Licensed under the Apache License, Version 2.0 (the "License"); you may not
* use this file except in compliance with the License. You may obtain a copy of
* the License. You may obtain a copy of the License at
* 
* http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
* License for the specific language governing permissions and limitations under
* the License.
*/
package com.adams.swizdao.views.components
{
	import flash.events.MouseEvent;
	
	import mx.core.IVisualElement;
	
	import org.osflash.signals.Signal;
	
	import spark.components.Button;
	import spark.components.TextInput;
	
	
	
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

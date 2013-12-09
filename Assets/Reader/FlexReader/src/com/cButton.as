// ActionScript file
package com
{
	import mx.controls.Button;
	public class cButton extends Button
	{
		public var dummy_skin:Class;
		public function cButton()
		{
			super();
			this.setStyle("skin", dummy_skin); 
			this.setStyle("disabledSkin", dummy_skin); 
			this.setStyle("downSkin", dummy_skin); 
			this.setStyle("overSkin", dummy_skin); 
			this.setStyle("upSkin", dummy_skin); 
			this.setStyle("selectedDisabledSkin", dummy_skin); 
			this.setStyle("selectedDownSkin", dummy_skin); 
			this.setStyle("selectedOverSkin", dummy_skin);
			this.setStyle("selectedUpSkin", dummy_skin);
			this.buttonMode=true 
		} 
	}
} 


package com.adams.dt.view.chartpeople.renderers {
	
	import mx.charts.styles.HaloDefaults;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridItemRenderer;
	import mx.styles.CSSStyleDeclaration;

    [Style(name="rowColor", type="uint", format="Color", inherit="yes")] 
	public class RowRenderer extends AdvancedDataGridItemRenderer
	{
		
		private static var stylesInited:Boolean = initStyles();
		
		private static function initStyles():Boolean {
			HaloDefaults.init();
			var ADGItemRendererExStyle:CSSStyleDeclaration = HaloDefaults.createSelector( "RowRenderer" );
			ADGItemRendererExStyle.defaultFactory = function():void {
				this.rowColor = 0x222222;
			}
			return true;
		}
		
		public function RowRenderer():void {
			super();
			background = true;
		}
		
		override public function validateNow():void {
			backgroundColor = getStyle( "rowColor" );
			super.validateNow();
		}
	}
}
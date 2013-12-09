package com.adams.swizdao.views.mediators
{
	import com.adams.swizdao.model.vo.SignalVO;
	
	import mx.core.UIComponent;

	public interface IViewMediator
	{
		function set hostSkin(value:Object):void
		function get hostSkin():Object
		function get viewSkin():UIComponent
		function setView( value:Object ):void 
		function resultMapping( obj:Object, signal:SignalVO ):void 
		function pushHandler( signal:SignalVO = null ): void 
		function alertReceiveHandler( alertResponder:Object ):void 
	}
}

package com.adams.dt.view.mediators
{
	import com.adams.dt.view.ProgressSkinView;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	
	public class ProgressViewMediator extends AbstractViewMediator
	{
		/**
		 * Constructor.
		 */
		public function ProgressViewMediator( viewType:Class=null )
		{
			super( ProgressSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():ProgressSkinView 	{
			return _view as ProgressSkinView;
		}
		
		[MediateView( "ProgressSkinView" )]
		override public function setView( value:Object ):void { 
			super.setView( value );	
		} 
		
		override protected function setViewDataBindings():void 	{
			//remove Effect
		}
		
		/**
		 * The <code>init()</code> method is fired off automatically by the 
		 * AbstractViewMediator when the creation complete event fires for the
		 * corresponding ViewMediator's view. This allows us to listen for events
		 * and set data bindings on the view with the confidence that our view
		 * and all of it's child views have been created and live on the stage.
		 */
		override protected function init():void {
			super.init();  
		} 
		
		override protected function setRenderers():void {
			super.setRenderers();  
		} 
		
		override protected function serviceResultHandler( obj:Object,signal:SignalVO ):void {  
		}
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners();  
		}
		
		override protected function pushResultHandler( signal:SignalVO ): void { 
		} 
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			super.cleanup( event ); 		
		}
	}
}
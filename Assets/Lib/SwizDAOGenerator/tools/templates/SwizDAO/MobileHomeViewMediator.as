/*

Copyright (c) @year@ @company.name@, All Rights Reserved 

@author   @author.name@
@contact  @author.email@
@project  @project.name@

@internal 

*/
package @namespace@.@view.dir@.mediators
{ 
	import @namespace@.model.AbstractDAO;
	import @namespace@.model.vo.*;
	import @namespace@.util.Utils;
	import @namespace@.@view.dir@.@gesture@SkinView;
	import @namespace@.signal.ControlSignal;
	
	import com.adams.swizdao.dao.PagingDAO;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.response.SignalSequence;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.ArrayUtil;
	import com.adams.swizdao.util.Description;
	import com.adams.swizdao.util.ObjectUtils;
	import com.adams.swizdao.views.components.NativeList;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.events.ResizeEvent;

	public class @gesture@ViewMediator extends AbstractViewMediator
	{ 		 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		private var backKeyEventPreventDefaulted:Boolean;
		private var menuKeyEventPreventDefaulted:Boolean;
		
		private var _homeState:String;
		public function get homeState():String
		{
			return _homeState;
		}
		
		public function set homeState(value:String):void
		{
			_homeState = value;
			if(value==Utils.@upperCaseGesture@_INDEX) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		
		protected function addedtoStage(ev:Event):void{
			init();
		}
		     
		/**
		 * Constructor.
		 */
		public function @gesture@ViewMediator( viewType:Class=null )
		{
			super( @gesture@SkinView ); 
		}

		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():@gesture@SkinView 	{
			return _view as @gesture@SkinView;
		}
		
		[MediateView( "@gesture@SkinView" )]
		override public function setView( value:Object ):void { 
			super.setView(value);	
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
			viewState = Utils.@upperCaseGesture@_INDEX;
			applicationResizeHandler(); 
		} 
		protected function setDataProviders():void {	    
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
			FlexGlobals.topLevelApplication.addEventListener(ResizeEvent.RESIZE,applicationResizeHandler, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, deviceKeyDownHandler, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, deviceKeyUpHandler, false, 0, true);
			super.setViewListeners(); 
		} 
		protected function backKeyUpHandler(event:KeyboardEvent):void
		{
		}
		protected function menuKeyUpHandler(event:KeyboardEvent):void
		{
		} 
		
		private function deviceKeyUpHandler(event:KeyboardEvent):void
		{
			var key:uint = event.keyCode;
			if (key == Keyboard.BACK && !backKeyEventPreventDefaulted)
				backKeyUpHandler(event);
			else if (key == Keyboard.MENU && !menuKeyEventPreventDefaulted)
				menuKeyUpHandler(event);
		}
		
		private function deviceKeyDownHandler(event:KeyboardEvent):void
		{
			var key:uint = event.keyCode;
			if (key == Keyboard.BACK)
			{
				backKeyEventPreventDefaulted = event.isDefaultPrevented();
				event.preventDefault();
			}
			else if (key == Keyboard.MENU)
			{
				menuKeyEventPreventDefaulted = event.isDefaultPrevented();
			}
		}
		
		
		protected function applicationResizeHandler(event:ResizeEvent=null):void{
			view.currentState =FlexGlobals.topLevelApplication.aspectRatio;
		} 
		
		override protected function pushResultHandler( signal:SignalVO ): void { 
		} 
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, deviceKeyDownHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP, deviceKeyUpHandler);
			FlexGlobals.topLevelApplication.removeEventListener(ResizeEvent.RESIZE,applicationResizeHandler);
			super.cleanup( event ); 		
		} 
	}
}
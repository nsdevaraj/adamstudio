package com.adams.dt.view.PDFTool.components
{
	import com.adams.dt.model.ModelLocator;
	
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.system.Capabilities;
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	[DefaultProperty("content")]
	public final class FSDisplay extends Canvas
	{
		// Private Elements
		private var _originalHeight : Number;
		private var _originalWidth : Number;
		private var _componentInst : UIComponent;
		private var _dispState : String = "";
		private var _rawPlayer : Canvas;
		private var _content : Array;
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		private var _contentChanged : Boolean = false;
		[Bindable]public var ScreenStatus : Boolean = false;
		public function FSDisplay()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE , initComponent);
		}

		override protected function createChildren() : void
		{
			super.createChildren();
			// Creates the default container to hold the assets that will go full screen & adds it to the stage.
			_rawPlayer = new Canvas();
			_rawPlayer.percentHeight = 100;
			_rawPlayer.percentWidth = 100;
			addChild(_rawPlayer);
		}

		override protected function commitProperties() : void
		{
			if(_contentChanged)
			{
				_contentChanged = false;
				// Adds any child to the _rawPlayer canvas instead of the component root
				for each(var child : UIComponent in content)
				{
					_rawPlayer.addChild(child);
				}
			}
		}

		public function set content(value : Array) : void
		{
			_content = value;
			_contentChanged = true;
			invalidateProperties();
		}

		public function get content() : Array
		{
			return _content;
			 
		}

		private function initComponent(e : FlexEvent) : void
		{
			// Full screen event listener
			systemManager.stage.addEventListener(FullScreenEvent.FULL_SCREEN , fullScreenHandler);
			// Set default display state & default container for full screen
			_dispState = systemManager.stage.displayState;
			_componentInst = _rawPlayer;
		}

		/**
		*  Toggles fullscreen mode
		* 
		*/		
		public function fullScreen() : void
		{
			try
			{
				switch (systemManager.stage.displayState)
				{
					case StageDisplayState.FULL_SCREEN : case StageDisplayState.FULL_SCREEN_INTERACTIVE : systemManager.stage.displayState = StageDisplayState.NORMAL;
					
					break;
					case StageDisplayState.NORMAL :
					ScreenStatus = true;
					systemManager.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
					break;
				}
			} 

			catch (e : SecurityError)
			{ 
				// Catches any errors
			}
		}

		private function fullScreenHandler(e : FullScreenEvent) : void
		{
			if(ScreenStatus){
				if (e.fullScreen)
				{
					model.bgAlpha = 1; 
					trace("Coming")
					// Reparent the default container to the stage & set its height / width to the stage
					if(_componentInst) if(_componentInst.parent) _componentInst.parent.removeChild(_componentInst);
					//systemManager.stage.addChild(_componentInst);
					DTFlex(this.parentApplication).addChild(_componentInst);
					_originalHeight = _componentInst.height;
					_originalWidth = _componentInst.width;
					model.schedulerViewerWidth = Capabilities.screenResolutionX - 200;
					_componentInst.width = Capabilities.screenResolutionX;
					_componentInst.height = Capabilities.screenResolutionY;
				}else
				{
					if(model.CF!=1){
						model.bgAlpha = 0;
					}
					// Reparent the default container back to its parent and reset its size back
					//systemManager.stage.removeChild(_componentInst);
					DTFlex(this.parentApplication).removeChild(_componentInst);
					this.addChildAt(_componentInst , 0);
					_componentInst.percentWidth = 100;
					_componentInst.percentHeight = 100;
					model.schedulerViewerWidth = _originalWidth - 150;
					ScreenStatus = false;
				}
			}
		}
	}
}

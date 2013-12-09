// ActionScript file
package com.adams.dt.view.components
{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	[DefaultProperty("content")]
	
	public final class AccordionHeader extends Canvas
	{
		private var _componentInst : UIComponent;
		private var _rawPlayer : Canvas;
		private var _content : Array;
		private var _contentChanged : Boolean = false;		
		private var _headerText:String;
		private var headerLable:Text = new Text();
		private var headerContainer:HBox= new HBox();
		private var headerBtn:Button =  new Button();
		public var closed:Boolean;
		
		public var isHaveProperty:String;
		
		public function set headerText(value:String):void{
			_headerText = value;
		}
		public function get headerText():String{
			return _headerText;
		}
		
		
		public function AccordionHeader()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE , onCreationComplete,false,0,true);
			addEventListener(FlexEvent.INITIALIZE, initComponent,false,0,true);
			
		}
		override protected function createChildren() : void
		{
			super.createChildren();
			headerContainer.height = 30;
			headerContainer.percentWidth = 100;
			headerContainer.addChild(headerBtn);
			headerContainer.addChild(headerLable);
			headerContainer.addEventListener(MouseEvent.ROLL_OVER,onRollOver,false,0,true)
			headerContainer.addEventListener(MouseEvent.ROLL_OUT,onRollOut,false,0,true)
			headerContainer.addEventListener(MouseEvent.CLICK,onClick,false,0,true)
			addChild(headerContainer)
			
			_rawPlayer = new Canvas();
			_rawPlayer.styleName = "technicalFormContainer";
			_rawPlayer.percentWidth = 100;
			addChild(_rawPlayer);
		}

		override protected function commitProperties() : void
		{
			if(_contentChanged)
			{
				_contentChanged = false;
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

		private function onCreationComplete(e : FlexEvent) : void
		{
			_componentInst = _rawPlayer;
			if(closed){
			remForm()
			headerBtn.selected = true;
			}
			
		}

		private function initComponent(e : FlexEvent):void{
			headerBtn.styleName = "chartViewerButton";
			headerBtn.toggle = true;
			headerContainer.styleName = "technicalFormHeader";
			headerLable.text = headerText;
			headerLable.setStyle("fontWeight","normal");
			headerLable.setStyle("fontSize",11);
		}
		private function onRollOver(e:Event) : void
		{
			headerLable.setStyle("fontWeight","bold");
		}
		private function onRollOut(e:Event) : void
		{
			headerLable.setStyle("fontWeight","normal");
		}
		private function onClick(e:Event) : void
		{
			if(headerBtn.selected == false){
					headerBtn.selected = true;
					remForm();
			}else{
				headerBtn.selected = false;
				addForm();
			}
		}
		private function addForm():void{
			_rawPlayer.includeInLayout = true;
			_rawPlayer.visible = true;
		}
		private function remForm():void{
			_rawPlayer.includeInLayout = false;
			_rawPlayer.visible = false;
		}
	}
}

package com.adams.dt.view.components.chatscreen.asfile
{
	import com.adams.dt.model.ModelLocator;
	
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.utils.setTimeout;
	
	import mx.containers.Canvas;
	import mx.controls.Text;
	import mx.core.UIComponent;
	import mx.core.Window;
	import mx.effects.Fade;
	import mx.effects.Move;
	import mx.effects.easing.*;
	import mx.events.EffectEvent;

	/**
	 * A lightweight window to display the message.
	 */
	public class MessageWindow extends Window
	{
		private var fadeEffect:Fade;
		private var moveEffect:Move;
		private var panPosition:String;
		private var panel:Canvas = new Canvas();		
		private var sHeight:int;
		private var sWidth:int;	
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		[Embed(source="assets/category/sounds/whistle.mp3")]
        public var soundClass:Class;
        
		public function MessageWindow():void{
		}
		 
		public function createWindow(parentPan:UIComponent,titleTxt:String,bodyTxt:String,windowPosition:String,timeout:Boolean=true):void{
			var bounds:Rectangle = Screen.mainScreen.visibleBounds;
			sHeight = bounds.bottomRight.y 
			sWidth = bounds.bottomRight.x
			panPosition = windowPosition;
			this.type = NativeWindowType.LIGHTWEIGHT;
			this.transparent = true;
			this.systemChrome  = "none"
			this.alwaysInFront = true;
			this.width = sWidth;
			this.height = sHeight;
			 
			this.showStatusBar = false;
			this.showGripper = false;
			this.verticalScrollPolicy = "off";
			this.horizontalScrollPolicy = "off"
			this.setStyle("borderStyle","none");
			this.setStyle("backgroundAlpha",0);
			this.showTitleBar = false;
			this.layout = 'absolute';
			this.addChild(panel);
			this.open(true);
			panel.addEventListener(MouseEvent.CLICK,removePanel,false,0,true); 
			panel.width = 300;
			panel.height = 200;
			panel.styleName = "customPanel";
			//panel.title = titleTxt;
			
			var txt:Text = new Text();
			txt.text = bodyTxt;
			txt.styleName = "customText";
			txt.percentWidth = 90;
			panel.addChild(txt); 
			
			/* var btn:Button = new Button();
			btn.label = "Ok";
			btn.styleName = "alertBtn";
			btn.addEventListener(MouseEvent.CLICK,removePanel,false,0,true);
			panel.addChild(btn); */
			activate();
			playSound();
			if(timeout){
			setTimeout(removePanel,model.alertDisplayTime*1000);
			}
			if(panPosition == "center"){
				fadeEffect = new Fade(panel);
				fadeEffect.easingFunction = Elastic.easeIn; 
				fadeEffect.play();
				panel.x = (sWidth - parentPan.width) +(parentPan.width/2-panel.width/2);
				panel.y = (sHeight/2)-(panel.height/2);
			}else{
				moveEffect = new Move(panel);
				moveEffect.xFrom = sWidth - panel.width;
				moveEffect.xTo = sWidth - panel.width;
				moveEffect.yFrom = sHeight;
				moveEffect.yTo = sHeight - panel.height;
				moveEffect.play();
				panel.x = sWidth-panel.width;
				panel.y = sHeight-panel.height;
			}
			this.maximize();
			//ntime.start();
			//ntime.addEventListener(TimerEvent.TIMER,removePanel,false,0,true);
		}
		 
        public function playSound():void
        {	
        	if(model.enableAlertSound){
        		var smallSound:Sound = new soundClass() as Sound;
            	smallSound.play();	
        	}
            
        }

		private function removePanel(event:Event=null):void{
			
			if(panPosition=="center"){
				fadeEffect = new Fade(panel)
				fadeEffect.alphaTo = 0;
				fadeEffect.play();
				fadeEffect.addEventListener(EffectEvent.EFFECT_END,removeWindow,false,0,true);	
			}else{
				moveEffect = new Move(panel);
				moveEffect.yTo = sHeight;
				moveEffect.play();
				moveEffect.addEventListener(EffectEvent.EFFECT_END,removeWindow,false,0,true);	
			} 
			
		}
		private function removeWindow(event:Event):void{
			if(panPosition=="center"){
				fadeEffect.removeEventListener(EffectEvent.EFFECT_END,removeWindow);
			}else{
				moveEffect.removeEventListener(EffectEvent.EFFECT_END,removeWindow);
			}
			this.close();			
		}
	 
		
		  
}
}
package com.adams.dt.view.mainView
{
	import com.adams.dt.event.mainView.AlternateEvent;
	import com.adams.dt.event.mainView.InitialCallEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.mainView.ViewFactory;
	
	import flash.display.DisplayObject;
	import flash.display.Screen;
	import flash.geom.Point;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.core.Container;
	import mx.effects.Effect;
	import mx.effects.Move;
	import mx.effects.easing.Exponential;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	
	[Event( name="makeAlternate", type="com.adams.dt.event.mainView")]
	[Event( name="initialCall", type="com.adams.dt.event.mainView")]
	public class DFMyContainer extends Canvas
	{
		[Bindable]
		public var headerButton:Button;
		private var contentContainer:Canvas;
		private var realParent:Container;
		private var moveEffect : Move;
		public var showing:Boolean = true;
		private var myEffect:Effect;
		public var headerLabel:LabelComponent;
		private var layerLeft:Canvas;
		private var layerRight:Canvas;
		public var layerCentre:Canvas;
		private var bgContainer:Canvas;
		[Bindable]
		public var labelText:String = '';
		[Bindable]
		public var moduleX:int;
		
		[Bindable]
		private var viewFactory:ViewFactory = ViewFactory.getInstance();
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		public function DFMyContainer()
		{
			this.addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete,false,0,true );
		}
		
		private function onCreationComplete( event:FlexEvent ):void {
			this.removeEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete );
			realParent = parent as Container;
		
			bgContainer = new Canvas();
			bgContainer.percentWidth= 100;
			bgContainer.percentHeight = 100;
			//this.addChild( bgContainer );
		}
		
		public function onClick( ):void {
			dispatchEvent( new AlternateEvent( AlternateEvent.DO_ALTERNATE ) );
			myEffect = animate( showing );
			if( !showing ) {
				myEffect.play();
				myEffect.addEventListener( EffectEvent.EFFECT_END, onEffectEnd,false,0,true );
				showing = true;
			}
			else {
				this.visible = true;
				myEffect.play();
				myEffect.addEventListener(EffectEvent.EFFECT_END, onShowEffectEnd ,false,0,true);
				showing = false;
			}
		}
		
		private function takingReference( event:FlexEvent ):void {
			event.currentTarget.removeEventListener( FlexEvent.CREATION_COMPLETE, takingReference );
			viewFactory.objClasses[ this.name ] = event.currentTarget;
			var initialEvent:InitialCallEvent = new InitialCallEvent( InitialCallEvent.INITIAL_CALL );
			initialEvent.propertyName = this.name;
			dispatchEvent( initialEvent );
		}
		
		private function onShowEffectEnd( event:EffectEvent ):void {
			myEffect.removeEventListener(EffectEvent.EFFECT_END, onShowEffectEnd );
			var display:DisplayObject;
			if( viewFactory.objClasses[ this.name ] == undefined ) {
				display = viewFactory.createInstance( this.name ) as DisplayObject;
				display.x = 0;
				display.name = this.name;
				display.addEventListener( FlexEvent.CREATION_COMPLETE, takingReference,false,0,true );
				this.addChild(  display );
			}
			else {
				var initialEvent:InitialCallEvent = new InitialCallEvent( InitialCallEvent.INITIAL_CALL );
				initialEvent.propertyName = this.name;
				dispatchEvent( initialEvent );
			}
		}
		
		private function onEffectEnd( event:EffectEvent ):void {
			myEffect.removeEventListener( EffectEvent.EFFECT_END, onEffectEnd );
			viewFactory.buttonObjects[ this.name ].visible = true; 
			this.visible = false;
		}
		
		private function animate( shouldShow: Boolean ) : Effect {
			var moveTo : Point;
			if (moveEffect != null) {
				moveEffect.pause();
				moveEffect = null;
			}
			moveEffect = new Move( this );
			moveEffect.easingFunction = mx.effects.easing.Exponential.easeOut; 
			moveTo = getPosition( shouldShow );
			moveEffect.xTo = moveTo.x;
			moveEffect.yTo = moveTo.y;
			return moveEffect;
		}

		private function getPosition( visible : Boolean ) : Point {
			var point : Point;
			if ( visible )
				point = new Point( 0,0);  
			else
				point = new Point( 0, Screen.mainScreen.visibleBounds.bottomRight.y);
			return point;
		}
	}
}
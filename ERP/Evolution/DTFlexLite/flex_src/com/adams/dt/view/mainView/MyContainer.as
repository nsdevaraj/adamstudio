package com.adams.dt.view.mainView
{
	import com.adams.dt.event.mainView.AlternateEvent;
	import com.adams.dt.event.mainView.InitialCallEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.mainView.ViewFactory;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
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
	public class MyContainer extends Canvas
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
		public var moduleY:int;
		
		[Bindable]
		private var viewFactory:ViewFactory = ViewFactory.getInstance();
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		public function MyContainer()
		{
			this.addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete,false,0,true );
		}
		
		private function onCreationComplete( event:FlexEvent ):void {
			this.removeEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete );
			realParent = parent as Container;
			
			headerButton = new Button();
			headerButton.width = 47;
			headerButton.height = 48;
			this.addChild(headerButton);
			headerButton.addEventListener(MouseEvent.CLICK, onClick,false,0,true );
			
			layerLeft = new Canvas();
			layerLeft.x = headerButton.x+headerButton.width;
			layerLeft.width = 30;
			layerLeft.percentHeight = 100;
			layerLeft.setStyle("backgroundColor", 0x272727 );
			this.addChild( layerLeft );
			
			layerRight = new Canvas();
			layerRight.x = this.width - ( 22+headerButton.width );
			layerRight.width = 20;
			layerRight.percentHeight = 100;
			layerRight.setStyle("backgroundColor", 0x000000);
			this.addChild( layerRight );
			
			bgContainer = new Canvas();
			bgContainer.styleName = 'contsWidth';
			bgContainer.percentHeight = 100;
			bgContainer.setStyle("backgroundColor", 0x363636);
			this.addChild( bgContainer );
			
			layerCentre = new Canvas();
			layerCentre.x = layerRight.x + layerRight.width;
			layerCentre.width = 47;
			layerCentre.height = headerButton.height;
			layerCentre.setStyle("backgroundColor", 0x000000 );
			this.addChild( layerCentre );
			
			headerLabel = new LabelComponent();
			headerLabel.visible = false;
			this.addChild( headerLabel );
		}
		
		private function onClick( event:MouseEvent ):void {
			dispatchEvent( new AlternateEvent( AlternateEvent.DO_ALTERNATE ) );
			myEffect = animate( showing );
			if( !showing ) {
				headerLabel.visible = false;
				myEffect.play();
				myEffect.addEventListener( EffectEvent.EFFECT_END, onEffectEnd,false,0,true );
				showing = true;
			}
			else {
				myEffect.play();
				myEffect.addEventListener(EffectEvent.EFFECT_END, onShowEffectEnd ,false,0,true);
				headerLabel.visible = true;
				headerLabel.labelText =labelText;
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
				display.x = layerLeft.x+layerLeft.width;
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
				point = new Point( realParent.width - ( width  ), 0 );
			else
				point = new Point( realParent.width - headerButton.width , 0 );
			point = realParent.localToGlobal(point);
			return point;
		}
	}
}
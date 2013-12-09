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
	import mx.controls.Spacer;
	import mx.core.Container;
	import mx.effects.Effect;
	import mx.effects.Move;
	import mx.effects.easing.Exponential;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	
	[Event( name="makeAlternate", type="com.adams.dt.event.mainView")]
	[Event( name="initialCall", type="com.adams.dt.event.mainView")]
	public class LegrandContainer extends Canvas
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
		private var layerTop:Spacer;
		private var layerBottom:Spacer;
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
		
		public function LegrandContainer()
		{
			this.addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete,false,0,true );
		}
		
		private function onCreationComplete( event:FlexEvent ):void {
			this.removeEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete );
			realParent = parent as Container;
			/*Background Color and set size from contsWidth style*/
			bgContainer = new Canvas();
			bgContainer.styleName = 'mainCenterBackground';
			this.addChild( bgContainer );
			
			/* TOP EMPTY SPACE */
			layerTop = new Spacer();
			layerTop.y = 0;
			layerTop.height = 22;
			layerTop.width = this.width - 57;
			this.addChild( layerTop  );
			
			/*Top Border*/
			layerLeft = new Canvas();
			layerLeft.styleName = 'mainTopBorder';
			layerLeft.y = 22;
			layerLeft.height = 22;
			layerLeft.width = this.width - 57;
			this.addChild( layerLeft );
			
			/*Bottom Border */
			layerRight = new Canvas();
			layerRight.styleName = 'mainBottomBorder';
			layerRight.y = height - 44;
			layerRight.height = 22;
			layerRight.width = this.width - 57;
			this.addChild( layerRight );
			
			/* BOTTOM EMPTY SPACE */
			layerBottom = new Spacer();
			layerBottom.y = height - 22;;
			layerBottom.height = 22;
			layerBottom.width = this.width - 57;
			this.addChild( layerBottom );
			
			/*Right Side Color for Button Place*/
			layerCentre = new Canvas();
			layerCentre.x = layerRight.x + layerRight.width;
			layerCentre.width = 57;
			layerCentre.height = 48;//headerButton.height;
			layerCentre.setStyle("backgroundColor", 0x5c5c5c );
			this.addChild( layerCentre );
			/* Side Button  */
			headerButton = new Button();
			headerButton.y = 23;
			headerButton.x =  this.width-85;
			headerButton.styleName = 'mainContainerCloseBtn'
			this.addChild(headerButton);
			headerButton.addEventListener(MouseEvent.CLICK, onClick,false,0,true );
		}
		
		private function onClick( event:MouseEvent ):void {
			dispatchEvent( new AlternateEvent( AlternateEvent.DO_ALTERNATE ) );
			myEffect = animate( showing );
			if( !showing ) {
				//headerLabel.visible = false;
				myEffect.play();
				myEffect.addEventListener( EffectEvent.EFFECT_END, onEffectEnd,false,0,true );
				showing = true;
			}
			else {
				myEffect.play();
				myEffect.addEventListener(EffectEvent.EFFECT_END, onShowEffectEnd ,false,0,true);
				//headerLabel.visible = true;
				//headerLabel.labelText =labelText;
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
				point = new Point( realParent.width - ( width  ),( realParent.height-height)/2 );
			else
				point = new Point(realParent.width , (realParent.height-height)/2 );
			//point = realParent.localToGlobal(point);
			return point;
		}
	}
}
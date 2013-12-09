package com.packaging.view
{
	
	import mx.containers.Canvas;
	import mx.core.UIComponent;
	import mx.effects.Move;
	import mx.effects.easing.*;
	import mx.events.FlexEvent;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class SlidingContainer extends Canvas
	{
		/**
		* Factory Class Instance to store the individual Effect instances
		**/
		
		private var objClasses:Dictionary = new Dictionary();
		
		/**
		* Constructor Function. 
		**/
		
		public function SlidingContainer()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete );
		}
		
		/**
		* Function called on the creationComplete Event of this container for intial setup
		**/
		
		private function onCreationComplete( event:FlexEvent ):void {
			startUp();
		}
		
		/**
		* Common function called on both initial and rollout events in order to position the children of the
		 * container to its original position
		**/
		
		private function startUp():void {
			for( var i:int = 0;i < this.numChildren;i++ ) {
				this.getChildAt( i ).width = ( this.width / this.numChildren ) * 2;
				this.getChildAt( i ).name = i.toString();
				UIComponent( this.getChildAt( i ) ).percentHeight = 100;
				animate( this.getChildAt( i ),  new Point( ( this.width / this.numChildren ) * this.getChildIndex( this.getChildAt( i ) as DisplayObject ), 0 ) );
				this.getChildAt( i ).addEventListener( MouseEvent.ROLL_OVER, onRollOver );
			    this.addEventListener( MouseEvent.ROLL_OUT, onRollOut );
			}
		}
		
		/**
		* Function called on the ROLL_OVER event of the child components in order to change their x Positions
		**/
		
		private function onRollOver( event:MouseEvent ):void {
			var index:int  = this.getChildIndex( event.currentTarget as DisplayObject );
			if( index == 0 ) {
				for( var i:int = 1;i < this.numChildren;i++ ) {
					var dispObject:DisplayObject = this.getChildAt( i );
					var adjustedWidth:Number  = ( this.width - this.getChildAt( index ).width ) / ( this.numChildren - 1 );
					animate( dispObject, new Point( this.getChildAt( index ).width + ( adjustedWidth *  ( i - 1 ) ), 0 ) );
				}
			}
			else if( index == ( this.numChildren - 1 ) ) {
				for( var j:int = 1;j < this.numChildren;j++ ) {
					var fordispObject:DisplayObject = this.getChildAt( j );
					var foradjustedWidth:Number  = ( this.width - this.getChildAt( index ).width ) / ( this.numChildren - 1 );
					animate( fordispObject, new Point( foradjustedWidth *   j, 0 ) ) ;
				}
			}
			else {
				for( var k:int = 0;k < this.numChildren;k++ ) {
					var interdispObject:DisplayObject = this.getChildAt( k );
					var interadjustedWidth:Number  = ( this.width - this.getChildAt( index ).width ) / ( this.numChildren - 1 );
					if( k < index )		animate( interdispObject, new Point( interadjustedWidth *   k, 0 ) ) ;
					else if( k > index )		animate( interdispObject, new Point( this.getChildAt( index ).width + ( interadjustedWidth *  ( k - 1 ) ), 0 ) );
					else	animate( interdispObject, new Point( interadjustedWidth *   k, 0 ) ) ;
				}
			}
		}
		
		/**
		* Function called on the ROLL_OUT event of the the container to position its children to original values
		**/
		
		private function onRollOut( event:MouseEvent ):void {
			for( var i:int = 0;i < this.numChildren;i++ ) {
				this.getChildAt( i ).removeEventListener( MouseEvent.ROLL_OVER, onRollOver );
			    this.removeEventListener( MouseEvent.ROLL_OUT, onRollOut );
			}
			startUp();
		}
		
		/**
		* Function called for animating the xPosition
		**/
		
		private function animate( targetObject:Object, moveTo:Point ) : void {
			if( objClasses[ targetObject.name ] != undefined ) {
				if ( objClasses[ targetObject.name ] != null) {
					 objClasses[ targetObject.name ].pause();
					 objClasses[ targetObject.name ] = null;
				}
			}
			objClasses[ targetObject.name ] = new Move( targetObject );
			objClasses[ targetObject.name ].easingFunction = mx.effects.easing.Exponential.easeOut;
			objClasses[ targetObject.name ].xTo = moveTo.x;
			objClasses[ targetObject.name ].yTo = moveTo.y;
			objClasses[ targetObject.name ].play();
		}
	}
}
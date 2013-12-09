package com.packaging.layouts
{
	import mx.core.ILayoutElement;
	import mx.core.IVisualElement;

	import spark.components.supportClasses.GroupBase;
	import spark.layouts.supportClasses.LayoutBase;
	import flash.geom.Point;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.display.DisplayObject;
	import flash.geom.PerspectiveProjection;

	/**
	 * Flex 4 Time Machine Layout
	 */
	public class CoverflowLayout extends LayoutBase
	{

		private var _distance : Number = 50;
		private var _rotation : Number = 90;
		private var _totalWidth : Number;
		private var _layoutWidth : Number;
		private var _index : Number = 0;

		/**
		 * Index of centered item
		 */
		[Bindable]
		public function get index () : Number
		{
			return _index;
		}

		public function set index ( value : Number ) : void
		{
			if ( _index != value )
			{
				_index = value;
				invalidateTarget();
			}
		}

		/**
		 * Distance between each item
		 */
		public function get distance () : Number
		{
			return _distance;
		}

		public function set distance ( value : Number ) : void
		{
			if ( _distance != value )
			{
				_distance = value;
				invalidateTarget();
			}
		}

		public function get rotation () : Number
		{
			return _rotation;
		}

		public function set rotation ( value : Number ) : void
		{
			if ( _rotation != value )
			{
				_rotation = value;
				invalidateTarget();
			}
		}

		public function CoverflowLayout ()
		{
			super();
		}


		override public function updateDisplayList ( width : Number, height : Number ) : void
		{

			var numElements : int = target.numElements;
			var selectedIndex : int = Math.max( index, 0 );

			_totalWidth = width + ( numElements - 1 ) * distance;
			_layoutWidth = width;

			target.setContentSize( _totalWidth, height );

			for ( var i : int = 0; i < numElements; i++ )
			{

				var element : ILayoutElement = useVirtualLayout ? target.getVirtualElementAt( i ) : target.getElementAt( i );

				element.setLayoutBoundsSize( NaN, NaN, false ); // reset size

				var matrix : Matrix3D = new Matrix3D();
				var position : Number = distance * i - target.horizontalScrollPosition;
				var step : Number = position - ( distance * ( i - 1 ) - target.horizontalScrollPosition );

				var posX : Number = position;
				var rotationElement : Number = rotation;

				if ( position < 0 )
				{
					IVisualElement( element ).depth = position;
					if ( position > -step )
					{
						rotationElement = -(( rotation * .01 ) * ( 100 / ( -step / position )));
					}
					else
					{
						rotationElement = -rotation;
					}
				}
				else if ( position == 0 )
				{
					posX = 0;
					rotationElement = 0;
				}
				else if ( position > 0 )
				{
					IVisualElement( element ).depth = -position;
					if ( position < step )
					{
						rotationElement = (( rotation * .01 ) * ( 100 / ( step / position )));
					}
				}

				matrix.appendRotation( rotationElement, Vector3D.Y_AXIS, new Vector3D( 100, 0, 0 ));

				matrix.appendTranslation( width * .5 - ( element.getPreferredBoundsWidth() * .5 ), height * .5 - ( element.getPreferredBoundsHeight() * .5 ), 0 ); // center element in container


				matrix.appendTranslation( posX, 0, 0 );

				element.setLayoutMatrix3D( matrix, false );

			}
		}

		override protected function scrollPositionChanged () : void
		{
			if ( target )
				target.invalidateDisplayList();
		}

		override public function updateScrollRect ( w : Number, h : Number ) : void
		{
			var g : GroupBase = target;
			if ( !g )
				return;

			if ( clipAndEnableScrolling )
			{
				// Since scroll position is reflected in our 3D calculations,
				// always set the top-left of the srcollRect to (0,0).
				g.scrollRect = new Rectangle( 0, 0, w, h );
			}
			else
				g.scrollRect = null;
		}

		override public function getScrollPositionDeltaToElement ( index : int ) : Point
		{
			var scrollPos : int = (( _totalWidth - _layoutWidth ) / ( target.numElements - 1 )) * index;
			return new Point( scrollPos, 0 );
		}

		protected function invalidateTarget () : void
		{
			if ( target )
			{
				target.invalidateSize();
				target.invalidateDisplayList();
			}
		}
	}
}
package com.adams.dt.view.scheduler.mainViews
{
	
	import com.adams.dt.model.scheduler.util.DateUtil;
	import com.adams.dt.model.scheduler.util.GridUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.HScrollBar;
	import mx.controls.VScrollBar;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ScrollEvent;
	
	public class GridComponent extends UIComponent
	{
		[Bindable]
		public var heightAdjustment:Number = 40;
		public var scrollerShowAdjustment:Number = 16;
		[Bindable]
		public var isVScrollerVisible:Boolean = true;
			
		protected var hScroller:HScrollBar;
		protected var vScroller:VScrollBar;
		protected var horizontalLine:Shape;
		protected var borderBox:Shape;
		protected var entryComponent:EntryComponent;
		protected var maskEntry:Shape;
		
		protected var entryRenderer:IFactory;
		
		protected var contentWidth:Number;
		protected var totalPeriod:Number;
		protected var perPixelTime:Number;
		protected var totalMonths:Number;
		protected var totalWeeks:Number;
		protected var totalDays:Number;
		protected var totalHours:Number;
		protected var totalMinutes:Number;
		protected var entryStart:Date;
		protected var entryEnd:Date;
		
		private var _columnPerView:Number;
		private var _perColumnPeriod:Number;
		private var _perColumnDistance:Number;
		private var _modeSet:Boolean;
		private var _widthSet:Boolean;
		private var _totalEntries:Number;
		private var freeRenderers:Array;
		private var visibleRenderers:Dictionary;
		private var labelArray:Array;
		private var startItemIndex:Number;
		private var xPositions:Array;
		private var previousContentWidth:Number;
		
		
		
		public function GridComponent()
		{	
			entryRenderer = new ClassFactory( TextField );	
			freeRenderers = [];
			visibleRenderers = new Dictionary();
			addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete );
		}
		
		private var _dataProvider:ArrayCollection;
		[Bindable]
		public function get dataProvider():ArrayCollection {
			return _dataProvider;
		} 	
		public function set dataProvider( value:ArrayCollection ):void {
			_dataProvider = value;
			if( value ) {
				horizontalScrollPosition = 0;
				verticalScrollPosition = 0;
				_totalEntries = value.length;
				findLimits();
				if( entryComponent ) {
					entryComponent.dataProvider = value;
				}
				if( _modeSet && _widthSet ) {
					initialCalculation();
				}
			}
		}
		
		private var _startDate:Date;
		[Bindable]
		public function get startDate():Date {
			return _startDate;
		} 	
		public function set startDate( value:Date ):void {
			_startDate = value;
			if( entryComponent ) {
				entryComponent.globalStart = value;
			}
		}
		
		private var _endDate:Date;
		[Bindable]
		public function get endDate():Date {
			return _endDate;
		} 	
		public function set endDate( value:Date ):void {
			_endDate = value;
			totalYears = ( endDate.fullYear - startDate.fullYear ) + 1;
			totalPeriod = totalYears * DateUtil.YEAR_IN_MILLISECONDS;
		}
		
		private var _startPointTime:Number;
		[Bindable]
		public function get startPointTime():Number {
			return _startPointTime;
		} 	
		public function set startPointTime( value:Number ):void {
			_startPointTime = value;
		}
		
		private var _endPointTime:Number;
		[Bindable]
		public function get endPointTime():Number {
			return _endPointTime;
		} 	
		public function set endPointTime( value:Number ):void {
			_endPointTime = value;
			invalidateDisplayList();
		}
		
		private var _rowHeight:Number;
		[Bindable]
		public function get rowHeight():Number {
			return _rowHeight;
		} 	
		public function set rowHeight( value:Number ):void {
			_rowHeight = value;
		}
		
		private var _headerHeight:Number = 30;
		[Bindable]
		public function get headerHeight():Number {
			return _headerHeight;
		} 	
		public function set headerHeight( value:Number ):void {
			_headerHeight = value;
		}
		
		private var _rowsToShow:Number;
		[Bindable]
		public function get rowsToShow():Number {
			return _rowsToShow;
		} 	
		public function set rowsToShow( value:Number ):void {
			_rowsToShow = value;
		}
		
		private var _mode:String;
		[Bindable]
		public function get mode():String {
			return _mode;
		}
		public function set mode( value:String ):void {
			_mode = value;
			if( !_modeSet ) {
				_modeSet = true;
			}
			if( dataProvider && _widthSet ) {
				initialCalculation();
			}
		}
		
		private var _totalYears:Number;
		[Bindable]
		public function get totalYears():Number {
			return _totalYears;
		} 	
		public function set totalYears( value:Number ):void {
			_totalYears = value;
			if( value == 0 ) {
				_totalYears = 1;
			} 
			else {
				_totalYears = value;
			}
			totalMonths = totalYears * 12;
			totalDays = DateUtil.totalNoOfDays( startDate.fullYear, endDate.fullYear );
			totalWeeks = Math.floor( totalDays / 7 );
			totalHours = totalDays * 24;
		}
		
		private var _horizontalScrollPosition:Number;
		[Bindable]
		public function get horizontalScrollPosition():Number {
			return _horizontalScrollPosition;
		} 	
		public function set horizontalScrollPosition( value:Number ):void {
			_horizontalScrollPosition = value;
		}
		
		private var _verticalScrollPosition:Number;
		[Bindable]
		public function get verticalScrollPosition():Number {
			return _verticalScrollPosition;
		} 	
		public function set verticalScrollPosition( value:Number ):void {
			_verticalScrollPosition = value;
		}
		
		protected function onCreationComplete( event:FlexEvent ):void {
			if( !_widthSet ) {
				_widthSet = true;
			}
			if( entryComponent ) {
				entryComponent.dataProvider = dataProvider;
				entryComponent.globalStart = startDate;
			}
			if( dataProvider && _modeSet ) {
				initialCalculation();
			}
		} 
		
		override protected function createChildren():void {
			super.createChildren();
			if( !hScroller ) {
				hScroller = new HScrollBar();
				hScroller.x = 0;
				hScroller.lineScrollSize = 1;
				hScroller.pageScrollSize = 10;
				hScroller.minScrollPosition = 0;
				hScroller.height = scrollerShowAdjustment;
				hScroller.visible = false;
				hScroller.addEventListener( ScrollEvent.SCROLL, onHorizontalScroll )
				addChild( hScroller );
			}	
			if( !vScroller ) {
				vScroller = new VScrollBar();
				vScroller.lineScrollSize = 1;
				vScroller.pageScrollSize = 10;
				vScroller.minScrollPosition = 0;
				vScroller.width = scrollerShowAdjustment;
				vScroller.visible = false;
				vScroller.addEventListener( ScrollEvent.SCROLL, onVerticalScroll )
				addChild( vScroller );
			}	
			if( !horizontalLine ) {
				horizontalLine = new Shape();
				addChild( horizontalLine );
			}
			if( !borderBox ) {
				borderBox = new Shape();
				addChild( borderBox );
			}
			if( !entryComponent ) {
				entryComponent = new EntryComponent();
				addChild( entryComponent ); 
			}
			if( !maskEntry ) {
				maskEntry = new Shape();
				addChild( maskEntry );
			}
		}
		
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void {
			
			height = rowsToShow * rowHeight + headerHeight;
			contentWidth = width - vScroller.width;
			
			if( isNaN( previousContentWidth ) ) {
				previousContentWidth = contentWidth;
			}	
			
			if( contentWidth != previousContentWidth ) {
				previousContentWidth = contentWidth;
				initialCalculation();
			}
			else {
				if( hScroller ) {
					hScroller.y = height + heightAdjustment;
					hScroller.width = contentWidth;
				}
				
				if( vScroller ) {
					vScroller.x = contentWidth;
					vScroller.y = headerHeight;
					vScroller.height = rowsToShow * rowHeight;
				}
				
				if( borderBox ) {
					borderBox.graphics.clear();
					borderBox.graphics.lineStyle( 2, 0x959494, 1 );
					borderBox.graphics.moveTo( contentWidth, 0 );
					borderBox.graphics.lineTo( 0, 0 );
					borderBox.graphics.moveTo( contentWidth, 0 );
					borderBox.graphics.lineTo( contentWidth, height );
					borderBox.graphics.moveTo( contentWidth, height );
					borderBox.graphics.lineTo( 0, height ); 
					borderBox.graphics.moveTo( 0, height );
					borderBox.graphics.lineTo( 0, 0 ); 
					borderBox.graphics.moveTo( contentWidth, headerHeight );
					borderBox.graphics.lineTo( 0, headerHeight ); 
					/* borderBox.graphics.moveTo( contentWidth, headerHeight / 2 );
					borderBox.graphics.lineTo( 0, headerHeight / 2 );   */
				}
				
				 if( horizontalLine ) {
					var startY:Number = verticalScrollPosition % rowHeight;
					startY = ( headerHeight + rowHeight ) - startY;
					horizontalLine.graphics.clear();
					horizontalLine.graphics.lineStyle( 1, 0x959494, 1 );
					for( var i:int = 0; i < rowsToShow; i++ ) {
						horizontalLine.graphics.moveTo( contentWidth , ( startY + ( i * rowHeight ) ) );
						horizontalLine.graphics.lineTo( 0, ( startY + ( i * rowHeight ) ) );
					}
				}
				
				if( !isNaN( startPointTime ) ) {
					var startX:Number = ( startPointTime - startDate.getTime() ) %  _perColumnPeriod;
					startX = _perColumnDistance - distanceForPeriod( startX );
					startItemIndex =  Math.floor( ( startPointTime - startDate.getTime() ) / _perColumnPeriod );
					graphics.clear();
					graphics.lineStyle( 1, 0x959494, 1 );
					xPositions = [];
					for( var j:int = 0; j <= _columnPerView; j++ ) {
						var xPosition:Number = startX + ( j * _perColumnDistance );
						xPositions.push( xPosition );
						graphics.moveTo( xPosition, height  );
						graphics.lineTo( xPosition, 0 );
					} 
					update();
					
					if( entryComponent ) {
						entryComponent.x = 0;
						entryComponent.y = headerHeight;
						entryComponent.rowHeight = rowHeight;
						entryComponent.rowsToShow = rowsToShow;
						entryComponent.width = contentWidth;
						entryComponent.height = rowsToShow * rowHeight;
						
						entryComponent.startX = horizontalScrollPosition;
						entryComponent.endX = horizontalScrollPosition + contentWidth;
						entryComponent.startY = verticalScrollPosition
						
						maskEntry.graphics.clear();
						maskEntry.graphics.lineStyle( 1, 0x000000 );
						maskEntry.graphics.beginFill( 0xFFFFFF, 0 );
						maskEntry.graphics.drawRect( entryComponent.x , entryComponent.y, entryComponent.width, entryComponent.height );
						maskEntry.graphics.endFill();
						entryComponent.mask = maskEntry;
						
						entryComponent.invalidateDisplayList();
					}
				} 
			}	
			super.updateDisplayList( unscaledWidth, unscaledHeight );
		}
		
		private function distanceForPeriod( diatanceTime:Number ):Number {
			return ( diatanceTime / perPixelTime );
		}  
		
		protected function findLimits():void {
			var startArray:Array = [];
			var endArray:Array = [];
			
			for each( var item:Object in dataProvider ) {
				for each( var innerItem:Object in item.phasesSet ) {
					startArray.push( innerItem.startDate );
					endArray.push( innerItem.endDate );
				}
			}
			
			startArray.sort( Array.NUMERIC );
			var tempStart:Date = new Date(  startArray[ 0 ]  );
			entryStart = tempStart; 
        	startDate = new Date( tempStart.fullYear, 0, 1 );
        	
        	endArray.sort( Array.NUMERIC );
        	var tempEnd:Date = new Date(  endArray[ endArray.length - 1 ]  );
        	entryEnd = tempEnd;
        	endDate = new Date( tempEnd.fullYear, 11, 31 );
        }
        
        protected function onHorizontalScroll( event:ScrollEvent ):void {
        	horizontalScrollPosition = event.position;
        	startPointTime = startDate.getTime() + ( horizontalScrollPosition * perPixelTime );
        	endPointTime = startPointTime + ( contentWidth * perPixelTime );
        }
        
        protected function onVerticalScroll( event:ScrollEvent ):void {
        	verticalScrollPosition = event.position;
        	invalidateDisplayList();
        }
        
        protected function initialCalculation():void {
        	switch( mode ) {
				case GridUtils.YEAR_MODE:
					perPixelTime = ( GridUtils.MAX_YEAR_IN_SINGLVIEW * DateUtil.YEAR_IN_MILLISECONDS ) / contentWidth;
					_columnPerView = GridUtils.MAX_YEAR_IN_SINGLVIEW;
					break;
				case GridUtils.MONTH_MODE:
					perPixelTime = ( GridUtils.MAX_MONTH_IN_SINGLVIEW * DateUtil.MONTH_IN_MILLISECONDS ) / contentWidth;
					_columnPerView = GridUtils.MAX_MONTH_IN_SINGLVIEW;
					break;
				case GridUtils.WEEK_MODE:
					perPixelTime = ( GridUtils.MAX_WEEK_IN_SINGLVIEW * DateUtil.WEEK_IN_MILLISECONDS ) / contentWidth;
					_columnPerView = GridUtils.MAX_WEEK_IN_SINGLVIEW;
					break;
				case GridUtils.DAY_MODE:
					perPixelTime = ( GridUtils.MAX_DAY_IN_SINGLVIEW * DateUtil.DAY_IN_MILLISECONDS ) / contentWidth;
					_columnPerView = GridUtils.MAX_DAY_IN_SINGLVIEW;
					break;
				case GridUtils.HOUR_MODE:
					perPixelTime = ( GridUtils.MAX_HOUR_IN_SINGLVIEW * DateUtil.HOUR_IN_MILLISECONDS ) / contentWidth;
					_columnPerView = GridUtils.MAX_HOUR_IN_SINGLVIEW;
					break;
				case GridUtils.MINUTE_MODE:
					break;
				default:
					break;
			}
			
			entryComponent.pixelTime = perPixelTime;
			
			_perColumnPeriod = ( contentWidth * perPixelTime ) / _columnPerView;
			_perColumnDistance = _perColumnPeriod / perPixelTime;
			
			if( entryStart ) {
        		startPointTime = entryStart.getTime();	
        	}
        	
			var totalPixelsRequired:Number = totalPeriod / perPixelTime;
        	hScroller.maxScrollPosition = 	( totalPixelsRequired - contentWidth );
        	if( hScroller.maxScrollPosition == 0 ) {
        		hScroller.visible = false;
        		hScroller.scrollPosition = 0;
        		startPointTime = startDate.getTime();	
        	}
        	else {
        		hScroller.visible = true;
        		hScroller.scrollPosition = ( startPointTime - startDate.getTime() ) / perPixelTime;
        	}
        	horizontalScrollPosition = hScroller.scrollPosition;
        	
        	vScroller.maxScrollPosition = ( _totalEntries * rowHeight ) - ( height - headerHeight );
        	if( vScroller.maxScrollPosition == 0 ) {
        		vScroller.visible = false;
        		isVScrollerVisible = false;
        		vScroller.scrollPosition = 0;
        	}
        	else {
        		vScroller.visible = true;
        		isVScrollerVisible = true;
        	}
        	
        	endPointTime = startPointTime + ( contentWidth * perPixelTime );
        }
        
        public function update():void {
			var oldRenderers:Dictionary = visibleRenderers;
			visibleRenderers = new Dictionary();
			for ( var i:int =0; i < xPositions.length; i++ ) {
				var item:Object = GridUtils.getItem( mode, ( startItemIndex + i ), startDate );
				var renderer:TextField = oldRenderers[ item ];
				if( renderer ) {
					renderer.x = xPositions[ i ] - _perColumnDistance;
					renderer.y = 0;
					renderer.height = rowHeight;
					renderer.textColor = 0x959494;
					renderer.thickness = 2;
					renderer.text = String( item );
					delete oldRenderers[ item ];
				}
				else {
					renderer = getRenderer();
					renderer.x = xPositions[ i ] - _perColumnDistance;
					renderer.y = 0;
					renderer.height = rowHeight;
					renderer.textColor = 0x959494;
					renderer.thickness = 2;
					renderer.text = String( item );
					addChild( renderer );
				}
				visibleRenderers[ item ] = renderer;
			}
			removeUnusedRenderers( oldRenderers );	
		}
		
		private function removeUnusedRenderers( oldRenderers:Dictionary ):void {
			for each( var freeRenderer:DisplayObject in oldRenderers ) {
				freeRenderers.push( removeChild( freeRenderer ) );
			}
		}
			
		private function getRenderer():TextField {
			if( freeRenderers.length > 0 ) {
				return freeRenderers.pop();
			}			
			return entryRenderer.newInstance();
		}
	}
}
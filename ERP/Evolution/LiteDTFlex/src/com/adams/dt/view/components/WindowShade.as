package com.adams.dt.view.components {
	
	import com.adams.dt.event.chartpeople.WindowShadeEvent;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Button;
	import mx.core.EdgeMetrics;
	import mx.core.IFactory;
	import mx.core.LayoutContainer;
	import mx.core.ScrollPolicy;
	import mx.effects.Resize;
	import mx.effects.effectClasses.ResizeInstance;
	import mx.events.EffectEvent;
	import mx.events.PropertyChangeEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	import mx.utils.StringUtil;
	
    [Style(name="openIcon", type="Class", inherit="no")]
	[Style(name="closeIcon", type="Class", inherit="no")]
	[Style(name="openDuration", type="Number", format="Time", inherit="no")]
	[Style(name="closeDuration", type="Number", format="Time", inherit="no")]
	[Style(name="headerClass", type="Class", inherit="no")]
    [Style(name="headerStyleName", type="String", inherit="no")]
	[Style(name="headerTextAlign", type="String", inherit="no")]
	[Style(name="toggleHeader", type="Boolean", inherit="no")]
	[Event(name="openedChanged", type="com.adams.dt.event.chartpeople.WindowShadeEvent")]
	[Event(name="openBegin", type="com.adams.dt.event.chartpeople.WindowShadeEvent")]
	[Event(name="openEnd", type="com.adams.dt.event.chartpeople.WindowShadeEvent")]
	[Event(name="closeBegin", type="com.adams.dt.event.chartpeople.WindowShadeEvent")]
	[Event(name="closeEnd", type="com.adams.dt.event.chartpeople.WindowShadeEvent")]
	
	public class WindowShade extends LayoutContainer {

		[Embed (source="assets/swf/General_Assets.swf#up_icon")]
		private static var DEFAULT_CLOSE_ICON:Class;
		
		[Embed (source="assets/swf/General_Assets.swf#down_icon")]
		private static var DEFAULT_OPEN_ICON:Class;
		
		public var isHaveProperty:String;
		
        private static var styleDefaults:Object = {
             openDuration:250
            ,closeDuration:250
            ,paddingTop:10
            ,headerClass:Button
            ,headerTextAlign:"left"
            ,toggleHeader:false
            ,headerStyleName:null
            ,closeIcon:DEFAULT_CLOSE_ICON
            ,openIcon:DEFAULT_OPEN_ICON
        };

        private static var classConstructed:Boolean = constructClass();

        private static function constructClass():Boolean {
			var css:CSSStyleDeclaration = StyleManager.getStyleDeclaration( "WindowShade" );
            var changed:Boolean = false;
            if( !css ) {
                css = new CSSStyleDeclaration();
                changed = true;
            }
			for( var styleProp:String in styleDefaults ) {
                if( !StyleManager.isValidStyleValue( css.getStyle( styleProp ) ) ) {
                    css.setStyle( styleProp, styleDefaults[ styleProp ] );
                    changed = true;
                }
            }
			if( changed ) {
                StyleManager.setStyleDeclaration( "WindowShade", css, true );
            }

            return true;
        }

		private var _headerButton:Button = null;
        private var headerChanged:Boolean;
        private var _openedChanged:Boolean = false;
        private var _enableHeader:Boolean = true;
        public function set enableHeader(val:Boolean):void{
        	_enableHeader = val;
        }
        public function get enableHeader():Boolean{
        	return _enableHeader;
        }
        private var _headerRenderer:IFactory;
        public function set headerRenderer( value:IFactory ):void {
        	_headerRenderer = value;
        	headerChanged = true;
        	invalidateProperties();
        }
        public function get headerRenderer():IFactory {
        	return _headerRenderer;
        }
        
        public function WindowShade():void {
            super();
            this.verticalScrollPolicy = ScrollPolicy.OFF;
            this.horizontalScrollPolicy = ScrollPolicy.OFF;
			addEventListener( EffectEvent.EFFECT_END, onEffectEnd ,false,0,true);
        }

        protected function createOrReplaceHeaderButton():void {
           if( _headerButton ) {
                _headerButton.removeEventListener( MouseEvent.CLICK, headerButton_clickHandler );
                if( rawChildren.contains( _headerButton ) ) {
                    rawChildren.removeChild( _headerButton );
                }
            }
            if( _headerRenderer ) {
            	_headerButton = _headerRenderer.newInstance() as Button;
            }
            else {
            	var headerClass:Class = getStyle( "headerClass" );
          	 	_headerButton = new headerClass();
            }
            applyHeaderButtonStyles( _headerButton );
			_headerButton.addEventListener( MouseEvent.CLICK, headerButton_clickHandler,false,0,true );
            rawChildren.addChild( _headerButton );
			_headerButton.tabEnabled = false;
        }

        protected function applyHeaderButtonStyles(button:Button):void {
        	button.height = 22;
        	this.styleName = 'innerBorder';
        	this.setStyle( 'borderSides', [ "left", "right", "bottom" ] );
        	
            button.setStyle( "textAlign", getStyle( "headerTextAlign" ) );
            button.styleName = "windowShadeButton";
            
            var headerStyleName:String = getStyle( "headerStyleName" );
            if( headerStyleName ) {
            	headerStyleName = StringUtil.trim( headerStyleName );
            	button.styleName = "windowShadeButton";
            }
            
            button.toggle = getStyle( "toggleHeader" );
            button.label = label;

            if( _opened ) {
                button.setStyle( 'icon', getStyle( "openIcon" ) );
            }
            else {
                button.setStyle( 'icon', getStyle( "closeIcon" ) );
            }
			if( button.toggle ) {
                button.selected = _opened;
            }
        }

        override public function get label():String {
            return super.label;
        }

        override public function set label( value:String ):void {
            super.label = value;
            if( _headerButton )	_headerButton.label = value;
        }

		private var _opened:Boolean = true;
		public function get opened():Boolean {
            return _opened;
        }
        [Bindable]
        public function set opened( value:Boolean ):void {
            var old:Boolean = _opened;
            _opened = value;
            _openedChanged = _openedChanged || ( old != _opened );
            if( _openedChanged && initialized ) {
                if( ( old != _opened ) && willTrigger( WindowShadeEvent.OPENED_CHANGED ) ) {
                    var evt:WindowShadeEvent = new WindowShadeEvent( WindowShadeEvent.OPENED_CHANGED, false, true );
                    dispatchEvent( evt );
                    var cancelled:Boolean = evt.isDefaultPrevented();
                    if( evt.isDefaultPrevented() ) {
                        callLater( restoreOpened, [ old ] );
                        return;
                    }
                }
				measure();
               	runResizeEffect();
                invalidateProperties();
            }
        }
        
        private var _headerLocation:String = "top";
		[Bindable]
		[Inspectable(enumeration="top,bottom", defaultValue="top")]
		public function set headerLocation( value:String ):void {
			_headerLocation = value;
			invalidateSize();
			invalidateDisplayList();
		}
		public function get headerLocation():String {
			return _headerLocation;
		}

        protected function restoreOpened( value:Boolean ):void {
             var old:Boolean = _opened;
             _opened = value;
             _openedChanged = _openedChanged || ( old != _opened );
             if( _opened != old ) {
                 dispatchEvent( PropertyChangeEvent.createUpdateEvent( this, "opened", old, _opened ) );
             }
        }
			
		override public function styleChanged( styleProp:String ):void {
            super.styleChanged( styleProp );
            if( styleProp == "headerClass" ) {
                headerChanged = true;
                invalidateProperties();
            }
            else if( styleProp == "headerStyleName" || styleProp == "headerTextAlign" || styleProp == "toggleHeader" 
            	|| styleProp == "openIcon" || styleProp == "closeIcon" ) {
                applyHeaderButtonStyles( _headerButton );
            }
            invalidateDisplayList();
        }

        override protected function createChildren():void {
            super.createChildren();
         	createOrReplaceHeaderButton();
        }

        override protected function commitProperties():void {
			super.commitProperties();
			if( headerChanged ) {
				createOrReplaceHeaderButton();
				headerChanged = false;
			}
			if( _openedChanged ) {
                if( _opened ) {
                    _headerButton.setStyle( 'icon', getStyle( "openIcon" ) );
                }
                else {
                    _headerButton.setStyle( 'icon', getStyle( "closeIcon" ) );
                }
                _openedChanged = false;
            }
        }

        override protected function updateDisplayList( w:Number, h:Number ):void {
            super.updateDisplayList( w, h );
            if( _headerLocation == "top" ) {
            	_headerButton.move( 0,0 );
            }
            else if( _headerLocation == "bottom" ) {
            	_headerButton.move( 0,h - _headerButton.getExplicitOrMeasuredHeight() );
            }
            _headerButton.setActualSize( w, _headerButton.getExplicitOrMeasuredHeight() );
        }

		private var _viewMetrics:EdgeMetrics;
		override public function get viewMetrics():EdgeMetrics {
    		if ( !_viewMetrics ) {
	            _viewMetrics = new EdgeMetrics( 0, 0, 0, 0 );
	     	}    
	        var vm:EdgeMetrics = _viewMetrics;
			var o:EdgeMetrics = super.viewMetrics;
	        vm.left = o.left;
	        vm.top = o.top;
	        vm.right = o.right;
	        vm.bottom = o.bottom;
	        var hHeight:Number = _headerButton.getExplicitOrMeasuredHeight();
	        if ( !isNaN( hHeight ) ) {
	        	if( _headerLocation == "top" ) {
	        		 vm.top += hHeight;
	        	}
	        	else if( _headerLocation == "bottom" ) {
	        		 vm.bottom += hHeight;
	        	}
	        }
	        return vm;
    	}
    	
    	public var closedHeight:Number = 0;
    	override protected function measure():void {
            super.measure();
            if( _opened ) {
            	//measuredHeight += _headerButton.getExplicitOrMeasuredHeight();
            }
            else {
            	measuredHeight = closedHeight + _headerButton.getExplicitOrMeasuredHeight();
            }
        }
		
		private var resize:Resize;
		private var resizeInstance:ResizeInstance;
		private var resetExplicitHeight:Boolean;
		private var transitionCompleted:Boolean = true;
		
		protected function runResizeEffect():void {
			if( resize && resize.isPlaying ) {
				transitionCompleted = false;
				resize.end();
			}
			transitionCompleted = true;
			var beginEvent:String = _opened ? WindowShadeEvent.OPEN_BEGIN : WindowShadeEvent.CLOSE_BEGIN;
            if( willTrigger( beginEvent ) ) {
                dispatchEvent(new WindowShadeEvent( beginEvent, false, false ) );
            }
			var duration:Number = _opened ? getStyle( "openDuration" ) : getStyle( "closeDuration" );
            if( duration == 0 ) { 
            	this.setActualSize( getExplicitOrMeasuredWidth(), measuredHeight );
            	invalidateSize();
            	invalidateDisplayList();
				var endEvent:String = _opened ? WindowShadeEvent.OPEN_END : WindowShadeEvent.CLOSE_END;
                if( willTrigger( endEvent ) ) {
                    dispatchEvent( new WindowShadeEvent( endEvent, false, false ) );
                }
				return;
            }
            resize = new Resize( this );
			resetExplicitHeight = isNaN( explicitHeight );
			resize.heightTo = Math.min( maxHeight, measuredHeight );
			resize.duration = duration;
			
			var instances:Array = resize.play();
            if( instances && instances.length ) {
                resizeInstance = instances[ 0 ];
            }
        }

        protected function onEffectEnd( evt:EffectEvent ):void {
            if( evt.effectInstance == resizeInstance ) {
                if( resetExplicitHeight ) explicitHeight = NaN;
                resizeInstance = null;
				if( transitionCompleted ) {
                    var endEvent:String = _opened ? WindowShadeEvent.OPEN_END : WindowShadeEvent.CLOSE_END;
                    if( willTrigger( endEvent ) ) {
                        dispatchEvent( new WindowShadeEvent( endEvent, false, false ) );
                    }
                }
            }
        }
		protected function headerButton_clickHandler( event:MouseEvent ):void {
			if(_enableHeader)opened = !_opened;
        }
    }
}

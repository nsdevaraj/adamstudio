package com.adams.dt.view.filemanagement.renderers
{
    import flash.filters.DropShadowFilter;
    
    import mx.containers.VBox;
    import mx.controls.Label;
    import mx.controls.SWFLoader;
    import mx.core.IToolTip;
    
    public class ThumbnailTooltip extends VBox implements IToolTip
    {
      	private var nameHolder:Label;
        private var imageHolder:SWFLoader;
        
        private var dropShadowFilter:DropShadowFilter = new DropShadowFilter(8,45,0,0.5);
        
        private var _nameOfFiletip:String;
        public function set nameOfFiletip( value:String ):void {
        	_nameOfFiletip = value;
        	if( nameHolder ) {
        		nameHolder.text = value;
        	}
        }
		
		private var _imageSource:Object;
		 public function set imageSource( value:Object ):void {
        	_imageSource = value;
        	if( imageHolder ) {
        		imageHolder.source = value;
        	}
        }
		
      	public function ThumbnailTooltip() 
      	{
      		super();
            mouseEnabled = false;
            mouseChildren = false;
            
            setStyle( 'backgroundColor', 0x3F3F3F );
        	setStyle( 'backgroundAlpha', 0.5 );
        	
        	setStyle( 'borderThickness', 0.5 );
        	setStyle( 'borderStyle', "solid" );
        	setStyle( 'borderColor', 0xCCCCCC );
        	
        	setStyle( 'horizontalAlign', 'center' ); 
        	setStyle( 'verticalAlign', 'middle' );
        	
        	setStyle( 'paddingLeft', 5 );
        	setStyle( 'paddingTop', 5 );
        	setStyle( 'paddingRight', 5 );
        	setStyle( 'paddingBottom', 5 ); 
        	
        	setStyle( 'verticalGap', 0 );
        	
        	filters = [dropShadowFilter];	 
        }
        
        override protected function createChildren():void {
        	if( !imageHolder ) {
        		imageHolder = new SWFLoader();
        		imageHolder.source = _imageSource;
        		imageHolder.width = 80;
        		imageHolder.height = 80;
        		imageHolder.setStyle( 'horizontalAlign', 'center' ); 
        		imageHolder.setStyle( 'verticalAlign', 'middle' ); 
        		addChild( imageHolder );
        	}
        	if( !nameHolder ) {
        		nameHolder = new Label();
        		nameHolder.setStyle( 'color', 0xFFFFFF );
        		nameHolder.setStyle( 'fontSize', 12 );
        		addChild( nameHolder );
        	}
        	super.createChildren();
    	}
    	
    	public function get text():String {
            return null;
        }
        [Bindable]
        public function set text( value:String ):void {
            nameOfFiletip = value;
        }
	}
}

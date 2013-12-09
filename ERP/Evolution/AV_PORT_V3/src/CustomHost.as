package
{
    import flash.display.NativeWindow;
    import flash.display.NativeWindowInitOptions;
    import flash.geom.Rectangle;
    import flash.html.HTMLHost;
    import flash.text.TextField;
    
    import mx.core.Application;

    public class CustomHost extends HTMLHost
    {
        import flash.html.*;
        public var statusField:TextField;
        public function CustomHost(defaultBehaviors:Boolean=true)
        {
            super(defaultBehaviors);
        }
        override public function windowClose():void
        {
           // htmlLoader.stage.window.close();
        }
        override public function createWindow(windowCreateOptions:HTMLWindowCreateOptions):HTMLLoader
        {
            var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
            var window:NativeWindow = new NativeWindow(initOptions);
           /*  htmlLoader.width = window.width;
            htmlLoader.height = window.height;
            window.stage.scaleMode = StageScaleMode.NO_SCALE;
            window.stage.addChild(htmlLoader); */
            return htmlLoader;
        }
        override public function updateLocation(locationURL:String):void
        {  
           // trace(locationURL + ' popup' ); 
        }        
        override public function set windowRect(value:Rectangle):void
        {
          //  htmlLoader.stage.window.bounds = value;
        } 
        override public function windowBlur():void
        {
            htmlLoader.alpha = 0.5;
        }
        override public function windowFocus():void
        {
            htmlLoader.alpha = 1;
        }
    }
}
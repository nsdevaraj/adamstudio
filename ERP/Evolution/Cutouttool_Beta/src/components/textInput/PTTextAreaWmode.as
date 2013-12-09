package components.textInput
{
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   
   import mx.controls.TextArea;

   /**
   * Wmode Workaround for TextArea
   * 
   * @version 1.2 16/12/2009
   * @author nicolas.cynober@pearltrees.com
   * @see http://nicolas.cynober.fr/blog/
   */
   public class PTTextAreaWmode extends TextArea 
   {
      protected var _forceLang:String;
      protected var _inputWmode:PTInputWmode;
           
      public function PTTextAreaWmode() {
         super();
         forceLang ='fr';
         addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
         addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
         addEventListener(TextEvent.TEXT_INPUT, onTextInput); 
      }
      
      override protected function createChildren():void{
         super.createChildren();
         _inputWmode = new PTInputWmode(textField);
         if(_forceLang) _inputWmode.lang = _forceLang;
      }    
      
      // Replace character input ----------------------------------------------
      
      protected function onTextInput(event:TextEvent):void {
         text = _inputWmode.getUpdatedText(event, textField);
      }
      
      // Key states  ----------------------------------------------------------
           
      private function onKeyUp(kEvent:KeyboardEvent):void {
         _inputWmode.updateModifierKeyState(kEvent.keyCode, false);
      }      
      private function onKeyDown(kEvent:KeyboardEvent):void {
         _inputWmode.updateModifierKeyState(kEvent.keyCode, true);        
         _inputWmode.currentKeyCode = kEvent.keyCode;
      }
      
      // Options --------------------------------------------------------------
      
      public function set forceLang(value:String):void {
         _forceLang = value;
         if(_inputWmode) {
            _inputWmode.lang = _forceLang;
         }
      }
      public function get forceLang():String {
         return _forceLang;
      }       

   }
}
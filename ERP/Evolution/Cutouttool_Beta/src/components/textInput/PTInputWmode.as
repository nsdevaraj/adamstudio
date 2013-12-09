package components.textInput
{
   import components.textInput.keyBoardMapping.IPTKeyboard;
   import components.textInput.keyBoardMapping.PTFrenchKeyboard;
   
   import flash.events.TextEvent;
   import flash.external.ExternalInterface;
   
   import mx.core.IUITextField;

   /**
   * Wmode Workaround
   * 
   * See PTTextAreaWmode & PTTextInputWmode if you want to use this workaround.
   * 
   * @version 1.2 16/12/2009
   * @author nicolas.cynober@pearltrees.com
   * @see http://nicolas.cynober.fr/blog/
   */   
   public class PTInputWmode
   {
      // config
      private var _browser:String;
      private var _lang:String;
      private var _keyboardHelper:IPTKeyboard;
      public static const BROWSER_FIREFOX:String = "Firefox";
      public static const BROWSER_MSIE:String = "MSIE";      
      
      // key state
      private var _currentKeyCode:int = 0;
      private var _altGrIsDown:Boolean;
      private var _shiftIsDown:Boolean;
      
      // component
      private var _textField:IUITextField;
      
      public function PTInputWmode(textField:IUITextField) {
         super();
         _textField = textField;
         init();
      }
      
      protected function init():void {
         lang = ExternalInterface.call("getClientLang");
         browser = ExternalInterface.call("getBrowserName");        
      }
      
      // Replace character input ----------------------------------------------
      
      /**
      * Flex components recreate their textField property when hasFontContextChanged is fired.
      * Thus I recommand to use the second parameter for Flex components.
      */
      public function getUpdatedText(event:TextEvent, refreshTextField:IUITextField=null):String {
         if(refreshTextField && refreshTextField != _textField) textField = refreshTextField;
         
         if(browser == BROWSER_MSIE || !keyboardHelper) return _textField.text;
         
         var char:String;
         if(_altGrIsDown) {
            char = keyboardHelper.getAltGrChar(event.text, currentKeyCode);
         }else if(_shiftIsDown){
            char = keyboardHelper.getShiftChar(event.text, currentKeyCode);
         }else{
            char = keyboardHelper.getChar(event.text, currentKeyCode);
         }
         
         if(event.text != char) {
            return replaceTextEventByCharacter(event, char);
         }
         return _textField.text;
      }
      public function replaceTextEventByCharacter(event:TextEvent, char:String):String {
         event.preventDefault();
         var str:String = _textField.text;
         var selIndex:int = _textField.caretIndex;
         _textField.text = str.substring(0, selIndex) + char + str.substring(selIndex, str.length); 
         _textField.setSelection(selIndex+char.length, selIndex+char.length);
         return _textField.text;
      }
      
      // Key states  ----------------------------------------------------------
      
      public function updateModifierKeyState(keyCode:int, isDown:Boolean):void {
         switch(keyCode) {
            case 17:
               _altGrIsDown = isDown;
               break;
            case 16:
               _shiftIsDown = isDown;
               break;
            default:
         }         
      }
      
      
      // Getters & Setters  ---------------------------------------------------

      public function set textField(value:IUITextField):void{
         _textField = value;
      }
      public function get textField():IUITextField{
         return _textField;
      }
      
      public function set keyboardHelper(value:IPTKeyboard):void {
         if(value != _keyboardHelper) {
            _keyboardHelper = value;
         }
      }
      public function get keyboardHelper():IPTKeyboard {
         return _keyboardHelper;
      }      
      
      public function set browser(value:String):void {
         if(value != _browser) {
            _browser = value;
            // currently do nothing...
         }
      }
      public function get browser():String {
         return _browser;
      }
      
      public function set lang(value:String):void {
         if(value != _lang) {
            _lang = value;
          	if(_lang == 'fr') {
               keyboardHelper = new PTFrenchKeyboard();
            }
         }
      }
      public function get lang():String {
         return _lang;
      }
      
      public function set currentKeyCode(value:int):void {
         if(value != _currentKeyCode) {
            _currentKeyCode = value;
         }
      }
      public function get currentKeyCode():int {
         return _currentKeyCode;
      }        
   }
}
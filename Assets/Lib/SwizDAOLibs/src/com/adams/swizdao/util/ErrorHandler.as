package com.adams.swizdao.util{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.net.FileReference;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	/**
	 * @author jonas
	 * @version 0.2
	 *
	 * TODO
	 * - catching external swf errors
	 * - open infos whith key
	 *
	 */
	public class ErrorHandler {
		public static const VERSION : String = "0.2";
		
		public static const PLAYER_STANDALONE : String = "StandAlone";// for the Flash StandAlone Player
		public static const PLAYER_EXTERNAL : String = "External";// for the Flash Player version used by the external player, or test movie mode..
		public static const PLAYER_PLUGIN : String = "PlugIn";// for the Flash Player browser plug-in
		public static const PLAYER_ACTIVEX : String = "ActiveX";// for the Flash Player ActiveX Control used by Microsoft Internet Explorer
		public static const PLAYER_DESKTOP : String = "Desktop";// for the Flash Player ActiveX Control used by Microsoft Internet Explorer
		
		public static const MODE_DEBUG : String = "debug";
		public static const MODE_RELEASE : String = "release";
		
		private var _buttonSize : uint = 15;
		private var _buttonBackgroundColor : Number = 0xFF0000;
		private var _buttonTextColor : Number = 0xFFFFFF;
		private var _windowWidth : Number = 500;
		private var _windowHeight : Number = 300;
		
		private var _stage : Stage;
		private var _display : DisplayObject;
		private var _container : Sprite;
		private var _errors : Vector.<ErrorData>;
		private var _errorIndex : uint = 0;
		
		private var _buildMode : String = isDebugBuild() ? MODE_DEBUG : MODE_RELEASE;
		private var _playerMode : String = Capabilities.isDebugger ? MODE_DEBUG : MODE_RELEASE;
		
		private var _activeWithPlayerType : Array = [PLAYER_ACTIVEX, PLAYER_DESKTOP, PLAYER_EXTERNAL, PLAYER_PLUGIN, PLAYER_STANDALONE];
		private var _activeWithPlayerMode : Array = [MODE_DEBUG, MODE_RELEASE];
		private var _activeWithBuildMode : Array = [MODE_DEBUG, MODE_RELEASE];
		
		private var _prevButton : Button;
		private var _nextButton : Button;
		private var _openButton : Button;
		private var _saveButton : Button;
		private var _message : TextField;
		
		private var _window : Sprite;
		
		public function ErrorHandler() {
		}
		
		public static var instance : ErrorHandler;
		
		public static function getIntance() : ErrorHandler {
			if (instance == null)
				instance = new ErrorHandler();
			return instance;
		}
		
		// GETTER / SETTERS
		public function get activeWithPlayerType() : Array {
			return _activeWithPlayerType;
		}
		
		public function set activeWithPlayerType(value : Array) : void {
			_activeWithPlayerType = value;
		}
		
		public function get activeWithPlayerMode() : Array {
			return _activeWithPlayerMode;
		}
		
		public function set activeWithPlayerMode(value : Array) : void {
			_activeWithPlayerMode = value;
		}
		
		public function get activeWithBuildMode() : Array {
			return _activeWithBuildMode;
		}
		
		public function set activeWithBuildMode(value : Array) : void {
			_activeWithBuildMode = value;
		}
		
		// PUBLIC
		public function init(display : DisplayObject) : void {
			_display = display;
			if (display.stage == null) {
				display.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			} else {
				start(display.stage);
			}
		}
		
		public function isActive() : Boolean {
			if (!inArray(_activeWithPlayerType, Capabilities.playerType))
				return false;
			if (!inArray(_activeWithBuildMode, _buildMode))
				return false;
			if (!inArray(_activeWithPlayerMode, _playerMode))
				return false;
			return true;
		}
		
		// PRIVATE
		private function addedToStage(event : Event) : void {
			start(DisplayObject(event.currentTarget).stage);
		}
		
		private function start(stage : Stage) : void {
			_stage = stage;
			_errors = new Vector.<ErrorData>();
			
			if (_stage.stageWidth < _windowWidth)
				_windowWidth = _stage.stageWidth;
			if (_stage.stageWidth < _windowHeight)
				_windowHeight = _stage.stageHeight;
			
			_display.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
		}
		
		private function uncaughtErrorHandler(event : UncaughtErrorEvent) : void {
			event.preventDefault();
			event.stopImmediatePropagation();
			
			
			var data : ErrorData = new ErrorData();
			if (event.error is Error) {
				var error : Error = event.error as Error;
				data.title = error.message;
				if (error.getStackTrace()!= null)
					data.message = error.getStackTrace();
			} else if (event.error is ErrorEvent) {
				var errorEvent : ErrorEvent = event.error as ErrorEvent;
				data.title = errorEvent.text;
				data.message = errorEvent.toString();
			} else {
				data.title = "Error";
				data.message = "A non-Error, non-ErrorEvent type was thrown and uncaught";
			}
			if(data.message == null)
				data.message = "";
			addNewError(data);
		}
			
		public function addNewError(dataObj:Object):void{
			var data: ErrorData = new ErrorData();
			data.type = dataObj.type;
			data.title = dataObj.title;
			data.message = dataObj.message;
			_errors.push(data);
			_errorIndex = _errors.length - 1;
			
			showError();
		}
		
		private function showError() : void {
			if (isActive() && false) {
				if (_container == null) {
					initView();
					DisplayObjectContainer(_stage.getChildAt(0)).addChild(_container);
				} else {
					DisplayObjectContainer(_stage.getChildAt(0)).removeChild(_container);
					DisplayObjectContainer(_stage.getChildAt(0)).addChild(_container);
				}
				_openButton.label.text = (_errors.length).toString();
				_openButton.x = 0;
				_openButton.y = 0;
				_openButton.visible = true;
			}
		}
		
		// ditchhopper version
		private function getSWFName() : String {
			return String(_stage.loaderInfo.url.split("/").pop()).replace("%5F", "_").replace("%2D", "-");
		}
		
		private function getLogs() : String {
			var logs : String = "";
			logs += getInfos(false);
			var n : int = _errors.length;
			for (var i : int = 0; i < n; i++) {
				logs += getMessage(false, i);
			}
			return logs;
		}
		
		private var _line : String = "\r\n\----------------------------------------\r\n\----------------------------------------";
		
		private function getMessage(html : Boolean = true, index : Number = -1) : String {
			var i : uint = index == -1 ? _errorIndex : index;
			var data : ErrorData = _errors[i];
			var message : String = "";
			
			if (html) {
				message += "<font size='11' color='#FFFFFF'>";
				message += "<b>" + (i + 1) + "/" + _errors.length + " - " + data.time + "</b><br/><br/>";
				message += "<b>" + data.title + "</b>";
				message += "<br/>" + data.message;
				message += "</font>";
			} else {
				message += "\r\n" + (i + 1) + "/" + _errors.length + " - " + data.time;
				message += _line;
				message += "\r\n" + data.title;
				message += "\r\n" + data.message.replace("\n", "\r\n");
				message += _line + "\r\n\r\n";
			}
			return message;
		}
		
		private function getInfos(html : Boolean = true) : String {
			var infos : String = "";
			
			if (html) {
				infos += "<font size='11' color='#FFFFFF'>";
				infos += "ErrorHandler " + VERSION;
				infos += "<br/><b>" + _stage.loaderInfo.url + "</b>";
				infos += "<br/>" + Capabilities.version + " " + Capabilities.playerType;
				infos += "<br/>Debug player : " + Capabilities.isDebugger;
				if (Capabilities.isDebugger)
					infos += "<br/>Debug build : " + isDebugBuild();
				infos += "</font>";
			} else {
				infos += "\r\nErrorHandler " + VERSION;
				infos += _line;
				infos += "\r\n" + _stage.loaderInfo.url;
				infos += "\r\n" + Capabilities.version + " " + Capabilities.playerType;
				infos += "\r\nDebug player : " + Capabilities.isDebugger;
				if (Capabilities.isDebugger)
					infos += "\r\nDebug build : " + isDebugBuild();
				infos += _line;
				
				infos += "\r\navHardwareDisable : " + Capabilities.avHardwareDisable;
				infos += "\r\ncpuArchitecture : " + Capabilities.cpuArchitecture;
				infos += "\r\nhasAccessibility : " + Capabilities.hasAccessibility;
				infos += "\r\nhasAudio : " + Capabilities.hasAudio;
				infos += "\r\nhasAudioEncoder : " + Capabilities.hasAudioEncoder;
				infos += "\r\nhasEmbeddedVideo : " + Capabilities.hasEmbeddedVideo;
				infos += "\r\nhasIME : " + Capabilities.hasIME;
				infos += "\r\nhasMP3 : " + Capabilities.hasMP3;
				infos += "\r\nhasPrinting : " + Capabilities.hasPrinting;
				infos += "\r\nhasScreenBroadcast : " + Capabilities.hasScreenBroadcast;
				infos += "\r\nhasScreenPlayback : " + Capabilities.hasScreenPlayback;
				infos += "\r\nhasStreamingAudio : " + Capabilities.hasStreamingAudio;
				infos += "\r\nhasStreamingVideo : " + Capabilities.hasStreamingVideo;
				infos += "\r\nhasTLS : " + Capabilities.hasTLS;
				infos += "\r\nhasVideoEncoder : " + Capabilities.hasVideoEncoder;
				infos += "\r\nisEmbeddedInAcrobat : " + Capabilities.isEmbeddedInAcrobat;
				infos += "\r\nlanguage : " + Capabilities.language;
				infos += "\r\nlocalFileReadDisable : " + Capabilities.localFileReadDisable;
				infos += "\r\nmanufacturer : " + Capabilities.manufacturer;
				infos += "\r\nmaxLevelIDC : " + Capabilities.maxLevelIDC;
				infos += "\r\nos : " + Capabilities.os;
				infos += "\r\npixelAspectRatio : " + Capabilities.pixelAspectRatio;
				infos += "\r\nscreenColor : " + Capabilities.screenColor;
				infos += "\r\nscreenDPI : " + Capabilities.screenDPI;
				infos += "\r\nscreenResolutionX : " + Capabilities.screenResolutionX;
				infos += "\r\nscreenResolutionY : " + Capabilities.screenResolutionY;
				infos += "\r\nsupports32BitProcesses : " + Capabilities.supports32BitProcesses;
				infos += "\r\nsupports64BitProcesses : " + Capabilities.supports64BitProcesses;
				infos += "\r\ntouchscreenType : " + Capabilities.touchscreenType;
				infos += _line + "\r\n";
			}
			return infos;
		}
		
		private function openError() : void {
			updateControls();
			_message.htmlText = getMessage();
			_window.x = 0;
			_window.visible = true;
		}
		
		private function initView() : void {
			_container = new Sprite();
			
			var _infos : TextField = new TextField();
			_infos.width = _windowWidth - 20;
			_infos.autoSize = TextFieldAutoSize.LEFT;
			_infos.wordWrap = true;
			_infos.multiline = true;
			_infos.htmlText = getInfos();
			_infos.x = 10;
			_infos.y = _windowHeight - _infos.height - 10;
			
			_message = new TextField();
			_message.selectable = true;
			_message.multiline = true;
			_message.wordWrap = true;
			_message.width = _windowWidth;
			_message.height = _windowHeight;
			_message.type = TextFieldType.DYNAMIC;
			_message.x = _message.y = 10;
			_message.y = _buttonSize + 3;
			_message.width = _windowWidth - 20;
			_message.height = _windowHeight - _message.y - _infos.height - 30;
			
			_window = new Sprite();
			_window.visible = false;
			
			_window.graphics.beginFill(0x333333);
			_window.graphics.drawRect(0, _buttonSize, _windowWidth, _windowHeight - _buttonSize);
			_window.graphics.endFill();
			
			_window.graphics.beginFill(0x111111);
			_window.graphics.drawRect(0, _buttonSize, _windowWidth, _buttonSize * 1.5);
			_window.graphics.endFill();
			
			_window.graphics.beginFill(0x666666);
			_window.graphics.drawRect(0, _infos.y - 10, _windowWidth, _infos.height + 20);
			_window.graphics.endFill();
			
			_window.x = -_windowWidth;
			_window.addChild(_message);
			_window.addChild(_infos);
			
			_nextButton = new Button(_buttonSize, _buttonSize * 1.5, _buttonBackgroundColor, _buttonTextColor, 10);
			_nextButton.addEventListener(MouseEvent.CLICK, onClickNext);
			_nextButton.label.text = ">";
			_nextButton.x = _windowWidth - _buttonSize;
			_nextButton.y = _buttonSize;
			_window.addChild(_nextButton);
			
			_prevButton = new Button(_buttonSize, _buttonSize * 1.5, _buttonBackgroundColor, _buttonTextColor, 10);
			_prevButton.addEventListener(MouseEvent.CLICK, onClickPrev);
			_prevButton.x = _windowWidth - 1 - _buttonSize * 2;
			_prevButton.y = _buttonSize;
			_prevButton.label.text = "<";
			_window.addChild(_prevButton);
			
			_saveButton = new Button(_buttonSize * 3, _buttonSize * 1.5, _buttonBackgroundColor, _buttonTextColor, 11);
			_saveButton.addEventListener(MouseEvent.CLICK, onClickSave);
			_saveButton.label.text = "save";
			_saveButton.x = _windowWidth - _saveButton.width - 2 - (_buttonSize * 2);
			_saveButton.y = _buttonSize;
			_window.addChild(_saveButton);
			
			_container.addChild(_window);
			
			_openButton = new Button(_buttonSize, _buttonSize, _buttonBackgroundColor, _buttonTextColor);
			_openButton.addEventListener(MouseEvent.CLICK, onClickOpen);
			_openButton.label.text = "0";
			_container.addChild(_openButton);
		}
		
		private function updateControls() : void {
			_prevButton.mouseEnabled = _errorIndex > 0;
			_prevButton.alpha = _prevButton.mouseEnabled ? 1 : 0.5;
			_nextButton.mouseEnabled = _errorIndex < _errors.length - 1;
			_nextButton.alpha = _nextButton.mouseEnabled ? 1 : 0.5;
		}
		
		private function onClickSave(event : MouseEvent) : void {
			var f : FileReference = new FileReference();
			var d : Date = new Date();
			f.save(getLogs(), getSWFName() + ".log." + d.fullYear + "-" + format2(d.month + 1) + "-" + format2(d.date) + d.time + ".txt");
			_errors = new Vector.<ErrorData>();
		}
		
		private function onClickNext(event : MouseEvent) : void {
			_errorIndex++;
			updateControls();
			openError();
		}
		
		private function onClickPrev(event : MouseEvent) : void {
			_errorIndex--;
			updateControls();
			openError();
		}
		
		private function onClickOpen(event : MouseEvent) : void {
			if (_window.visible) {
				_window.visible = false;
				_window.x = -_windowWidth;
			} else {
				openError();
			}
		}
		
		private function isDebugBuild() : Boolean {
			var s : String = new Error().getStackTrace();
			if (s == null)
				return false;
			// undefined status
			return s.indexOf('[') != -1;
		}
		
		private function inArray(array : Array, value : String) : Boolean {
			var n : uint = array.length;
			for (var i : uint = 0; i < n; i++) {
				if (array[i] == value)
					return true;
			}
			return false;
		}
		
		private function format2(n : uint) : String {
			if (n < 10)
				return "0" + n;
			return n.toString();
		}
	}
}
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

internal class Button extends Sprite {
	public var label : TextField;
	
	public function Button(width : Number, height : Number, bgColor : Number = 0xFF0000, textColor : Number = 0xFFFFFF, textSize : Number = 9) {
		label = new TextField();
		label.mouseEnabled = false;
		label.autoSize = TextFieldAutoSize.LEFT;
		label.text = " ";
		label.defaultTextFormat = new TextFormat(null, textSize, textColor, false, false, false, null, null, "center");
		label.y = (height - label.height) / 2;
		label.autoSize = TextFieldAutoSize.NONE;
		label.width = width;
		
		buttonMode = true;
		graphics.beginFill(bgColor);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
		addChild(label);
	}
}
internal class ErrorData {
	public var time : Date;
	public var type : String;
	public var title : String;
	public var message : String;
	
	public function ErrorData() {
		time = new Date();
	}
}


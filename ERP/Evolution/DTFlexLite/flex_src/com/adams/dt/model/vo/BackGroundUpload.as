package com.adams.dt.model.vo {
	
	import com.adams.dt.event.FileDetailsEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	public class BackGroundUpload extends EventDispatcher
	{
		
		private var _idle:Boolean = true;
		[Bindable(event="idleChange")]
		public function set idle (value:Boolean):void {
			if (value != _idle ) 	{
				_idle = value;
				dispatchEvent( new Event ( "idleChange" ) );
			}
		}
		public function get idle():Boolean {
			return _idle;
		}

		private var _fileToUpload:ArrayCollection = new ArrayCollection();
		[Bindable(event="fileToUploadChange")]
		public function set fileToUpload ( value:ArrayCollection ):void {
			if( _fileToUpload ) 	{
				_fileToUpload.removeEventListener( CollectionEvent.COLLECTION_CHANGE, onFileToUploadChange );
			}
			_fileToUpload = value;
			if ( _fileToUpload ) {
				_fileToUpload.addEventListener( CollectionEvent.COLLECTION_CHANGE, onFileToUploadChange,false,0,true );
			}
			var uploadEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_BGUPLOAD_FILE );
			if( idle ) {
				_fileToUpload.removeEventListener( CollectionEvent.COLLECTION_CHANGE, onFileToUploadChange );
				uploadEvent.dispatch();
			} 
			dispatchEvent ( new Event( "fileToUploadChange" ) );
		}
		public function get fileToUpload():ArrayCollection {
			return _fileToUpload;
		}
		
		public function BackGroundUpload():void 	{
			_fileToUpload.addEventListener( CollectionEvent.COLLECTION_CHANGE, onFileToUploadChange,false,0,true );
		}
		
		private function onFileToUploadChange ( event:CollectionEvent ):void 	{
			if ( ( event.kind == CollectionEventKind.ADD ) ||
				 ( event.kind == CollectionEventKind.REMOVE ) || 
				 ( event.kind == CollectionEventKind.REPLACE ) ||
				 ( event.kind == CollectionEventKind.RESET ) ) {
				var uploadEvent:FileDetailsEvent = new FileDetailsEvent( FileDetailsEvent.EVENT_BGUPLOAD_FILE );
				if( idle ) {
					 uploadEvent.dispatch();
				}	
			}
		}
	}
}
package com.adams.dt.model.vo
{
	
import com.adams.dt.event.FileDetailsEvent;
import com.adams.dt.model.ModelLocator;

import flash.events.Event;
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
	public class BackGroundDownload extends EventDispatcher
	{
		
			 
		private var _idle:Boolean = true;
		[Bindable(event="idleChange")]
		public function set idle (value:Boolean):void
		{
			if (value != _idle)
			{
				_idle = value;
				dispatchEvent (new Event ("idleChange"));
			}
		}

		public function get idle ():Boolean
		{
			return _idle;
		}


			
		private var _fileToDownload:ArrayCollection = new ArrayCollection();
		[Bindable(event="fileToDownloadChange")]
		public function set fileToDownload (value:ArrayCollection):void
		{
			
			if (value != _fileToDownload)
			{
				if (_fileToDownload)
				{
					_fileToDownload.removeEventListener
						(CollectionEvent.COLLECTION_CHANGE, onfileToDownloadChange);
				}
				_fileToDownload = value;
				if (_fileToDownload)
				{
					_fileToDownload.addEventListener
						(CollectionEvent.COLLECTION_CHANGE, onfileToDownloadChange,false,0,true);
				}
				
				dispatchEvent (new Event ("fileToDownloadChange"));
			}
		}
		public function BackGroundDownload()
		{
			_fileToDownload.addEventListener
						(CollectionEvent.COLLECTION_CHANGE, onfileToDownloadChange,false,0,true);
		}
		public function get fileToDownload ():ArrayCollection
		{
			return _fileToDownload;
		}
		public function downloadComplete():void{
			dispatchEvent(new Event("downloadComplete"));
		}
		private function onfileToDownloadChange (event:CollectionEvent):void
		{
			if ((event.kind == CollectionEventKind.ADD)  || 
				(event.kind == CollectionEventKind.REPLACE) ||
				(event.kind == CollectionEventKind.RESET))
			{
				ModelLocator.getInstance().downloadFileNumbers = fileToDownload.length;
				var uploadEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_BGDOWNLOAD_FILE);
				if(idle) uploadEvent.dispatch()
			}
			if(event.kind == CollectionEventKind.REMOVE)ModelLocator.getInstance().downloadFileNumbers = fileToDownload.length;
		}
		 


	}
}
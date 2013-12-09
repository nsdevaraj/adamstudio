/**
 * FileUploadManager
 * 
 * This class encapsulates the process of uploading a file to the server. 
 * 
 * While the FileReference API is pretty simple, there are still a number of choices to be
 * made and events to handle. They are all placed here.
 */
package com.adams.blog.editor
{
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import com.adobe.blog.events.BlogEvent;
	
	[Event(name="uploadBegin",type="com.adobe.blog.events.BlogEvent")]
	[Event(name="uploadComplete",type="com.adobe.blog.events.BlogEvent")]

	public class FileUploadManager extends EventDispatcher
	{
		private var fileRef:FileReference;
		
		/**
		 * upload
		 * 
		 * This function begins the upload process. It displays the File Chooser and sets event handlers.
		 */
		public function upload() : void
		{
			var imageTypes:FileFilter = new FileFilter("Images (*.swf, *.jpg, *.jpeg, *.gif, *.png)", "*.swf; *.jpg; *.jpeg; *.gif; *.png");
			var zipTypes:FileFilter = new FileFilter("Compressed Files (*.zip, *.tar)", "*.zip; *.tar");
			var textTypes:FileFilter = new FileFilter("Text Files (*.txt, *.rtf)", "*.txt; *.rtf");
			var allTypes:Array = new Array(imageTypes, zipTypes, textTypes);
			fileRef = new FileReference();
			fileRef.addEventListener(Event.SELECT, selectHandler);
			fileRef.addEventListener(Event.OPEN, progressHandler);
			fileRef.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			fileRef.addEventListener(SecurityErrorEvent.SECURITY_ERROR, progressHandler);
			fileRef.addEventListener(HTTPStatusEvent.HTTP_STATUS, progressHandler);
			fileRef.addEventListener(IOErrorEvent.IO_ERROR, progressHandler);
			fileRef.addEventListener(Event.COMPLETE, completeHandler);

			var success:Boolean = fileRef.browse(allTypes);
			trace("success = "+success);
		}
		
		/**
		 * selectHandler
		 * 
		 * This function is called in response to the SELECT event; the user has selected a file to upload.
		 * The function uses the fileRef.upload() function to send the file to the waiting PHP script.
		 */
		private function selectHandler( event:Event ) : void
		{
			trace("Upload file: "+fileRef.name);
			var request:URLRequest = new URLRequest("phpscripts/uploadFile.php");
		    try
		    {
		        fileRef.upload(request);
		    }
		    catch (error:Error)
		    {
		        trace("Unable to upload file.");
		    }

		}
		
		/**
		 * progressHandler
		 * 
		 * This function's job is to dispatch a UPLOAD_BEGIN event when the upload begins. All
		 * other PROGRESS messages are ignored.
		 */
		private function progressHandler( event:Event ) : void
		{
			trace("Progress: "+event.type);
			if( event.type == Event.OPEN ) {
				dispatchEvent( new BlogEvent(BlogEvent.UPLOAD_BEGIN) );
			}
		}
		
		/**
		 * completeHandler
		 *
		 * This function is called when the file has been transferred. A UPLOAD_COMPELTE event
		 * is dispatched with the name of the uploaded file.
		 */
		private function completeHandler(event:Event):void
		{
		    trace(fileRef.name,"uploaded");
		    
		    var evt:BlogEvent = new BlogEvent(BlogEvent.UPLOAD_COMPLETE);
		    evt.uploadURL = "uploads/"+fileRef.name;
		    dispatchEvent(evt);
		}

	}
}
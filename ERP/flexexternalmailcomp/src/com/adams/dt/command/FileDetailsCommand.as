package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.FileDetailsEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.FileDetails;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.events.*;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.*;
	import mx.rpc.IResponder;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	public final class FileDetailsCommand extends AbstractCommand 
	{ 
		private var fileReference:FileReference;
    	private var type:String;
		private var obj:FileDetails;
		private var fileDetails:Object;
		private var fileDetailsEvent:FileDetailsEvent;
		private var fileCollection:ArrayCollection;
		private var filename:String;		
		private var evtype:String;
		
       	private var feventlocalvo:FileDetails;        	
		
		override public function execute( event : CairngormEvent ) : void
		{
			super.execute(event);
			fileDetailsEvent= FileDetailsEvent(event);
			this.delegate = DelegateLocator.getInstance().fileDetailsDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			this.evtype = event.type;
	       	switch(event.type){  
	       	   case FileDetailsEvent.EVENT_SELECT_FILEDETAILS:
	            	delegate.responder = new Callbacks(selectFiles,fault);
	            	delegate.findByIdName(model.currentProjects.projectId,"Message"); 
	           break;
	           case FileDetailsEvent.EVENT_GET_FILEDETAILS:
	            	delegate.responder = new Callbacks(getFileResult,fault);
	            	delegate.findByMailFileId(fileDetailsEvent.filedetailsVo.fileId);   
	           break;
	           case FileDetailsEvent.EVENT_SAVEAS_FILE:
	           		delegate = DelegateLocator.getInstance().fileUploadDelegate;
	            	delegate.responder = new Callbacks(downloadByteFile,fault);
	            	trace("\n FileDetailsCommand execute:"+fileDetailsEvent.filedetailsVo.filePath);
	            	delegate.doDownload(fileDetailsEvent.filedetailsVo.filePath);  
	           break;
	           case FileDetailsEvent.EVENT_UPLOAD_FILE:
	           		delegate = DelegateLocator.getInstance().fileUploadDelegate;
	            	delegate.responder = new Callbacks(uploadByteFile,fault);
	            	feventlocalvo = fileDetailsEvent.filedetailsVo;
	            	delegate.doUpload(fileDetailsEvent.storeByteArray,fileDetailsEvent.fileName,fileDetailsEvent.filePath);
	           	break;	
	           	case FileDetailsEvent.EVENT_MAILCREATE_FILEDETAILS:
	            	delegate.responder = new Callbacks(getFinalResult,fault);
	            	trace("InsertUploadFileCommand fileName :"+fileDetailsEvent.filedetailsVo.fileName+" , "+fileDetailsEvent.filedetailsVo.filePath+" , "+fileDetailsEvent.filedetailsVo.taskId+" , "+fileDetailsEvent.filedetailsVo.categoryFK+" , "+fileDetailsEvent.filedetailsVo.type+" , "+fileDetailsEvent.filedetailsVo.storedFileName+" , "+fileDetailsEvent.filedetailsVo.projectFK);  
            		delegate.create(FileDetails(fileDetailsEvent.filedetailsVo));   
	           	break; 
	           	case FileDetailsEvent.EVENT_SELECT_IMP_FILE:
	           		delegate.responder = new Callbacks(selectIMPFiles,fault);
	            	delegate.findByIdName(model.currentProjects.projectId,"Basic");
	           	break; 
	           	case FileDetailsEvent.EVENT_GET_IMPFILEDETAILS:
	            	delegate.responder = new Callbacks(getIMPFileResult,fault);
	            	delegate.findByMailFileId(fileDetailsEvent.filedetailsVo.fileId);   
	           	break;  
	           	case FileDetailsEvent.EVENT_IMPSAVEAS_FILE:
	           		delegate = DelegateLocator.getInstance().fileUploadDelegate;
	            	delegate.responder = new Callbacks(downloadByteIMPFile,fault);
	            	trace("\n FileDetailsCommand execute:"+fileDetailsEvent.impFileVo.filePath);
	            	delegate.doDownload(fileDetailsEvent.impFileVo.filePath);  
	           	break;
	                  		       	   
	           	default:
	            	break;  
	    	}
 		
		} 	
		public function selectIMPFiles(rpcEvent : Object):void{
			super.result(rpcEvent);
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			trace("selectIMPFiles :"+arrc.length);
			model.modelTileFileCollection = arrc;
						
		}	
		public function selectFiles(rpcEvent : Object):void{
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			trace("selectFiles :"+arrc.length);
			model.messageFileCollection = arrc;
			/* var sort:Sort = new Sort(); 
            sort.fields = [new SortField("taskId")];
            model.messageFileCollection.sort = sort; */
           // model.messageFileCollection.refresh(); 			
		}
		public function getIMPFileResult(rpcEvent : Object):void{
			model.modelFileDetailsVo = ArrayCollection(rpcEvent.result).getItemAt(0) as FileDetails;			
			model.modelLinkName = model.modelFileDetailsVo.fileName;
			
			var events:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SAVEAS_FILE);
			events.filedetailsVo = new FileDetails();
			events.filedetailsVo.filePath = model.modelFileDetailsVo.filePath;
			var handler:IResponder = new Callbacks(result,fault)
 			var fSeq:SequenceGenerator = new SequenceGenerator([events],handler)
  			fSeq.dispatch();
			
		} 
		public function downloadByteIMPFile(rpcEvent : Object):void{	
			if(rpcEvent.result!=null)
			{
				model.modelIMPByteArrray = rpcEvent.result as ByteArray;
				trace("downloadByteIMPFile :"+model.modelIMPByteArrray.toString());	
				//model.mainClass.fileView.saveimpid.dispatchEvent( new MouseEvent( MouseEvent.CLICK ) );		
					
			}
			else
			{
				Alert.show("Server side File not found");
			}
		}
		
		public function getFileResult(rpcEvent : Object):void{			
			//var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			//model.modelFileDetailsVo = rpcEvent.message.body as FileDetails;
			//Alert.show("SelectFilesCommand body :"+model.modelFileDetailsVo.fileName+" , "+model.modelFileDetailsVo.fileId);
			
			//var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			//model.modelFileCollection = arrc; 

			model.modelFileDetailsVo = ArrayCollection(rpcEvent.result).getItemAt(0) as FileDetails;			
			model.modelLinkName = model.modelFileDetailsVo.fileName;
			
			var events:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_SAVEAS_FILE);
			events.filedetailsVo = new FileDetails();
			events.filedetailsVo.filePath = model.modelFileDetailsVo.filePath;
			var handler:IResponder = new Callbacks(result,fault)
 			var fSeq:SequenceGenerator = new SequenceGenerator([events],handler)
  			fSeq.dispatch();
			
		} 
		public function downloadByteFile(rpcEvent : Object):void{	
			if(rpcEvent.result!=null)
			{
				model.modelByteArrray = rpcEvent.result as ByteArray;					
				//model.mainClass.saveid.dispatchEvent( new MouseEvent( MouseEvent.CLICK ) );
				//trace("FileDetailsCommand downloadByteFile:"+model.modelByteArrray);
			}
			else
			{
				Alert.show("Server side File not found");
			}
		}
		public function uploadByteFile(rpcEvent : Object):void{		
			var returnstr:String = rpcEvent.result;	
			if(returnstr == "success")  //success  
			{
				var fileEvent:FileDetailsEvent = new FileDetailsEvent(FileDetailsEvent.EVENT_MAILCREATE_FILEDETAILS);
				fileEvent.filedetailsVo = feventlocalvo;
	 			var handler:IResponder = new Callbacks(result,fault)
	 			var fSeq:SequenceGenerator = new SequenceGenerator([fileEvent],handler)
	  			fSeq.dispatch();
			}
			else  //failure
			{
				Alert.show("File not upload");
			}
		}
		public function getFinalResult( rpcEvent : Object ) : void {
			//Alert.show("InsertUploadFileCommand result ");			
			//var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			 model.expiryState = "sentState";	
		} 
		
	}
}

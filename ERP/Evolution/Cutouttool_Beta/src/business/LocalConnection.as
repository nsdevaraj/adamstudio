// ActionScript file
import events.FileDropEvent;

import mx.controls.Alert;
import mx.core.Application;

			public var storeFileArray:Array;					
			
            public function initiate():void{
            	storeFileArray = new Array();
            	Application.application.addEventListener(FileDropEvent.FILEDROPED,lcHandler);	
            }
            public function removeListener():void{
            	Application.application.removeEventListener(FileDropEvent.FILEDROPED,lcHandler);
            	Application.application.removeEventListener(FileDropEvent.FILEUPLOADED,getCompletedFile);

            }
            public function lcHandler(event:FileDropEvent):void 
            {
            	var returnString:String = event.filePath;
			 	var arrayStr:Array = returnString.split("**");
                for (var i:Number = 0; i <arrayStr.length; i++) 
				{
					displayFiles(arrayStr[i].toString());
				}
				Application.application.addEventListener(FileDropEvent.FILEUPLOADED,getCompletedFile);

			}
		public var tempUploadCompletedFile:Array = new Array();
			public function getCompletedFile(event:FileDropEvent):void{			
				var returnString:String = event.filePath;
				
				var splitArr:Array = returnString.split("::");
				if(splitArr[1]=="Done" && tempUploadCompletedFile.indexOf(splitArr[0]) == -1){
						tempUploadCompletedFile.push(splitArr[0]);
						fileUpload_client.DndUploadCompletedArray = tempUploadCompletedFile; 
				}
				
			}
			//C:\Documents and Settings\Administrator\Desktop\download.php:::5KB:*:uploadsTemp
			public function displayFiles(_filename:String):void 
            {
            	_filename = (unescape(_filename));
			 	_filename = _filename.replace('://',':\\');
			 	_filename = _filename.replace('\\','\\');
			 	_filename = _filename.replace('\/','\\');
			 	_filename = _filename.replace('(','(');
			 	_filename = _filename.replace(')',')');			 	
			 	
                if(_filename.indexOf(":::")!=-1)
				{
					var fileName:String = _filename.substring(0,_filename.indexOf(":::"));  
					var tempFile:String = _filename.substring(_filename.lastIndexOf(":*:")+3);
														
					var _filesizeTemp:String = _filename.substring(_filename.lastIndexOf(":::")+3);
					var _filesize:String = _filesizeTemp.substring(0,_filesizeTemp.lastIndexOf(":*:"));
										 				
					var fileExtension:String = fileName.substring(fileName.length,fileName.lastIndexOf("\\")+1); 	
					var fileExtension1:String = fileName.substring(fileName.length,fileName.lastIndexOf("//")); 
					var fileExtension2:String = fileName.substring(fileName.length,fileName.lastIndexOf("/")); 	
					
				}
							
				var bool:Boolean = true;
				
				for (var i:Number = 0; i <fileUpload_client._arrUploadFiles.length; i++) 
				{		
					//if(fileuploadId._arrUploadFiles[i].name==fileExtension) 
					if(new String(fileUpload_client._arrUploadFiles[i].name)==fileExtension)
					{
						bool = false;
						break;
					}
											
				} 
				
				if(bool)
				{
					fileUpload_client._arrUploadFiles.push({name:fileExtension,size:_filesize,file:fileName,source:tempFile});	
					fileUpload_client.listFiles.dataProvider = fileUpload_client._arrUploadFiles;
					fileUpload_client.listFiles.selectedIndex = fileUpload_client._arrUploadFiles.length - 1; 
					fileUpload_client.uploadCheck();
				}
				else
				{
					Alert.show("The file(s): \n\n• " + fileExtension+"\n "+ "\n...are already on the upload list. Please change the filename(s) or pick a different file.", "File(s) already on list");
				}		
            } 
			
			
/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.control
{
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.model.vo.*;
	import com.adams.dt.signal.ControlSignal;
	import com.adams.dt.util.ProcessUtil;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.mediators.MainViewMediator;
	import com.adams.swizdao.dao.PagingDAO;
	import com.adams.swizdao.model.vo.CurrentInstance;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.response.SignalSequence;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.FileNameSplitter;
	import com.adams.swizdao.views.mediators.IViewMediator;
	
	import mx.collections.ArrayCollection;
	
	public class FilesCommand
	{
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var signalSequence:SignalSequence; 
		
		[Inject]
		public var pagingDAO:PagingDAO;  
		
		[Inject("filedetailsDAO")]
		public var fileDAO:AbstractDAO;  
		 
		/**
		 * Whenever an UpdateFileSignal is dispatched.
		 * MediateSignal initates this updatefileAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='updateFileSignal')]
		public function updatefileAction(obj:IViewMediator,file:FileDetails):void {
			var signal:SignalVO = new SignalVO( obj, fileDAO, Action.UPDATE );
			signal.valueObject = file;
			signalSequence.addSignal( signal );
		}
		
		/**
		 * Whenever an GetProjectFilesSignal is dispatched.
		 * MediateSignal initates this getprojectfilesAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getProjectFilesSignal')]
		public function getprojectfilesAction( obj:IViewMediator, projectId:int ):void {
			var signal:SignalVO = new SignalVO( obj, fileDAO, Action.FIND_ID );
			signal.id = projectId;
			signalSequence.addSignal( signal );
		}
		
		/**
		 * Whenever an ConvertFilesSignal is dispatched.
		 * MediateSignal initates this convertfilesAction to perform control Actions
		 * The invoke functions to perform control functions
		 * Linux OS-->serverpath with .pdf location
		 * Windows OS --> serverpath not pdf extention
		 */
		[ControlSignal(type='convertFilesSignal')]
		public function convertfilesAction(obj:IViewMediator,filePathColl:ArrayCollection):void {
			for(var i:int =0; i<filePathColl.length; i++){
				var file:FileDetails = filePathColl.getItemAt(i) as FileDetails;
				var signal:SignalVO = new SignalVO(obj,pagingDAO,Action.FILECONVERT);
				var path:String =  file.filePath;
				if(currentInstance.mapConfig.serverOSWindows){
					var fileObj:Object = FileNameSplitter.splitFileName( file.filePath );
					path=fileObj.filename;
				}				
				signal.name =path; 
				signal.emailBody = currentInstance.config.pdfServerDir; //pdfServerDir -->C:\\temp\\pdf2swf.bat or /home/brennus/pdfswftools/pdf2swf-multipage.sh
				signal.valueObject = file;
				signal.startIndex = i;
				signal.id = filePathColl.length-1;
				signalSequence.addSignal(signal);
			}
		}
		
		/**
		 * Whenever an DownloadFileSignal is dispatched.
		 * MediateSignal initates this downloadfileAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='downloadFileSignal')]
		public function downloadfileAction(obj:IViewMediator,filePath:String,fileId:int,fileRelease:int):void {
			var signal:SignalVO = new SignalVO( obj, pagingDAO, Action.FILEDOWNLOAD );
			signal.id = fileId; //File ID
			signal.emailBody = filePath;
			signal.startIndex = fileRelease; // Release Version No.
			signalSequence.addSignal( signal ); 
		}
		
		/**
		 * Whenever an MoveFilesSignal is dispatched.
		 * MediateSignal initates this movefilesAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='moveFilesSignal')]
		public function movefilesAction(obj:IViewMediator,fileCollection:ArrayCollection,toPath:String):void {
			for each(var file:FileDetails in fileCollection){
				var signal:SignalVO = new SignalVO( obj, pagingDAO, Action.FILEMOVE );
				//from location
				signal.name = currentInstance.config.FileServer+Utils.fileSplitter+file.fileName
				//to location
				signal.emailBody = toPath+file.type+Utils.fileSplitter+file.storedFileName;
				signalSequence.addSignal( signal ); 
			}
		}
		
		/**
		 * Whenever an BulkUpdateFilesSignal is dispatched.
		 * MediateSignal initates this bulkupdatefilesAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='bulkUpdateFilesSignal')]
		public function bulkupdatefilesAction(obj:IViewMediator,fileCollection:ArrayCollection):void {
			var signal:SignalVO = new SignalVO( obj, fileDAO, Action.BULK_UPDATE );
			signal.list = fileCollection;
			signalSequence.addSignal( signal );
			
			var eventLog:Events = new Events();
			var filesLogArr:Array =[];
			for each(var file:FileDetails in fileCollection){
				eventLog.projectFk = file.projectFK;
				filesLogArr.push(file.fileId+'$'+file.fileName);
			}
			eventLog.eventType = EventStatus.FILEUPLOADED;
			eventLog.details = ProcessUtil.convertToByteArray(filesLogArr.join('$$'));
			controlSignal.createEventLogSignal.dispatch(null,eventLog);
		}
	}
}
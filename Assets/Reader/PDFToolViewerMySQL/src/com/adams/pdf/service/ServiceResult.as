/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  PDFTool

@internal 

*/
package com.adams.pdf.service
{
	import com.adams.pdf.model.AbstractDAO;
	import com.adams.pdf.model.vo.FileDetails;
	import com.adams.pdf.signal.ControlSignal;
	import com.adams.pdf.util.ProcessUtil;
	import com.adams.pdf.util.Utils;
	import com.adams.pdf.view.mediators.MainViewMediator;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.response.AbstractResult;
	import com.adams.swizdao.signals.AbstractSignal;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.ArrayUtil;
	import com.adams.swizdao.util.FileNameSplitter;
	import com.adams.swizdao.util.StringUtils;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;
	
	public class ServiceResult extends AbstractResult
	{ 		
		[Inject("personsDAO")]
		public var personDAO:AbstractDAO;
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		private var swfArrc: ArrayCollection;
		private var firstMiscelleneous:String = null;
				
		public function ServiceResult()
		{
			super();
		}
		override protected function resultHandler( rpcevt:ResultEvent, prevSignal:AbstractSignal = null ):void {
			super.resultHandler(rpcevt,prevSignal);
			serviceResultHandler(  resultObj, prevSignal.currentSignal );
			resultSignal.dispatch( resultObj, prevSignal.currentSignal );
			// on push
			if(prevSignal.currentSignal.action == Action.FINDPUSH_ID){  
				pushRefreshSignal.dispatch( prevSignal.currentSignal );
			}
			signalSeq.onSignalDone();
		} 
		protected function serviceResultHandler( obj:Object,signal:SignalVO ):void {  
			switch(signal.destination){
				case Utils.PERSONSKEY:
					switch(signal.action){
						case Action.GET_LIST:
							currentInstance.mapConfig.currentPerson = personDAO.collection.findExistingPropItem(currentInstance.mapConfig.currentPerson,'personLogin');
							//controlSignal.changeStateSignal.dispatch( Utils.PDFTOOL_INDEX );
							if(!currentInstance.mapConfig.isFileIdAvalable){ // false - upload / true - pdffileviewer
								controlSignal.changeStateSignal.dispatch( Utils.UPLOAD_INDEX );
							}else{							
								firstFileCollection();
							}
							break;
						default:
							break;
					}
				case ArrayUtil.PAGINGDAO:
					switch(signal.action ) {
						case  Action.FILECONVERT:
							var fileDetails:FileDetails = signal.valueObject as FileDetails;
							if(signal.startIndex == 0) swfArrc = new ArrayCollection();
							var returnStr:String = obj as String;
							if( returnStr.indexOf( 'OK:' ) != -1 ) {
								var lastind:int = 1;
								if(currentInstance.mapConfig.serverOSWindows) lastind = 2;
								var charspl:int;
								var findIndex:int = returnStr.indexOf( 'OK:' );
								( !currentInstance.mapConfig.serverOSWindows) ?  ( charspl = ( 4 + findIndex ) ) : ( charspl = ( 5 + findIndex ) ); 
								
								var convertedSwf:String = returnStr.substring( charspl, ( returnStr.length - lastind ) );
								( !currentInstance.mapConfig.serverOSWindows) ?  ( convertedSwf += ', ' ) : ( convertedSwf );
								
								var convertedSwfArr:Array = convertedSwf.split( "," );
								if( convertedSwfArr.length == 1 ) {
									controlSignal.showAlertSignal.dispatch(null,Utils.PDFCONVERSIONFAILED,Utils.APPTITLE,1,null)
								}  
								for( var i:int = 0; i < ( convertedSwfArr.length - 1 ); i++ ) {
									var fileObject:FileDetails = new FileDetails();
									fileObject.fileId = NaN;
									fileObject.fileName = ProcessUtil.getFileName( convertedSwfArr[ i ] );
									fileObject.storedFileName = fileObject.fileName;
									fileObject.taskId = fileDetails.taskId;
									fileObject.categoryFK = 0;
									fileObject.fileCategory = fileDetails.fileCategory;
									fileObject.fileDate = new Date();
									fileObject.visible = false;
									fileObject.downloadPath = fileDetails.downloadPath;
									fileObject.projectFK = fileDetails.projectFK;
									fileObject.filePath = StringUtils.trimSpace( convertedSwfArr[ i ] ); //fileDetails.destinationpath+"/"+fileDetails.type+"/"+fileObject.storedFileName;
									fileObject.type = fileDetails.type;
									fileObject.miscelleneous = fileDetails.miscelleneous;
									 
									
									fileObject.page = i+1;
									swfArrc.addItem( fileObject );
									
									var thumbDetail:FileDetails = new FileDetails();
									var filePath:String = fileObject.filePath.split( fileObject.type )[ 0 ];
									thumbDetail.type = fileObject.type;
									thumbDetail.fileName = FileNameSplitter.splitFileName( fileObject.storedFileName ).filename + "_thumb.swf";
									thumbDetail.filePath = filePath + fileObject.type + '/' + thumbDetail.fileName;
								} 
							}
							else {
								controlSignal.showAlertSignal.dispatch(null,Utils.PDFCONVERSIONFAILED,Utils.APPTITLE,1,null)
							}
							if( signal.startIndex == signal.id ) {
								controlSignal.bulkUpdateFilesSignal.dispatch( null, swfArrc );
									controlSignal.progressStateSignal.dispatch(Utils.PROGRESS_OFF); 
									mainViewMediator.view.upload.view.filedetail.text = "PDF FileId :"+fileDetails.fileId
							}
							break;
					}
				case Utils.FILEDETAILSKEY:
					switch(signal.action){
						case  Action.BULK_UPDATE: 
							var pdfFileAC : ArrayCollection = new ArrayCollection();
							for each(var pdfFile:FileDetails in signal.currentProcessedCollection){
								var splitObject:Object = FileNameSplitter.splitFileName( pdfFile.fileName );			
								if(splitObject.extension  == 'pdf')	pdfFileAC.addItem(pdfFile);
							}	
							if(pdfFileAC.length>0){	
								controlSignal.convertFilesSignal.dispatch(null,pdfFileAC);
							}							
							break; 
						default:
							break;
					}					
			}
			if(signal.destination == Utils.FILEDETAILSKEY && signal.action == Action.FIND_ID){
				var firstFilePDFCollection:ArrayCollection = (obj as ArrayCollection);
				if(firstFilePDFCollection){
					if(firstFilePDFCollection.length!=0){
						var fileDetails1:FileDetails = firstFilePDFCollection.getItemAt(0) as FileDetails;
						var firstMiscelleneous:String = fileDetails1.miscelleneous;
						controlSignal.getFileMiscelleneousSignal.dispatch(null,firstMiscelleneous, signal.emailBody );
					}else{
						controlSignal.showAlertSignal.dispatch(null,Utils.FILEID_WRONG,Utils.APPTITLE,1,null);
					}
				}else{
					controlSignal.showAlertSignal.dispatch(null,Utils.FILEID_WRONG,Utils.APPTITLE,1,null);
				}
			}
			if(signal.destination == Utils.FILEDETAILSKEY && signal.action == Action.FINDBY_NAME){
				var fileSWFCollection:ArrayCollection = (obj as ArrayCollection);
				var flag:Boolean = false;
				if(fileSWFCollection){
					if(fileSWFCollection.length!=0){	
						if(signal.emailBody == 'FIRST'){	
							currentInstance.mapConfig.firstCollection = (obj as ArrayCollection);
							if(currentInstance.mapConfig.secondFileID!= -1){
								controlSignal.getProjectFilesSignal.dispatch(null, currentInstance.mapConfig.secondFileID,"SECOND");
							}else
							{
								flag = true;
							}
						}else if(signal.emailBody == 'SECOND'){	
							currentInstance.mapConfig.secondCollection = (obj as ArrayCollection);
							flag = true; 
						}
					}
				}
				if(flag || (fileSWFCollection.length == 0)){
					controlSignal.changeStateSignal.dispatch( Utils.PDFTOOL_INDEX );
				}
			}		
		}
		protected function firstFileCollection():void {  
			if(currentInstance.mapConfig.firstFileID!= -1){
				controlSignal.getProjectFilesSignal.dispatch(null, currentInstance.mapConfig.firstFileID,"FIRST");
			}else{
				controlSignal.showAlertSignal.dispatch(null,Utils.FILEID_WRONG,Utils.APPTITLE,1,null);
				controlSignal.changeStateSignal.dispatch( Utils.PDFTOOL_INDEX );	
			}
		}		
	}
}
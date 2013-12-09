/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  PDFTool

@internal 

*/
package com.adams.pdf.control
{
	import com.adams.pdf.model.AbstractDAO;
	import com.adams.pdf.model.vo.*;
	import com.adams.pdf.signal.ControlSignal;
	import com.adams.pdf.util.Utils;
	import com.adams.pdf.view.mediators.MainViewMediator;
	import com.adams.swizdao.dao.PagingDAO;
	import com.adams.swizdao.model.vo.CurrentInstance;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.response.SignalSequence;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.FileNameSplitter;
	import com.adams.swizdao.views.mediators.IViewMediator;
	
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	
	public class SignalsCommand
	{
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var signalSequence:SignalSequence;
		
		[Inject("personsDAO")]
		public var personDAO:AbstractDAO;
		
		[Inject]
		public var pagingDAO:PagingDAO;  
		
		[Inject("commentvoDAO")]
		public var commentDAO:AbstractDAO;
		
		[Inject("filedetailsDAO")]
		public var fileDAO:AbstractDAO; 
		
		private var view:Object;
		
		private var alertView:IViewMediator;
		private var alertResponder:Object;
		// todo: add listener
		
		/**
		 * Whenever an showAlertSignal is dispatched.
		 * MediateSignal initates this showAlertAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='showAlertSignal')]
		public function showAlertAction( obj:IViewMediator, text:String, title:String, type:int, responder:Object ):void {
			alertView = obj;
			alertResponder = responder;
			mainViewMediator.showAlert( text, title ,type);
		}
		
		/**
		 * Whenever an ProgressStateSignal is dispatched.
		 * MediateSignal initates this progressStateAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='progressStateSignal')]
		public function progressStateAction( state:String ):void {
			mainViewMediator.progressToggler = state;
		}
		
		/**
		 * Whenever an hideAlertSignal is dispatched.
		 * MediateSignal initates this hideAlertAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='hideAlertSignal')]
		public function hideAlertAction( state:uint ):void {
			if( state == Utils.ALERT_YES|| state == Utils.ALERT_OK ) {
				alertView.alertReceiveHandler( alertResponder );
			}
			alertView = null;
			alertResponder = null;
		}
		/**
		 * Whenever an ChangeStateSignal is dispatched.
		 * MediateSignal initates this changestateAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='changeStateSignal')]
		public function changestateAction(state:String):void {
			Object(mainViewMediator.view).currentState = state;
		}
		
		
		/**
		 * Whenever an DownloadFileSignal is dispatched.
		 * MediateSignal initates this downloadfileAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='downloadFileSignal')]
		public function downloadfileAction(obj:IViewMediator,filePath:String,fileId:int):void {
			var signal:SignalVO = new SignalVO( obj, pagingDAO, Action.FILEDOWNLOAD );
			signal.id = fileId; //File ID
			signal.emailBody = filePath;
			signalSequence.addSignal( signal ); 
		}
		
		/**
		 * Whenever an GetPDFCommentsSignal is dispatched.
		 * MediateSignal initates this getpdfcommentsAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getPDFCommentsSignal')]
		public function getpdfcommentsAction(obj:IViewMediator,fileId:int):void {
			//var signal:SignalVO = new SignalVO( obj, commentDAO, Action.FINDBY_ID); //READ
			var signal:SignalVO = new SignalVO( obj, commentDAO, Action.READ);
			signal.id = fileId;
			signalSequence.addSignal( signal );
		}
		
		/**
		 * Whenever an CreateCommentSignal is dispatched.
		 * MediateSignal initates this createcommentAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='createCommentSignal')]
		public function createcommentAction( obj:IViewMediator, note:CommentVO ):void {
			var signal:SignalVO = new SignalVO( obj, commentDAO, Action.CREATE );
			note.commentDescriptionBlob = note.commentDescription;
			
			note.misc = 'dddd';
			note.history = 0;
			note.commentStatus = 'dddd';
				
			signal.valueObject = note;
			signalSequence.addSignal( signal );
		}
		
		/**
		 * Whenever an updateCommentSignal is dispatched.
		 * MediateSignal initates this createcommentAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='updateCommentSignal')]
		public function updateCommentAction(obj:IViewMediator,note:CommentVO):void {
			var signal:SignalVO = new SignalVO(obj,commentDAO,Action.DIRECTUPDATE);
			signal.valueObject = note;
			signalSequence.addSignal(signal);
		}
		
		/**
		 * Whenever an DeleteCommentSignal is dispatched.
		 * MediateSignal initates this deletecommentAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='deleteCommentSignal')]
		public function deletecommentAction(obj:IViewMediator,note:CommentVO):void {
			var signal:SignalVO = new SignalVO(obj,commentDAO,Action.DELETE);
			signal.valueObject = note;
			signalSequence.addSignal(signal);
		} 
		
		/**
		 * Whenever an GetProjectFilesSignal is dispatched.
		 * MediateSignal initates this getprojectfilesAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getProjectFilesSignal')]
		public function getprojectfilesAction( obj:IViewMediator, projectId:int, checkFile:String ):void {
			var signal:SignalVO = new SignalVO( obj, fileDAO, Action.FIND_ID );
			signal.id = projectId;
			signal.emailBody = checkFile;
			signalSequence.addSignal( signal );
		}
		/**
		 * Whenever an LoginSignal is dispatched.
		 * MediateSignal initates this loginAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='loginSignal')]
		public function loginAction( obj:Object, username:String, password:String ):void {
			view = obj;
			personDAO.controlService.authCS.loginAttempt.add( checkLogin ); 
			personDAO.controlService.authCS.login( username, password );
			currentInstance.mapConfig.currentPerson = new Persons();
			currentInstance.mapConfig.currentPerson.personLogin = username;
			currentInstance.mapConfig.currentPerson.personPassword = password;
		}
		
		/**
		 * Whenever an GetPersonsSignal is dispatched.
		 * MediateSignal initates this getpersonsAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getPersonsSignal')]
		public function getpersonsAction(obj:IViewMediator):void {
			var signal:SignalVO = new SignalVO(obj,personDAO,Action.GET_LIST);
			signalSequence.addSignal(signal);
		}
		
		/**
		 * Whenever an getFileMiscelleneousSignal is dispatched.
		 * MediateSignal initates this getFileMiscelleneousAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getFileMiscelleneousSignal')]
		public function getFileMiscelleneousAction(obj:IViewMediator,miscelleneous:String, checkFile:String):void {
			var signal:SignalVO = new SignalVO(obj,fileDAO,Action.FINDBY_NAME);
			signal.name = miscelleneous;
			signal.emailBody = checkFile;
			signalSequence.addSignal(signal);
		}
		
		
		
		/**
		 * The handler to check the userlogin credentials
		 */
		protected function checkLogin( event:Object = null ):void {
			if( personDAO.controlService.authCS.authenticated ) {
				controlSignal.getPersonsSignal.dispatch( view );
				personDAO.controlService.authCS.loginAttempt.removeAll();
			}
			else {
				setTimeout( wrongCredentials, 1000 ); 
			}
		}
		
		protected function wrongCredentials():void {
			if( personDAO.controlService.authCS.loginAttempt.numListeners != 0 ) {
				view.wrongCredentialsAlert();
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
					path = fileObj.filename;
				}				
				signal.name = path; 
				signal.emailBody = currentInstance.config.pdfServerDir; //pdfServerDir -->C:\\temp\\pdf2swf.bat or /home/brennus/pdfswftools/pdf2swf-multipage.sh
				signal.valueObject = file;
				signal.startIndex = i;
				signal.id = filePathColl.length-1;
				
				signalSequence.addSignal(signal);
			}
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
		
	}
}
/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  PDFTool

@internal 

*/
package com.adams.pdf.signal
{
	import com.adams.pdf.model.vo.*;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.views.mediators.IViewMediator;
	
	import mx.collections.ArrayCollection;
	import org.osflash.signals.Signal;
	import com.adams.pdf.model.vo.*;
	public class ControlSignal
	{
		// add Signal 
		public var changeStateSignal:Signal = new Signal(String);
		public var hideAlertSignal:Signal = new Signal( uint );
		public var progressStateSignal:Signal = new Signal( String );
		public var showAlertSignal:Signal = new Signal( IViewMediator, String, String, int,Object );
		
		public var getProjectFilesSignal:Signal = new Signal( IViewMediator, int, String );
		public var downloadFileSignal:Signal = new Signal( IViewMediator, String, int);
		public var getPDFCommentsSignal:Signal = new Signal( IViewMediator, int );
		public var createCommentSignal:Signal = new Signal( IViewMediator, CommentVO );
		public var updateCommentSignal:Signal = new Signal( IViewMediator, CommentVO );
		public var deleteCommentSignal:Signal = new Signal( IViewMediator, CommentVO );
		
		public var logoutSignal:Signal = new Signal( IViewMediator );
		public var loginSignal:Signal = new Signal( IViewMediator, String, String );
		public var getPersonsSignal:Signal = new Signal(IViewMediator); 
		public var bulkUpdateFilesSignal:Signal = new Signal(IViewMediator,ArrayCollection);
		public var modifyPDFContextSignal:Signal = new Signal();
		public var convertFilesSignal:Signal= new Signal(IViewMediator,ArrayCollection);
		public var getFileMiscelleneousSignal:Signal= new Signal(IViewMediator, String, String); 
		public var moveFilesSignal:Signal= new Signal(IViewMediator,ArrayCollection,String);
	}
}
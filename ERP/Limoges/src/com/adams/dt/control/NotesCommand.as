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
	import com.adams.dt.view.mediators.MainViewMediator;
	import com.adams.swizdao.model.vo.CurrentInstance;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.response.SignalSequence;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.views.mediators.IViewMediator;

	public class NotesCommand
	{
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var signalSequence:SignalSequence; 
		
		[Inject("commentvoDAO")]
		public var commentDAO:AbstractDAO;
		
		[Inject("eventsDAO")]
		public var eventsDAO:AbstractDAO;
		// todo: add listener
		
		/**
		 * Whenever an GetPDFCommentsSignal is dispatched.
		 * MediateSignal initates this getpdfcommentsAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getPDFCommentsSignal')]
		public function getpdfcommentsAction(obj:IViewMediator,fileId:int):void {
			var signal:SignalVO = new SignalVO( obj, commentDAO, Action.FINDBY_ID);
			signal.id = fileId;
			signalSequence.addSignal( signal );
		}
		
		/**
		 * Whenever an CreateEventLogSignal is dispatched.
		 * MediateSignal initates this createeventlogAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='createEventLogSignal')]
		public function createeventlogAction( obj:IViewMediator, eventLog:Events ):void {
			var signal:SignalVO = new SignalVO( obj, eventsDAO, Action.CREATE );
			eventLog.personFk = currentInstance.mapConfig.currentPerson.personId;
			var currentTime:Date = new Date();
			var frenchTime:Date = new Date();
			if(ProcessUtil.isIndia)frenchTime = new Date( frenchTime.time - ProcessUtil.timeDiff);
			eventLog.eventDateStart = frenchTime;
			signal.valueObject = eventLog;
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
         * Whenever an GetProjectCommentsSignal is dispatched.
         * MediateSignal initates this getprojectcommentsAction to perform control Actions
         * The invoke functions to perform control functions
         */
        [ControlSignal(type='getProjectCommentsSignal')]
        public function getprojectcommentsAction( obj:IViewMediator, projId:int ):void {
			var signal:SignalVO = new SignalVO( obj, commentDAO, Action.FIND_ID );
			signal.id = projId;
			signalSequence.addSignal( signal );
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
    }
}
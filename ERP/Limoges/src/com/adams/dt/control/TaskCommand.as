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
	import com.adams.swizdao.dao.PagingDAO;
	import com.adams.swizdao.model.vo.CurrentInstance;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.response.SignalSequence;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.views.mediators.IViewMediator;

	public class TaskCommand
	{
		
		[Inject]
		public var controlSignal:ControlSignal; 
		
		[Inject]
		public var signalSequence:SignalSequence;
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		 
		
		[Inject("tasksDAO")]
		public var taskDAO:AbstractDAO;
		
		[Inject]
		public var paging:PagingDAO;  
		// todo: add listener 
		/**
		 * Whenever an SendEmailSignal is dispatched.
		 * MediateSignal initates this sendemailAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='sendEmailSignal')]
		public function sendemailAction(obj:IViewMediator,emailId:String, name:String, emailBody:String):void {
			var signal:SignalVO = new SignalVO( obj, paging, Action.SENDMAIL );
			signal.emailId = emailId;
			signal.name = name;
			signal.emailBody = emailBody;
			signalSequence.addSignal( signal );
		}

		/**
		 * Whenever an CreateTaskSignal is dispatched.
		 * MediateSignal initates this createtaskAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='createTaskSignal')]
		public function createtaskAction(obj:IViewMediator,task:Tasks,purpose:String):void {
			var signal:SignalVO = new SignalVO(obj,taskDAO,Action.CREATE);
			signal.valueObject = task;
			signal.emailBody = purpose;
			signalSequence.addSignal(signal);
		}
		
		/**
		 * Whenever an CreateTaskSignal is dispatched.
		 * MediateSignal initates this createtaskAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='updateTaskSignal')]
		public function updatetaskAction( obj:IViewMediator, task:Tasks ):void {
			var signal:SignalVO = new SignalVO( obj, taskDAO, Action.UPDATE );
			signal.valueObject = task;
			signalSequence.addSignal( signal );
		}
		
		/**
		 * Whenever an CreateNavigationTaskSignal is dispatched.
		 * MediateSignal initates this createnavigationtaskAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='createNavigationTaskSignal')]
		public function createnavigationtaskAction(obj:IViewMediator,previousTaskId:int,workflowFK:int,workflowTemplateId:int,projectFk:int,personFk:int,taskCode:String,currentTaskComment:String,projProperties:String):void {
			var objArray:Array =[];
			objArray.push(previousTaskId);
			objArray.push(workflowFK);
			objArray.push(workflowTemplateId);
			objArray.push(projectFk);
			objArray.push(personFk);
			objArray.push(taskCode);
			objArray.push(currentTaskComment); 
			
			var signal:SignalVO = new SignalVO(obj,paging,Action.CREATENAVTASK);
			signal.receivers = objArray;
			signal.emailBody = projProperties;
			signalSequence.addSignal(signal);
		}
		
		/**
		 * Whenever an GetTodoTasksSignal is dispatched.
		 * MediateSignal initates this gettodotasksAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getTodoTasksSignal')]
		public function gettodotasksAction(obj:IViewMediator,personId:int):void {
			var signal:SignalVO = new SignalVO(obj,taskDAO,Action.FIND_ID);
			signal.id = personId;
			signalSequence.addSignal(signal);
		}
	}
}
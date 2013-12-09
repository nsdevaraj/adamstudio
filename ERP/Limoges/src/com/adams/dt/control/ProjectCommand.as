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
	import com.adams.swizdao.dao.PagingDAO;
	import com.adams.swizdao.model.vo.CurrentInstance;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.response.SignalSequence;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.views.mediators.IViewMediator;

	public class ProjectCommand
	{
		
		[Inject]
		public var controlSignal:ControlSignal; 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var signalSequence:SignalSequence; 
		
		[Inject]
		public var paging:PagingDAO;  
		
		[Inject("eventsDAO")]
		public var eventsDAO:AbstractDAO;  
		
		[Inject("filedetailsDAO")]
		public var filedetailsDAO:AbstractDAO;  
		
		[Inject("commentvoDAO")]
		public var commentvoDAO:AbstractDAO;  
		
		[Inject("phasesDAO")]
		public var phasesDAO:AbstractDAO;  
		
		[Inject("propertiespjDAO")]
		public var propertiespjDAO:AbstractDAO;  
		
		[Inject("teamlinesDAO")]
		public var teamlinesDAO:AbstractDAO;  
		 
		[Inject("tasksDAO")]
		public var tasksDAO:AbstractDAO;  
		
		[Inject("projectsDAO")]
		public var projectDAO:AbstractDAO;
		// todo: add listener
		
		/**
		 * Whenever an GetModifiedProjectsSignal is dispatched.
		 * MediateSignal initates this getmodifiedprojectsAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getModifiedProjectsSignal')]
		public function getmodifiedprojectsAction(obj:IViewMediator,lastAccessed:String, personId:int):void {
			var signal:SignalVO = new SignalVO( obj, paging, Action.REFRESHQUERY );
			signal.id = personId;
			signal.emailBody = lastAccessed;
			signalSequence.addSignal( signal );
		}
		
		/**
		 * Whenever an GetProjectEventsSignal is dispatched.
		 * MediateSignal initates this getprojecteventsAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getProjectEventsSignal')]
		public function getprojecteventsAction( obj:IViewMediator, projId:int ):void {
			var signal:SignalVO = new SignalVO( obj, eventsDAO, Action.FINDTASKSLIST );
			signal.id = projId;
			signalSequence.addSignal( signal ); 
		}
		
		/**
		 * Whenever an ModifyProjectStatusSignal is dispatched.
		 * MediateSignal initates this modifyprojectstatusAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='modifyProjectStatusSignal')]
		public function modifyprojectstatusAction(obj:IViewMediator,objArray:Array ):void {
			var signal:SignalVO = new SignalVO(obj,paging,Action.STAND_RESUMEPROJECT);
			signal.receivers = objArray;
			signalSequence.addSignal(signal); 
		}
		
		/**
		 * Whenever an UpdateProjectSignal is dispatched.
		 * MediateSignal initates this updateprojectAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='updateProjectSignal')]
		public function updateprojectAction( obj:IViewMediator, proj:Projects ):void {
			var signal:SignalVO = new SignalVO( obj, projectDAO, Action.UPDATE );
			signal.valueObject = proj;
			if(proj.finalTask)signal.description = proj.finalTask;
			signalSequence.addSignal( signal );
			
			var eventLog:Events = new Events();
			eventLog.eventType = EventStatus.PROJECTINPROGRESS;
			eventLog.projectFk = proj.projectId;
			eventLog.details = ProcessUtil.convertToByteArray( proj.projectStatusFK.toString() );
			controlSignal.createEventLogSignal.dispatch( obj, eventLog );
		}

		/**
		 * Whenever an GetProjectTasksSignal is dispatched.
		 * MediateSignal initates this getprojecttasksAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getProjectTasksSignal')]
		public function getprojecttasksAction( obj:IViewMediator, projectId:int ):void {
			var signal:SignalVO = new SignalVO( obj, tasksDAO, Action.FINDTASKSLIST );
			signal.id = projectId;
			signalSequence.addSignal( signal );
		}
		
		/**
		 * Whenever an GetProjectListSignal is dispatched.
		 * MediateSignal initates this getprojectlistAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getProjectListSignal')]
		public function getprojectlistAction(obj:IViewMediator,personId:int,refreshCall:Boolean):void {
			var signal:SignalVO = new SignalVO(obj,projectDAO,Action.GETPROJECTSLIST);
			signal.id = personId;
			signal.processed = refreshCall;
			signalSequence.addSignal(signal);
		}
		
		/**
		 * Whenever an GetPagedProjectListSignal is dispatched.
		 * MediateSignal initates this getpagedprojectlistAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getPagedProjectListSignal')]
		public function getpagedprojectlistAction(obj:IViewMediator,personId:int,startIndex:int,endIndex:int):void {
			var signal:SignalVO = new SignalVO(obj,paging,Action.PAGINATIONQUERY);
			signal.id = personId;
			signal.startIndex = startIndex;
			signal.endIndex = endIndex;
			signal.description ='Projects.'+Action.PAGINATIONQUERY;
			signalSequence.addSignal(signal);
		}
		
        /**
         * Whenever an CreateProjectSignal is dispatched.
         * MediateSignal initates this createprojectAction to perform control Actions
         * The invoke functions to perform control functions
         */
        [ControlSignal(type='createProjectSignal')]
        public function createprojectAction(obj:IViewMediator,projectprefix:String,projectName:String,projectComments:String,
											categoryId:int,personId:int,
											parentFolderName:String,domain:Categories,categories1:Categories,
											categories2:Categories,workflowFK:int,
											codeEAN:String,codeGEST:String,codeIMPRE:String,currentImpremiuerID:int,
											phaseColl0:String,
											phaseColl2:String,phaseColl1:String,phaseColl3:String,
											phaseColl4:String,phaseColl5:String,PhaseStatus:int,
											workflowTemplateId:int,endTaskCode:String,pjCollection:String):void {
			var objArray:Array=[];
			objArray.push(projectprefix);
			objArray.push(projectName);
			objArray.push(projectComments);
			objArray.push(categoryId);
			objArray.push(personId);
			objArray.push(parentFolderName);
			objArray.push(domain);
			objArray.push(categories1);
			objArray.push(categories2);
			objArray.push(workflowFK);
			objArray.push(codeEAN);
			objArray.push(codeGEST);
			objArray.push(codeIMPRE);
			objArray.push(currentImpremiuerID);
			objArray.push(phaseColl0);
			objArray.push(phaseColl2);
			objArray.push(phaseColl1);
			objArray.push(phaseColl3);
			objArray.push(phaseColl4);
			objArray.push(phaseColl5);
			objArray.push(PhaseStatus);
			objArray.push(workflowTemplateId);
			objArray.push(endTaskCode);
						
			var signal:SignalVO = new SignalVO(obj,paging,Action.CREATEPROJECT);
			signal.emailBody = pjCollection;
			signal.receivers = objArray;
			signalSequence.addSignal(signal);
		} 
		
		/**
		 * Whenever an closeProjectsSignal is dispatched.
		 * MediateSignal initates this closeprojectsAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='closeProjectsSignal')]
		public function closeprojectsAction(obj:IViewMediator,objArray:Array):void {
			var signal:SignalVO = new SignalVO(obj,paging,Action.CLOSEPROJECT);
			signal.receivers = objArray;
			signalSequence.addSignal(signal); 
		}
		
		/**
		 * Whenever an DeleteAllProjectsSignal is dispatched.
		 * MediateSignal initates this deleteallprojectsAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='deleteAllProjectsSignal')]
		public function deleteallprojectsAction(obj:IViewMediator):void {
			var signal1:SignalVO = new SignalVO(obj,eventsDAO,Action.DELETE_ALL);
			var signal2:SignalVO = new SignalVO(obj,filedetailsDAO,Action.DELETE_ALL);
			var signal3:SignalVO = new SignalVO(obj,commentvoDAO,Action.DELETE_ALL);
			var signal4:SignalVO = new SignalVO(obj,phasesDAO,Action.DELETE_ALL);
			var signal5:SignalVO = new SignalVO(obj,propertiespjDAO,Action.DELETE_ALL);
			var signal6:SignalVO = new SignalVO(obj,tasksDAO,Action.DELETE_ALL);
			var signal7:SignalVO = new SignalVO(obj,teamlinesDAO,Action.DELETE_ALL);
			var signal8:SignalVO = new SignalVO(obj,projectDAO,Action.DELETE_ALL);
			signalSequence.addSignal(signal1);
			signalSequence.addSignal(signal2);
			signalSequence.addSignal(signal3);
			signalSequence.addSignal(signal4);
			signalSequence.addSignal(signal5);
			signalSequence.addSignal(signal6);
			signalSequence.addSignal(signal7);
			signalSequence.addSignal(signal8);
		}
   	}
}
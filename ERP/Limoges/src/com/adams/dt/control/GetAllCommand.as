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
	import com.adams.dt.view.mediators.MainViewMediator;
	import com.adams.swizdao.dao.PagingDAO;
	import com.adams.swizdao.model.vo.CurrentInstance;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.response.SignalSequence;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.views.mediators.IViewMediator;

	public class GetAllCommand
	{
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		[Inject]
		public var signalSequence:SignalSequence;
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject("personsDAO")]
		public var personDAO:AbstractDAO;
		
		[Inject("categoriesDAO")]
		public var categoryDAO:AbstractDAO;
		
		[Inject("proppresetstemplatesDAO")]
		public var propPresettemplateDAO:AbstractDAO;
		
		[Inject("reportsDAO")]
		public var reportDAO:AbstractDAO;
		
		[Inject("columnsDAO")]
		public var columnDAO:AbstractDAO;
		
		[Inject("presetstemplatesDAO")]
		public var presettemplateDAO:AbstractDAO;
		
		[Inject("propertiespresetsDAO")]
		public var propertypresetDAO:AbstractDAO;
			
		[Inject]
		public var paging:PagingDAO;  
		
		/**
		 * Whenever an GetReportsListSignal is dispatched.
		 * MediateSignal initates this getreportslistAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getReportsListSignal')]
		public function getreportslistAction(obj:IViewMediator):void {
			var signal:SignalVO = new SignalVO(obj,reportDAO,Action.GET_LIST);
			signalSequence.addSignal(signal);
		}
		
		/**
		 * Whenever an GetColumnsListSignal is dispatched.
		 * MediateSignal initates this getcolumnslistAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getColumnsListSignal')]
		public function getcolumnslistAction(obj:IViewMediator):void {
			var signal:SignalVO = new SignalVO(obj,columnDAO,Action.GET_LIST);
			signalSequence.addSignal(signal);
		}
		
		/**
		 * Whenever an GetPropPresetTemplateListSignal is dispatched.
		 * MediateSignal initates this getproppresettemplatelistAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getPropPresetTemplateListSignal')]
		public function getproppresettemplatelistAction(obj:IViewMediator):void {
			var signal:SignalVO = new SignalVO(obj,propPresettemplateDAO,Action.GET_LIST);
			signalSequence.addSignal(signal);
		}

		/**
		 * Whenever an GetPresetTemplateListSignal is dispatched.
		 * MediateSignal initates this getpresettemplatelistAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getPresetTemplateListSignal')]
		public function getpresettemplatelistAction(obj:IViewMediator):void {
			var signal:SignalVO = new SignalVO(obj,presettemplateDAO,Action.GET_LIST);
			signalSequence.addSignal(signal);
		}
		
		/**
		 * Whenever an GetPropertiesPresetsListSignal is dispatched.
		 * MediateSignal initates this getpropertiespresetslistAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getPropertiesPresetsListSignal')]
		public function getpropertiespresetslistAction(obj:IViewMediator):void {
			var signal:SignalVO = new SignalVO(obj,propertypresetDAO,Action.GET_LIST);
			signalSequence.addSignal(signal);
		}
		
		
		/**
		 * Whenever an getCategoryListSignal is dispatched.
		 * MediateSignal initates this getcategorylistAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getCategoryListSignal')]
		public function getcategorylistAction(obj:IViewMediator):void {
			var signal:SignalVO = new SignalVO(obj,categoryDAO,Action.GET_LIST);
			signalSequence.addSignal(signal);
		}

		/**
		 * Whenever an GetAllTemplatesSignal is dispatched.
		 * MediateSignal initates this getalltemplatesAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getAllTemplatesSignal')]
		public function getalltemplatesAction(obj:IViewMediator,personId:int,defaultProfileId:int):void {
			var signal:SignalVO = new SignalVO(obj,paging,Action.GETLOGINLISTRESULT);
			signal.id = personId;
			signal.startIndex = defaultProfileId;
			signalSequence.addSignal(signal);
		}
		
		/**
		 * Whenever an GetPropTemplatesSignal is dispatched.
		 * MediateSignal initates this getproptemplatesAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getPropTemplatesSignal')]
		public function getproptemplatesAction(obj:IViewMediator):void {
			controlSignal.getAllTemplatesSignal.dispatch(null,currentInstance.mapConfig.currentPerson.personId,currentInstance.mapConfig.currentPerson.defaultProfile);
			controlSignal.getReportsListSignal.dispatch(null);
			controlSignal.getColumnsListSignal.dispatch(null);
			controlSignal.getPresetTemplateListSignal.dispatch(null);
			controlSignal.getPropertiesPresetsListSignal.dispatch(null);
			controlSignal.getPropPresetTemplateListSignal.dispatch(null);
			controlSignal.getCategoryListSignal.dispatch(null);
			controlSignal.getProjectListSignal.dispatch(null,currentInstance.mapConfig.currentPerson.personId,false);
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
	}
}
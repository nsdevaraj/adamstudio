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

	public class PropertiesCommand
	{
		
		[Inject]
		public var controlSignal:ControlSignal; 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var signalSequence:SignalSequence;  
		
		[Inject("proppresetstemplatesDAO")]
		public var propPresettemplateDAO:AbstractDAO;
		
		[Inject("propertiespresetsDAO")]
		public var propertiespresetsDAO:AbstractDAO;
				
		[Inject]
		public var paging:PagingDAO;  
		
		[Inject("propertiespjDAO")]
		public var propertiespjDAO:AbstractDAO;	
		
		// todo: add listener
        /**
         * Whenever an UpdatePresetTemplateSignal is dispatched.
         * MediateSignal initates this updatepresettemplateAction to perform control Actions
         * The invoke functions to perform control functions
         */
        [ControlSignal(type='updatePropPresetTemplateSignal')]
        public function updatepresettemplateAction(obj:IViewMediator,propTemplate:Proppresetstemplates):void {
			var signal:SignalVO = new SignalVO(obj,propPresettemplateDAO,Action.UPDATE);
			signal.valueObject = propTemplate;
			signalSequence.addSignal(signal);
        }
		
		/**
		 * Whenever an UpdatePresetSignal is dispatched.
		 * MediateSignal initates this updatepresetAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='updatePresetSignal')]
		public function updatepresetAction(obj:IViewMediator,preset:Propertiespresets):void {
			var signal:SignalVO = new SignalVO(obj,propertiespresetsDAO,Action.UPDATE);
			signal.valueObject = preset;
			signalSequence.addSignal(signal);
		}

        /**
         * Whenever an BulkUpdatePrjPropertiesSignal is dispatched.
         * MediateSignal initates this bulkupdateprjpropertiesAction to perform control Actions
         * The invoke functions to perform control functions
         */
        [ControlSignal(type='bulkUpdatePrjPropertiesSignal')]
        public function bulkupdateprjpropertiesAction(obj:IViewMediator,projectId:int,
													  propertyPresetFk:String,fieldValue:String,taskid:int,filePath:String):void {
			var signal:SignalVO = new SignalVO(obj,paging,Action.BULKUPDATEPROJECTPROPERTIES);
			signal.receivers = [];
			signal.id = projectId;
			signal.endIndex = taskid;
			signal.emailBody= filePath;
			signal.receivers.push(projectId.toString());
			signal.receivers.push(propertyPresetFk);
			signal.receivers.push(fieldValue);
			signalSequence.addSignal(signal);
        } 
    }
}
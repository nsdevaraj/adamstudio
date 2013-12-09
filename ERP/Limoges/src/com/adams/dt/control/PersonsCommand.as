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
	import com.adams.swizdao.model.vo.CurrentInstance;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.response.SignalSequence;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.views.mediators.IViewMediator;

	public class PersonsCommand
	{
		
		[Inject]
		public var controlSignal:ControlSignal; 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var signalSequence:SignalSequence; 
		
		[Inject("personsDAO")]
		public var personDAO:AbstractDAO;
		
        /**
         * Whenever an CreatePersonSignal is dispatched.
         * MediateSignal initates this createpersonAction to perform control Actions
         * The invoke functions to perform control functions
         */
        [ControlSignal(type='createPersonSignal')]
        public function createpersonAction(obj:IViewMediator,person:Persons):void {
			var signal:SignalVO = new SignalVO(obj,personDAO,Action.CREATE);
			signal.valueObject = person;
			signalSequence.addSignal(signal);
        }

        /**
         * Whenever an EditPersonSignal is dispatched.
         * MediateSignal initates this editpersonAction to perform control Actions
         * The invoke functions to perform control functions
         */
        [ControlSignal(type='editPersonSignal')]
        public function editpersonAction(obj:IViewMediator,person:Persons):void {
			var signal:SignalVO = new SignalVO(obj,personDAO,Action.UPDATE);
			signal.valueObject = person;
			signalSequence.addSignal(signal);
        }

        /**
         * Whenever an DeletePersonSignal is dispatched.
         * MediateSignal initates this deletepersonAction to perform control Actions
         * The invoke functions to perform control functions
         */
        [ControlSignal(type='deletePersonSignal')]
        public function deletepersonAction(obj:IViewMediator,person:Persons):void {
			var signal:SignalVO = new SignalVO(obj,personDAO,Action.DELETE);
			signal.valueObject = person;
			signalSequence.addSignal(signal);
        }
 
    }
}
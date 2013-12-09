/*

Copyright (c) @year@ @company.name@, All Rights Reserved 

@author   @author.name@
@contact  @author.email@
@project  @project.name@

@internal 

*/
package @namespace@.control
{
	import @namespace@.model.AbstractDAO;
	import @namespace@.model.vo.*;
	import @namespace@.util.Utils;
	import @namespace@.view.mediators.MainViewMediator;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.model.vo.CurrentInstance;
	import com.adams.swizdao.response.SignalSequence;
	import com.adams.swizdao.views.mediators.IViewMediator;

	import @namespace@.signal.ControlSignal;
	public class SignalsCommand
	{
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
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
			mainViewMediator.view.currentState = state;
		}
	}
}
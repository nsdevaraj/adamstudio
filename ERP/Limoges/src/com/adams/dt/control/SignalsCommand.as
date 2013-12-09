/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.control
{
	import com.adams.dt.model.vo.*;
	import com.adams.dt.signal.ControlSignal;
	import com.adams.dt.util.ProcessUtil;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.mediators.MainViewMediator;
	import com.adams.swizdao.dao.PagingDAO;
	import com.adams.swizdao.model.vo.CurrentInstance;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.response.SignalSequence;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.views.mediators.IViewMediator;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class SignalsCommand
	{
		
		[Inject]
		public var controlSignal:ControlSignal; 

		protected var requestService:HTTPService;
		protected var lastUrl:String;
		protected var limogesTime:Date;
		protected var pondyTime:Date;
		
		// todo: add listener
		/**
		 * Whenever an GetTimeDiffSignal is dispatched.
		 * MediateSignal initates this gettimediffAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='getTimeDiffSignal')]
		public function gettimediffAction(obj:IViewMediator):void {
			makeServiceCall(ProcessUtil.PONDYTIME);
		}
		
		protected function makeServiceCall( url:String, param:Object = null, method:String = "POST", format:String = "e4x" ):void {
			if( !requestService ) {
				requestService = new HTTPService();
				requestService.useProxy = false;
				requestService.addEventListener( ResultEvent.RESULT, resultHandler);
				requestService.addEventListener( FaultEvent.FAULT, faultHandler );
			}	
			requestService.url = url;
			requestService.method = method;
			requestService.resultFormat = format;
			lastUrl = url;
			requestService.send( param );
		}
		
		protected function resultHandler( event:ResultEvent ):void {
			var xml:XMLList = new XMLList( event.target.lastResult );
			var timeStr:String = xml.isotime;
			var resultArr:Array = timeStr.split(' '); 
			var dateArr:Array =  resultArr[0].split('-');
			var timeArr:Array= resultArr[1].split(':'); 
			if(lastUrl == ProcessUtil.LIMOGESTIME){
				limogesTime= new Date(dateArr[0],parseInt(dateArr[1])-1,dateArr[2],timeArr[0],timeArr[1],timeArr[2])
			}else if(lastUrl == ProcessUtil.PONDYTIME){
				makeServiceCall(ProcessUtil.LIMOGESTIME);
				pondyTime= new Date(dateArr[0],parseInt(dateArr[1])-1,dateArr[2],timeArr[0],timeArr[1],timeArr[2])
			}
			if(limogesTime){
				var diffSecs:int = pondyTime.getTime()-limogesTime.getTime() 
				ProcessUtil.timeDiff = diffSecs;
			}				
		}
		
		protected function faultHandler( event:FaultEvent ):void {
			controlSignal.showAlertSignal.dispatch(null,Utils.TIMESERVERCONNECTION ,Utils.APPTITLE,1,null)
		}
	}
}
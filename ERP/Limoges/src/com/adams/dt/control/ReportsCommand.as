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
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.mediators.MainViewMediator;
	import com.adams.swizdao.dao.PagingDAO;
	import com.adams.swizdao.model.vo.CurrentInstance;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.response.SignalSequence;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.views.mediators.IViewMediator;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class ReportsCommand
	{
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var signalSequence:SignalSequence; 
		
		[Inject]
		public var pagingDAO:PagingDAO;  
		
		[Inject("reportsDAO")]
		public var reportDAO:AbstractDAO;
		
		[Inject("columnsDAO")]
		public var columnDAO:AbstractDAO;
		
		private var orderColumns:ArrayCollection = new ArrayCollection();
		
        /**
         * Whenever an DeleteReportSignal is dispatched.
         * MediateSignal initates this deletereportAction to perform control Actions
         * The invoke functions to perform control functions
         */
        [ControlSignal(type='deleteReportSignal')]
        public function deletereportAction(obj:IViewMediator,report:Reports):void {
			var signal:SignalVO = new SignalVO( obj, reportDAO, Action.DELETE );
			signal.valueObject = report;
			signalSequence.addSignal( signal );
        } 

        /**
         * Whenever an UpdateReportSignal is dispatched.
         * MediateSignal initates this updatereportAction to perform control Actions
         * The invoke functions to perform control functions
         */
        [ControlSignal(type='updateReportSignal')]
        public function updatereportAction(obj:IViewMediator,report:Reports,order:Boolean=false):void {
			var signal:SignalVO = new SignalVO( obj, reportDAO, Action.DIRECTUPDATE );
			signal.valueObject = report;
			if(order){
				signal.list = orderColumns;
			}
			signalSequence.addSignal( signal );
        } 

        /**
         * Whenever an CreateReportSignal is dispatched.
         * MediateSignal initates this createreportAction to perform control Actions
         * The invoke functions to perform control functions
         */
        [ControlSignal(type='createReportSignal')]
        public function createreportAction(obj:IViewMediator,report:Reports):void {
			var signal:SignalVO = new SignalVO( obj, reportDAO, Action.CREATE );
			signal.valueObject = report;
			signalSequence.addSignal( signal );
        }

        /**
         * Whenever an ReOrderColumnsSignal is dispatched.
         * MediateSignal initates this reordercolumnsAction to perform control Actions
         * The invoke functions to perform control functions
         */
        [ControlSignal(type='reOrderColumnsSignal')]
        public function reordercolumnsAction(obj:IViewMediator,report:Reports):void {
			for each (var col:Columns in report.columnSet){
				orderColumns.addItem(col);
			}
			report.columnSet.removeAll();
			controlSignal.updateReportSignal.dispatch(obj,report,true);
        } 
		
		/**
		 * Whenever an ReportSignal is dispatched.
		 * MediateSignal initates this reportAction to perform control Actions
		 * The invoke functions to perform control functions
		 */
		[ControlSignal(type='reportSignal')]
		public function reportAction( obj:IViewMediator, query:String, columnIndex:int ):void {
			var signal:SignalVO = new SignalVO( obj, pagingDAO, Action.GETQUERYRESULT );
			signal.id = columnIndex;
			signalSequence.addSignal( signal );
		}
	}
}
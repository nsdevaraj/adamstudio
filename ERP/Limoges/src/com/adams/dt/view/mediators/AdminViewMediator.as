/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.view.mediators
{ 
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.model.vo.*;
	import com.adams.dt.signal.ControlSignal;
	import com.adams.dt.util.PropertyUtil;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.AdminSkinView;
	import com.adams.dt.view.components.autocomplete.AutoCompleteView;
	import com.adams.swizdao.dao.PagingDAO;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.response.SignalSequence;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.ArrayUtil;
	import com.adams.swizdao.util.Description;
	import com.adams.swizdao.util.GetVOUtil;
	import com.adams.swizdao.util.ObjectUtils;
	import com.adams.swizdao.views.components.NativeList;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	
	public class AdminViewMediator extends AbstractViewMediator
	{ 		 
		[Inject("propertiespresetsDAO")]
		public var propertiespresetsDAO:AbstractDAO;
		
		[Inject("proppresetstemplatesDAO")]
		public var propPresettemplateDAO:AbstractDAO;
		
		[Inject("profilesDAO")]
		public var profileDAO:AbstractDAO;
		
		[Inject("reportsDAO")]
		public var reportsDAO:AbstractDAO;
		
		[Inject("columnsDAO")]
		public var columnDAO:AbstractDAO;
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Bindable]
		private var reportStatusArray:ArrayCollection = new ArrayCollection(["All","projectDateEndIsNull","projectDateEndIsNotNull","CLT","OPE","EPR","FAB","TRA","CurrentYear","SUB","TRAFAB","DepartureDateIsNull","ArrivalDateIsNull","CurrentMonthArrival","PreviousMonthArrival"]);
		
		private var _reportCollection:ArrayCollection;
		private var localColumns:Vector.<int> = new Vector.<int>();
		[Bindable]
		private var showForm:Boolean;
		[Bindable]
		private var formEditOption:Boolean;
		[Bindable]
		private var formAddOption:Boolean;
		
		[Bindable]
		private var currentLable:String;
		
		[Inject]
		public var controlSignal:ControlSignal;
		private var propfieldNames:Array;
		private var _homeState:String;
		public function get homeState():String
		{
			return _homeState;
		}
		
		public function set homeState(value:String):void
		{
			_homeState = value;
			if(value==Utils.ADMIN_INDEX) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		
		protected function addedtoStage(ev:Event):void{
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function AdminViewMediator( viewType:Class=null )
		{
			super( AdminSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():AdminSkinView 	{
			return _view as AdminSkinView;
		}
		
		[MediateView( "AdminSkinView" )]
		override public function setView( value:Object ):void { 
			super.setView(value);	
		}  
		/**
		 * The <code>init()</code> method is fired off automatically by the 
		 * AbstractViewMediator when the creation complete event fires for the
		 * corresponding ViewMediator's view. This allows us to listen for events
		 * and set data bindings on the view with the confidence that our view
		 * and all of it's child views have been created and live on the stage.
		 */
		override protected function init():void {
			super.init();  
			viewState = Utils.ADMIN_INDEX;
			assignValues();
			reportManagement();
		}
		
		private function assignValues():void {
			propfieldNames=[];
			for each(var propPresets:Propertiespresets in propertiespresetsDAO.collection.items){
				propfieldNames.push(propPresets.fieldName);
			}
			var currentProjObject:Object = {};
			var formIds:Array = PropertyUtil.getFormIDs(view.newProjectForm)
			PropertyUtil.propertyUpdate(currentProjObject,formIds,propfieldNames,propertiespresetsDAO.collection, propPresettemplateDAO.collection)
			PropertyUtil.setUpForm(currentProjObject,view.newProjectForm,propfieldNames);
		}  
		
		private function updatePropPresetTemplate( viewComp:AutoCompleteView ):void{
			var getPropertiespresets:Propertiespresets = new Propertiespresets();
			getPropertiespresets.propertyPresetId = parseInt( viewComp.name );
			var currentPreset:Propertiespresets = propertiespresetsDAO.collection.findExistingItem(getPropertiespresets) as Propertiespresets;
			var getpropPresetTempItem:Proppresetstemplates = new Proppresetstemplates();
			getpropPresetTempItem.propertiesPresets = currentPreset;
			var currentPropPresetTemp:Proppresetstemplates= propPresettemplateDAO.collection.findExistingPropItem(getpropPresetTempItem,'propertiesPresets') as Proppresetstemplates;
			var optionsArr:Array = propertiesRemove( currentPreset.fieldOptionsValue.split(','), viewComp.specificText );
			currentPreset.fieldOptionsValue = currentPropPresetTemp.fieldOptionsValue = optionsArr.toString();
			
			controlSignal.updatePropPresetTemplateSignal.dispatch( this,currentPropPresetTemp );
			controlSignal.updatePresetSignal.dispatch( this,currentPreset );
		}
		
		private function propertiesRemove( optionsArr:Array, optionStr:String ):Array{
			var arrPush:Array = [];
			for(var i:int = 0; i < optionsArr.length; i++){
				if( optionStr != optionsArr[i] ){
					arrPush.push( optionsArr[i] );
				}
			}
			return arrPush;
		}
		
		private function reportManagement():void {
			makeReportDataProvider();
			view.profileList.dataProvider = profileDAO.collection.items as ArrayCollection;
			view.columnChart.dataProvider = columnDAO.collection.items as ArrayCollection;
			view.barChart.dataProvider = columnDAO.collection.items as ArrayCollection;
			view.reportStatus.dataProvider = reportStatusArray;
			view.reportColList.dataProvider = columnDAO.collection.items as ArrayCollection;
		}
		
		private function makeReportDataProvider():void {
			_reportCollection = reportsDAO.collection.items as ArrayCollection;
			for each( var reportObj:Reports in _reportCollection ) {
				for each( var col:Columns in reportObj.columnSet ) {
					reportObj.headerArray.push( col.columnName );
					reportObj.fieldArray.push( col.columnField );
					reportObj.widthArray.push( col.columnWidth );
					reportObj.booleanArray.push( col.columnFilter );
					reportObj.resultArray.push( '' );
				}
			} 
			_reportCollection.refresh();
			
			view.reportGrid.dataProvider = _reportCollection;
		}
		
		private function showDetails( event:MouseEvent ):void {
			var strName:String = event.currentTarget.label.toString();
			var index:int = view.reportGrid.selectedIndex;
			var selectedReport:Reports = view.reportGrid.selectedItem as Reports;
			localColumns = new Vector.<int>();
			view.currentState = "reportView";
			
			view.reportColOrder.visible = false;
			view.reportColOrder.includeInLayout = false;
			if(strName == "View"){
				formAddOption = false;
				if( index == -1 ) {
					controlSignal.showAlertSignal.dispatch(null,Utils.REPORT_VIEW_ALERT_MESSAGE,Utils.APPTITLE,1,null)
					
					showForm = false;
					formEditOption = false;						
					return;
				}
				else{
					showForm = true;
					formEditOption = false;
					
					viewReport( selectedReport );						
				}
			}else if(strName == "Modify"){
				currentLable = "Modify Form";
				formAddOption = false;
				if( index == -1 ) {
					controlSignal.showAlertSignal.dispatch(null,Utils.REPORT_MODIFY_ALERT_MESSAGE,Utils.APPTITLE,1,null)
					
					showForm = false;					
					formEditOption = false;
					return;
				}else{
					showForm = true;						
					formEditOption = true;	
					view.reportColOrder.visible = true;
					view.reportColOrder.includeInLayout = true;
					viewReport( selectedReport );						
				}					
			}else if(strName == "Add"){
				currentLable = "Add New";
				showForm = true;
				formAddOption = true;
				formEditOption = false;
				
				view.reportName.text = "";	
				view.barChartName.text = "";
				view.columnChartName.text = "";
				view.profileList.selectedIndex = 0;
				view.columnChart.selectedIndex = 0;
				view.barChart.selectedIndex = 0;
				view.reportStatus.selectedIndex = 0;
				view.reportColList.selectedIndices = new Vector.<int>();
			}
			
			view.reprotForm.title = currentLable;
			makeVisible( formAddOption,formEditOption );
			
		}
		
		private function makeVisible( formAddOption :Boolean, formEditOption:Boolean ):void{ 
			
			view.createReportId.visible = formAddOption;
			view.createReportId.includeInLayout = formAddOption;
			view.cancelReportId.visible = formAddOption;
			view.cancelReportId.includeInLayout = formAddOption;
			
			view.modifyReportId.visible = formEditOption;
			view.modifyReportId.includeInLayout = formEditOption; 
			view.duplicateReportId.visible = formEditOption; 
			view.duplicateReportId.includeInLayout = formEditOption; 
			view.reorderReportId.visible = formEditOption; 
			view.reorderReportId.includeInLayout = formEditOption; 
		}
		
		private function viewReport( viewReportVo:Reports ):void{
			view.reportName.text = viewReportVo.reportName;	
			view.profileList.selectedItem = GetVOUtil.getVOObject( viewReportVo.profileFk, profileDAO.collection.items, profileDAO.destination, Profiles ) as Profiles;
			view.columnChart.selectedItem = Columns( getColumns( viewReportVo.pieChartCol.columnId ));
			view.barChart.selectedItem = Columns( getColumns( viewReportVo.stackBarCol.columnId )); 
			view.columnChartName.text = viewReportVo.pieChartName;				
			view.barChartName.text = viewReportVo.stackBarName;				
			view.reportStatus.selectedIndex = reportStatusArray.getItemIndex( viewReportVo.projectStatus );
			for each (var columnsVo:Columns in viewReportVo.columnSet){									
				var indexValue:int = getReportCollections(columnsVo);
				localColumns.push( indexValue );
			}					
			view.reportColList.selectedIndices = localColumns;
		}
		
		private function getReportCollections( columnIdRef:Columns ):int {
			var lengthReport:int = columnDAO.collection.items.length;
			for(var i:int=0;i<lengthReport;i++){
				var items:Columns = columnDAO.collection.items[i] as Columns;
				if(items.columnId == columnIdRef.columnId){
					return i;
				}
			}
			return 0;				
		}
		
		private function getColumns( columnIdRef:int ):Columns {
			for each (var items:Columns in columnDAO.collection.items ){
				if(items.columnId == columnIdRef){
					return items;
				}
			}
			return null;
		}	
		
		override protected function setRenderers():void {
			super.setRenderers();  
			view.closeBtn.clicked.add(closeHandler);
			view.deleteClient.addEventListener(MouseEvent.CLICK, deleteClientHandler);
			view.deleteTask.addEventListener(MouseEvent.CLICK, deleteTaskHandler);
		} 
		
		private function getStrLen( str:String ):String{
			return str.split(" ").join("");
		}
		
		private function createReport( event:MouseEvent ) :void {
			if(getStrLen( view.reportName.text ).length > 0 && 
				getStrLen( view.barChartName.text ).length > 0 && 
				getStrLen( view.columnChartName.text ).length > 0 &&
				view.reportColList.selectedIndices.length > 0)
			{
				addReportColumn();
			}else{
				controlSignal.showAlertSignal.dispatch(null,Utils.REPORT_ALERT_MESSAGE,Utils.APPTITLE,1,null)
			}
		}
		
		private function addReportColumn():void{
			var report:Reports = new Reports();
			report.reportName = view.reportName.text;
			report.stackBarName = view.barChartName.text;
			report.profileFk = Profiles(view.profileList.selectedItem).profileId;
			report.pieChartCol = view.columnChart.selectedItem as Columns;
			report.stackBarCol = view.barChart.selectedItem as Columns;
			report.projectStatus = view.reportStatus.selectedItem as String
			report.pieChartName = view.columnChartName.text
			for each( var col:Columns in view.reportColList.selectedItems){
				report.columnSet.addItem( col );	
			}
			controlSignal.createReportSignal.dispatch( this, report );			
		}
		
		private function clearAll( event:MouseEvent=null )  :void {
			view.reportName.text = "";	
			view.barChartName.text = "";
			view.columnChartName.text = "";
			view.profileList.selectedIndex = 0;
			view.columnChart.selectedIndex = 0;
			view.barChart.selectedIndex = 0;
			view.reportStatus.selectedIndex = 0;
			view.reportColList.selectedIndices = new Vector.<int>();
		}
		public function closeForm( event:CloseEvent ) :void {
			view.currentState = "normal";
			showForm = false;
		}
		
		private function modifyReport( event:MouseEvent ) :void {
			var modify:Boolean;
			var order:Boolean;
			if( event.currentTarget == view.modifyReportId ){
				modify = true;
				order = false;
			}
			if( event.currentTarget == view.duplicateReportId ){
				modify = false;
				order = false;
			}
			if( event.currentTarget == view.reorderReportId ){
				modify = true;
				order = true;
			}
			if( getStrLen( view.reportName.text ).length > 0 && 
				getStrLen( view.barChartName.text ).length > 0 && 
				getStrLen( view.columnChartName.text ).length > 0 &&
				view.reportColList.selectedIndices.length > 0)
			{
				modifyReportColumn( modify,order );
			}else{
				controlSignal.showAlertSignal.dispatch(null,Utils.REPORT_ALERT_MESSAGE,Utils.APPTITLE,1,null)
			}
		}
		private function modifyReportColumn( modify:Boolean,order:Boolean ):void{		
			var report:Reports;
			if( modify ){
				report = view.reportGrid.selectedItem as Reports; 
			}else{
				report = new Reports();
			}
			
			report.reportName = view.reportName.text;
			report.stackBarName = view.barChartName.text;
			report.profileFk = Profiles( view.profileList.selectedItem ).profileId;
			report.pieChartCol = view.columnChart.selectedItem as Columns;
			report.stackBarCol = view.barChart.selectedItem as Columns;
			report.projectStatus = view.reportStatus.selectedItem as String;
			report.pieChartName = view.columnChartName.text;
			var tempOrder:ArrayCollection = new ArrayCollection()
			for each( var orCol:Columns in view.reportColOrderList.dataProvider){
				tempOrder.addItem(orCol);	
			} 
			report.columnSet.removeAll();
			if(order){
				for each( var col1:Columns in tempOrder){
					report.columnSet.addItem(col1); 
				}
				controlSignal.reOrderColumnsSignal.dispatch( this, report );	
			}else{
				for each( var col:Columns in view.reportColList.selectedItems){
					report.columnSet.addItem(col);	
				} 
				if(!modify){
					controlSignal.updateReportSignal.dispatch( this, report );
				}else{
					controlSignal.createReportSignal.dispatch( this, report );
				}
			}
		}
		
		private function clearForm():void
		{
			view.reportName.text = "";	
			view.barChartName.text = "";
			view.columnChartName.text = "";
			view.profileList.selectedIndex = 0;
			view.columnChart.selectedIndex = 0;
			view.barChart.selectedIndex = 0;
			view.reportStatus.selectedIndex = 0;
			view.reportColList.selectedIndices = new Vector.<int>();
			
			showForm = false;
		}
		
		public function orderReportResult( rpcEvent : Object ) : void{
			var alertMessage:String = "Modify Report "+view.reportName.text+" updated";
			controlSignal.showAlertSignal.dispatch(null,alertMessage,Utils.APPTITLE,1,null);
			
			clearForm(); 
		}
		
		public function modifyReportResult( rpcEvent : Object ) : void{			
			var alertMessage:String = "Modify Report "+view.reportName.text+" updated";
			controlSignal.showAlertSignal.dispatch(null,alertMessage,Utils.APPTITLE,1,null);			
			
			clearForm(); 
		}
		
		private function deleteClientHandler( event:MouseEvent ):void {
			updatePropPresetTemplate( view.brand );
		}
		
		private function deleteTaskHandler( event:MouseEvent ):void {
			updatePropPresetTemplate( view.department );
		}
		
		private function closeHandler( event:MouseEvent ):void {
			controlSignal.changeStateSignal.dispatch(Utils.TASKLIST_INDEX);
		}
		
		private var removeIndex:int;
		private function onReportDeleteHandler( reportsObj:Reports ):void {
			var removeIndex:int = view.reportGrid.dataProvider.getItemIndex( reportsObj );
			controlSignal.showAlertSignal.dispatch(this,Utils.REPORT_DELETE_MESSAGE,Utils.APPTITLE,0,Utils.REPORT_DELETE_MESSAGE);
		}
		override public function alertReceiveHandler( obj:Object ):void {
			if( obj == Utils.REPORT_DELETE_MESSAGE) {
				var selectedReports:Reports = view.reportGrid.selectedItem as Reports;
				controlSignal.deleteReportSignal.dispatch( this, selectedReports );	
				view.reportGrid.dataProvider.removeItemAt( removeIndex );				
			}
		}
		
		override protected function serviceResultHandler( obj:Object,signal:SignalVO ):void {  
			if( signal.action == Action.UPDATE && signal.destination == Utils.PROPPRESETSTEMPLATESKEY ){
				assignValues();
			} 
			if( signal.action == Action.DELETE && signal.destination == Utils.REPORTSKEY ){
				controlSignal.getReportsListSignal.dispatch( this );	
			} 
			if( signal.action == Action.DIRECTUPDATE && signal.destination == Utils.REPORTSKEY ){
				if(signal.list){
					var updatedReport:Reports = obj as Reports;
					var getReport:Reports = new Reports()
					getReport.reportId = updatedReport.reportId;
					var foundReport:Reports= reportsDAO.collection.findExistingItem(getReport) as Reports;
					foundReport.columnSet = signal.list as ArrayCollection;
					controlSignal.updateReportSignal.dispatch(this,foundReport);
				}else{
					controlSignal.getReportsListSignal.dispatch( this );	
				}
			} 
			if( signal.action == Action.GET_LIST && signal.destination == Utils.REPORTSKEY ){
				makeReportDataProvider();
			}
		}
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
			view.addReport.addEventListener( MouseEvent.CLICK, showDetails, false, 0, true );
			view.modifyReport.addEventListener( MouseEvent.CLICK, showDetails, false, 0, true );
			
			view.createReportId.addEventListener( MouseEvent.CLICK, createReport, false, 0, true );
			view.cancelReportId.addEventListener( MouseEvent.CLICK, clearAll, false, 0, true );
			view.modifyReportId.addEventListener( MouseEvent.CLICK, modifyReport, false, 0, true );
			view.duplicateReportId.addEventListener( MouseEvent.CLICK, modifyReport, false, 0, true );
			view.reorderReportId.addEventListener( MouseEvent.CLICK, modifyReport, false, 0, true );
			view.reprotForm.addEventListener( Event.CLOSE, closeForm, false, 0, true );
			
			view.reportGrid.rendererSignal.add( onReportDeleteHandler );			
		}
		override protected function pushResultHandler( signal:SignalVO ): void { 
		} 
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			super.cleanup( event ); 		
		} 
	}
}
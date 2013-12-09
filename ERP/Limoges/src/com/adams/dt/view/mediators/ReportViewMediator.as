package com.adams.dt.view.mediators
{
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.model.vo.Columns;
	import com.adams.dt.model.vo.ProjectStatus;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Reports;
	import com.adams.dt.signal.ControlSignal;
	import com.adams.dt.util.ExcelGenerator;
	import com.adams.dt.util.PdfGenerator;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.ReportSkinView;
	import com.adams.dt.view.renderers.ReportColorRenderer;
	import com.adams.swizdao.model.vo.CurrentInstance;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.ArrayUtil;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.ClassFactory;
	
	import spark.components.gridClasses.GridColumn;
	import spark.events.GridEvent;
	import spark.events.IndexChangeEvent;
	
	public class ReportViewMediator extends AbstractViewMediator
	{ 		 
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject]
		public var mainViewMediator:MainViewMediator; 
		
		[Inject("projectsDAO")]
		public var projectsDAO:AbstractDAO;
		
		[Inject("reportsDAO")]
		public var reportsDAO:AbstractDAO;
		
		private var _reportCollection:ArrayCollection;
		private var _projectsCollection:ArrayCollection;
		private var _selectedReport:Reports;
		private var _sqlEvArr:Array;
		private var _columnsDictionary:Dictionary;
		private var _stateChange:Boolean;
		
		private var _homeState:String;
		public function get homeState():String {
			return _homeState;
		}
		public function set homeState( value:String ):void {
			_homeState = value;
			if( value == Utils.REPORT_INDEX ) {
				addEventListener( Event.ADDED_TO_STAGE, addedtoStage );
			} 
		}
		
		protected function addedtoStage( event:Event ):void {
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function ReportViewMediator( viewType:Class=null )
		{
			super( ReportSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():ReportSkinView {
			return _view as ReportSkinView;
		}
		
		[MediateView( "ReportSkinView" )]
		override public function setView( value:Object ):void { 
			super.setView( value );	
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
			viewState = Utils.REPORT_INDEX;
			
			//Checks if the reports are already set, otherwise just changes the stateChange Boolean and dispatches report selector Event
			if( !_reportCollection ) {
				setReportProviders();
			}
			else {
				_stateChange = true;
			}
			view.reportSelector.dispatchEvent( new IndexChangeEvent( IndexChangeEvent.CHANGE ) );
		}
		
		override protected function setRenderers():void {
			super.setRenderers();  
		} 
		
		override protected function serviceResultHandler( obj:Object, signal:SignalVO ):void {  
			if( ( signal.destination == ArrayUtil.PAGINGDAO ) && ( signal.action == Action.GETQUERYRESULT ) ) {
				_selectedReport.resultArray[ signal.id ] = obj;
				if( _sqlEvArr.indexOf( signal.id ) == ( _sqlEvArr.length - 1 ) ) {
					buildReport();
				}
			}
			if( ( signal.destination == Utils.TASKSKEY ) && ( signal.action == Action.FINDTASKSLIST ) ) {
				if( mainViewMediator.isTaskInToDo( currentInstance.mapConfig.currentProject.tasksCollection ) ) {
					currentInstance.mapConfig.isTaskInToDo = true;
					mainViewMediator.showAccordingScreen();
				}
				else {
					currentInstance.mapConfig.isTaskInToDo = false;
					controlSignal.changeStateSignal.dispatch( Utils.GENERAL_INDEX );
				}
			}
		}
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
			view.reportSelector.addEventListener( IndexChangeEvent.CHANGE, onReportSelect, false, 0, true );
			view.searchSelector.addEventListener( IndexChangeEvent.CHANGE, onSearchSelect, false, 0, true );
			view.reportGrid.addEventListener( GridEvent.GRID_CLICK, onProjectSelect, false, 0, true );
			view.pdfCreation.clicked.add(onPdfGeneration)
			view.excelCreation.clicked.add(onExcelGeneration)
		}
		
		
		private function onPdfGeneration(event:MouseEvent):void{
			var _pdfGenerator:PdfGenerator = new PdfGenerator();
			_pdfGenerator._gridHeaderData = currentInstance.mapConfig._gridHeaderText;
			_pdfGenerator._gridDataField = currentInstance.mapConfig._gridDataField;
			_pdfGenerator.createPdf(_projectsCollection)
		}
		
		private function onExcelGeneration(event:MouseEvent):void{
			var _excelGenerator:ExcelGenerator = new ExcelGenerator();
			_excelGenerator._gridHeaderData = currentInstance.mapConfig._gridHeaderText;
			_excelGenerator._gridDataField = currentInstance.mapConfig._gridDataField;
			_excelGenerator.createExcel(_projectsCollection);
		}
		
		override protected function pushResultHandler( signal:SignalVO ): void { 
		} 
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			view.reportSelector.removeEventListener( IndexChangeEvent.CHANGE, onReportSelect );
			view.searchSelector.removeEventListener( IndexChangeEvent.CHANGE, onSearchSelect );
			view.reportGrid.removeEventListener( GridEvent.GRID_CLICK, onProjectSelect );
			super.cleanup( event ); 		
		}
		
		//@TODO
		/**
		 * Create The Report only on the very first time
		 */
		
		private function setReportProviders():void {
			_columnsDictionary = new Dictionary();
			makeReportDataProvider();
			view.reportSelector.dataProvider = _reportCollection;
			view.reportSelector.selectedIndex = 0;
		}
		
		/**
		 * Report Creation only on the very first time
		 */
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
		}
		
		/**
		 * Listener of report selector checks if there any query statments attched to the report column
		 * and execute it, if not just goes to the buildReport method. 
		 */
		private function onReportSelect( event:IndexChangeEvent ):void {
			_selectedReport = view.reportSelector.selectedItem;
			_sqlEvArr = [];
			for( var i:int = 0; i < _selectedReport.booleanArray.length; i++ ) {
				var query:String = _selectedReport.booleanArray[ i ];
				if( ( query != '0' ) && ( query != '1' ) ) {
					_sqlEvArr.push( i );
					controlSignal.reportSignal.dispatch( this, _sqlEvArr[ i ], i );
				} 
			}
			if( _sqlEvArr.length == 0 ) {
				buildReport();
			}
		}
		
		/**
		 * Check if the columns for a particular report is stored in the dictionary Object
		 * if not prepares by calling buildReportProvider method,
		 */
		private function buildReport():void {
			if( _columnsDictionary.hasOwnProperty( _selectedReport.reportName ) ) {
				view.reportGrid.columns = _columnsDictionary[ _selectedReport.reportName ];
			}
			else {
				view.reportGrid.columns = buildReportProvider();
			}
			if( !_stateChange ) {
				var searchList:IList = new ArrayList();
				searchList.addItem( 'All' );
				var propertyList:IList = new ArrayList();
				for ( var i:int = 0; i < _selectedReport.headerArray.length ; i++ ) {
					searchList.addItem( _selectedReport.headerArray[ i ] );
					propertyList.addItem( _selectedReport.fieldArray[ i ] );
				}
				view.autoComplete.nameProperty = propertyList;
				view.searchSelector.dataProvider = searchList;
				view.searchSelector.selectedIndex = 0;
			}
			else {
				_stateChange = false;
			}
			makeProjectsProvider();
		}
		
		/**
		 * Prepares the GridColumns for the grid correponding to the report selected
		 */
		private function buildReportProvider():IList {
			var columnsReturn:IList = new ArrayList();	
			for ( var i:int = 0; i < _selectedReport.headerArray.length ; i++ ) {
				var dgColumn:GridColumn = new GridColumn();
				if( _selectedReport.widthArray[ i ] != 0 )	{
					dgColumn.width = _selectedReport.widthArray[ i ];	
				}
				dgColumn.itemRenderer = new ClassFactory( ReportColorRenderer );
				dgColumn.headerText = _selectedReport.headerArray[ i ];
				dgColumn.dataField = _selectedReport.fieldArray[ i ];
				columnsReturn.addItem( dgColumn );
				currentInstance.mapConfig._gridHeaderText.push(dgColumn.headerText)
				currentInstance.mapConfig._gridDataField.push(dgColumn.dataField)
			}	
			_columnsDictionary[ _selectedReport.reportName ] = columnsReturn;
			return columnsReturn;
		}
		
		/**
		 * Checks and Creates a corresponding Object for every project Object
		 * and provides the dataProvider for the grid.
		 */
		private function makeProjectsProvider():void {
			if( !_projectsCollection ) {
				_projectsCollection = new ArrayCollection();
			}
			else {
				_projectsCollection.removeAll();
			}
			
			var projectsDAOCollection:ArrayCollection = projectsDAO.collection.items as ArrayCollection;
			
			for each( var item:Projects in projectsDAOCollection ) {
				if( item.projectStatusFK != ProjectStatus.ABORTED ) {
					var reportElement:Object  = {};
					_projectsCollection.addItem( reportElement );
					reportElement.projectId = item.projectId;
					reportElement[ 'clt_date' ] = Utils.reportLabelFuction( item, 'clt_date' );
					propertyUpdate( reportElement, item );
				}
			}
			view.reportGrid.dataProvider = _projectsCollection;
			view.searchSelector.dispatchEvent( new IndexChangeEvent( IndexChangeEvent.CHANGE ) );
		}
		
		/**
		 * Assigns the values for the properties of the corresponding
		 * project object by going thro the Utils method. 
		 */
		private function propertyUpdate( item:Object, prj:Projects ):void {
			for( var i:int = 0; i < view.autoComplete.nameProperty.length; i++ ) {
				var property:String = view.autoComplete.nameProperty.getItemAt( i ) as String;
				item[ property ] = Utils.reportLabelFuction( prj, property, _selectedReport.resultArray[ i ] as ArrayCollection );
			}
		} 
		
		/**
		 * Get the Corresponding Project Object
		 */
		private function getCorresProject( index:int, collection:* ):Object {
			for each( var item:Object in collection ) {
				if( item.projectId == index ) {
					return item;
				}
			}
			return null;
		}
		
		/**
		 * On Selecting the project from the grid assigns the current projecta nd changes the state.
		 */
		private function onProjectSelect( event:GridEvent ):void {
			if( event.rowIndex != -1 ) {
				currentInstance.mapConfig.previousState = Utils.FROM_MPV;
				currentInstance.mapConfig.currentProject = getCorresProject( view.reportGrid.selectedItem.projectId, projectsDAO.collection.items as ArrayCollection );
				controlSignal.getProjectTasksSignal.dispatch( this, currentInstance.mapConfig.currentProject.projectId );
			}
		}
		
		
		/**
		 * On Selecting the search item for assigning labelField of the autoComplete component
		 */
		private function onSearchSelect( event:IndexChangeEvent ):void {
			var selectedIndex:int = view.searchSelector.selectedIndex;
			if( selectedIndex == 0 ) {
				view.autoComplete.labelField = 'All';
			}
			else {
				view.autoComplete.labelField = view.autoComplete.nameProperty.getItemAt( selectedIndex - 1 ) as String;
			}
		} 
		
		[ControlSignal(type='updateReportGridSignal')]
		public function onRefresh():void {
			makeProjectsProvider();
		}
	}
}
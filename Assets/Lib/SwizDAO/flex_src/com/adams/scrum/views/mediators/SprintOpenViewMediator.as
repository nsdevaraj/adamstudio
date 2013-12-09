package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Domains;
	import com.adams.scrum.models.vo.Events;
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.models.vo.ProfileAccessVO;
	import com.adams.scrum.models.vo.PushMessage;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Sprints;
	import com.adams.scrum.models.vo.Stories;
	import com.adams.scrum.models.vo.Tasks;
	import com.adams.scrum.models.vo.Themes;
	import com.adams.scrum.models.vo.Tickets;
	import com.adams.scrum.models.vo.Versions;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.ArrayUtil;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.ExcelGenerator;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.HtmlGenerator;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.PdfGenerator;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.SprintOpenSkinView;
	import com.adams.scrum.views.components.NativeADGrid;
	import com.adams.scrum.views.components.NativeList;
	import com.adams.scrum.views.renderers.ADTaskRenderer;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IHierarchicalCollectionView;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Alert;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.mx_internal;
	import mx.events.AdvancedDataGridEvent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	import mx.utils.ObjectUtil;
	
	import spark.events.IndexChangeEvent;
	import spark.skins.spark.DefaultItemRenderer;

	public class SprintOpenViewMediator extends AbstractViewMediator
	{
		
		private var _pdfGenerate:PdfGenerator; 
		private var _excelGenerate:ExcelGenerator; 
		private var _htmlGenerate:HtmlGenerator;
		private var _reportType:String 
		
		[SkinState(Utils.BASICSTATE)]
		[SkinState(Utils.TICKETSTATE)]
		[SkinState(Utils.TICKETDETAIL)]
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject("taskDAO")]
		public var taskDAO:AbstractDAO;
		
		[Inject("ticketDAO")]
		public var ticketDAO:AbstractDAO;
		
		[Inject("storyDAO")]
		public var storyDAO:AbstractDAO;
		
		[Inject("sprintDAO")]
		public var sprintDAO:AbstractDAO;
		
		[Inject("eventDAO")]
		public var eventDAO:AbstractDAO;
		
		[Inject("personDAO")]
		public var personDAO:AbstractDAO;		
		
		use namespace mx_internal;
		
		/**
		 * Constructor.
		 */
		public function SprintOpenViewMediator(viewType:Class=null)
		{
			super(SprintOpenSkinView); 
		}
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():SprintOpenSkinView
		{
			return _view as SprintOpenSkinView;
		}
		
		[MediateView( "SprintOpenSkinView" )]
		override public function setView(value:Object):void
		{ 
			super.setView(value);	
		}
		private var _sprintOpenState:String = new String();
		public function get sprintOpenState():String
		{
			return _sprintOpenState;
		}
		//@TODO
		public function set sprintOpenState(value:String):void
		{
			_sprintOpenState = value;
			invalidateSkinState();
			if(sprintOpenState == Utils.TICKETSTATE){
				if(view.newTicketMediator)view.newTicketMediator.sprintOpenState = currentInstance.sprintOpenState;	
				callLater(setNewTicket);
			}
			if(sprintOpenState == Utils.TICKETDETAIL){
				if(view.ticketDetailedMediator)view.ticketDetailedMediator.sprintOpenState = currentInstance.sprintOpenState;
				callLater(setTicketDetail);
			}
			if(sprintOpenState == Utils.BASICSTATE){
				view.storyTotalEstimatedTxt.text = currentInstance.currentSprint.totalEstimatedTime.toString();
				view.storyTotalDoneTxt.text = currentInstance.currentSprint.totalDoneTime.toString(); 
				view.storyTotalRemainingTxt.text = currentInstance.currentSprint.totalRemainingTime.toString(); 
			}
		}		
		private function setNewTicket():void{
			view.newTicketMediator.currentTask = selectedTask;
			view.newTicketMediator.editable = false;
		}
		private function setTicketDetail():void{
			view.ticketDetailedMediator.currentTask = selectedTask;
			var ticketSignal:SignalVO = new SignalVO(this,ticketDAO,Action.FIND_ID); 
			ticketSignal.id = selectedTask.taskId;
			signalSeq.addSignal(ticketSignal);				
		}
		override protected function getCurrentSkinState():String {
			//just return the component's current state to force the skin to mirror it
			return currentInstance.sprintOpenState;
		}
		/**
		 * The <code>init()</code> method is fired off automatically by the 
		 * AbstractViewMediator when the creation complete event fires for the
		 * corresponding ViewMediator's view. This allows us to listen for events
		 * and set data bindings on the view with the confidence that our view
		 * and all of it's child views have been created and live on the stage.
		 */
		override protected function init():void
		{
			super.init();   
			ADTaskRenderer.dataCollection = currentInstance.currentProducts.productTaskTypeArr;
			
			viewIndex = Utils.SPRINT_OPEN_INDEX;						
			//*********************************
			var themeDP:ArrayCollection = GetVOUtil.sortArrayCollection(Utils.THEMEKEY,(currentInstance.currentProducts.themeSet)) as ArrayCollection;
			themeDetails = [];
			checkNullItems( themeDP );
			
			view.sprintThemeList.validateNow();
			view.sprintThemeList.selectedIndex = 0;
			
			currentInstance.currentSprint.storySet.filterFunction = themeFilter;
			currentInstance.currentSprint.storySet.refresh();			
			//*********************************
			
			view.storyGridProvider.source = GetVOUtil.sortArrayCollection(Utils.STORYKEY,(currentInstance.currentSprint.storySet));
			view.sprintNameTxt.text = currentInstance.currentSprint.sprintLabel;
			
			currentInstance.currentSprint.totalEstimatedTime = Utils.headingTotalStoryEstimated(GetVOUtil.sortArrayCollection(Utils.STORYKEY,(currentInstance.currentSprint.storySet)));
			currentInstance.currentSprint.totalDoneTime = Utils.headingTotalStoryDone(GetVOUtil.sortArrayCollection(Utils.STORYKEY,(currentInstance.currentSprint.storySet)));
			currentInstance.currentSprint.totalRemainingTime = Utils.totalStoryRemainingTime(currentInstance.currentSprint.totalEstimatedTime,currentInstance.currentSprint.totalDoneTime);
				
			view.storyTotalEstimatedTxt.text = currentInstance.currentSprint.totalEstimatedTime.toString();
			view.storyTotalDoneTxt.text = currentInstance.currentSprint.totalDoneTime.toString(); 
			view.storyTotalRemainingTxt.text = currentInstance.currentSprint.totalRemainingTime.toString(); 
			
			//Total Story-->Task waiting,inprogress,StandBy,Finished count
			var totalTaskStatus : Array = Utils.headingTotalStoryStatus(GetVOUtil.sortArrayCollection(Utils.STORYKEY,(currentInstance.currentSprint.storySet)));
			view.totalWaitingTxt.text = totalTaskStatus[0];
			view.totalPendingTxt.text = totalTaskStatus[1];
			/*view.totalVerifyTxt.text = totalTaskStatus[2];*/
			view.totalDoneTxt.text = totalTaskStatus[3];
			
			//Total Story Status Finish or Not. If 1 story false all Status is WAITING otherwise all Story true, Status is FINISHED 
			var totalSprintStatus : Array = Utils.headingValidateStoryFinish(GetVOUtil.sortArrayCollection(Utils.STORYKEY,(currentInstance.currentSprint.storySet)));
			changeStyle( totalSprintStatus, false );
								
			view.storyList.expandAll();
			
			/*view.createExcel.visible = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.ADMIN]; 
			view.createPDF.visible = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.ADMIN]; 
			view.createHtml.visible = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.ADMIN];*/ 
			
			view.createExcel.visible = currentInstance.currentProfileAccess.reportAccessArr[ProfileAccessVO.READ]; 
			view.createPDF.visible = currentInstance.currentProfileAccess.reportAccessArr[ProfileAccessVO.READ]; 
			view.createHtml.visible = currentInstance.currentProfileAccess.reportAccessArr[ProfileAccessVO.READ];
						
			view.storyList.addEventListener(DragEvent.DRAG_DROP , dragAndDropTasks);
			
		}
		//******************************************************************************************************************
		private function expandDatagrid( event:MouseEvent ):void
		{			
			if(view.expandIcon.label == "Expand"){
				view.storyList.expandAll();
				view.expandIcon.label = "Collapse";
			}else{
				view.storyList.collapseAll();
				view.expandIcon.label = "Expand";
			}
		}
		private var currentSprint:Sprints;
		private function filterChangeHandler(ev:IndexChangeEvent):void{
			currentInstance.currentSprint.storySet.filterFunction = themeFilter;
			currentInstance.currentSprint.storySet.refresh();
			
			view.storyList.collapseAll();
			view.expandIcon.label = "Expand";
		}
		
		private function themeFilter(data:Stories):Boolean{
			var filter:Boolean;
			if(view.sprintThemeList.selectedIndex!=0){
				var selectedTheme:Themes = view.sprintThemeList.selectedItem;
				if( selectedTheme ){
					for each(var theme:Themes in data.themeSet){
						if(theme.themeId == selectedTheme.themeId){
							filter =true;
							return filter;
						}					
					}
				}
			}else{
				filter =true;
			}
			return filter;
		}
		private function themeRefreshCollection():void
		{
			themeDetails = [];
			checkNullItems( currentInstance.currentProducts.themeSet );
			view.sprintThemeList.validateNow();
			view.sprintThemeList.selectedIndex = 0;
		}
		private function checkNullItems( themeColl:ArrayCollection  ):void
		{
			currentInstance.currentSprint.storySet.refresh();
			for each( var stories :Stories in currentInstance.currentSprint.storySet )
			{
				removeTheme(stories,themeColl)
			}	
			var tempArray:Array = removeDuplicatedItems( themeDetails );
			tempArray = setFirstItemAll( tempArray );
			if(view.sprintThemeList.dataProvider)
				view.sprintThemeList.dataProvider.removeAll();
			view.sprintThemeList.dataProvider = new ArrayCollection( tempArray );
			
			if(tempArray.length == 1){
				view.sprintThemeList.enabled = false;
			}else{
				view.sprintThemeList.enabled = true;
			}
		}		
		private function removeDuplicatedItems( source:Array ):Array {
			var returnArray:Array = [];
			var str:String = "";
			for( var i:int = 0;  i < source.length; i++ ) {
				if( str.indexOf( Themes(source[ i ]).themeLbl) == -1 ) {
					returnArray.push( source[ i ] );
					str +=(Themes(source[ i ]).themeLbl+", ");
				}
			}
			return returnArray;
		}		
		private function setFirstItemAll( themeArray :Array ):Array
		{
			var themeArr:Array = new Array();
			var allThemes:Themes = new Themes();
			allThemes.themeLbl='All';
			themeArr = themeArray;			
			ArrayUtil.addElementAt(allThemes,0,themeArr);
			return themeArr;
		}
		private var themeDetails:Array = new Array();
		private function removeTheme(dataStories:Stories , themeColl:ArrayCollection ):void
		{
			var filter:Boolean;
			for each(var currentTheme:Themes in dataStories.themeSet){	
				for each(var theme:Themes in themeColl){
					if(currentTheme.themeId == theme.themeId){
						themeDetails.push(currentTheme);
					}
				}
			}
		}		
		//******************************************************************************************************************
				
		//******************************************************************************************************************
		private function dragAndDropTasks(event:DragEvent):void{
			var bulkTasksCollection:ArrayCollection = new ArrayCollection();
			var tempTask:Array = event.dragSource.dataForFormat("treeDataGridItems") as Array;
		 
			var items:Array = new Array();
			for(var i:Number = 0;i<tempTask.length;i++){
				if(tempTask[i] is Tasks)
				{
					items.push( tempTask[i] );
				}
			} 
			var droppedStories:Stories = (view.storyList._dropData.parent) as Stories;
			 
			if(droppedStories){ 
				if(event.dragInitiator == view.storyList)
				{
					view.storyList.calculateDropIndex(event);
					if( findNullParentItem(view.storyList._dropData.parent) )
					{
						event.preventDefault();
						for each( var draggedTasks:Tasks in items ){
							if(!checkItemsFound(droppedStories, draggedTasks))
							{
								var addedTask:Tasks = new Tasks();
								var propertyNames:Array = ObjectUtils.getPropNames( draggedTasks );
								for each( var str:String in propertyNames ) 
								{ 
									if(str!= taskDAO.destination)addedTask[ str ] = draggedTasks[ str ];
								}
								selectedTask = draggedTasks;
								
								addedTask = draggedTasks;
								addedTask.taskId = NaN;
								addedTask.storyFk = droppedStories.storyId;
								addedTask.taskStatusFk = Utils.taskStatusWaiting;
								addedTask.TDateCreation = new Date();
								addedTask.personFk = currentInstance.currentPerson.personId;
								addedTask.ticketCollection = new ArrayCollection();
								addedTask.fileCollection =  new ArrayCollection();
								bulkTasksCollection.addItem( addedTask );
							}else{ 
								//Alert.show(Utils.DIFFERENT_LOCATION);
								event.currentTarget.showDropFeedback(event);
							}
							view.storyList.hideDropFeedback(event);
						}
					}
					else{
						view.storyList.hideDropFeedback(event);
						event.preventDefault(); 
						event.currentTarget.showDropFeedback(event);
						//Alert.show(Utils.DIFFERENT_LOCATION);
					}		 
					var droppedTaskSignal:SignalVO = new SignalVO(this,taskDAO,Action.BULK_UPDATE);
					droppedTaskSignal.list = bulkTasksCollection; 
					signalSeq.addSignal( droppedTaskSignal );
				}
			}
			else{
				view.storyList.hideDropFeedback(event);
				event.preventDefault(); 
				event.currentTarget.showDropFeedback(event);
				//Alert.show(Utils.DIFFERENT_LOCATION);
			}	
		}
		
		/**
		 *  check whether the dropped task has
		 *  stories .
		 * */
		public function findNullParentItem(item:Object):*
		{
			if (item == null){
				return false;
			}else{
				return  true;
			}
		}
		/**
		 * check whether the dropped stories has same task
		 * or not...  
		 **/
		private function checkItemsFound( selectedStories:Stories, selectedTask:Tasks ):Boolean
		{
			var retVal:Boolean;
			for each( var task:Tasks in selectedStories.taskSet )
			{
				if(task.taskComment.toString() == selectedTask.taskComment.toString() )
				{
					retVal = true;
					break;
				}
			}
			return retVal;
		}
		
		override protected function setRenderers():void
		{
			super.setRenderers();
			view.storyRender.renderer = Utils.getCustomRenderer(Utils.SPRINTLOGSTORYRENDER);
			view.taskRender.renderer = Utils.getCustomRenderer(Utils.SPRINTLOGTASKRENDER);
								
			//view.storyList.addOnOffRendererProperty = currentInstance.currentProfileAccess.sprintAccessArr[ProfileAccessVO.EDIT];
			if((currentInstance.currentProfileAccess.isSSM) || (currentInstance.currentProfileAccess.isSTM)){
				view.storyList.addOnOffRendererProperty = true;
				view.storyList.dragEnabled = true;
				view.storyList.dropEnabled = true;
				view.storyList.dragMoveEnabled = true;
				view.storyList.allowMultipleSelection = true;
			}
			view.storyList.addStatusProperty = currentInstance.currentProfileAccess.isSSM;			
		}
		private var _mainViewStackIndex:int
		public function get mainViewStackIndex():int
		{
			return _mainViewStackIndex;
		}
		
		public function set mainViewStackIndex(value:int):void
		{
			_mainViewStackIndex = value;
			if(value == Utils.SPRINT_OPEN_INDEX){
				init();
			}
		}
		private function backToProductView( event:MouseEvent ):void
		{
			currentInstance.mainViewStackIndex = Utils.PRODUCT_OPEN_INDEX;
		}
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners();
			view.expandIcon.addEventListener(MouseEvent.CLICK,expandDatagrid);
			view.storyList.clicked.add(gridClicked); 
			view.storyList.renderSignal.add(taskHandler);
			view.splPanel.panelSignal.add(closedPanel);
			view.sConfigBtn.clicked.add(editSprintHandler);
			view.createExcel.clicked.add( getAllTickets );
			view.createPDF.clicked.add( getAllTickets );
			view.createHtml.clicked.add( getAllTickets );
			
			view.productView.clicked.add( backToProductView );
			
			view.sprintThemeList.addEventListener( IndexChangeEvent.CHANGE, filterChangeHandler );			
		}
		private function collapseItem(obj:Object):void{ 
			if(!NativeADGrid(view.storyList).isItemOpen(obj.data)){
				NativeADGrid(view.storyList).expandChildrenOf(obj.data,true) 
			}else{
				NativeADGrid(view.storyList).expandChildrenOf(obj.data,false)
			}
		}
		 
		/**
		 * Get the List Of All Tickets ....
		 */
		private function getAllTickets(event:MouseEvent):void{
			if(event.target == view.createExcel){
			_reportType = Utils.REPORT_EXCEL
			}else if(event.target == view.createHtml){
				_reportType = Utils.REPORT_HTML
			}if(event.target == view.createPDF){
				trace(" Enter Pdf File")
				_reportType = Utils.REPORT_PDF
			}
			var ticketsignal:SignalVO = new SignalVO( this, ticketDAO, Action.GET_LIST );
			signalSeq.addSignal( ticketsignal );			
		}
		
		override protected function pushResultHandler( signal:SignalVO ): void {
			if( signal.daoName == Utils.SPRINTDAO &&(( signal.description as int)== currentInstance.currentSprint.sprintId)) {		
				currentInstance.currentSprint = GetVOUtil.getVOObject( signal.description as int, sprintDAO.collection.items, sprintDAO.destination, Sprints ) as Sprints;
				init();
			}
		}
		
		private var selectedStory:Stories;
		private var selectedTask:Tasks;
		
		private function gridClicked(event:ListEvent):void{
			
		}
		
		private function taskHandler(type:String, task:Tasks,obj:Object =null):void{
			selectedStory = view.storyList.selectedItem as Stories;
			if( type == NativeList.TASKCREATED ){
				var taskSignal:SignalVO = new SignalVO(this,taskDAO,Action.CREATE);
				task.personFk = currentInstance.currentPerson.personId;
				task.visible = 1;
				taskSignal.valueObject = task; 
				signalSeq.addSignal(taskSignal);
			}
			if( type == NativeList.STORYEXPAND ){
				collapseItem(obj)
			}
			if( type == NativeList.TICKETCREATED ){
				selectedTask = task;
				currentInstance.sprintOpenState = Utils.TICKETSTATE;
			}
			if( type == NativeList.TICKETDETAIL ){
				selectedTask = task;
				
				currentInstance.sprintOpenState = Utils.TICKETDETAIL;
			} 
			if( type == NativeList.TASKLABELUPDATE ){
				selectedTask = task;
				selectedStory = GetVOUtil.getVOObject(task.storyFk,storyDAO.collection.items,storyDAO.destination,Stories) as Stories;
				var taskLabelSignal:SignalVO = new SignalVO(this,taskDAO,Action.UPDATE);
				taskLabelSignal.valueObject = task; 
				signalSeq.addSignal(taskLabelSignal);
			} 
			if( type == NativeList.TASKDELETE ){
				selectedTask = task;
				selectedStory = GetVOUtil.getVOObject(task.storyFk,storyDAO.collection.items,storyDAO.destination,Stories) as Stories;
				var taskDeleteSignal:SignalVO = new SignalVO(this,taskDAO,Action.DELETE); 
				taskDeleteSignal.valueObject = selectedTask;
				signalSeq.addSignal(taskDeleteSignal);
			}
			
			if( type == NativeList.TASKVISIBLEUPDATE )
			{
				selectedTask = task;
				selectedStory = GetVOUtil.getVOObject(task.storyFk,storyDAO.collection.items,storyDAO.destination,Stories) as Stories;
				var taskVisibleSignal:SignalVO = new SignalVO(this,taskDAO,Action.UPDATE);
				taskVisibleSignal.valueObject = selectedTask;
				signalSeq.addSignal(taskVisibleSignal);				
			}
			if( type== NativeList.TASKSTATUSUPDATE )
			{
				selectedTask = task;
				selectedStory = GetVOUtil.getVOObject(task.storyFk,storyDAO.collection.items,storyDAO.destination,Stories) as Stories;
				var currentStoryStatus:int = selectedStory.storyStatusFk;
				var storyFinished:Array=[];
				selectedStory.storyStatusFk = Utils.storyStatusStandBy;
				for each( var storyTask:Tasks in selectedStory.taskSet ){
					if( storyTask.taskStatusFk == Utils.taskStatusInProgress	|| storyTask.taskStatusFk == Utils.taskStatusStandBy){
						selectedStory.storyStatusFk = Utils.storyStatusInProgress;
						break;
					} 
					if( storyTask.taskStatusFk == Utils.taskStatusFinished ){
						storyFinished.push(true);
					}
				}
				if( storyFinished.length == selectedStory.taskSet.length ) {
					selectedStory.storyStatusFk = Utils.storyStatusFinished;
				}else if( storyFinished.length >0 ){
					selectedStory.storyStatusFk = Utils.storyStatusInProgress;
				}
				if( selectedStory.storyStatusFk != currentStoryStatus ){
					var storySignal:SignalVO = new SignalVO(this,storyDAO,Action.UPDATE);
					storySignal.valueObject = selectedStory; 
					signalSeq.addSignal(storySignal);
				}
				
				if( task.taskStatusFk == Utils.taskStatusWaiting ){
					task.onairTime = 0;
				}else if( task.taskStatusFk == Utils.taskStatusInProgress ){
					task.onairTime = 0;
				}
				
				var statusSignal:SignalVO = new SignalVO(this,taskDAO,Action.UPDATE);
				statusSignal.valueObject = task; 
				signalSeq.addSignal(statusSignal);
			}
		}
		private function changeStyle( totalStoryStatus : Array, bool:Boolean ):void
		{
			var tempStatus:int = 0;
			if((totalStoryStatus[0] == 0) && (totalStoryStatus[1] == 0)){
				view.sprintStatusTxt.styleName = Utils.getStatusSkinName(Utils.taskStatusFinished,Utils.TASK);
				tempStatus = Utils.sprintStatusFinished;
			}else if((totalStoryStatus[1] >= 1) || (totalStoryStatus[3] >= 1)){
				view.sprintStatusTxt.styleName = Utils.getStatusSkinName(Utils.taskStatusInProgress,Utils.TASK);
				tempStatus = Utils.sprintStatusInProgress;
			}else if((totalStoryStatus[1] == 0) && (totalStoryStatus[3] == 0)){
				view.sprintStatusTxt.styleName = Utils.getStatusSkinName(Utils.taskStatusWaiting,Utils.TASK);
				tempStatus = Utils.sprintStatusWaiting;
			}
			if((totalStoryStatus[0] == 0) && (totalStoryStatus[1] == 0) && (totalStoryStatus[2] == 0) && (totalStoryStatus[3] == 0)){
				view.sprintStatusTxt.styleName = Utils.getStatusSkinName(Utils.taskStatusWaiting,Utils.TASK);
				tempStatus = Utils.sprintStatusWaiting;
			}
			if((totalStoryStatus[0] == undefined) && (totalStoryStatus[1] == undefined) && (totalStoryStatus[2] == undefined) && (totalStoryStatus[3] == undefined)){
				view.sprintStatusTxt.styleName = Utils.getStatusSkinName(Utils.taskStatusWaiting,Utils.TASK);
				tempStatus = Utils.sprintStatusWaiting;
			}
			if(bool){
				if(tempStatus!=0)
				updateStatus( tempStatus );
			}
		}
		private function updateStatus( statusvalue:int ):void{
			var sprintSignal:SignalVO = new SignalVO(this,sprintDAO,Action.UPDATE);
			currentInstance.currentSprint.sprintStatusFk = statusvalue;
			sprintSignal.valueObject = currentInstance.currentSprint;
			currentInstance.currentProducts.storyCollection.refresh();
			signalSeq.addSignal( sprintSignal );
		}
		private var gotoSprint:Boolean
		private function editSprintHandler(ev:MouseEvent):void{
			gotoSprint = true;
			exitModule();
		}
		private function exitModule():void{
			var storyEffortSignal:SignalVO = new SignalVO(this,storyDAO,Action.BULK_UPDATE);
			storyEffortSignal.list = currentInstance.currentSprint.storySet; 
			signalSeq.addSignal(storyEffortSignal); 
		}
		
		private function closedPanel():void{
			gotoSprint = false;
			exitModule(); 
		}
		private var reportsGenerate:String = '';
		private var bulkUpdateColl:ArrayCollection = new ArrayCollection();
		override protected function serviceResultHandler(obj:Object,signal:SignalVO):void {
			var currentProductId:int = (currentInstance.currentProducts!=null)?currentInstance.currentProducts.productId:0;
			var currentSprintId:int = (currentInstance.currentSprint!=null)?currentInstance.currentSprint.sprintId:0;
			var currentStoryId:int = (selectedStory!=null)?selectedStory.storyId:0;
			
			if( signal.destination == taskDAO.destination ){
				if( signal.action == Action.CREATE ){
					Utils.addArrcStrictItem(obj,selectedStory.taskSet,taskDAO.destination);
					Utils.addArrcStrictItem(selectedStory,currentInstance.currentSprint.storySet,storyDAO.destination,true);
					view.storyList.validateNow();
					view.storyList.expandAll();
					var addedTasks:Tasks = obj as Tasks;
					var eventsSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusTaskCreate,String(addedTasks.taskComment).substr(0,4)+" "+Utils.TASK_CREATE,currentInstance.currentPerson.personId,addedTasks.taskId,currentProductId,currentSprintId,currentStoryId);
					signalSeq.addSignal(eventsSignal);
				}
				if( signal.action == Action.UPDATE ){ 
					Utils.addArrcStrictItem(selectedTask,selectedStory.taskSet,taskDAO.destination, true);
					var updateTasks:Tasks = obj as Tasks;
					var eventsUpdateSignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusTaskUpdate,String(updateTasks.taskComment).substr(0,4)+" "+Utils.TASK_UPDATE,currentInstance.currentPerson.personId,selectedTask.taskId,currentProductId,currentSprintId,currentStoryId);
					signalSeq.addSignal(eventsUpdateSignal);
				}	
				if( signal.action == Action.DELETE ){ 
					Utils.removeArrcItem(selectedTask,selectedStory.taskSet,Utils.TASKKEY);
					Utils.addArrcStrictItem(selectedStory,currentInstance.currentSprint.storySet,storyDAO.destination,true);
					view.storyList.dataProvider.removeChild( view.storyList.dataProvider.getParentItem(view.storyList.selectedItem), view.storyList.selectedItem );
					view.storyList.validateNow();
					view.storyList.expandAll();
				}
				if( signal.action == Action.BULK_UPDATE ){
					for each ( var droppedTask:Tasks in obj){
						view.storyList.addChildItem(view.storyList._dropData.parent, droppedTask,view.storyList._dropData.index);
					}
					view.storyList.validateNow();
					view.storyList.expandAll();
				}
				currentInstance.currentSprint.totalEstimatedTime = Utils.headingTotalStoryEstimated(GetVOUtil.sortArrayCollection(Utils.STORYKEY,(currentInstance.currentSprint.storySet)));
				currentInstance.currentSprint.totalDoneTime = Utils.headingTotalStoryDone(GetVOUtil.sortArrayCollection(Utils.STORYKEY,(currentInstance.currentSprint.storySet)));
				currentInstance.currentSprint.totalRemainingTime = Utils.totalStoryRemainingTime(currentInstance.currentSprint.totalEstimatedTime,currentInstance.currentSprint.totalDoneTime);
				
				view.storyTotalEstimatedTxt.text = currentInstance.currentSprint.totalEstimatedTime.toString();
				view.storyTotalDoneTxt.text = currentInstance.currentSprint.totalDoneTime.toString(); 
				view.storyTotalRemainingTxt.text = currentInstance.currentSprint.totalRemainingTime.toString();
				
				//Total Story-->Task waiting,inprogress,StandBy,Finished count
				var totalTaskStatus : Array = Utils.headingTotalStoryStatus(GetVOUtil.sortArrayCollection(Utils.STORYKEY,(currentInstance.currentSprint.storySet)));
				view.totalWaitingTxt.text = totalTaskStatus[0];
				view.totalPendingTxt.text = totalTaskStatus[1];
				/*view.totalVerifyTxt.text = totalTaskStatus[2];*/
				view.totalDoneTxt.text = totalTaskStatus[3];
				
				//Total Story Status Finish or Not. If 1 story false all Status is WAITING otherwise all Story true, Status is FINISHED 
				var totalSprintStatus : Array = Utils.headingValidateStoryFinish(GetVOUtil.sortArrayCollection(Utils.STORYKEY,(currentInstance.currentSprint.storySet)));
				changeStyle( totalSprintStatus, true );
				
				var receivers:Array = GetVOUtil.getSprintMembers(currentInstance.currentSprint,currentInstance.currentPerson.personId);
				var pushMessage:PushMessage = new PushMessage( Description.CREATE, receivers, currentInstance.currentSprint.sprintId );
				var pushSignal:SignalVO = new SignalVO( this, sprintDAO, Action.PUSH_MSG, pushMessage );
				signalSeq.addSignal( pushSignal );
			}
			if( signal.destination == ticketDAO.destination ){
				if( signal.action == Action.FIND_ID ){ 
					for each(var selectedticket:Tickets in obj){
						Utils.addArrcStrictItem(selectedticket,selectedTask.ticketCollection,ticketDAO.destination);
					}
					view.ticketDetailedMediator.dataProvider = selectedTask.ticketCollection;
				}
				if( signal.action == Action.GET_LIST ){ 
					currentInstance.currentTicketsCollection = GetVOUtil.sortArrayCollection( ticketDAO.destination, ( ticketDAO.collection.items ) ) as ArrayCollection;
					if(Utils.REPORT_EXCEL ==_reportType)
					{
						_excelGenerate = new ExcelGenerator();
						_excelGenerate.createExcel(currentInstance.currentSprint.storySet ,currentInstance.currentSprint, currentInstance.currentTicketsCollection  , ArrayCollection( personDAO.collection.items),
							view.timeSheetDate.selectedDate,view.timeSheetBtn.selected);
					}
					if(Utils.REPORT_HTML ==_reportType)
					{
						_htmlGenerate = new HtmlGenerator();
						_htmlGenerate.createHtml( currentInstance.currentSprint.storySet ,currentInstance.currentSprint, currentInstance.currentTicketsCollection  , ArrayCollection( personDAO.collection.items),
							view.timeSheetDate.selectedDate,view.timeSheetBtn.selected );
					}
					if(Utils.REPORT_PDF ==_reportType)
					{
						_pdfGenerate = new PdfGenerator();
						_pdfGenerate.createPdf( currentInstance.currentSprint.storySet ,currentInstance.currentSprint, currentInstance.currentTicketsCollection  , ArrayCollection( personDAO.collection.items),
							view.timeSheetDate.selectedDate , view.timeSheetBtn.selected)
					}
				}
			}
			
			if( signal.destination == storyDAO.destination ){
				if( signal.action == Action.UPDATE ){
					var updateStories:Stories = obj as Stories;				
					var eventsStorySignal:SignalVO = Utils.createEvent(this,eventDAO,Utils.eventStatusStoryUpdate,updateStories.IWantToLabel+" "+Utils.STORY_UPDATE,currentInstance.currentPerson.personId,0,currentProductId,currentSprintId,currentStoryId);
					signalSeq.addSignal(eventsStorySignal);
				}
				if( signal.action == Action.BULK_UPDATE ){
					if(gotoSprint){
						currentInstance.mainViewStackIndex = Utils.SPRINT_EDIT_INDEX;
					}else{
						currentInstance.mainViewStackIndex = Utils.HOME_INDEX;
					}
					cleanup(null);
				}
			}
		}
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void
		{
			super.cleanup(event);
			view.storyList.clicked.removeAll(); 
			view.storyList.renderSignal.removeAll();
			view.splPanel.panelSignal.removeAll();
			view.sConfigBtn.clicked.removeAll();
		} 

		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */		
		override protected function gcCleanup( event:Event ):void
		{
			if(viewIndex!= Utils.SPRINT_OPEN_INDEX)cleanup(event);
		}
	}
}
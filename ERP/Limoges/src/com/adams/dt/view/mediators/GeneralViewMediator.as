/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.view.mediators
{ 
	import com.adams.dt.BootStrapCommand;
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.model.vo.*;
	import com.adams.dt.signal.ControlSignal;
	import com.adams.dt.util.ProcessUtil;
	import com.adams.dt.util.ProjectUtil;
	import com.adams.dt.util.PropertyUtil;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.GeneralSkinView;
	import com.adams.dt.view.components.FileUploadTileList;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.ArrayUtil;
	import com.adams.swizdao.util.EncryptUtil;
	import com.adams.swizdao.util.GetVOUtil;
	import com.adams.swizdao.util.StringUtils;
	import com.adams.swizdao.views.components.NativeButton;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IViewCursor;
	import mx.collections.Sort;
	import mx.controls.Label;
	import mx.managers.PopUpManager;
	
	import spark.components.Button;
	import spark.utils.TextFlowUtil;
	
	
	public class GeneralViewMediator extends AbstractViewMediator
	{ 		 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject("Basic")]
		public var fileUploadTileList:FileUploadTileList;
		
		[Inject("personsDAO")]
		public var personDAO:AbstractDAO;	
		
		[Inject("companiesDAO")]
		public var companyDAO:AbstractDAO;
		
		[Inject("categoriesDAO")]
		public var categoryDAO:AbstractDAO;
		
		[Inject("profilesDAO")]
		public var profileDAO:AbstractDAO;
		
		[Inject("projectsDAO")]
		public var projectDAO:AbstractDAO;
		
		[Inject("filedetailsDAO")]
		public var filedetailsDAO:AbstractDAO; 
		
		[Inject("propertiespresetsDAO")]
		public var propertiespresetsDAO:AbstractDAO;
		
		[Inject("proppresetstemplatesDAO")]
		public var propPresettemplateDAO:AbstractDAO;
		
		[Inject("presetstemplatesDAO")]
		public var presettemplateDAO:AbstractDAO;	
		
		private var categoriescoll:ArrayCollection;
		private var categoriesVo:Categories;
		private static var sort:Sort;
		private static var dp:ArrayCollection;
		private static var cursor:IViewCursor;
		private static var found:Boolean;
		private var selectedProject:Projects;
		
		private var _urlLinkDetails:String;
		private var _mailperson:Persons;
		
		private var _homeState:String;
		private var isBackButton:Boolean;		
		private var statusIndex:int;
		private var _selectedBtnID:String;
		
		private var propfieldNames:Array;
		private var projNames:Array;
		private var selectedProjName:String;
		private var currentProjectStandBy:Boolean = true;
		
		public function get homeState():String
		{
			return _homeState;
		}
		
		public function set homeState(value:String):void
		{
			_homeState = value;
			if(value==Utils.GENERAL_INDEX) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		
		protected function addedtoStage(ev:Event):void{
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function GeneralViewMediator( viewType:Class=null )
		{
			super( GeneralSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():GeneralSkinView 	{
			return _view as GeneralSkinView;
		}
		
		[MediateView( "GeneralSkinView" )]
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
			view.currentState = Utils.GENERAL_INDEX;
			viewState = Utils.GENERAL_INDEX;
			
			PropertyUtil.formModified = false;
			PropertyUtil.formModifiedArr = [];
			propfieldNames = [];
			for each(var propPresets:Propertiespresets in propertiespresetsDAO.collection.items){
				propfieldNames.push(propPresets.fieldName);
			}
			projNames =[];
			for each(var proj:Projects in projectDAO.collection.filteredItems){
				projNames.push(proj.projectName);
			}
			
			view.fileTile.addElement(fileUploadTileList);
			fileUploadTileList.componentType = "default";
			fileUploadTileList.fileType = Utils.BASICFILETYPE;
			callLater(fileUploadTileList.resetUploader);
			
			setProjectProperties();
			giveSchedulerInput(currentInstance.mapConfig.currentProject.tasksCollection)
			
			if( currentInstance.mapConfig.currentProject ) {
				if( ( currentInstance.mapConfig.currentProject.projectStatusFK == ProjectStatus.STANDBY ) || ( currentInstance.mapConfig.currentProject.projectStatusFK == ProjectStatus.ARCHIVED )|| ( currentInstance.mapConfig.currentProject.projectStatusFK == ProjectStatus.ABORTED )  ) {
					currentProjectStandBy = false;
				}
				else {
					currentProjectStandBy = true;
				}
			}	
			
			var commentStr:String = ''; 
			if( Projects( currentInstance.mapConfig.currentProject ).finalTask ) {
				if( Projects( currentInstance.mapConfig.currentProject ).finalTask.previousTask ) {
					if( Projects( currentInstance.mapConfig.currentProject ).finalTask.previousTask.taskComment ) {
						commentStr = Projects( currentInstance.mapConfig.currentProject ).finalTask.previousTask.taskComment.toString();
					}
				}
			}	
			
			if( currentInstance.mapConfig.currentProject.projectStatusFK == ProjectStatus.STANDBY ) {
				view.standByBtn.label = Utils.RESUME;
			}
			else {
				view.standByBtn.label = Utils.STANDBY;
			}
			
			resetStandBy( currentProjectStandBy );
			
			view.previousComments.textFlow = TextFlowUtil.importFromString( commentStr );
			setProjectStatus( currentInstance.mapConfig.currentProject.projectStatusFK );
			
			controlSignal.getProjectFilesSignal.dispatch( this, currentInstance.mapConfig.currentProject.projectId );
			
			visibleScreen( currentInstance.mapConfig.isTaskInToDo );				
			
			view.validateDeadLine.enabledDate = false;
			view.validateDeadLine.visible = false;
			
			var _validatePropPj:Propertiespj =   Utils.propertyPjForFieldName( 'bat_date', currentInstance.mapConfig.currentProject.propertiespjSet );
			if(_validatePropPj)
			{
				if(_validatePropPj.fieldValue !="NULL" ){
					view.rejectedBtn.visible = false;
					view.acceptBtn.visible = false;
					view.validateDeadLine.visible =true;
					view.validateDeadLine.selectedDate = new Date( _validatePropPj.fieldValue );
				}
			}
			if(ProcessUtil.isCLT){
				view.rejectedBtn.visible = false;
				view.acceptBtn.visible = false;  
				disablePersonSelection(false)
			}
			view.requestedDeadLine.enabledDate = false;
			var _requestedPropertiesPj:Propertiespj =   Utils.propertyPjForFieldName( 'clt_date', currentInstance.mapConfig.currentProject.propertiespjSet );
			if(_requestedPropertiesPj)
			{
				if(_requestedPropertiesPj.fieldValue !="NULL"){
					view.requestedDeadLine.selectedDate = new Date( _requestedPropertiesPj.fieldValue );
				}
			}
		}		
		
		protected function fileProperties():void {
			fileUploadTileList.componentType = "default";
			fileUploadTileList.fileType = Utils.BASICFILETYPE;
			fileUploadTileList.resetUploader();
		}
		
		protected function disablePersonSelection(enable:Boolean):void{
			view.chp_validation.enabled = enable; 
			view.comm_validation.enabled = enable;
			view.cpp_validation.enabled = enable; 
			view.ind_validation.enabled = enable;
			view.agn_validation.enabled = enable; 
			view.imp_validation.enabled = enable;
			view.industry_supplier.enabled = enable;
			view.industry_estimate.enabled = enable;
		}
		
		protected function resetStandBy( enable:Boolean ):void {	
			view.previousComments.enabled = enable; 
			view.chp.enabled = enable;  
			disablePersonSelection(enable);
			if( ProcessUtil.isCLT ) {
				disablePersonSelection( false );
			}
			view.comm.enabled = enable; 
			view.fileTile.enabled = enable;  
			view.cpp.enabled = enable; 
			view.ind.enabled = enable;
			view.department.enabled = enable;
			view.agn.enabled = enable;  
			view.imp.enabled = enable;
			view.standByBtn.enabled = enable;
			if( view.standByBtn.label == Utils.RESUME &&  currentInstance.mapConfig.currentProject.projectStatusFK == ProjectStatus.STANDBY ) {
				view.standByBtn.enabled = true;
			}			
			view.requestedDeadLine.enabled = enable;
			view.acceptBtn.enabled = enable;
			view.rejectedBtn.enabled = enable;
			view.validateDeadLine.enabled = enable;
			view.previousNavigationId.enabled = enable; 
			view.waiting.enabled = enable;
			view.in_progress.enabled = enable; 
			view.in_photoshop.enabled = enable; 
			view.in_illustrator.enabled = enable; 
			view.in_checking.enabled = enable;
			view.in_delivery.enabled = enable;
			view.nextNavigationId.enabled = enable;
		} 
		
		protected function setProjectProperties():void {
			var categoriescoll:ArrayCollection  = categoryDAO.collection.filteredItems as ArrayCollection;
			categoriescoll.filterFunction = ProcessUtil.getDomainsOnly;
			categoriescoll.refresh();
			callLater(fileUploadTileList.resetUploader);
			updateProperties();
			view.refId.dataProvider = ArrayCollection ( projectDAO.collection.filteredItems );
			view.domainLbl.text = currentInstance.mapConfig.currentProject.categories.domain.categoryName;
		}
		
		private function visibleScreen( bool:Boolean ):void {
			view.previousNavigationId.visible = bool;
			view.nextNavigationId.visible = bool;
			if( currentInstance.mapConfig.currentTasks ) {
				view.previousNavigationId.label = Tasks( currentInstance.mapConfig.currentTasks ).workflowtemplateFK.optionPrevLabel;
				view.nextNavigationId.label = Tasks( currentInstance.mapConfig.currentTasks ).workflowtemplateFK.optionNextLabel;
			}
			if( currentInstance.mapConfig.currentTasks ) {
				if( ( currentInstance.mapConfig.currentTasks.workflowtemplateFK.taskCode == Utils.NEWORDER_CORRECTION_SCREEN ) ||
					( currentInstance.mapConfig.currentTasks.workflowtemplateFK.taskCode == Utils.CORRECTIONS_BACK_SCREEN ) ) {
					view.previousNavigationId.visible = false;
					view.nextNavigationId.visible = false;
				}
			}
		} 		
		
		public function updateProperties():void {
			var currentProjObject:Object = {};
			var formIds:Array = PropertyUtil.getFormIDs( view.genralForm );
			if(currentInstance.mapConfig.currentProject){
				view.refId.text = currentInstance.mapConfig.currentProject.projectName;
			}
			PropertyUtil.propertyUpdate( currentProjObject,formIds, propfieldNames, propertiespresetsDAO.collection, propPresettemplateDAO.collection ,currentInstance.mapConfig.currentProject );
			PropertyUtil.setUpForm( currentProjObject,view.genralForm, propfieldNames );
		}
		
		private function getPropertyPjSet( propertyCollection:Array):Array {
			var propArr:Array = [];
			for( var i:int = 0; i < propertyCollection.length; i++ ) {
				var property:String = propertyCollection[i] as String;
				if(propfieldNames.indexOf(property)!=-1) {
					propArr.push(property);
				}
			}
			return propArr;
		} 
		
		private function getPropertiespjSet():ArrayCollection {
			var arrC:ArrayCollection; 
			if(currentInstance.mapConfig.currentProject){
				arrC = currentInstance.mapConfig.currentProject.propertiespjSet;
			}else{
				arrC = new ArrayCollection();
			}
			arrC = PropertyUtil.getFormValues(getPropertyPjSet(PropertyUtil.getFormIDs(view.genralForm)),view.genralForm,arrC);
			return arrC;			
		}  
		
		protected function onProjectSelection( event:Event =null ): void {
			if(projNames.indexOf(view.refId.text)!=-1 && selectedProjName != view.refId.text){
				selectedProjName = view.refId.text;
				var labelField:String = view.refId.labelField;
				var getSelectedProject:Projects = new Projects();
				getSelectedProject[labelField] = view.refId.text;
				currentInstance.mapConfig.currentProject =  projectDAO.collection.findExistingPropItem( getSelectedProject,labelField ) as Projects;
				updateProperties();
			}
		}
		
		override protected function setRenderers():void {
			super.setRenderers();  
		} 
		
		override protected function serviceResultHandler( obj:Object, signal:SignalVO ):void {  
			if( signal.action == Action.CREATE && signal.destination == Utils.TASKSKEY ){
				var createdTask:Tasks = obj as Tasks;
				if( createdTask.deadlineTime != 0 ) {
					onCloseDeadlineHandler();
				}
			} 
			
			if( ( signal.action == Action.CREATENAVTASK ) && ( signal.destination == ArrayUtil.PAGINGDAO ) ) {
				//For updating the previous task's status on navigational task creation ( Done By Deepan )
				if( currentInstance.mapConfig.currentTasks ) {
					Tasks( currentInstance.mapConfig.currentTasks ).taskStatusFK = TaskStatus.FINISHED;
				}
				controlSignal.changeStateSignal.dispatch( Utils.TASKLIST_INDEX ); 
			} 
			
			if( signal.destination == Utils.FILEDETAILSKEY ) {				
				if( signal.action == Action.FIND_ID ) {	
					var projectFileCollection:ArrayCollection = new ArrayCollection();
					for each( var itemFiles:FileDetails in signal.currentProcessedCollection ) {
						if( itemFiles.visible ) {
							projectFileCollection.addItem( itemFiles );
						}
					}
					fileUploadTileList.fileListDataProvider = projectFileCollection;
					fileUploadTileList.fileListDataProvider.refresh();
					fileUploadTileList.onDataChange();
				} 
			} 
		}
		
		protected function clickProjectStatusHandler( event:MouseEvent ):void {
			var statusObj:NativeButton = event.currentTarget as NativeButton;
			event.stopImmediatePropagation();
			if( statusObj.getStyle( 'backgroundColor' ) != 'Green' ) {
				switch( statusObj ) {
					case view.waiting:
						currentInstance.mapConfig.currentProject.projectStatusFK = ProjectStatus.WAITING;
						statusIndex = view.statusGroup.getElementIndex( view.waiting );
						break;
					case view.in_progress:
					case view.in_photoshop:	
						currentInstance.mapConfig.currentProject.projectStatusFK = ProjectStatus.INPROGRESS;
						statusIndex = view.statusGroup.getElementIndex( view.in_progress );
						break;
					case view.in_illustrator:
						currentInstance.mapConfig.currentProject.projectStatusFK = ProjectStatus.INPROGRESS_ILLUSTRATOR;
						statusIndex = view.statusGroup.getElementIndex( view.in_progress );
						break;
					case view.in_checking:
						currentInstance.mapConfig.currentProject.projectStatusFK = ProjectStatus.INCHECKING;
						statusIndex = view.statusGroup.getElementIndex( view.in_checking );
						break;
					case view.in_delivery:
						currentInstance.mapConfig.currentProject.projectStatusFK = ProjectStatus.INDELIVERY;
						statusIndex = view.statusGroup.getElementIndex( view.in_delivery );
						break;
					default:
						break;
				}
				setProjectStatus( currentInstance.mapConfig.currentProject.projectStatusFK );
				controlSignal.updateProjectSignal.dispatch( this, currentInstance.mapConfig.currentProject );
			}
		}
		
		protected function setProjectStatus( statusFk:int ):void {
			var selectedStatus:String = "statusSelectedIcon";
			switch( statusFk ) {
				case ProjectStatus.WAITING:
					view.waiting.styleName = selectedStatus;
					statusIndex = view.statusGroup.getElementIndex( view.waiting );
					break;
				case ProjectStatus.INPROGRESS:
					view.in_progress.styleName = selectedStatus;
					view.in_photoshop.styleName = selectedStatus;
					statusIndex = view.statusGroup.getElementIndex( view.in_progress );
					break;
				case ProjectStatus.INPROGRESS_ILLUSTRATOR:
					view.in_photoshop.styleName = 'statusNormalIcon';
					view.in_progress.styleName = selectedStatus;
					view.in_illustrator.styleName = selectedStatus;
					statusIndex = view.statusGroup.getElementIndex( view.in_progress );
					break;
				case ProjectStatus.INCHECKING:
					view.in_checking.styleName = selectedStatus;
					statusIndex = view.statusGroup.getElementIndex( view.in_checking );
					break;
				case ProjectStatus.INDELIVERY:
					view.in_delivery.styleName = selectedStatus;
					statusIndex = view.statusGroup.getElementIndex( view.in_delivery );
					break;
				default:
					break;
			}
			setDeselectStatus();
			setEnabledStatus( statusFk );
		}
		protected function setDeselectStatus():void {
			for( var i:int = 0; i < view.statusGroup.numElements; i++ ) {
				if( i != statusIndex ) {
					NativeButton( view.statusGroup.getElementAt( i ) ).styleName = "statusNormalIcon";
				}
			}
			if( currentInstance.mapConfig.currentProject.projectStatusFK != ProjectStatus.INPROGRESS && currentInstance.mapConfig.currentProject.projectStatusFK != ProjectStatus.INPROGRESS_ILLUSTRATOR ) {
				view.in_photoshop.styleName = 'statusNormalIcon';
				view.in_illustrator.styleName = 'statusNormalIcon';
			}
		}
		protected function setEnabledStatus( statusFk:int ):void {
			if( statusFk == ProjectStatus.INDELIVERY ){
				view.nextNavigationId.enabled = true;
			}else{
				view.nextNavigationId.enabled = false;
			}
		}
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
			view.previousNavigationId.clicked.add( createNavigationCommentTask );
			view.nextNavigationId.clicked.add( createNavigationCommentTask );
			view.refId.inputTxt.addEventListener( KeyboardEvent.KEY_DOWN, onProjectSelection, false, 0, true );
			view.refId.inputTxt.addEventListener( Event.CHANGE, onProjectSelection, false, 0, true );
			
			if(!ProcessUtil.isCLT){
				view.waiting.clicked.add( clickProjectStatusHandler );
				view.in_progress.clicked.add( clickProjectStatusHandler );
				view.in_photoshop.clicked.add( clickProjectStatusHandler );
				view.in_illustrator.clicked.add( clickProjectStatusHandler );
				view.in_checking.clicked.add( clickProjectStatusHandler );
				view.in_delivery.clicked.add( clickProjectStatusHandler );
				
				view.chp.addEventListener( MouseEvent.CLICK,onPersonSelection );
				view.cpp.addEventListener( MouseEvent.CLICK,onPersonSelection );
				view.agn.addEventListener( MouseEvent.CLICK,onPersonSelection );
				view.comm.addEventListener( MouseEvent.CLICK,onPersonSelection );
				view.ind.addEventListener( MouseEvent.CLICK,onPersonSelection );
				view.imp.addEventListener( MouseEvent.CLICK,onPersonSelection ); 
				view.ind1.addEventListener( MouseEvent.CLICK,onPersonSelection ); 
				view.ind2.addEventListener( MouseEvent.CLICK,onPersonSelection ); 
				
				
			}
			view.rejectedBtn.clicked.add( messageHandler );
			view.acceptBtn.addEventListener( MouseEvent.CLICK , onAcceptDateDateHandler );	
			view.standByBtn.clicked.add( onStandByHandler );
			view.planningHeader.addEventListener(MouseEvent.CLICK,showHidePlanning)
			checkMessageView();
			
		}
		private function showHidePlanning(event:MouseEvent):void{
			if(view.currentState == Utils.PLANNING_INDEX){
				view.currentState = Utils.GENERAL_INDEX;
			}else{
				view.currentState = Utils.PLANNING_INDEX;
			}
		}
		/**
		 * 
		 * */
		protected function checkMessageView():void
		{
			for each( var messageTask:Tasks in  currentInstance.mapConfig.currentProject.tasksCollection )
			{
				if(messageTask.deadlineTime==1)
				{
					view.rejectedBtn.visible = false;
					view.acceptBtn.visible = false;
				}else{
					view.rejectedBtn.visible = true;
					view.acceptBtn.visible = true;
				}
			}
			
		}
		/**
		 * 
		 * */
		protected function onStandByHandler ( event:MouseEvent ):void
		{
			if(view.standByBtn.label == Utils.STANDBY){
				controlSignal.showAlertSignal.dispatch(this,Utils.STANDBY_PROJECT,Utils.APPTITLE,0,Utils.STANDBY_PROJECT);
			}else if(view.standByBtn.label == Utils.RESUME){
				controlSignal.showAlertSignal.dispatch(this,Utils.RESUME_PROJECT,Utils.APPTITLE,0,Utils.RESUME_PROJECT);
			}
		}
		override public function alertReceiveHandler(obj:Object):void {
			var messageStatus:String;
			var objArray:Array;
			if( obj == Utils.STANDBY_PROJECT) {
				currentInstance.mapConfig.currentProject.projectStatusFK = ProjectStatus.STANDBY;
				messageStatus =	currentInstance.mapConfig.currentPerson.personFirstname+
					Utils.SEPERATOR+Utils.PROJECT_STANDBY+
					Utils.SEPERATOR+currentInstance.mapConfig.currentPerson.personId+","+
					currentInstance.mapConfig.currentPerson.defaultProfile;;
				objArray = ProjectUtil.standByProject( currentInstance.mapConfig.currentProject ,
					currentInstance.mapConfig.currentProject.workflowFK,
					currentInstance.mapConfig.currentProject.projectStatusFK,messageStatus,
					currentInstance.mapConfig.currentPerson.personId );
				controlSignal.modifyProjectStatusSignal.dispatch(this, objArray );
			}else if( obj == Utils.RESUME_PROJECT) {
				currentInstance.mapConfig.currentProject.projectStatusFK = ProjectStatus.INPROGRESS;
				messageStatus = currentInstance.mapConfig.currentPerson.personFirstname+
					Utils.SEPERATOR+Utils.PROJECT_RESUME+
					Utils.SEPERATOR+currentInstance.mapConfig.currentPerson.personId+","+
					currentInstance.mapConfig.currentPerson.defaultProfile;;
				objArray = ProjectUtil.standByProject( currentInstance.mapConfig.currentProject ,
					currentInstance.mapConfig.currentProject.workflowFK,
					currentInstance.mapConfig.currentProject.projectStatusFK,messageStatus,
					currentInstance.mapConfig.currentPerson.personId );
				controlSignal.modifyProjectStatusSignal.dispatch(this, objArray );
			}  
		}
		/**
		 * 
		 * */
		protected function onPersonSelection ( event:MouseEvent ):void
		{
			view.currentState = Utils.PERSONSELECTION_INDEX;
			view.personselection.personListCollection = ArrayCollection( personDAO.collection.filteredItems );
			view.personselection.sortedProfile = getPersonDefaultProfile( event.currentTarget as NativeButton );
			view.personselection.selectionCloseSignal.add( onGridClickHandler );
			view.personselection.homeState = Utils.PERSONSELECTION_INDEX; 
		}
		/**
		 *  
		 * */
		protected function getPersonDefaultProfile(btn:NativeButton):int{
			var personDefaultPro:int
			switch(btn)
			{
				case view.chp:
					personDefaultPro = getProfileFromPerson( Utils.PERSON_COMMERCIAL );
					break;
				case view.ind1:
					personDefaultPro = getProfileFromPerson( Utils.PERSON_COMMERCIAL );
					break;
				case view.cpp:
					personDefaultPro = getProfileFromPerson( Utils.PERSON_CHEFPRODUIT );
					break;
				case view.agn:
					personDefaultPro = getProfileFromPerson( Utils.PERSON_APM );
					break;
				case view.comm:
					personDefaultPro = getProfileFromPerson( Utils.PERSON_COMMERCIAL );
					break;
				case view.ind2:
					personDefaultPro = getProfileFromPerson( Utils.PERSON_COMMERCIAL );
					break;
				case view.ind:
					personDefaultPro = getProfileFromPerson( Utils.PERSON_CHEFPRODUIT );
					break;
				case view.imp:
					personDefaultPro = getProfileFromPerson( Utils.PERSON_APM );
					break;
			}
			_selectedBtnID = btn.id;
			return personDefaultPro;
		}
		protected function getProfileFromPerson( profLabel:String ):int
		{
			var retProfileId:int;
			var profileArr:ArrayCollection = profileDAO.collection.filteredItems  as ArrayCollection
			for each( var profile:Profiles in profileArr)
			{
				if( profile.profileCode == profLabel )
				{
					retProfileId = profile.profileId;
					break;
				}
			}
			return retProfileId;
		}
		protected function onGridClickHandler ( pop:PersonSelectionViewMediator, name:String ):void {
			if(_selectedBtnID == "ind1" && name !='')
			{
				view.industry_estimate.text = name;
			}else if(_selectedBtnID == "ind2" && name !='')
			{
				view.industry_supplier.text = name;
			}else if (name !=''){
				view[ _selectedBtnID + '_validation' ].text = name;
			}
			view.currentState = Utils.GENERAL_INDEX;
		}
		
		
		
		protected function getMessageTemplate(pro:int):Workflowstemplates {
			var workTemp:Workflowstemplates;
			var messageTemplateCollection:ArrayCollection = currentInstance.mapConfig.messageTemplatesCollection;
			for each(var item:Workflowstemplates in  messageTemplateCollection){
				if(item.profileFK == pro){
					workTemp =  item;
					break;
				}
			}
			return workTemp;
		} 		
		
		protected function createNavigationCommentTask( event:MouseEvent ):void {
			view.currentState = Utils.NAVIGATECOMMENT_INDEX;
			view.navigateCommentWindow.closeButton.addEventListener( MouseEvent.CLICK, onCloseNavHandler );
			view.navigatecommentId.selectionCloseSignal.add( onCloseNavHandler );
			view.navigatecommentId.storedNativeButton = NativeButton( event.currentTarget );
		}
		
		public function modifiedProperties():String {
			var propChangedColl:ArrayCollection = getPropertiespjSet();
			var propertiesChangedColl:ArrayCollection = new ArrayCollection();
			if( PropertyUtil.formModified ) {
				if( PropertyUtil.formModifiedArr.length != 0 ) {
					for( var i:int = 0; i < PropertyUtil.formModifiedArr.length;i++ ) {
						propertiesChangedColl.addItem( PropertyUtil.formModifiedArr[ i ] );
					}
				}
				else {
					propertiesChangedColl = new ArrayCollection();
				}
			}
			return Utils.pjParameters( propertiesChangedColl );
		}
		
		protected function onCloseNavHandler ( event:Event = null ):void {
			view.currentState = Utils.GENERAL_INDEX;
		} 
		
		protected function onAcceptDateDateHandler ( event :MouseEvent ):void {
			var approvedTask:Tasks = new Tasks();
			approvedTask.deadlineTime = 0;
			approvedTask.projectFk = currentInstance.mapConfig.currentProject.projectId; 
			approvedTask.previousTask = currentInstance.mapConfig.currentTasks;
			approvedTask.projectObject = currentInstance.mapConfig.currentProject;
			approvedTask.domainDetails = currentInstance.mapConfig.currentProject.categories.categoryFK.categoryFK;
			approvedTask.taskFilesPath = currentInstance.mapConfig.currentPerson.personId + "," + currentInstance.mapConfig.currentPerson.defaultProfile;
			approvedTask.tDateCreation = new Date();
			
			var approvedComments:String = Utils.TRAFFIC_ACCEPTED_DATE + view.requestedDeadLine.selectedDate.toString();
			
			var str:String = currentInstance.mapConfig.currentPerson.personFirstname + Utils.SEPERATOR + 
				                    approvedComments + Utils.SEPERATOR +
				                    currentInstance.mapConfig.currentPerson.personId + "," +
				                    currentInstance.mapConfig.currentPerson.defaultProfile;
	        
			approvedTask.taskComment = ProcessUtil.convertToByteArray( str );
			approvedTask.wftFK = ProcessUtil.getMessageTemplate( ProcessUtil.getOtherProfileCode( currentInstance.mapConfig.currentProfileCode ), currentInstance.mapConfig.messageTemplatesCollection ).workflowTemplateId;
			approvedTask.taskStatusFK = TaskStatus.WAITING;
			
			controlSignal.createTaskSignal.dispatch( this , approvedTask, Utils.MESSAGE_INDEX );
			
			var _propertiesPj:Propertiespj =   Utils.propertyPjForFieldName( 'bat_date', currentInstance.mapConfig.currentProject.propertiespjSet );
			
			controlSignal.bulkUpdatePrjPropertiesSignal.dispatch( this, _propertiesPj.projectFk, _propertiesPj.propertyPresetFk.toString(), view.requestedDeadLine.selectedDate.toString(), 0, '' );
			
			view.validateDeadLine.visible = true;
			view.validateDeadLine.selectedDate = view.requestedDeadLine.selectedDate;
			
			view.acceptBtn.visible = false;
			view.rejectedBtn.visible = false;
		}
		
		/**
		 * 
		 * */
		protected function messageHandler ( event:MouseEvent ):void {
			view.currentState = Utils.DEADLINEMESSAGE_INDEX;
			view.requestDeadline.closeButton.addEventListener(MouseEvent.CLICK,onCloseMesssageViewHandler);
			view.deadline.view.currentState = Utils.TRAFFICDEADLINE_GENERAL;
			view.deadline.view.replyCommTxt.editor.text='';
		}
		
		protected function onCloseMesssageViewHandler (event:MouseEvent):void
		{
			view.currentState = Utils.GENERAL_INDEX;
			view.rejectedBtn.visible = true;
			view.acceptBtn.visible = true;
		}
		protected function onCloseDeadlineHandler ():void
		{
			view.currentState = Utils.GENERAL_INDEX;
			view.rejectedBtn.visible = false;
			view.acceptBtn.visible = false;
		} 
		
		public function giveSchedulerInput( tasksCollection:ArrayCollection ):void {
			var schedulerProvider:ArrayCollection = new ArrayCollection();
			var tasksRow:Object = {};
			tasksRow.name = Utils.TASKFILETYPE;
			tasksRow.selectable = false;
			tasksRow.collection = new ArrayCollection();
			for each( var item:Tasks in tasksCollection ) {
				var entry:Object = {};
				entry.startDate = item.tDateCreation;
				if( item.tDateEnd ) {
					entry.endDate = item.tDateEnd;
					entry.backgroundColor = item.workflowtemplateFK.profileObject.profileColor;
				}
				else {
					entry.endDate = new Date();
					entry.backgroundColor = 0xFFFF00;
				}
				entry.label = '';
				entry.refObject = item
				entry.selectable = false;
				tasksRow.collection.addItem( entry );
			}
			tasksRow.collection.refresh();
			schedulerProvider.addItem( tasksRow );
			schedulerProvider.refresh();
			view.scheduler.schedulerInput = schedulerProvider;
		}
		
		override protected function pushResultHandler( signal:SignalVO ): void { 
		} 
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			var storedProperties:String = modifiedProperties();
			var propertyPresetFk:String = String(storedProperties.split("#&#")[1]).slice(0,-1);
			var propFieldValue:String = String(storedProperties.split("#&#")[0]).slice(0,-1);
			if( propertyPresetFk.length!=0 ){
				if(PropertyUtil.formModified)controlSignal.bulkUpdatePrjPropertiesSignal.dispatch( null,currentInstance.mapConfig.currentProject.projectId, propertyPresetFk, propFieldValue,0,'');
			}
			super.cleanup( event ); 		
		} 
	}
}
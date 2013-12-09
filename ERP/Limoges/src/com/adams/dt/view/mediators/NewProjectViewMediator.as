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
	import com.adams.dt.util.DateUtil;
	import com.adams.dt.util.ProcessUtil;
	import com.adams.dt.util.ProjectUtil;
	import com.adams.dt.util.PropertyUtil;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.NewProjectSkinView;
	import com.adams.dt.view.components.FileUploadTileList;
	import com.adams.dt.view.components.autocomplete.PropertyCompleteView;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.ArrayUtil;
	import com.adams.swizdao.util.GetVOUtil;
	import com.adams.swizdao.util.StringUtils;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	
	public class NewProjectViewMediator extends AbstractViewMediator
	{ 		 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		[Inject("Release")]
		public var fileUploadTileList:FileUploadTileList; 
		
		[Inject("categoriesDAO")]
		public var categoryDAO:AbstractDAO;
		
		[Inject("profilesDAO")]
		public var profileDAO:AbstractDAO;
		
		[Inject("projectsDAO")]
		public var projectDAO:AbstractDAO;
		
		[Inject("propertiespresetsDAO")]
		public var propertiespresetsDAO:AbstractDAO;
		
		[Inject("proppresetstemplatesDAO")]
		public var propPresettemplateDAO:AbstractDAO;
		
		[Inject("presetstemplatesDAO")]
		public var presettemplateDAO:AbstractDAO;
		
		[Inject("workflowstemplatesDAO")]
		public var workflowstemplateDAO:AbstractDAO;
		
		[Inject("workflowsDAO")]
		public var workflowDAO:AbstractDAO;
		
		[Inject("phasesDAO")]
		public var phaseDAO:AbstractDAO;
		
		[Inject("phasestemplatesDAO")]
		public var phasestemplateDAO:AbstractDAO;
		
		[Bindable]
		private var fileTempCollection:ArrayCollection = new ArrayCollection();	
		private var propTempCollection:ArrayCollection = new ArrayCollection();
		private var propfieldNames:Array;
		private var selectedProjName:String='';
		private var correctionDone:Boolean;
		private var modifyFinishTask:Tasks
		private var _homeState:String;
		public function get homeState():String {
			return _homeState;
		}
		public function set homeState( value:String ):void {
			_homeState = value;
			if( value == Utils.NEWPROJECT_INDEX ) {
				addEventListener( Event.ADDED_TO_STAGE, addedtoStage );
			}
		}
		
		protected function addedtoStage( event:Event ):void {
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function NewProjectViewMediator( viewType:Class=null )
		{
			super( NewProjectSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():NewProjectSkinView 	{
			return _view as NewProjectSkinView;
		}
		
		[MediateView( "NewProjectSkinView" )]
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
			resetForm();
			propfieldNames = [];
			for each( var propPresets:Propertiespresets in propertiespresetsDAO.collection.items ) {
				propfieldNames.push( propPresets.fieldName );
			} 
			
			viewState = Utils.NEWPROJECT_INDEX;
			
			setProjectProperties();
			
			view.fileTile.addElement( fileUploadTileList );
			fileUploadTileList.componentType = "upload";
			fileUploadTileList.fileType = Utils.BASICFILETYPE; 
			callLater( fileUploadTileList.resetUploader );
			
			resetProjectProperties( true ); 
		}
		
		protected function fileProperties():void {
			fileUploadTileList.componentType = "upload";
			fileUploadTileList.fileType = Utils.BASICFILETYPE; 
			fileUploadTileList.resetUploader();
		}
		
		protected function resetProjectProperties( enable:Boolean ):void {	
			view.domain.enabled = enable; 
			view.refId.enabled = enable; 
			view.brand.enabled = enable;
			view.projectReset.visible = !enable;
		}   
		
		protected function setProjectProperties():void {
			if( !view.domain.dataProvider ) {
				var categoriescoll:ArrayCollection  = categoryDAO.collection.filteredItems as ArrayCollection;
				categoriescoll.filterFunction = ProcessUtil.getDomainsOnly;
				categoriescoll.refresh();
				view.domain.dataProvider = categoriescoll;
				view.domain.selectedIndex = 0;
			}
			
			updateProperties();
			
			if( currentInstance.mapConfig.currentProject ) {
				view.domain.selectedItem = currentInstance.mapConfig.currentProject.categories.domain;
			}
			else {
				view.domain.selectedIndex = 0;
			}		
			
			callLater( fileUploadTileList.resetUploader );
			BindingUtils.bindProperty( view.projectCreation, 'enabled', fileUploadTileList, 'uploadNotInProcess' );
		}
		
		protected function validationProject( event:MouseEvent ):void { 
			if( ( StringUtils.trimAll( view.brand.text ).length > 0 ) && 
				 ( StringUtils.trimAll( view.refId.text ).length > 0 ) && 
				 ( StringUtils.trimAll( view.department.text ).length > 0 ) &&
				 ( view.domain.selectedIndex != -1 ) ) {
				
				if( projectDAO.collection.items ) { 
					var selectedProject:Projects = getReferencedProject( view.refId.text.toLocaleLowerCase() );
				}
				
				if( fileUploadTileList.currentListComp.dataProvider ) {
					if( fileUploadTileList.currentListComp.dataProvider.length == 0 ) {
						currentInstance.mapConfig.fileUploadCollection = new ArrayCollection();
					}
				}
				
				if( selectedProject ) {
					currentInstance.mapConfig.currentProject = selectedProject; 
					modifyFinishTask = currentInstance.mapConfig.currentTasks as Tasks;
					currentInstance.mapConfig.currentTasks = Projects( currentInstance.mapConfig.currentProject ).finalTask;
					existingProjectTasks();
				}
				else {
					createNewProject( view.refId.text, view.comment.getText, view.domain.selectedItem as Categories, getPropPjCollection() );
					resetForm();
				}
			}
			else {
				controlSignal.showAlertSignal.dispatch( this, Utils.REPORT_ALERT_MESSAGE, Utils.APPTITLE, 1, null );
			}
		}
		
		private function updatePropPresetTemplate( viewComp:PropertyCompleteView ):void {
			if( viewComp.dataProvider.length == 0 ) {
				var getPropertiespresets:Propertiespresets = new Propertiespresets();
				getPropertiespresets.propertyPresetId = parseInt(viewComp.name);
				var currentPreset:Propertiespresets = propertiespresetsDAO.collection.findExistingItem(getPropertiespresets) as Propertiespresets;
				var getpropPresetTempItem:Proppresetstemplates = new Proppresetstemplates();
				getpropPresetTempItem.propertiesPresets = currentPreset;
				var currentPropPresetTemp:Proppresetstemplates= propPresettemplateDAO.collection.findExistingPropItem(getpropPresetTempItem,'propertiesPresets') as Proppresetstemplates;
				var optionsArr:Array = currentPreset.fieldOptionsValue.split(',');
				optionsArr.push(viewComp.text);
				var optionsStr:String = optionsArr.join();
				if(optionsStr.length > 950){
					controlSignal.showAlertSignal.dispatch(this,Utils.PROPERTIES_HIGH,Utils.APPTITLE,1,null);
				}else{
					currentPreset.fieldOptionsValue = currentPropPresetTemp.fieldOptionsValue =optionsStr;
					controlSignal.updatePropPresetTemplateSignal.dispatch( this,currentPropPresetTemp );
					controlSignal.updatePresetSignal.dispatch( this,currentPreset );
				}
			}
		}
		
		private function getPropPjCollection():String{  
			currentInstance.mapConfig.updatedPropPjCollection ='';
			updatePropPresetTemplate( view.brand );
			updatePropPresetTemplate( view.department );
			propTempCollection =  getPropertiespjSet()
			return Utils.pjParameters( getPropertiespjSet() );
		}
		
		private function existingProjectTasks():void{
			if(currentInstance.mapConfig.currentTasks!=null){
				if(currentInstance.mapConfig.currentTasks.taskStatusFK != TaskStatus.FINISHED &&  
					(currentInstance.mapConfig.currentTasks.workflowtemplateFK.taskCode == Utils.CORRECTIONS_BACK_SCREEN ||
						currentInstance.mapConfig.currentTasks.workflowtemplateFK.taskCode == Utils.CORRECTIONS_FRONT_SCREEN ||
						currentInstance.mapConfig.currentTasks.workflowtemplateFK.taskCode == Utils.NEWORDER_CORRECTION_SCREEN )){
					var workflowtemplates:Workflowstemplates  =  Workflowstemplates( currentInstance.mapConfig.currentTasks.workflowtemplateFK );
					if( Profiles(GetVOUtil.getVOObject( workflowtemplates.profileFK,profileDAO.collection.items,Utils.PROFILESKEY,Profiles )).profileCode 
						== currentInstance.mapConfig.currentProfileCode){
						controlSignal.showAlertSignal.dispatch(this,Utils.NEXTTASK_MESSAGE,Utils.APPTITLE,0,Utils.NEXTTASK_MESSAGE)
						return;
					}
				}
			}
			controlSignal.showAlertSignal.dispatch(this,Utils.TASKSYNC,Utils.APPTITLE,1,null)
		}
		
		private function navigationTasks():void{
			var workflowtemplates:Workflowstemplates =  Workflowstemplates( currentInstance.mapConfig.currentTasks.workflowtemplateFK );
			var tempCurrentTasks:Tasks = Tasks( currentInstance.mapConfig.currentTasks );
			var tempCurrentProjects:Projects = Projects(currentInstance.mapConfig.currentProject);
			var tempNextWorkflowtemplatesId:int = 0;
			var tempNextWorkflowtempCode:String = null;
			
			if(workflowtemplates.nextTaskFk ){ 
				tempNextWorkflowtemplatesId = workflowtemplates.nextTaskFk.workflowTemplateId;
				tempNextWorkflowtempCode = workflowtemplates.nextTaskFk.taskCode;
			}
			else{  
				tempNextWorkflowtemplatesId = workflowtemplates.prevTaskFk.workflowTemplateId;
				tempNextWorkflowtempCode = workflowtemplates.prevTaskFk.taskCode;
			}
			var tasksComments:String = ProcessUtil.convertToByteArray(view.comment.getText).toString();
			var pjresult:String = Utils.pjParameters( getPropertiespjSet());
			correctionDone =true;
			controlSignal.createNavigationTaskSignal.dispatch(this,tempCurrentTasks.taskId , tempCurrentProjects.workflowFK , tempNextWorkflowtemplatesId , tempCurrentProjects.projectId , Persons(currentInstance.mapConfig.currentPerson).personId , tempNextWorkflowtempCode , tasksComments, pjresult);
		}
		
		private function updateProperties():void {
			var currentProjObject:Object = {};
			var formIds:Array = PropertyUtil.getFormIDs( view.newProjectForm );
			if( selectedProjName.length == 0 ) { 
				PropertyUtil.propertyUpdate( currentProjObject, formIds, propfieldNames, propertiespresetsDAO.collection, propPresettemplateDAO.collection );
			}else {
				PropertyUtil.propertyUpdate( currentProjObject, formIds, propfieldNames, propertiespresetsDAO.collection, propPresettemplateDAO.collection, currentInstance.mapConfig.currentProject );
				view.domain.selectedItem = currentInstance.mapConfig.currentProject.categories.domain;
			}
			PropertyUtil.setUpForm( currentProjObject, view.newProjectForm, propfieldNames );
		}
		
		private function getPropertyPjSet( propertyCollection:Array):Array {
			var propArr:Array = []
			for( var i:int = 0; i < propertyCollection.length; i++ ) {
				var property:String = propertyCollection[i] as String;
				if(propfieldNames.indexOf(property)!=-1) {
					propArr.push(property);
				}
			}
			return propArr;
		} 
		
		private function getPropertiespjSet():ArrayCollection {
			var arrC:ArrayCollection= new ArrayCollection();
			arrC = PropertyUtil.getFormValues(getPropertyPjSet(PropertyUtil.getFormIDs(view.newProjectForm)),view.newProjectForm,arrC);
			var batDatePropPj:Propertiespj = PropertyUtil.createPropertyPj('bat_date',propertiespresetsDAO.collection);
			var traDatePropPj:Propertiespj = PropertyUtil.createPropertyPj('tra_date',propertiespresetsDAO.collection);
			arrC.addItem(batDatePropPj);
			arrC.addItem(traDatePropPj);
			return arrC;			
		}  
		
		private function createNewProject(projName:String,comments:String,domain:Categories,propPjColl:String):void {
			var projects:Projects = new Projects();			
			projects.projectDateStart = new Date();	 
			projects.workflowFK = 1;
			var workfTemplate:Workflowstemplates = new Workflowstemplates();
			workfTemplate.workflowTemplateId = projects.workflowFK;
			var workflowTemplate:Workflowstemplates =  workflowstemplateDAO.collection.findExistingItem(workfTemplate) as Workflowstemplates;
			projects.projectStatusFK = ProjectStatus.WAITING;
			projects.projectName = projName;
			var findPreset:Presetstemplates = new Presetstemplates()
			findPreset.presetstemplateId = 1;
			projects.presetTemplateFK = presettemplateDAO.collection.findExistingItem(findPreset) as Presetstemplates;
			projects.projectDateStart= new Date();		
			projects.projectComment = ProcessUtil.convertToByteArray(comments);
			var categ:Categories = new Categories();			
			categ.categoryName = String( new Date().fullYear );
			categ.categoryFK = domain;	
			var categ2:Categories = new Categories();
			categ2.categoryName = ProcessUtil.month[ new Date().month ];		
			var categories1:Categories = categ; 
			var categories2:Categories = categ2;  
			var endTaskCode:String =Utils.NEWPROJENDTASKCODE;
			var projectCreatePersonId:int = currentInstance.mapConfig.currentPerson.personId; 			
			var phaseColl:ArrayCollection = getIntialPhases(makePhasesSet(1, new Date()) , 1 );
			controlSignal.createProjectSignal.dispatch(this,"",projects.projectName,projects.projectComment.toString(),
				domain.categoryId,projectCreatePersonId,
				currentInstance.config.FileServer, domain,
				categories1,categories2,projects.workflowFK, "","","",0,
				phaseColl.getItemAt(0).toString(),phaseColl.getItemAt(2).toString(),
				phaseColl.getItemAt(1).toString(),phaseColl.getItemAt(3).toString(),
				phaseColl.getItemAt(4).toString(),phaseColl.getItemAt(5).toString(),2,1,endTaskCode,propPjColl);
		}	 
		
		public function makePhasesSet( workflowFk:int, startTime:Date ):ArrayCollection {
			var phasesCollection:ArrayCollection = new ArrayCollection();
			for( var i:int = 0; i < phasestemplateDAO.collection.items.length; i++ ) {
				var item:Phasestemplates = phasestemplateDAO.collection.items.getItemAt( i ) as Phasestemplates;
				if( item.workflowId == workflowFk ) {
					var phase:Phases = new Phases();
					phase.phaseTemplateFK = item.phaseTemplateId;
					phase.phaseName = item.phaseName;
					if( phasesCollection.length == 0 ) {
						phase.phaseStart = startTime;	
					}
					else {
						phase.phaseStart = Phases( phasesCollection.getItemAt( i - 1 ) ).phaseEndPlanified;
					}
					phase.phaseEndPlanified = DateUtil.weekEndRemovalOfPeriod( phase.phaseStart, item.phaseDurationDays );
					phase.phaseEnd = null; 
					phase.phaseDuration = item.phaseDurationDays; 
					phase.phaseDelay = 0;
					phasesCollection.addItem( phase );
				}
			}
			return phasesCollection;
		}
		
		public function getIntialPhases(phasesColl:ArrayCollection,workflow_Id:int):ArrayCollection
		{
			var intialPhasesCollection:ArrayCollection = new ArrayCollection();
			var phaseID:String='';
			var phaseName:String='';
			var phaseCode:String='';
			var phaseStart:String='';
			var phaseplanified:String='';
			var phaseDuration:String='';
			var dateFormat:DateFormatter = new DateFormatter();
			dateFormat.formatString="YYY/MM/DD";
			for each( var phaseTemp:Phasestemplates in phasestemplateDAO.collection.items )
			{
				for each( var phaseObj:Phases in phasesColl )
				{
					if(phaseTemp.phaseName == phaseObj.phaseName && phaseTemp.workflowId == workflow_Id){
						phaseID += phaseTemp.phaseTemplateId+";";
						phaseName += phaseTemp.phaseName+";";
						phaseCode += "P00"+phaseTemp.phaseTemplateId+";";
						phaseStart +=  dateFormat.format( phaseObj.phaseStart )+";";
						phaseplanified  +=  dateFormat.format( phaseObj.phaseEndPlanified)+";";
						phaseDuration +=  phaseObj.phaseDuration+";";
					}
				}
			}
			intialPhasesCollection.addItem(phaseID.slice(0,-1));
			intialPhasesCollection.addItem(phaseName.slice(0,-1));
			intialPhasesCollection.addItem(phaseCode.slice(0,-1));
			intialPhasesCollection.addItem(phaseStart.slice(0,-1));
			intialPhasesCollection.addItem(phaseplanified.slice(0,-1));
			intialPhasesCollection.addItem(phaseDuration.slice(0,-1));
			return intialPhasesCollection;
		}  
		
		private function resetForm(obj:Object=null):void { 
			selectedProjName=''
			view.domain.selectedIndex = 0;
			view.brand.text = "";
			view.refId.text = "";
			view.department.text = "";
			view.priority.selectedState = '';
			view.clt_date.selectedDate = new Date();
			view.comment.editor.text = "";
			resetProjectProperties(true);
			if(fileUploadTileList)fileUploadTileList.resetUploader(); 
		} 
		
		override protected function serviceResultHandler( obj:Object,signal:SignalVO ):void {   
			if( signal.destination == ArrayUtil.PAGINGDAO && signal.action == Action.BULKUPDATEPROJECTPROPERTIES ){
				resetForm();
			}
			if( ( signal.action == Action.CLOSEPROJECT ) && ( signal.destination == ArrayUtil.PAGINGDAO ) ) {
				if( currentInstance.mapConfig.currentTasks ) {
					currentInstance.mapConfig.currentTasks.taskStatusFK = TaskStatus.FINISHED;
				}
				controlSignal.changeStateSignal.dispatch( Utils.TASKLIST_INDEX );
			}
			if( ( signal.action == Action.CREATENAVTASK ) && ( signal.destination == ArrayUtil.PAGINGDAO ) ) {
				//For updating the previous task's status on navigational task creation ( Done By Deepan )
				if( currentInstance.mapConfig.currentTasks ) {
					modifyFinishTask.taskStatusFK = TaskStatus.FINISHED;
				}
			} 
		} 
		
		private function onReferenceSelect( obj:Object ):void {
			onProjectSelection();
		}
		
		protected function onProjectSelection( event:Event = null ): void {
			selectedProjName = '';
			var prj:Projects = getReferencedProject( view.refId.text.toLocaleLowerCase() );
			if( prj ) {
				resetProjectProperties( false );
				selectedProjName = prj.projectName;
				currentInstance.mapConfig.currentProject = prj;
				view.domain.selectedItem = currentInstance.mapConfig.currentProject.categories.domain;
				updateProperties();
			}
		}
		
		private function getReferencedProject( prjname:String ):Projects {
			for each( var item:Projects in projectDAO.collection.items ) {
				if( item.projectName.toLocaleLowerCase() == prjname ) {
					return item;
				}
			}
			return null;
		}
		
		protected function onAbortDateDateHandler ( event :MouseEvent ):void {	
			controlSignal.showAlertSignal.dispatch( this, Utils.ABORT_MESSAGE, Utils.APPTITLE, 0, Utils.ABORT_MESSAGE );
		}	
		
		override public function alertReceiveHandler(obj:Object):void {
			if( obj==Utils.ABORT_MESSAGE) {
				var objArray:Array = ProjectUtil.abortProject(Utils.ABORT,currentInstance.mapConfig.currentProject,currentInstance.mapConfig.closeProjectTemplate,
					currentInstance.mapConfig.currentTasks,currentInstance.mapConfig.currentPerson,view.comment.getText);
				currentInstance.mapConfig.closeTaskCollection = objArray[objArray.length-1];
				controlSignal.closeProjectsSignal.dispatch(this,objArray);
			}else if( obj==Utils.NEXTTASK_MESSAGE) {
				navigationTasks();
				resetForm();
			}
		} 
		
		private function filterDomainProject( event:FocusEvent = null ):void {
			var domainProjects:ArrayCollection = new ArrayCollection();
			for each( var obj:Object in projectDAO.collection.filteredItems ) {
				if( obj.categories.categoryFK.categoryFK.categoryName == view.domain.selectedItem[ view.domain.labelField ] ) {
					domainProjects.addItem( obj );
				}
			}
			domainProjects.refresh();
			view.refId.dataProvider = domainProjects;
		}
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
			view.abortedBtn.addEventListener( MouseEvent.CLICK , onAbortDateDateHandler, false, 0, true );
			view.projectCreation.addEventListener(MouseEvent.CLICK,validationProject, false, 0, true );
			view.refId.addEventListener( FocusEvent.FOCUS_OUT, onProjectSelection, false, 0, true );
			view.refId.addEventListener( FocusEvent.FOCUS_IN, filterDomainProject, false, 0, true );
			view.refId.selectedSignal.add( onReferenceSelect );
			view.projectReset.addEventListener( MouseEvent.CLICK , resetForm, false, 0, true );
		} 
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void { 
			resetForm();
			view.abortedBtn.removeEventListener( MouseEvent.CLICK , onAbortDateDateHandler );
			view.projectCreation.removeEventListener(MouseEvent.CLICK,validationProject );
			view.refId.removeEventListener( FocusEvent.FOCUS_OUT, onProjectSelection );
			view.refId.removeEventListener( FocusEvent.FOCUS_IN, filterDomainProject );
			view.refId.selectedSignal.remove( onReferenceSelect );
			view.projectReset.removeEventListener( MouseEvent.CLICK , resetForm );
			super.cleanup( event ); 		
		} 
	}
}
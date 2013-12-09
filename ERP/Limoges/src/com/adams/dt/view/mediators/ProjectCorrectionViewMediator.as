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
	import com.adams.dt.util.ProcessUtil;
	import com.adams.dt.util.ProjectUtil;
	import com.adams.dt.util.PropertyUtil;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.ProjectCorrectionSkinView;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.ArrayUtil;
	import com.adams.swizdao.util.GetVOUtil;
	import com.adams.swizdao.util.StringUtils;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	
	public class ProjectCorrectionViewMediator extends AbstractViewMediator
	{ 		
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
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
		
		[Bindable]
		private var fileTempCollection:ArrayCollection = new ArrayCollection();	
		private var propTempCollection:ArrayCollection = new ArrayCollection();
		private var propfieldNames:Array;
		private var selectedProjName:String='';
		private var correctionDone:Boolean;
		private var modifyFinishTask:Tasks
		private var _homeState:String;
		public function get homeState():String
		{
			return _homeState;
		}
		
		public function set homeState(value:String):void
		{
			_homeState = value;
			if(value==Utils.PROJECTCORRECTION_INDEX) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		
		protected function addedtoStage(ev:Event):void{
			init();
		}
		
		/**
		 * Constructor.
		 */
		public function ProjectCorrectionViewMediator( viewType:Class=null )
		{
			super( ProjectCorrectionSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():ProjectCorrectionSkinView 	{
			return _view as ProjectCorrectionSkinView;
		}
		
		[MediateView( "ProjectCorrectionSkinView" )]
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
			resetForm();
			propfieldNames = [];
			for each( var propPresets:Propertiespresets in propertiespresetsDAO.collection.items ) {
				propfieldNames.push( propPresets.fieldName );
			} 
			
			viewState = Utils.NEWPROJECT_INDEX;
			
			setProjectProperties();
			
			if( currentInstance.mapConfig.currentTasks.workflowtemplateFK.taskCode == Utils.NEWORDER_CORRECTION_SCREEN ) {
				view.abortedBtn.visible = true;
			}
			view.refId.enabled = false;
			view.refId.text = currentInstance.mapConfig.currentProject.projectName;
		}
		 
		
		protected function setProjectProperties():void {
			
			updateProperties();
			view.domain.text = Categories(currentInstance.mapConfig.currentProject.categories.domain).categoryName;
		}
		
		protected function validationProject(event:MouseEvent):void { 
			if ( StringUtils.trimAll( view.brand.text ).length>0 && StringUtils.trimAll( view.refId.text ).length>0 
				&& StringUtils.trimAll( view.department.text ).length>0)
			{
				if(projectDAO.collection.items ){ 
					var selectedProject:Projects = getReferencedProject( view.refId.text.toLocaleLowerCase() );
				} 
                currentInstance.mapConfig.fileUploadCollection = new ArrayCollection();		
				if( selectedProject ) {
					currentInstance.mapConfig.currentProject = selectedProject; 
					modifyFinishTask = currentInstance.mapConfig.currentTasks as Tasks
					currentInstance.mapConfig.currentTasks = Projects(currentInstance.mapConfig.currentProject).finalTask;
					existingProjectTasks();
				} 
			}else
			{
				controlSignal.showAlertSignal.dispatch(this,Utils.REPORT_ALERT_MESSAGE,Utils.APPTITLE,1,null)
			}
			
		}
		
		private function updatePropPresetTemplate( viewComp:UIComponent ):void {
			var getPropertiespresets:Propertiespresets = new Propertiespresets();
			getPropertiespresets.propertyPresetId = parseInt(viewComp.name);
			var currentPreset:Propertiespresets = propertiespresetsDAO.collection.findExistingItem(getPropertiespresets) as Propertiespresets;
			var getpropPresetTempItem:Proppresetstemplates = new Proppresetstemplates();
			getpropPresetTempItem.propertiesPresets = currentPreset;
			var currentPropPresetTemp:Proppresetstemplates= propPresettemplateDAO.collection.findExistingPropItem(getpropPresetTempItem,'propertiesPresets') as Proppresetstemplates;
			var optionsArr:Array = currentPreset.fieldOptionsValue.split(',');
			optionsArr.push(Object(viewComp).text);
			var optionsStr:String = optionsArr.join();
			if(optionsStr.length > 950){
				controlSignal.showAlertSignal.dispatch(this,Utils.PROPERTIES_HIGH,Utils.APPTITLE,1,null);
			}else{
				currentPreset.fieldOptionsValue = currentPropPresetTemp.fieldOptionsValue =optionsStr;
				controlSignal.updatePropPresetTemplateSignal.dispatch( this,currentPropPresetTemp );
				controlSignal.updatePresetSignal.dispatch( this,currentPreset );
			}
		}
		
		private function getPropPjCollection():String{  
			currentInstance.mapConfig.updatedPropPjCollection ='';
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
			
			PropertyUtil.propertyUpdate( currentProjObject, formIds, propfieldNames, propertiespresetsDAO.collection, propPresettemplateDAO.collection, currentInstance.mapConfig.currentProject );
			view.domain.text = currentInstance.mapConfig.currentProject.categories.domain.categoryName;
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
			var arrC:ArrayCollection= currentInstance.mapConfig.currentProject.propertiespjSet;
			arrC = PropertyUtil.getFormValues(getPropertyPjSet(PropertyUtil.getFormIDs(view.newProjectForm)),view.newProjectForm,arrC);
			var batDatePropPj:Propertiespj = PropertyUtil.createPropertyPj('bat_date',propertiespresetsDAO.collection);
			var traDatePropPj:Propertiespj = PropertyUtil.createPropertyPj('tra_date',propertiespresetsDAO.collection);
			arrC.addItem(batDatePropPj);
			arrC.addItem(traDatePropPj);
			return arrC;			
		}  
		
		private function resetForm(obj:Object=null):void { 
			selectedProjName=''
			view.domain.text = '';
			view.brand.text = "";
			view.refId.text = "";
			view.department.text = "";
			view.clt_date.selectedDate = new Date();
			view.comment.editor.text = "";
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
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
			view.abortedBtn.addEventListener( MouseEvent.CLICK , onAbortDateDateHandler, false, 0, true );
			view.projectCreation.addEventListener(MouseEvent.CLICK,validationProject, false, 0, true );
		} 
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			if(correctionDone){
				correctionDone = false;
				currentInstance.mapConfig.currentProject.projectStatusFK = ProjectStatus.WAITING;
				controlSignal.updateProjectSignal.dispatch( null, currentInstance.mapConfig.currentProject );
			}
			resetForm();
			super.cleanup( event ); 		
		} 
	}
}
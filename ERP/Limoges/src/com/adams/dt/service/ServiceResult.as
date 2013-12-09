/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.service
{
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.model.vo.*;
	import com.adams.dt.signal.ControlSignal;
	import com.adams.dt.util.DateUtil;
	import com.adams.dt.util.ProcessUtil;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.mediators.MainViewMediator;
	import com.adams.swizdao.dao.PagingDAO;
	import com.adams.swizdao.model.collections.ICollection;
	import com.adams.swizdao.model.processor.IVOProcessor;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.response.AbstractResult;
	import com.adams.swizdao.signals.AbstractSignal;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.ArrayUtil;
	import com.adams.swizdao.util.FileNameSplitter;
	import com.adams.swizdao.util.GetVOUtil;
	import com.adams.swizdao.util.StringUtils;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.ResultEvent;
	
	public class ServiceResult extends AbstractResult
	{ 
		
		[Inject("personsDAO")]
		public var personDAO:AbstractDAO;
		
		[Inject("companiesDAO")]
		public var companyDAO:AbstractDAO;
		
		[Inject("projectsDAO")]
		public var projectDAO:AbstractDAO;
		
		[Inject("tasksDAO")]
		public var taskDAO:AbstractDAO;
		
		[Inject("propertiespresetsDAO")]
		public var propertiespresetsDAO:AbstractDAO;
		
		[Inject("phasestemplatesDAO")]
		public var phasestemplateDAO:AbstractDAO;
		
		[Inject]
		public var mainViewMediator:MainViewMediator
		
		[Inject("statusDAO")]
		public var statusDAO:AbstractDAO;
		
		[Inject("profilesDAO")]
		public var profileDAO:AbstractDAO;
		
		[Inject("workflowstemplatesDAO")]
		public var workflowstemplateDAO:AbstractDAO;
		
		[Inject("categoriesDAO")]
		public var categoryDAO:AbstractDAO;
		
		[Inject("groupsDAO")]
		public var groupDAO:AbstractDAO;
		
		[Inject("domainworkflowDAO")]
		public var domainworkflowDAO:AbstractDAO;
		
		[Inject("teamlinesDAO")]
		public var teamlineDAO:AbstractDAO;
		
		[Inject("phasesDAO")]
		public var phaseDAO:AbstractDAO;
		
		[Inject("propertiespjDAO")]
		public var propertiespjDAO:AbstractDAO;	
		
		
		[Inject]
		public var paging:PagingDAO;
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		private var perPageMaximum :int = 200;
		private var count:int;
		private var swfArrc: ArrayCollection;
		
		/**
		 * 
		 * @param rpcevt
		 * @param prevSignal
		 * 
		 */		
		override protected function resultHandler( rpcevt:ResultEvent, prevSignal:AbstractSignal = null ):void {
			super.resultHandler(rpcevt,prevSignal);
			serviceResultHandler(  resultObj, prevSignal.currentSignal );
			resultSignal.dispatch( resultObj, prevSignal.currentSignal );
			// on push
			if(prevSignal.currentSignal.action == Action.FINDPUSH_ID){  
				pushRefreshSignal.dispatch( prevSignal.currentSignal );
			}
			signalSeq.onSignalDone();
		}  
		
		protected function serviceResultHandler( obj:Object,signal:SignalVO ):void {  
			switch(signal.destination){
				case Utils.PERSONSKEY:
					switch(signal.action){
						case Action.GET_LIST:
							currentInstance.mapConfig.currentPerson = personDAO.collection.findExistingPropItem(currentInstance.mapConfig.currentPerson,'personLogin');
							controlSignal.getPropTemplatesSignal.dispatch(null);
							break;
						default:
							break;
					}
					break;
				case ArrayUtil.PAGINGDAO:
					switch(signal.action ) {						
						case  Action.REFRESHQUERY:
							var refreshArrColl:ArrayCollection = obj as ArrayCollection;
							var refreshColl:ArrayCollection = refreshArrColl.getItemAt( 0 ) as ArrayCollection;
							var projectRefreshColl:ArrayCollection = new ArrayCollection();
							var prjRefresh:Projects;
							var curRefPrjTsk:Tasks;
							for each( var objs:Array in refreshColl ) {
							prjRefresh = objs[ 0 ] as Projects;
							curRefPrjTsk = objs[ 1 ] as Tasks; 
							prjRefresh.currentTaskDateStart = curRefPrjTsk.tDateCreation;
							prjRefresh.wftFK = curRefPrjTsk.wftFK;
							prjRefresh.finalTask = curRefPrjTsk; 
							projectRefreshColl.addItem( prjRefresh );
						}
							processCollections( projectRefreshColl, projectDAO.processor, projectDAO.collection , true);
							controlSignal.updateReportGridSignal.dispatch();
							break;
						case  Action.FILECONVERT:
							var fileDetails:FileDetails = signal.valueObject as FileDetails;
							if(signal.startIndex ==0) swfArrc = new ArrayCollection();
							var returnStr:String = obj as String;
							if( returnStr.indexOf( 'OK:' ) != -1 ) {
								var lastind:int =1;
								if(currentInstance.mapConfig.serverOSWindows) lastind= 2;
								var charspl:int;
								var findIndex:int = returnStr.indexOf( 'OK:' );
								( !currentInstance.mapConfig.serverOSWindows) ?  ( charspl = ( 4 + findIndex ) ) : ( charspl = ( 5 + findIndex ) ); 
								
								var convertedSwf:String = returnStr.substring( charspl, ( returnStr.length - lastind ) );
								
								( !currentInstance.mapConfig.serverOSWindows) ?  ( convertedSwf += ', ' ) : ( convertedSwf );
								
								var convertedSwfArr:Array = convertedSwf.split( "," );
								
								if( convertedSwfArr.length == 1 ) {
									controlSignal.showAlertSignal.dispatch(null,Utils.PDFCONVERSIONFAILED,Utils.APPTITLE,1,null)
								}  
								for( var i:int = 0; i < ( convertedSwfArr.length - 1 ); i++ ) {
									var fileObject:FileDetails = new FileDetails();
									fileObject.fileId = NaN;
									fileObject.fileName = ProcessUtil.getFileName( convertedSwfArr[ i ] );
									fileObject.storedFileName = fileObject.fileName;
									fileObject.taskId = fileDetails.taskId;
									fileObject.categoryFK = 0;
									fileObject.fileCategory = fileDetails.fileCategory;
									fileObject.fileDate = new Date();
									fileObject.visible = false;
									fileObject.downloadPath = fileDetails.downloadPath;
									fileObject.projectFK = fileDetails.projectFK;
									fileObject.filePath = convertedSwfArr[ i ];//StringUtils.trimSpace( convertedSwfArr[ i ] ); //fileDetails.destinationpath+"/"+fileDetails.type+"/"+fileObject.storedFileName;
									fileObject.type = fileDetails.type;
									fileObject.miscelleneous = fileDetails.miscelleneous;
									
									if( fileObject.taskId != 0 && currentInstance.mapConfig.currentTasks ) {//&& model.isFrontTask 
										if( ProcessUtil.checkTemplateExist( currentInstance.mapConfig.firstRelease,currentInstance.mapConfig.currentTasks.workflowtemplateFK.workflowTemplateId ) ) {
											fileObject.releaseStatus = 1;
										}
										else if( ProcessUtil.checkTemplateExist( currentInstance.mapConfig.otherRelease, currentInstance.mapConfig.currentTasks.workflowtemplateFK.workflowTemplateId ) ) {
											fileObject.releaseStatus = 2;
										}
									}
									
									fileObject.page = i+1;
									swfArrc.addItem( fileObject );
									
									var thumbDetail:FileDetails = new FileDetails();
									var filePath:String = fileObject.filePath.split( fileObject.type )[ 0 ];
									thumbDetail.type = fileObject.type;
									thumbDetail.fileName = FileNameSplitter.splitFileName( fileObject.storedFileName ).filename + "_thumb.swf";
									thumbDetail.filePath = filePath + fileObject.type + '/' + thumbDetail.fileName;
								} 
							}
							else {
								controlSignal.showAlertSignal.dispatch(null,Utils.PDFCONVERSIONFAILED,Utils.APPTITLE,1,null)
							}
							if( signal.startIndex == signal.id ) {
								controlSignal.bulkUpdateFilesSignal.dispatch( null, swfArrc );
								controlSignal.changeStateSignal.dispatch( Utils.TASKLIST_INDEX );
							}
							break;
						case  Action.GETLOGINLISTRESULT:
							var resultArrColl : ArrayCollection = obj as ArrayCollection;
							
							var companyList:ArrayCollection 			= resultArrColl.getItemAt(0) as ArrayCollection;
							var phasestemplateList:ArrayCollection 	= resultArrColl.getItemAt(1) as ArrayCollection;
							var statusList:ArrayCollection 				= resultArrColl.getItemAt(2) as ArrayCollection;
							var profilesList:ArrayCollection 			= resultArrColl.getItemAt(3) as ArrayCollection;
							var workflowTemplatesList:ArrayCollection 	= resultArrColl.getItemAt(4) as ArrayCollection;
							var categoriesList:ArrayCollection 			= resultArrColl.getItemAt(5) as ArrayCollection;
							//var personProfilesList:ArrayCollection 		= resultArrColl.getItemAt(6) as ArrayCollection;
							var groupsList:ArrayCollection 				= resultArrColl.getItemAt(7) as ArrayCollection;
							var domainworkflowsList:ArrayCollection 	= resultArrColl.getItemAt(8) as ArrayCollection;
							//var modulesList:ArrayCollection 			= resultArrColl.getItemAt(9) as ArrayCollection;
							
							processCollections(companyList,companyDAO.processor,companyDAO.collection);
							processCollections(phasestemplateList,phasestemplateDAO.processor,phasestemplateDAO.collection);
							processCollections(statusList,statusDAO.processor,statusDAO.collection);
							//process statuses
							ProcessUtil.getStatusColl(statusDAO.collection.items);
							
							processCollections(profilesList,profileDAO.processor,profileDAO.collection); 
							//set currentProfilecode
							var getProfile:Profiles = new Profiles();
							getProfile.profileId = currentInstance.mapConfig.currentPerson.defaultProfile;
							var currentProfile:Profiles = profileDAO.collection.findExistingItem(getProfile) as Profiles;
							currentInstance.mapConfig.currentProfileCode = currentProfile.profileCode;
							currentInstance.mapConfig.currentProfileCode == Utils.LIMOGES_PROFILE ? ProcessUtil.isCLT =true : ProcessUtil.isCLT =false;
							
							if(mainViewMediator.view.header)mainViewMediator.view.header.view.newProjectBtn.visible = ProcessUtil.isCLT;
							processCollections(workflowTemplatesList,workflowstemplateDAO.processor,workflowstemplateDAO.collection);
							
							//process workflowtemplates
							ProcessUtil.getWorkflowTemplates(workflowstemplateDAO.collection.items,currentInstance.mapConfig);
							
							processCollections(categoriesList,categoryDAO.processor,categoryDAO.collection);
							processCollections(groupsList,groupDAO.processor,groupDAO.collection);
							processCollections(domainworkflowsList,domainworkflowDAO.processor,domainworkflowDAO.collection);
							
							break;
						case Action.CREATEPROJECT:
							var resultArrCollect : ArrayCollection = obj as ArrayCollection;
							
							if( resultArrCollect ) {
								var newcategorydomainList:ArrayCollection = resultArrCollect.getItemAt( 0 ) as ArrayCollection;
								var newcategory1List:ArrayCollection 	= resultArrCollect.getItemAt( 1 ) as ArrayCollection;
								var newcategory2List:ArrayCollection 	= resultArrCollect.getItemAt( 2 ) as ArrayCollection;
								var newprojectList:ArrayCollection = resultArrCollect.getItemAt( 3 ) as ArrayCollection;
								var newteamlineList:ArrayCollection = resultArrCollect.getItemAt( 4 ) as ArrayCollection;
								var newphasesList:ArrayCollection	= resultArrCollect.getItemAt( 5 ) as ArrayCollection;
								var newtasksList:ArrayCollection = resultArrCollect.getItemAt( 6 ) as ArrayCollection;
								var newpropertiesspjList:ArrayCollection = resultArrCollect.getItemAt( 7 ) as ArrayCollection;
								
								processCollections(newcategorydomainList,categoryDAO.processor,categoryDAO.collection);
								processCollections(newcategory1List,categoryDAO.processor,categoryDAO.collection);
								processCollections(newcategory2List,categoryDAO.processor,categoryDAO.collection);
								processCollections(newprojectList,projectDAO.processor,projectDAO.collection);
								processCollections(newteamlineList,teamlineDAO.processor,teamlineDAO.collection);
								processCollections(newphasesList,phaseDAO.processor,phaseDAO.collection);
								processCollections(newtasksList,taskDAO.processor,taskDAO.collection);
								processCollections(newpropertiesspjList,propertiespjDAO.processor,propertiespjDAO.collection);
								var getPrj:Projects = new Projects();
								var projectId:int = newprojectList.getItemAt(0).projectId;
								getPrj.projectId = projectId;
								var createdPrj:Projects = projectDAO.collection.findExistingItem(getPrj) as Projects;
								var path:String = createdPrj.categories.categoryFK.categoryFK.categoryName+Utils.fileSplitter
									+createdPrj.categories.categoryFK.categoryName+Utils.fileSplitter
									+ createdPrj.categories.categoryName+Utils.fileSplitter+createdPrj.projectName;
								
								var pjresult:String;
								if(currentInstance.mapConfig.updatedPropPjCollection=='' ){
									pjresult = signal.emailBody;
								}else{
									pjresult = currentInstance.mapConfig.updatedPropPjCollection;
								}
								var propertyPresetFk:String = String(pjresult.split("#&#")[1]).slice(0,-1);
								var propFieldValue:String = String(pjresult.split("#&#")[0]).slice(0,-1);
								createdPrj.finalTask = newtasksList.getItemAt(1) as Tasks;
								if(propFieldValue){
									controlSignal.bulkUpdatePrjPropertiesSignal.dispatch( null,projectId,propertyPresetFk, propFieldValue,newtasksList.getItemAt(0).taskId,path);
								}else{ 
									if(currentInstance.mapConfig.fileUploadCollection.length >0){
										fileUpdation(projectId,newtasksList.getItemAt(0).taskId,path );	
									}else if(signal.endIndex !=0){
										controlSignal.changeStateSignal.dispatch( Utils.TASKLIST_INDEX );
									}	
								}
							}
							break;
						case Action.CREATENAVTASK:
							var resultNavigationCollect:ArrayCollection = obj as ArrayCollection;							
							if( resultNavigationCollect ) {
								var newNavTasksList:ArrayCollection = resultNavigationCollect.getItemAt( 0 ) as ArrayCollection;
								var getNavPrj:Projects = new Projects();
								var newCreatedTask:Tasks = Tasks( newNavTasksList.getItemAt( 0 ) );
								getNavPrj.projectId = newCreatedTask.projectFk;
								processCollections( newNavTasksList,taskDAO.processor,taskDAO.collection );
								var existNavPrj:Projects = projectDAO.collection.findExistingItem( getNavPrj ) as Projects;
								var serverUploadpath:String = existNavPrj.categories.categoryFK.categoryFK.categoryName + Utils.fileSplitter
									+ existNavPrj.categories.categoryFK.categoryName+ Utils.fileSplitter
									+ existNavPrj.categories.categoryName+ Utils.fileSplitter+ existNavPrj.projectName;
								
								var proppjresult:String = signal.emailBody;
								var propertysPresetFk:String = String( proppjresult.split( "#&#" )[ 1 ] ).slice( 0, -1 );
								var propsFieldValue:String = String( proppjresult.split( "#&#" )[ 0 ] ).slice( 0, -1 );
								if( propsFieldValue ) {
									controlSignal.bulkUpdatePrjPropertiesSignal.dispatch( null, getNavPrj.projectId, propertysPresetFk, propsFieldValue, newNavTasksList.getItemAt( 0 ).taskId, serverUploadpath );
								}
								else {
									if( currentInstance.mapConfig.fileUploadCollection.length > 0 ) {
										fileUpdation( getNavPrj.projectId,newNavTasksList.getItemAt( 0 ).taskId, serverUploadpath );
									}
									else if( signal.endIndex != 0 ) {
										controlSignal.changeStateSignal.dispatch( Utils.TASKLIST_INDEX );
									}	
								}
							}
							break;
						case Action.CLOSEPROJECT:
							var resultCollection : ArrayCollection = obj as ArrayCollection;							
							if( resultCollection ) {
								var closeprojectList:ArrayCollection = resultCollection.getItemAt( 0 ) as ArrayCollection;
								//var propertyFieldValueList:ArrayCollection 		= resultCollection.getItemAt( 1 ) as ArrayCollection;
								//var propertyPresetList:ArrayCollection 			= resultCollection.getItemAt( 2 ) as ArrayCollection;
								//var propertyIdList:ArrayCollection 				= resultCollection.getItemAt( 3 ) as ArrayCollection;				
								var phasesList:ArrayCollection 					= resultCollection.getItemAt( 4 ) as ArrayCollection;
								var closeTasksList:ArrayCollection				= resultCollection.getItemAt( 5 ) as ArrayCollection;
								var closeworflowtemplatesList:ArrayCollection 	= resultCollection.getItemAt( 6 ) as ArrayCollection;
								
								processCollections( closeprojectList,projectDAO.processor,projectDAO.collection );
								processCollections( phasesList,phaseDAO.processor,phaseDAO.collection );
								processCollections( closeTasksList,taskDAO.processor,taskDAO.collection );
								processCollections( closeworflowtemplatesList,workflowstemplateDAO.processor,workflowstemplateDAO.collection );
							}
							break;
						case Action.PAGINATIONQUERY:
							var resultAC : ArrayCollection = obj as ArrayCollection;
							var projectColl:ArrayCollection = new ArrayCollection();
							var curTsk:Tasks;
							for each( var prjArr:Array in resultAC ) {
							var prj:Projects = prjArr[ 0 ] as Projects;
							curTsk = prjArr[ 1 ] as Tasks;
							prj.currentTaskDateStart = curTsk.tDateCreation;
							prj.wftFK = curTsk.wftFK;
							prj.finalTask = curTsk; 
							projectColl.addItem( prj );
						}
							processCollections( projectColl,projectDAO.processor, projectDAO.collection );
							controlSignal.updateReportGridSignal.dispatch();
							break;
						case Action.STAND_RESUMEPROJECT:
							controlSignal.changeStateSignal.dispatch( Utils.TASKLIST_INDEX );
							break;
						case Action.BULKUPDATEPROJECTPROPERTIES:
							var propArrCollect : ArrayCollection = obj as ArrayCollection;
							
							var findUpdatedPrj:Projects = new Projects();
							findUpdatedPrj.projectId = signal.id;
							var updatedPrj:Projects = projectDAO.collection.findExistingItem(findUpdatedPrj) as Projects;
							if( propArrCollect ) {
								var fieldValue:Array = propArrCollect.getItemAt( 0 ) as Array;
								var presetFK:Array 	= propArrCollect.getItemAt( 1 ) as Array;
								var propPjID:Array 	= propArrCollect.getItemAt( 2 ) as Array;
								var propPjCollection:ArrayCollection = updatedPrj.propertiespjSet;
								var oldPropPjIds:Array =[];
								for each(var oldProPj:Propertiespj in propPjCollection){
									oldPropPjIds.push(oldProPj.propertyPjId);
								}
								for(var z:int=0; z<fieldValue.length; z++){
									var propPj:Propertiespj = new Propertiespj();
									propPj.fieldValue =(fieldValue[z]!=null)?fieldValue[z]:' '; 
									propPj.propertyPresetFk = presetFK[z];
									propPj.propertyPjId = propPjID[z];
									if(oldPropPjIds.indexOf(propPj.propertyPjId) == -1){
										var findPropertiespresets:Propertiespresets = new Propertiespresets();
										findPropertiespresets.propertyPresetId = propPj.propertyPresetFk;
										propPj.propertyPreset = propertiespresetsDAO.collection.findExistingItem(findPropertiespresets) as Propertiespresets;
										propPjCollection.addItem(propPj);
									}else{
										var updateOldPj:Propertiespj = GetVOUtil.getValueObject(propPj,propertiespjDAO.destination,propPjCollection) as Propertiespj;
										updateOldPj.fieldValue = propPj.fieldValue;
									}
								}
								if(currentInstance.mapConfig.fileUploadCollection.length >0){
									fileUpdation(signal.id ,signal.endIndex,signal.emailBody );	
								}else if(signal.endIndex !=0){
									controlSignal.changeStateSignal.dispatch( Utils.TASKLIST_INDEX );
								}	
							}
							break;
						default:
							break;
					}
					break;
				case Utils.TASKSKEY:
					switch( signal.action ) {
						case Action.FIND_ID:
							currentInstance.mapConfig.taskCollectionOfCurrentPerson = signal.currentProcessedCollection;	
							break;	
						case Action.FINDTASKSLIST:
							currentInstance.mapConfig.currentProject.tasksCollection = signal.currentProcessedCollection;
						default:
							break;
					}
					break;
				case Utils.PROJECTSKEY:
					switch( signal.action ) {
						case  Action.GETPROJECTSLIST:
							//project count
							var resultCount:int = parseInt( ( obj as ArrayCollection ).getItemAt( 0 ) as String );
							var startIndex:int = 0;
							var numberofPages:int;
							if(signal.processed && projectDAO.collection.items) count = projectDAO.collection.items.length
							//if(count != resultCount){
							count = resultCount
							numberofPages =  Math.ceil( count / perPageMaximum );
							for( var curPage:int = 1; curPage <= numberofPages; curPage++ ) {
								controlSignal.getPagedProjectListSignal.dispatch( null, currentInstance.mapConfig.currentPerson.personId, startIndex, perPageMaximum );
								startIndex = perPageMaximum*curPage;
							} 
							//}
							if( !signal.processed ) {
								controlSignal.changeStateSignal.dispatch( Utils.TASKLIST_INDEX );	
							}
							else {
								controlSignal.getTodoTasksSignal.dispatch( mainViewMediator.view.tasklist, currentInstance.mapConfig.currentPerson.personId );	
							}
							break; 
						case Action.UPDATE:
							var getUpdatedPrj:Projects = new Projects();
							getUpdatedPrj.projectId = obj.projectId;
							var updatedNewPrj:Projects = projectDAO.collection.findExistingItem(getUpdatedPrj) as Projects;
							if(signal.description)updatedNewPrj.finalTask = Tasks(signal.description);
							break;
						default:
							break;
					}
					break;
				case Utils.FILEDETAILSKEY:
					switch(signal.action){
						case  Action.BULK_UPDATE: 
							var pdfFileAC : ArrayCollection = new ArrayCollection();
							for each(var pdfFile:FileDetails in signal.currentProcessedCollection){
							var splitObject:Object = FileNameSplitter.splitFileName( pdfFile.fileName );			
							if(splitObject.extension  == 'pdf')	pdfFileAC.addItem(pdfFile);
						}							
							if(pdfFileAC.length>0){	
								tasksFilePathUpdation( pdfFileAC );
								controlSignal.convertFilesSignal.dispatch(null,pdfFileAC);
							}else{
								controlSignal.changeStateSignal.dispatch( Utils.TASKLIST_INDEX );
							}							
							break; 
						default:
							break;
					}
					break;
				default:
					break;
			}  
		} 
		
		private function tasksFilePathUpdation( pdfFileAC:ArrayCollection ):void{
			var fileObj:FileDetails = pdfFileAC.getItemAt( 0 ) as FileDetails;
			var updatedTask:Tasks = GetVOUtil.getVOObject( fileObj.taskId, taskDAO.collection.items, taskDAO.destination, Tasks ) as Tasks;
			if( updatedTask.previousTask ){
				var previousTasks:Tasks = updatedTask.previousTask;
				if( previousTasks.workflowtemplateFK.taskCode == Utils.NEWPROJENDTASKCODE||
					previousTasks.workflowtemplateFK.taskCode == Utils.CORRECTIONS_FRONT_SCREEN ){
					previousTasks.fileObj = fileObj;
					previousTasks.taskFilesPath = fileObj.fileId.toString();
					controlSignal.updateTaskSignal.dispatch( null, previousTasks );	
				}	
			}
		}
		
		private function fileUpdation(projid:int, taskid:int,path:String):void{
			var arrc:ArrayCollection = new ArrayCollection();
			var toPath:String = currentInstance.config.FileServer+path+Utils.fileSplitter
			for each(var filesVo:FileDetails in currentInstance.mapConfig.fileUploadCollection){
				filesVo.taskId = taskid;
				filesVo.projectFK = projid;
				var filename:String = filesVo.fileName; 
				var splitObject:Object = FileNameSplitter.splitFileName( filesVo.fileName );			
				
				if( filesVo.taskId ) {
					filename = splitObject.filename + filesVo.taskId;
				}
				filesVo.storedFileName = filename + DateUtil.getFileIdGenerator() + "." + splitObject.extension;
				filesVo.filePath = toPath+filesVo.type+Utils.fileSplitter+filesVo.storedFileName;
				filesVo.miscelleneous = FileNameSplitter.getUId();
				arrc.addItem( filesVo );
			}
			currentInstance.mapConfig.fileUploadCollection = new ArrayCollection();
			controlSignal.moveFilesSignal.dispatch(null,arrc,toPath);
			controlSignal.bulkUpdateFilesSignal.dispatch(null,arrc);
		}
		
		private function processCollections( resultObj:Object, currentProcessor:IVOProcessor, currentCollection:ICollection, getAllProjects:Boolean =false ):void {
			var currentSignal:SignalVO 
			if(getAllProjects){ 
				currentSignal = new SignalVO( null, paging,Action.GET_LIST );
			}else{
				currentSignal = new SignalVO( null, paging,Action.ADD_LIST );	
			}
			var outCollection:ICollection = updateCollection( currentCollection, currentSignal, resultObj );
			paging.delegate.processVO( currentProcessor, outCollection );
		}
	}
}
package com.adams.dt.business
{
	import com.adams.dt.model.vo.DefaultTemplate;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	

	public interface IDAODelegate extends IResponderAware
	{			
		function findByMailFileId(id:int):void
		function findUpdateStratusPersonDelegate(vo:IValueObject):void
		function findOnlinePersonDelegate():void
		function findUpdateOnlinePersonDelegate(vo:IValueObject): void
		function create(vo:IValueObject): void
		function update(vo:IValueObject): void
		function findPersonsListCount(subnum:int): void
		function directUpdate(vo:IValueObject): void		
		function select(vo: IValueObject) : void
		function deleteVO(vo:IValueObject): void
		function findByName(name:String ): void
		function findByNames(name1:String ,name2:String ): void
		function findByCode(name:String ): void
		function findByNameId(name:String ,id:int): void 
		function findByIdName(id:int,name:String ): void 
		function findById(subnum:int): void
		function findByNums(subnum1:int,subnum2:int): void
		function findByList(): void
		function findAll(): void
		function findByDate(date:Date): void
		function findByDateBetween(startDate:Date, endDate:Date): void
		function findByDateEnd(date:Date, id:int): void
		function findByDateBetweenEnd(startDate:Date, endDate:Date): void
		function findByPersonId(id:int): void
		function findList(): void
		function findByDomainWorkFlow(o:IValueObject): void
		function findByChatList(id:int,id1:int,id2:int): void
		function findChatUserList(senid1:int,recid1:int,senid2:int,recid2:int,projid:int): void
		function findWorkflowList(domainfk:int): void
		function findTasksList(projectfk:int): void 
		function findNotesList(taskfk:int): void
		function findPersonsList(project:IValueObject): void
		function findProfilesList(projectid:IValueObject): void
		function findDomain(code:String ): void 
		function findByProfile(profilefk:int): void 
		function findByWorkFlowId(workFlowfk:int): void
		function findByStopLabel(str:String ): void
		function findWorkflow(categoryId:int): void
		function login(username : String , password : String) : void	
		function findByMailPersonId(perid:int): void
		function findMailList(projectfk:int): void
		function findByMailProfileId(profileid:int): void
		function findMaxTaskId(perid:int): void
		function findByTaskId(id:int): void
		function bulkUpdate(arrayCollection : ArrayCollection) : void
		function createSubDir(parentFilePath:String,dirName:String):void
		//chat
		function findByChatListDelegate(chat:IValueObject):void
		//file
		 function copyDirectory(frompath : String,topath:String) : void
		 function doUpload(bytes : ByteArray , fileName : String, filePath : String) : void
		 function doCheck(fileName : String) : void
		 function getDownloadList() : void
		 function doConvert(filePath:String, exe:String) : void
		 function doDownload(fileName : String) : void
		 //translate
		 function changetoFrench(): void
		 function changetoEnglish(): void
		 function findProfileByPersonId(personId : int) : void
		 //teamline push
		 function findByTeamLinesId(profileid:int,projectid:int): void
		  // TimeLine
		 function getByProjectId(projectId : int) : void
		 function findProjectId(projectId : int) : void	
		 function findByBasicMessageId(id:int,name:String ): void 	 
		 // dtpagedao
		 function getQueryResult(query : String) : void
		 function deleteQuery(query : String) : void
		 function queryPagination(query : String, start:int, end:int) : void
		 function namedQuery(query : String, start:int, end:int) : void
		 function namedQueryId(query : String,id1:int, start:int, end:int) : void
		 function namedQueryIdId(query : String, id1:int,id2:int,start:int, end:int) : void
		 function namedQueryIdIdId(query : String, id1:int,id2:int,id3:int,start:int, end:int) : void
		 function namedQueryIdStr(query : String, id1:int,str:String,start:int, end:int) : void
		 function namedQueryIdDtDt(query : String, id1:int,dt1:Date,dt2:Date,start:int, end:int) : void
		 function namedQueryStr(query : String,str:String, start:int, end:int) : void
		 function namedQueryStrStr(query : String,str1:String, str2:String, start:int, end:int) : void
		 function namedQueryStrStrDtDt(query : String, str1:String,str2:String,dt1:Date,dt2:Date,start:int, end:int) : void
		 function namedQueryList(query : String) : void
		 function countRecords(vo : IValueObject) : void
		 function deleteAll() : void		 
		 function SmtpSSLMail(msgTo:String, msgSubject:String, msgBody:String) : void
		 
		 function getLoginListResult(id : int,profileId:int) : void
		 function getHomeList(personId:int, profileCode:String, domainFk:int, allReports:String, profilesFk:int): void
		 function createProjectList(categoryName : String,categoryId : int,personId : int) : void
		 	 
		 function createOracleNewProject(projectprefix : String,projectName : String,projectCommentName : String,categoryId : int,personId : int,
		 rootFolder : String,categorydomain : IValueObject,category1 : IValueObject,category2 : IValueObject,workflowId : int,codeEAN : String,codeGEST : String,codeIMPRE : String,codeIMPID : int,
		 phaseTemp:String,phaseCode:String,phaseName:String,phaseStart:String,phaseEndPlanified:String,phaseDuration:String,phaseStatus:int,workflowTemplatesId : int,endtaskCode:String) : void
		 
		 function createProjectProperties(projectID:String, propertiesPresetID:String, propValues:String) : void 
		 function createNavigationTasks(currenttaskId:int,workflowId:int,workflownexttempId:int,projId:int,personId:int,wftcode:String,tasksComments:String) : void
		 function oracleUpdateTeamline(projectId:String ,profileId:String ,personId:String,propprojectID:String, propertiesPresetID:String, propValues:String) : void
		 function oracleCreateDefaultTemp(defTempObj:DefaultTemplate, default_template_value:String, property_preset_fk:String) : void
		 function bulkDeleteId(defaulttempId : int) : void
		 function closeProjects(p_projectId:int, p_previousTask:int, p_workflowfk:int, p_tasksComment:String, p_propPresetFkArray:String, p_fieldValueArray:String, p_closingMode : String, p_personFk:int) : void
		 function projectStatusChangeTask(projectId :int , workflowFk :int , projectStatus :int,taskMessage:String,personFk :int ): void
		 function createReferenceFiles(ref_projectId :int, current_projectId :int, current_taskId :int, refTypeName:String, refCategoryName:String, 
				txtInputImpLength :int, clientTeamlineId :int, propertiesprojectId:String, propertiesPresetId:String, propertiespropValues:String ): void
		
	}
}

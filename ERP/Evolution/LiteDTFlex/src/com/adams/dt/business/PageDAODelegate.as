package com.adams.dt.business
{
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.model.vo.DefaultTemplate;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.rpc.IResponder;

	public final class PageDAODelegate extends AbstractDelegate implements IDAODelegate
	{ 
		public function PageDAODelegate(handlers:IResponder = null, service:String='')
		{		
			super(handlers, Services.PAGE_SERVICE ); 
		} 
		override public function findPersonsListCount(personId : int) : void
		{
			invoke("findPersonsListCount",personId );
		}		
		override public function getQueryResult(query : String) : void
		{
			invoke("getQueryResult",query);
		}
		override public function deleteQuery(query : String) : void
		{
			invoke("deleteByForeignKey",query);
		}
		override public function queryPagination(query : String, start:int, end:int) : void
		{
			invoke("queryPagination",query,start,end);
		}
		override public function namedQueryList(query : String) : void
		{
			invoke("queryListView",query);
		}
		override public function namedQuery(query : String, start:int, end:int) : void
		{
			invoke("paginationListView",query,start,end);
		}
 		override public function namedQueryId(query : String,id1:int, start:int, end:int) : void
		{
			invoke("paginationListViewId",query,id1,start,end);
		}
		override public function namedQueryIdId(query : String, id1:int,id2:int,start:int, end:int) : void
		{
			invoke("paginationListViewIdId",query,id1,id2,start,end);
		}
		override public function namedQueryIdIdId(query : String, id1:int,id2:int,id3:int,start:int, end:int) : void
		{
			invoke("paginationListViewIdIdId",query,id1,id2,id3,start,end);
		}
		override public function namedQueryIdStr(query : String, id1:int,str:String,start:int, end:int) : void
		{
			invoke("paginationListViewIdStr",query,id1,str,start,end);
		}
		
		override public function namedQueryIdDtDt(query : String, id1:int,dt1:Date,dt2:Date,start:int, end:int) : void
		{
			invoke("paginationListViewIdDtDt",query,id1,dt1,dt2,start,end);
		}
		
		override public function namedQueryStr(query : String,str:String, start:int, end:int) : void
		{
			invoke("paginationListViewStr",query,str,start,end);
		}
		override public function namedQueryStrStr(query : String,str1:String, str2:String, start:int, end:int) : void
		{
			invoke("paginationListViewStrStr",query,str1,str2,start,end);
		}
		
		override public function namedQueryStrStrDtDt(query : String, str1:String,str2:String,dt1:Date,dt2:Date,start:int, end:int) : void
		{
			invoke("paginationListViewStrStrDtDt",query,str1,str2,dt1,dt2,start,end);
		}
		override public function SmtpSSLMail(msgTo:String, msgSubject:String, msgBody:String) : void
		{
			invoke("SmtpSSLMail",msgTo,msgSubject,msgBody);
		}
		
		override public function getLoginListResult(personId:int,profileId:int) : void
		{
			invoke("getLoginListResult",personId,profileId);
		}
		override public function getHomeList(personId:int, profileCode:String, domainFk:int, allReports:String, profilesFk:int): void
		{
			invoke("getHomeList",personId,profileCode,domainFk,allReports,profilesFk);
		}
		override public function createProjectList(categoryName : String,categoryId : int,personId : int) : void
		{
			invoke("createProjectList",categoryName,categoryId,personId);
		} 
		override public function createOracleNewProject(projectprefix : String,projectName : String,projectCommentName : String,categoryId : int,personId : int,
														rootFolder : String,categorydomain : IValueObject,category1 : IValueObject,category2 : IValueObject,
														workflowId : int,codeEAN : String,codeGEST : String,codeIMPRE : String,codeIMPID : int,
														phaseTemp:String,phaseCode:String,phaseName:String,phaseStart:String,phaseEndPlanified:String,
														phaseDuration:String,phaseStatus:int,workflowTemplatesId : int,endtaskCode:String) : void
		{
			Utils.traceLog("Delegate Before Calling");
			
			
			invoke("createOracleNewProject",projectprefix,projectName,projectCommentName,categoryId,personId,rootFolder,
			categorydomain,category1,category2,workflowId,codeEAN,codeGEST,codeIMPRE,codeIMPID,
			phaseTemp,phaseCode,phaseName,phaseStart,phaseEndPlanified,phaseDuration,phaseStatus,workflowTemplatesId,endtaskCode);
			
			Utils.traceLog("Delegate After Calling");
		}
		override public function createProjectProperties(projectID:String ,propertiesPresetID:String ,propValues:String) : void
		{
			invoke("createProjectProperties",projectID,propertiesPresetID,propValues);
		}	
		override public function createNavigationTasks(currenttaskId:int,workflowId:int,workflownexttempId:int,projId:int,personId:int,wftcode:String,tasksComments:String) : void
		{
			invoke("createNavigationTasks",currenttaskId,workflowId,workflownexttempId,projId,personId,wftcode,tasksComments);
		}	
		override public function oracleUpdateTeamline(projectId:String ,profileId:String ,personId:String,propprojectID:String, propertiesPresetID:String, propValues:String) : void
		{
			invoke("oracleUpdateTeamline",projectId,profileId,personId,propprojectID,propertiesPresetID,propValues);
		}
		override public function oracleCreateDefaultTemp(defTempObj:DefaultTemplate, default_template_value:String, property_preset_fk:String) : void
		{
			invoke("oracleCreateDefaultTemp",defTempObj,default_template_value,property_preset_fk);
		}
		override public function bulkDeleteId(deftempvalueId : int) : void
		{
			invoke("bulkDeleteId",deftempvalueId);
		} 
		override public function closeProjects(p_projectId:int, p_previousTask:int, p_workflowfk:int, p_tasksComment:String, p_propPresetFkArray:String, p_fieldValueArray:String, p_closingMode : String, p_personFk:int) : void
		{
			invoke("closeProjects",p_projectId,p_previousTask,p_workflowfk,p_tasksComment,p_propPresetFkArray,p_fieldValueArray,p_closingMode,p_personFk);
		} 
		override public function projectStatusChangeTask(projectId :int , workflowFk :int , projectStatus :int,taskMessage:String,personFk :int ): void
		{
			invoke( "projectStatusChangeTask",projectId,workflowFk,projectStatus,taskMessage,personFk );
		}	
		
		override public function createReferenceFiles(ref_projectId :int, current_projectId :int, current_taskId :int, refTypeName:String, refCategoryName:String, 
								txtInputImpLength :int, clientTeamlineId :int, propertiesprojectId:String, propertiesPresetId:String, propertiespropValues:String ): void
		{
			invoke( "createReferenceFiles",ref_projectId, current_projectId, current_taskId, refTypeName, refCategoryName, txtInputImpLength, clientTeamlineId, propertiesprojectId, propertiesPresetId, propertiespropValues);
		}	
	}
}

package com.adams.dt.business
{
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
		override public function createFolderList(domain : IValueObject,category1 : IValueObject,category2 : IValueObject) : void
		{
			invoke("createFolderList",domain,category1,category2);
		} 
		override public function createProjectList(categoryName : String,categoryId : int,personId : int) : void
		{
			invoke("createProjectList",categoryName,categoryId,personId);
		} 
		override public function SelectALLCategories(categoryId : int) : void
		{
			invoke("SelectALLCategories",categoryId);
		} 
		override public function createBulkTasks(workflowFK:int, nextworkflowtempid:int, projId:int, persId:int,taskcode : String) : void
		{
			invoke("createBulkTasks",workflowFK,nextworkflowtempid,projId,persId,taskcode);
		} 
		override public function createOracleNewProject(projectprefix : String,projectName : String,projectCommentName : String,categoryId : int,personId : int,rootFolder : String,categorydomain : IValueObject,category1 : IValueObject,category2 : IValueObject,workflowId : int,codeEAN : String,codeGEST : String,codeIMPRE : String) : void
		{
			invoke("createOracleNewProject",projectprefix,projectName,projectCommentName,categoryId,personId,rootFolder,categorydomain,category1,category2,workflowId,codeEAN,codeGEST,codeIMPRE);
		}						
	}
}

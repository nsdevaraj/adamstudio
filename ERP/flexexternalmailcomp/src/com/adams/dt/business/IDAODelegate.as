package com.adams.dt.business
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	

	public interface IDAODelegate extends IResponderAware
	{			
		function findAll(): void
		function create(vo:IValueObject): void
		function update(vo:IValueObject): void
		function select(vo: IValueObject) : void
		function deleteVO(vo:IValueObject): void
		function bulkUpdate(arrayCollection : ArrayCollection) : void
		
		function findByTaskId(id:int): void
		function findMailList(projectfk:int): void
		function findByIdName(id:int,name:String ): void 
		function findByMailFileId(id:int):void
		function doUpload(bytes : ByteArray , fileName : String, filePath : String) : void
		function doDownload(fileName : String) : void
		function findByMailProfileId(profileid:int): void
		function findByMailPersonId(perid:int): void
		function findById(workflowid:int): void
		// TimeLine
		function getByProjectId(projectId : int) : void
		//translate
		 function changetoFrench(): void
		 function changetoEnglish(): void
		 //teamline push
		 function findByTeamLinesId(profileid:int,projectid:int): void
		 
		 function findByEmailId(eMail:String): void
		 function findByName(name:String ): void
		 function findProfilesList(projectid:IValueObject): void
		 function findDomain(code:String ): void 
		 function findPersonsList(project:IValueObject): void
		function findIMPEmail(name:String ): void
		 function login(username : String , password : String) : void	
		 
				
		/* function findByMailFileId(id:int):void
		function findUpdateStratusPersonDelegate(vo:IValueObject):void
		function findOnlinePersonDelegate():void
		function findUpdateOnlinePersonDelegate(vo:IValueObject): void
		function create(vo:IValueObject): void
		function update(vo:IValueObject): void
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
		function findByDate(date:Date, id:int): void
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
		function findMaxTaskId(): void
		function findByTaskId(id:int): void
		function bulkUpdate(arrayCollection : ArrayCollection) : void
		function createSubDir(parentFilePath:String,dirName:String):void
		//chat
		function findByChatListDelegate(chat:IValueObject):void
		//file
		 function doUpload(bytes : ByteArray , fileName : String, filePath : String) : void
		 function doCheck(fileName : String) : void
		 function getDownloadList() : void
		 function doConvert(bytes : ByteArray , fileName : String) : void
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
		 function namedQueryList(query : String) : void */
	}
}

package com.adams.dt.business
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	

	public interface IDAODelegate extends IResponderAware
	{			
		function getList(): void
		function findAll(): void
		function create(vo:IValueObject): void
		function update(vo:IValueObject): void
		function directUpdate(vo:IValueObject): void
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
		 function findByNameFileId(name:String ,projid:int,fileid:int): void
		function findByNums(subnum1:int,subnum2:int): void
		function findByIndProjId(name:String ,projid:int): void
		function deleteById(vo:IValueObject): void		
		function findProjectId(projectId : int) : void			
		
	}
}

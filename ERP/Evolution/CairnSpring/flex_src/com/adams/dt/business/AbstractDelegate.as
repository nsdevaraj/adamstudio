package com.adams.dt.business
{
	import com.adams.dt.model.ModelLocator;
	import com.adobe.cairngorm.vo.IValueObject;
	import com.universalmind.cairngorm.business.Delegate;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.InvokeEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.remoting.RemoteObject;
	import mx.rpc.remoting.mxml.Operation;
	public class AbstractDelegate extends Delegate
	{
		/**
		 * Reference to the XML / HTTP service the concrete delegate's will will use.
		 */
		public var httpService:HTTPService;
 		public var rservice:RemoteObject;
 		
		 /** ModelLocator look-up and common references*/
		public var model : ModelLocator = ModelLocator.getInstance();
		/**
		 * Constructor.
		 */
		public function AbstractDelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers,service);
			trace("AbstractDelegate Constructor");
		}
		/** Invoke the dynamic parameter of java method*/
		protected function invoke(methodName:String, ...args) : void
		  {
		  	 // if(service.channelSet==null) service.channelSet = model.channelSet;
		      var operation:Operation = service[ methodName ];
		      operation.arguments = args;
		            
		      var call:AsyncToken = operation.send();
		      call.addResponder( responder );
		  }
		  
		/** Type of service Invoked */  
		public function serviceInvoked(event:mx.rpc.events.InvokeEvent):void{  
	        trace(event.currentTarget.toString()+ ' here ' )
		} 
		/**
		 * RPC Responder, used as a reference back to the command that made the request.
		 */
		private var _responder:IResponder;
		override public function get responder():IResponder
		{
			return this._responder;
		}
		public function set responder(value:IResponder):void
		{
			this._responder = value;
		}
		 /**
		  * Find an Method by its primary key.
		  * @param id
		  */
		public function findById(id : int) : void
		{
			invoke("findById",id);
		}
		 /**
		  * Finds all the methods
		  */
		public function findAll() : void
		{
			invoke("findAll");
		}
		/**
	     * Insert a new Method .
	     * @param vo
	     */
		public function create(vo :IValueObject) : void
		{
			invoke("create",vo);
		}
		 /**
		  * Find a Method by its Name.
		  * @param str
		  */		
		public function findByName(str : String) : void
		{
			invoke("findByName",str);
		}
		/**
	     * Delete a new Method .
	     * @param vo
	     */		
		public function deleteVO(vo : IValueObject) : void
		{
			invoke("deleteById",vo);
		}
		/**
	     * Update the Method.
	     * @param vo
	     */		
 		public function update(vo : IValueObject) : void
		{
			invoke("update",vo);
		}
		/**
	     * Select the Method.
	     * @param vo
	     */			 
		 public function select(vo : IValueObject) : void
		{
			invoke("select",vo);
		}
		/**
	     * Update the Method.
	     * @param vo
	     */			 
		public function bulkUpdate(collection : ArrayCollection) : void
		{
			invoke("bulkUpdate",collection);
		}
		/**
	     * Find a Method by its Names.
		 * @param str,str1
	     */			
 		public function findByNames(str : String , str1 : String) : void
		{
			invoke("findByNames",str , str1);
		}
		  /**
           * Authentication based on Username and password.
           */	
		public function login(username : String , password : String) : void{}
		/* Find a Method by its Code */
		public function findByCode(name:String ): void {}
		/**
	     * Find a Method by its Name and Id.
		 * @param Name,Id
	     */		
		public function findByNameId(name:String ,id:int): void {
			invoke("findByNameId",name , id);
		} 
		/* Find a Method by its MailFileId */
		public function findByMailFileId(id:int):void{
		}
		
		/**
	     * Method Name findByIdName.
		 * @param id primarykey value pass
		 * @param name value pass 
		 * return type void
	     */		
		public function findByIdName(id:int,name:String ): void {} 
		/**
	     * Method Name findByNums.
		 * @param subnum1 primarykey value pass
		 * @param subnum2 foreignkey value pass
		 * return type void
	     */	
		public function findByNums(subnum1:int,subnum2:int): void {}
		/**
	     * Method Name findByList.		
		 * return type void
	     */	
		public function findByList(): void {}
		/**
	     * Method Name findByDate.
	     * @param date Date value pass
		 * @param unique id value pass
		 * return type void
	     */	
		public function findByDate(date:Date, id:int): void {}
		/**
	     * Method Name findByDateBetween.
	     * @param Date startDate value pass
		 * @param Date endDate value pass
		 * return type void
	     */	
		public function findByDateBetween(startDate:Date, endDate:Date): void {}
		/**
	     * Method Name findByDateEnd.
	     * @param date Date value pass
		 * @param unique id value pass
		 * return type void
	     */	
		public function findByDateEnd(date:Date, id:int): void {}
		/**
	     * Method Name findByDateBetweenEnd.
	     * @param Date startDate value pass
		 * @param Date endDate value pass
		 * return type void
	     */	
		public function findByDateBetweenEnd(startDate:Date, endDate:Date): void {}
		/**
	     * Method Name findByPersonId.
	     * @param unique id value pass
		 * return type void
	     */	
		public function findByPersonId(id:int): void {}
		/**
	     * Method Name findPersonsList.
	     * @param Project Object value pass
		 * return type void
	     */	
		public function findPersonsList(project:IValueObject): void {}
		/**
	     * Method Name findOnlinePersonDelegate.
		 * return type void
	     */	
		public function findOnlinePersonDelegate() : void {}
		/**
	     * Method Name findUpdateOnlinePersonDelegate.
	     * @param Persons Object value pass
		 * return type void
	     */	
		public function findUpdateOnlinePersonDelegate(persons :IValueObject) : void {}
		/**
	     * Method Name findUpdateStratusPersonDelegate.
	     * @param Persons Object value pass
		 * return type void
	     */
		public function findUpdateStratusPersonDelegate(persons : IValueObject) : void {}
		/**
	     * Method Name findList.
		 * return type void
	     */
		public function findList(): void {}
		/**
	     * Method Name findByDomainWorkFlow.
	     * @param Domain Object value pass
		 * return type void
	     */
		public function findByDomainWorkFlow(o:IValueObject): void {}
		/**
	     * Method Name findByChatList.
	     * @param unique id value pass
	     * @param unique id1 value pass
	     * @param unique id2 value pass
		 * return type void
	     */	
		public function findByChatList(id:int,id1:int,id2:int): void {}
		/**
	     * Method Name findChatUserList.
	     * @param unique senid1 value pass
	     * @param unique recid1 value pass
	     * @param unique senid2 value pass
	     * @param unique recid2 value pass
	     * @param unique projid value pass
		 * return type void
	     */	
		public function findChatUserList(senid1:int,recid1:int,senid2:int,recid2:int,projid:int): void {}
		/**
	     * Method Name findWorkflowList.
	     * @param unique domainfk value pass	     
		 * return type void
	     */	
		public function findWorkflowList(domainfk:int): void {}
		/**
	     * Method Name findTasksList.
	     * @param unique projectfk value pass	     
		 * return type void
	     */	
		public function findTasksList(projectfk:int): void {} 
		
		/**
	     * Method Name findNotesList.
	     * @param unique taskfk value pass	     
		 * return type void
	     */	
		public function findNotesList(taskfk:int): void {}
		
		/**
	     * Method Name findProfilesList.
	     * @param Profile Object value pass     
		 * return type void
	     */	
		public function findProfilesList(vo:IValueObject): void {}
		
		/**
	     * Method Name findDomain.
	     * @param String code value pass     
		 * return type void
	     */	
		public function findDomain(code:String ): void {} 
		
		/**
	     * Method Name findByProfile.
	     * @param unique profilefk value pass	       
		 * return type void
	     */	
		public function findByProfile(profilefk:int): void {}
		
		/**
	     * Method Name findByWorkFlowId.
	     * @param unique workFlowfk value pass	       
		 * return type void
	     */	 
		public function findByWorkFlowId(workFlowfk:int): void {}
		
		/**
	     * Method Name findByStopLabel.
	     * @param String str value pass        
		 * return type void
	     */	
		public function findByStopLabel(str:String ): void {}
		
		/**
	     * Method Name findByStopLabel.
	     * @param unique categoryId value pass	       
		 * return type void
	     */	
		public function findWorkflow(categoryId:int): void {}
			
		/**
	     * Method Name findByMailPersonId.
	     * @param unique personid value pass	       
		 * return type void
	     */	
		public function findByMailPersonId(perid:int): void {}
		
		/**
	     * Method Name findMailList.
	     * @param unique projectfk value pass	       
		 * return type void
	     */	
		public function findMailList(projectfk:int): void {}
		
		/**
	     * Method Name findByMailProfileId.
	     * @param unique profileid value pass	       
		 * return type void
	     */	
		public function findByMailProfileId(profileid:int): void {}
		
		/**
	     * Method Name findMaxTaskId.
		 * return type void
	     */	
		public function findMaxTaskId(): void {}
		
		/**
	     * Method Name findByTaskId.
	     * @param unique taskid value pass	       
		 * return type void
	     */	
		public function findByTaskId(id:int): void {}
		
		/**
	     * Method Name createSubDir.
	     * @param parentFilePath value pass	       
		 * @param dirName value pass	 
		 * * return type void
	     */	
		public function createSubDir(parentFilePath:String,dirName:String):void{}
		
		/**
	     * Method Name findByChatListDelegate.
	     * @param Chat Object value pass     
		 * return type void
	     */	
		public function findByChatListDelegate(chat:IValueObject):void{}
		
		/**
	     * Method Name doUpload.
	     * @param ByteArray value pass	upload file ByteArray       
		 * @param fileName value pass	upload file name
		 * @param filePath value pass	upload file path
		 * return type void
	     */	
		public function doUpload(bytes : ByteArray , fileName : String, filePath : String) : void{}
		
		/**
	     * Method Name doCheck.
		 * @param fileName value pass	 
		 * * return type void
	     */	
		public function doCheck(fileName : String) : void{}
		
		/**
	     * Method Name getDownloadList.
		 * return type void
	     */
		public function getDownloadList() : void{}
		
		/**
	     * Method Name doConvert.
	     * @param ByteArray value pass	upload file ByteArray       
		 * @param fileName value pass	upload file name
		 * return type void
	     */	
		public function doConvert(bytes : ByteArray , fileName : String) : void{}
		
		/**
	     * Method Name doDownload.
		 * @param fileName value pass	 
		 * return type void
	     */	
		public function doDownload(fileName : String) : void{}
		
		/**
	     * Method Name changetoFrench. 
	     * translate French
		 * return type void
	     */		
		public function changetoFrench(): void{}
		
		/**
	     * Method Name changetoEnglish. 
	     * translate nglish
		 * return type void
	     */	
		public function changetoEnglish(): void{}
		
		/**
	     * Method Name findProfileByPersonId.
		 * @param unique personId value pass	   
		 * return type void
	     */	
		public function findProfileByPersonId(personId : int) : void{}
		
		/**
	     * Method Name findByTeamLinesId.
		 * @param unique profileid value pass	
		 * @param unique projectid value pass	   
		 * return type void
	     */			
		public function findByTeamLinesId(profileid:int,projectid:int) : void{}
		
		/**
	     * Method Name getByProjectId.
		 * @param unique projectid value pass	   
		 * return type void
	     */		
		public function getByProjectId(projectId : int) : void{}
		
		/**
	     * Method Name getQueryResult.
		 * @param query value pass  
		 * serverside invoke java method getQueryResult
		 * return type void
	     */	
		public function getQueryResult(query : String) : void
		{
			invoke("getQueryResult",query);
		}
		
		/**
	     * Method Name deleteQuery.
		 * @param query value pass  
		 * serverside invoke java method deleteByForeignKey
		 * return type void
	     */	
		public function deleteQuery(query : String) : void
		{
			invoke("deleteByForeignKey",query);
		}
		
		/**
	     * Method Name queryPagination.
		 * @param query value pass  
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method queryPagination
		 * return type void
	     */
		public function queryPagination(query : String, start:int, end:int) : void
		{
			invoke("queryPagination",query,start,end);
		}
		
		/**
	     * Method Name namedQuery.
		 * @param query value pass  
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListView
		 * return type void
	     */
		public function namedQuery(query : String, start:int, end:int) : void
		{
			invoke("paginationListView",query,start,end);
		}
		
		/**
	     * Method Name namedQueryId.
		 * @param query value pass 
		 * @param unique id value pass 
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewId
		 * return type void
	     */
 		public function namedQueryId(query : String,id1:int, start:int, end:int) : void
		{
			invoke("paginationListViewId",query,id1,start,end);
		}
		
		/**
	     * Method Name namedQueryIdId.
		 * @param query value pass 
		 * @param unique id1 value pass 
		 * @param unique id2 value pass 
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewIdId
		 * return type void
	     */
		public function namedQueryIdId(query : String, id1:int,id2:int,start:int, end:int) : void
		{
			invoke("paginationListViewIdId",query,id1,id2,start,end);
		}
		
		/**
	     * Method Name namedQueryIdIdId.
		 * @param query value pass 
		 * @param unique id1 value pass 
		 * @param unique id2 value pass 
		 * @param unique id3 value pass 
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewIdIdId
		 * return type void
	     */
		public function namedQueryIdIdId(query : String, id1:int,id2:int,id3:int,start:int, end:int) : void
		{
			invoke("paginationListViewIdIdId",query,id1,id2,id3,start,end);
		}
		
		/**
	     * Method Name namedQueryIdStr.
		 * @param query value pass 
		 * @param unique id1 value pass 
		 * @param str value pass
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewIdStr
		 * return type void
	     */
		public function namedQueryIdStr(query : String, id1:int,str:String,start:int, end:int) : void
		{
			invoke("paginationListViewIdStr",query,id1,str,start,end);
		}
		
		/**
	     * Method Name namedQueryIdDtDt.
		 * @param query value pass 
		 * @param unique id1 value pass 
		 * @param Date dt1 value pass
		 * @param Date dt2 value pass
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewIdDtDt
		 * return type void
	     */
		public function namedQueryIdDtDt(query : String, id1:int,dt1:Date,dt2:Date,start:int, end:int) : void
		{
			invoke("paginationListViewIdDtDt",query,id1,dt1,dt2,start,end);
		}
		
		/**
	     * Method Name namedQueryStr.
		 * @param query value pass 
		 * @param String value pass 
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewStr
		 * return type void
	     */
		public function namedQueryStr(query : String,str:String, start:int, end:int) : void
		{
			invoke("paginationListViewStr",query,str,start,end);
		}
		
		/**
	     * Method Name namedQueryStrStr.
		 * @param query value pass 
		 * @param String str1 value pass 
		 * @param String str2 value pass
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewStrStr
		 * return type void
	     */
		public function namedQueryStrStr(query : String,str1:String, str2:String, start:int, end:int) : void
		{
			invoke("paginationListViewStrStr",query,str1,str2,start,end);
		}
		
		/**
	     * Method Name namedQueryStrStrDtDt.
		 * @param query value pass 
		 * @param String str1 value pass 
		 * @param String str2 value pass
		 * @param Date dt1 value pass
		 * @param Date dt2 value pass
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewStrStrDtDt
		 * return type void
	     */
		public function namedQueryStrStrDtDt(query : String, str1:String,str2:String,dt1:Date,dt2:Date,start:int, end:int) : void
		{
			invoke("paginationListViewStrStrDtDt",query,str1,str2,dt1,dt2,start,end);
		}
		
		/**
	     * Method Name namedQueryList.
		 * @param query value pass 		 
		 * serverside invoke java method queryListView
		 * return type void
	     */
		public function namedQueryList(query : String) : void
		{
			invoke("queryListView",query);
		}
	}
}
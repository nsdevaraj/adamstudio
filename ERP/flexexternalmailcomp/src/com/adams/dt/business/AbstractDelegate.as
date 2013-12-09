package com.adams.dt.business
{
	import com.adams.dt.model.ModelLocator;
	import com.adobe.cairngorm.vo.IValueObject;
	import com.universalmind.cairngorm.business.Delegate;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.events.InvokeEvent;
	import mx.rpc.http.HTTPService;
	import mx.rpc.remoting.RemoteObject;
	import mx.rpc.remoting.mxml.Operation;
	import flash.utils.ByteArray;
	public class AbstractDelegate extends Delegate
	{
		/**
		 * Reference to the XML / HTTP service the concrete delegate's will will use.
		 */
		public var httpService:HTTPService;
 		public var rservice:RemoteObject;
		
		public var model : ModelLocator = ModelLocator.getInstance();
		/**
		 * Constructor.
		 */
		public function AbstractDelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers,service);
			trace("AbstractDelegate Constructor");
		}
		protected function invoke(methodName:String, ...args) : void
		  {
		  	 // if(service.channelSet==null) service.channelSet = model.channelSet;
		      var operation:Operation = service[ methodName ];
		      operation.arguments = args;
		            
		      var call:AsyncToken = operation.send();
		      call.addResponder( responder );
		  }
		public function serviceInvoked(event:mx.rpc.events.InvokeEvent):void{
			var timeStamp:Date = model.currentTime;
			var diffmins:int = -(model.serverLastAccessedAt.time - timeStamp.time)/60000;
 			model.serverLastAccessedAt = timeStamp;
 			//(diffmins>1)? model.bgUploadFile.idle=true:model.bgUploadFile.idle=false;
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
		//methods for interface
		public function findById(id : int) : void
		{
			invoke("findById",id);
		}
		public function findAll() : void
		{
			invoke("findAll");
		}
		public function create(vo :IValueObject) : void
		{
			invoke("create",vo);
		}
		public function findByName(str : String) : void
		{
			invoke("findByName",str);
		}
		public function deleteVO(vo : IValueObject) : void
		{
			invoke("deleteById",vo);
		}
 		public function update(vo : IValueObject) : void
		{
			invoke("update",vo);
		} 
		 public function select(vo : IValueObject) : void
		{
			invoke("select",vo);
		} 
		public function bulkUpdate(collection : ArrayCollection) : void
		{
			invoke("bulkUpdate",collection);
		}	
		//Authenticate
		public function login(username : String , password : String) : void{}	
		public function findByTaskId(id:int): void {}
		public function findMailList(taskid:int): void {}
		public function findByIdName(id:int,name:String ): void {
			invoke("findByIdName",id , name);
		} 	
		public function findByMailFileId(id:int):void{
		}
		public function doUpload(bytes : ByteArray , fileName : String, filePath : String) : void{}
		public function doDownload(fileName : String) : void{}
		public function findByMailProfileId(profileid:int): void {}
		public function findByMailPersonId(perid:int): void {}
		 // TimeLine
		public function getByProjectId(projectId : int) : void{}
		//translate
		public function changetoFrench(): void{}
		public function changetoEnglish(): void{}
		//teamline push
		public function findByTeamLinesId(profileid:int,projectid:int) : void{}
		
		public function findByEmailId(eMail:String): void {}
		public function findProfilesList(vo:IValueObject): void {}
		public function findDomain(code:String ): void {} 
		public function findPersonsList(project:IValueObject): void {}
		public function findIMPEmail(str : String) : void
		{
			invoke("findIMPEmail",str);
		}
		
 		/*public function findByNames(str : String , str1 : String) : void
		{
			invoke("findByNames",str , str1);
		}		//Authenticate
		public function login(username : String , password : String) : void{}
		
		public function findByCode(name:String ): void {}
		public function findByNameId(name:String ,id:int): void {
			invoke("findByNameId",name , id);
		} 
		public function findByMailFileId(id:int):void{
		}
		public function findByIdName(id:int,name:String ): void {
			invoke("findByIdName",id , name);
		} 	
		public function findByWorkFlowId(workFlowfk:int): void {
			invoke("findByWorkFlowId",workFlowfk);
		}

		public function findByNums(subnum1:int,subnum2:int): void {}
		public function findByList(): void {}
		public function findByDate(date:Date, id:int): void {}
		public function findByDateBetween(startDate:Date, endDate:Date): void {}
		public function findByDateEnd(date:Date, id:int): void {}
		public function findByDateBetweenEnd(startDate:Date, endDate:Date): void {}
		public function findByPersonId(id:int): void {}
		public function findPersonsList(project:IValueObject): void {}
		public function findOnlinePersonDelegate() : void {}
		public function findUpdateOnlinePersonDelegate(persons :IValueObject) : void {}
		public function findUpdateStratusPersonDelegate(persons : IValueObject) : void {}
		public function findList(): void {}
		public function findByDomainWorkFlow(o:IValueObject): void {}
		public function findByChatList(id:int,id1:int,id2:int): void {}
		public function findChatUserList(senid1:int,recid1:int,senid2:int,recid2:int,projid:int): void {}
		public function findWorkflowList(domainfk:int): void {}
		public function findTasksList(projectfk:int): void {} 
		public function findNotesList(taskfk:int): void {}
		public function findProfilesList(vo:IValueObject): void {}
		public function findDomain(code:String ): void {} 
		public function findByProfile(profilefk:int): void {} 
		public function findByStopLabel(str:String ): void {}
		public function findWorkflow(categoryId:int): void {}
			
		public function findByMailPersonId(perid:int): void {}
		public function findMailList(projectfk:int): void {}
		public function findByMailProfileId(profileid:int): void {}
		public function findMaxTaskId(): void {}
		public function findByTaskId(id:int): void {}
		//directory
		public function createSubDir(parentFilePath:String,dirName:String):void{}
		//chat
		public function findByChatListDelegate(chat:IValueObject):void{}
		//file
		public function doUpload(bytes : ByteArray , fileName : String, filePath : String) : void{}
		public function doCheck(fileName : String) : void{}
		public function getDownloadList() : void{}
		public function doConvert(bytes : ByteArray , fileName : String) : void{}
		public function doDownload(fileName : String) : void{}
		//translate
		public function changetoFrench(): void{}
		public function changetoEnglish(): void{}
		public function findProfileByPersonId(personId : int) : void{}
		//teamline push
		public function findByTeamLinesId(profileid:int,projectid:int) : void{}
		 // TimeLine
		public function getByProjectId(projectId : int) : void{}
		
		public function findProjectId(projectId : int) : void{}
		public function findByBasicMessageId(id:int,name:String ): void {} 		
				
		public function getQueryResult(query : String) : void
		{
			invoke("getQueryResult",query);
		}
		public function deleteQuery(query : String) : void
		{
			invoke("deleteByForeignKey",query);
		}
		public function queryPagination(query : String, start:int, end:int) : void
		{
			invoke("queryPagination",query,start,end);
		}
		public function namedQuery(query : String, start:int, end:int) : void
		{
			invoke("paginationListView",query,start,end);
		}
 		public function namedQueryId(query : String,id1:int, start:int, end:int) : void
		{
			invoke("paginationListViewId",query,id1,start,end);
		}
		public function namedQueryIdId(query : String, id1:int,id2:int,start:int, end:int) : void
		{
			invoke("paginationListViewIdId",query,id1,id2,start,end);
		}
		public function namedQueryIdIdId(query : String, id1:int,id2:int,id3:int,start:int, end:int) : void
		{
			invoke("paginationListViewIdIdId",query,id1,id2,id3,start,end);
		}
		public function namedQueryIdStr(query : String, id1:int,str:String,start:int, end:int) : void
		{
			invoke("paginationListViewIdStr",query,id1,str,start,end);
		}
		
		public function namedQueryIdDtDt(query : String, id1:int,dt1:Date,dt2:Date,start:int, end:int) : void
		{
			invoke("paginationListViewIdDtDt",query,id1,dt1,dt2,start,end);
		}
		
		public function namedQueryStr(query : String,str:String, start:int, end:int) : void
		{
			invoke("paginationListViewStr",query,str,start,end);
		}
		public function namedQueryStrStr(query : String,str1:String, str2:String, start:int, end:int) : void
		{
			invoke("paginationListViewStrStr",query,str1,str2,start,end);
		}
		
		public function namedQueryStrStrDtDt(query : String, str1:String,str2:String,dt1:Date,dt2:Date,start:int, end:int) : void
		{
			invoke("paginationListViewStrStrDtDt",query,str1,str2,dt1,dt2,start,end);
		}
		public function namedQueryList(query : String) : void
		{
			invoke("queryListView",query);
		} */
	}
}
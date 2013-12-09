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
			invoke("getList");//invoke("findAll");
		}
		public function getList() : void
		{
			invoke("getList");//invoke("findAll");
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
		
 		public function directUpdate(vo : IValueObject) : void
		{
			invoke("directUpdate",vo);
		} 
		 public function select(vo : IValueObject) : void
		{
			invoke("select",vo);
		} 
		public function bulkUpdate(collection : ArrayCollection) : void
		{
			invoke("bulkUpdate",collection);
		}	
		public function deleteById(vo : IValueObject) : void
		{
			invoke("deleteById",vo);
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
		public function findByNameFileId(name:String ,projid:int,fileid:int): void
		{}
		public function findByNums(subnum1:int,subnum2:int): void {}
		public function findByIndProjId(name:String ,projid:int): void{}
		public function findProjectId(projectId : int) : void{}			
	}
}
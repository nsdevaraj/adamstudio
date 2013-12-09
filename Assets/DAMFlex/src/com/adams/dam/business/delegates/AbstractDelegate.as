package com.adams.dam.business.delegates
{
	
	import com.adams.dam.model.ModelLocator;
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
		public var httpService:HTTPService;
 		public var rservice:RemoteObject;
		
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		private var _responder:IResponder;
		override public function get responder():IResponder {
			return this._responder;
		}
		public function set responder(value:IResponder):void {
			this._responder = value;
		}
		
		public function AbstractDelegate( handlers:IResponder = null, service:String='' )
		{
			super( handlers, service );
		}
		
		protected function invoke( methodName:String, ...args):void {
		  	  var operation:Operation = service[ methodName ];
		      operation.arguments = args;
		            
		      var call:AsyncToken = operation.send();
		      call.addResponder( responder );
		}
		
		public function serviceInvoked( event:mx.rpc.events.InvokeEvent ):void {
			/*var timeStamp:Date = model.currentTime;
			var diffmins:int = - ( model.serverLastAccessedAt.time - timeStamp.time ) / 60000;
 			model.serverLastAccessedAt = timeStamp;
 			( diffmins > 1 ) ? ( model.bgUploadFile.idle = true ) : ( model.bgUploadFile.idle = false );*/
 		} 
		
		public function login( username:String, password:String ):void {
		
		}
		
		public function findAll():void {
			invoke( "getList" );
		}
		
		public function create( vo:IValueObject ):void {
			invoke( "create", vo );
		}
		
		public function update( vo:IValueObject ):void {
			invoke( "update", vo );
		} 
		
		public function bulkUpdate( collection:ArrayCollection ):void {
			invoke( "bulkUpdate", collection );
		}
		
		public function findPersonsList( project:IValueObject ):void {
		
		}
		
		public function doUpload( bytes:ByteArray, fileName:String, filePath:String ):void {
		
		}
		
		public function findByMailFileId( id:int ):void {
			
		}
		
		public function doDownload( fileName:String ):void {
		
		}
		
		public function doConvert( filePath:String, exe:String ):void {
		
		}
		
		public function copyDirectory( frompath:String, topath:String ):void {
		
		}
	}
}
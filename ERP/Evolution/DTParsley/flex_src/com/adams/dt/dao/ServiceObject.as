package com.adams.dt.dao 
{
	import com.adams.dt.delegates.AbstractDelegate;
	import com.adams.dt.model.vo.IValueObject;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	public class ServiceObject extends CRUDObject implements ICommon  
	{ 
		public function extracreate( vo:IValueObject ):AsyncToken {
			delegate.token = service.create();
			return delegate.token;
		}
	}
}
package com.adams.dt.business.login
{
	import com.adams.dt.business.AbstractDelegate;
	import com.adams.dt.business.IDAODelegate;
	import com.adams.dt.business.Services;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.rpc.IResponder;
	public final class LogoutDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function LogoutDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.PERSON_SERVICE );
		}
 
		override public function select(per : IValueObject) : void
		{
			invoke("update",per);
		} 
	}
}

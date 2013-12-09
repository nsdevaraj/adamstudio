package com.adams.dt.business
{
	import mx.rpc.IResponder;
	import com.adobe.cairngorm.vo.IValueObject;
	public final class DefaultTemplateValueDelegate extends AbstractDelegate implements IDAODelegate
	{
	 	public function DefaultTemplateValueDelegate( handlers:IResponder = null, service:String='' )
		{
			super( handlers, Services.DEFAULT_VALUE_SERVICE );			
		}
		override public function findById(id:int):void {
        	invoke("findById",id)
        }
	}
}

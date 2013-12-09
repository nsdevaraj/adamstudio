package com.adams.dt.business
{
	import mx.rpc.IResponder;
	import com.adobe.cairngorm.vo.IValueObject;

	public final class DefaultTemplateDelegate extends AbstractDelegate implements IDAODelegate
	{
	 	public function DefaultTemplateDelegate( handlers:IResponder = null, service:String='' )
		{
			super( handlers, Services.DEFAULT_SERVICE );			
		}
		
		override public function update(defTemp : IValueObject) : void
		{
			invoke("create",defTemp);
		}
        
        override public function findById(id:int):void {
        	invoke("findById",id)
        }

	}
}

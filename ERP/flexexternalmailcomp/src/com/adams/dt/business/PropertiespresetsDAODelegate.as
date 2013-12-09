package com.adams.dt.business
{
	import com.adams.dt.model.vo.Workflows;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.rpc.IResponder;
	public final class PropertiespresetsDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function PropertiespresetsDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.PROPERTY_PRESET_SERVICE);	
		}
 		override public function findAll() : void
		{
			invoke("findAll");
		}
	}
}

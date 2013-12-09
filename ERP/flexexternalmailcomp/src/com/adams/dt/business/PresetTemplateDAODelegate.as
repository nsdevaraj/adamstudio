package com.adams.dt.business
{
	import com.adams.dt.model.vo.Workflows;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.rpc.IResponder;
	public final class PresetTemplateDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function PresetTemplateDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.PRESETTEMPLATE_SERVICE);
		}
		override public function findAll() : void
		{
			invoke("findAll");
		}
 		override public function findById(id : int) : void
		{
			invoke("findById",id);
		} 
	}
}

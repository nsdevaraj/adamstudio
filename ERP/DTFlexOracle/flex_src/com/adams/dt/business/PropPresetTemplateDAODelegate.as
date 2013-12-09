package com.adams.dt.business
{
	import mx.rpc.IResponder;
	
	public class PropPresetTemplateDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function PropPresetTemplateDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.PROP_PRESET_TEMPLATE_SERVICE);
		}  
	}
}
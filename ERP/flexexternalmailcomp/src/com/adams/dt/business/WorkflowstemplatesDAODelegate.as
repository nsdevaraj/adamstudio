package com.adams.dt.business
{
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	public final class WorkflowstemplatesDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function WorkflowstemplatesDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.WORKFLOW_TEMPLATE_SERVICE);
		} 
		override public function findByMailProfileId(profileFk:int) : void
		{
			invoke("findByMailProfileId",profileFk);
		}
		override public function findById(id:int) : void
		{
			invoke("findById",id);
		} 
		override public function findAll() : void 
		{
			invoke("findAll");
		}
		
		/* override public function findById(id:int) : void
		{
			invoke("findById",id);
		} 
		override public function findList() : void
		{
			invoke("findList");
		} 
		override public function findByProfile(profileFk : int) : void
		{
			invoke("findByProfile",profileFk);
		}

		override public function findByStopLabel(str : String) : void
		{
			invoke("findByStopLabel",str);
		} */
 
	}
}
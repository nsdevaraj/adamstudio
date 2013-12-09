package com.adams.dt.business
{
	import mx.rpc.IResponder;
	public final class TasksDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function TasksDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.TASK_SERVICE );
			
			
		}
 
		override public function findByPersonId(id : int) : void
		{
			invoke("findByPersonId",id , id);
		}

		override public function findTasksList(id : int) : void
		{
			invoke("findTasksList",id);
		}
		override public function findByTaskId(id : int) : void
		{
			invoke("findByTaskId",id);
		}
		
		override public function findMaxTaskId(perid:int):void
		{
			invoke("findMaxTaskId",perid);
		}
		
		
	}
}

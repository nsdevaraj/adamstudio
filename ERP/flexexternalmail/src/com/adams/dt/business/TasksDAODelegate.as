package com.adams.dt.business
{
	import mx.rpc.IResponder;
	public final class TasksDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function TasksDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.TASK_SERVICE );
		}
 		override public function findMailList(taskId : int):void
		{
			invoke("findMailList",taskId);
		} 
		override public function findByTaskId(taskId : int) : void
		{
			invoke("findByTaskId",taskId);
		}
		override public function findByEmailId(mailid : String) : void
		{
			invoke("findByEmailId",mailid);
		}		
	}
}

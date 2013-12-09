package com.adams.dt.business
{
	import com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.rpc.IResponder;
	public final class CommentsDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function CommentsDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.NOTE_SERVICE );
		} 		
		override public function update(comment : IValueObject) : void
		{
			invoke("create",comment);
		}

		override public function findByNums(id1 : int, id2:int) : void
		{
			invoke("findByNums",id1,id2);
		}
		override public function deleteById(comment : IValueObject) : void
		{
			invoke("deleteById",comment);
		}		
		override public function findAll() : void 
		{
			invoke("getList");//invoke("findAll");
		}
		override public function getList() : void
		{
			invoke("getList"); //invoke("findAll");
		}
	}
}

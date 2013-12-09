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
 
		override public function select(comment : IValueObject) : void
		{
			invoke("create",comment);
		}

		override public function update(comment : IValueObject) : void
		{
			invoke("create",comment);
		}

		override public function findNotesList(id : int) : void
		{
			invoke("findNotesList",id);
		}
		override public function findByNums(id1 : int, id2:int) : void
		{
			invoke("findByNums",id1,id2);
		}
		
		
	}
}

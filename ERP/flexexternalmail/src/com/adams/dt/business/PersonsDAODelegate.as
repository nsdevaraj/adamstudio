package com.adams.dt.business
{ 
	import com.adams.dt.model.vo.Projects;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.rpc.IResponder;
	public final class PersonsDAODelegate extends AbstractDelegate implements IDAODelegate
	{ 
		public function PersonsDAODelegate(handlers:IResponder = null, service:String='') 
		{
			super(handlers, Services.PERSON_SERVICE );
		}
		
		override public function findByMailPersonId(personId:int) : void
		{
			invoke("findByMailPersonId",personId);
		}
		override public function findById(id : int) : void
		{
			invoke("findById",id);
		}
		override public function findByName(username : String) : void
		{ 
			 invoke("findByName", username); 
		} 
		override public function findIMPEmail(username : String) : void
		{ 
			 invoke("findIMPEmail", username); 
		} 		
		override public function findAll() : void
		{
			invoke("getList");
		}
		override public function getList() : void
		{
			invoke("getList"); //invoke("findAll");
		}
	}
}

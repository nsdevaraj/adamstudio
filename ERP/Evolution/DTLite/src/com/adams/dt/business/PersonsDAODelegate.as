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
 
		override public function update(person : IValueObject) : void
		{
			invoke("create",person);
		}

		override public function findByNames(login : String , login1 : String) : void
		{
			invoke("findByNames",login , login1);
		}

		//Online users load
		override public function findOnlinePersonDelegate() : void
		{
			invoke("findOnlinePerson");
		}

		//DataBase Online and Offline status change
		override public function findUpdateOnlinePersonDelegate(persons :IValueObject) : void
		{
			invoke("update",persons);
		}

		//DataBase stratusId update 
		override public function findUpdateStratusPersonDelegate(persons : IValueObject) : void
		{
			invoke("update",persons);
		}

		override public function findPersonsList(project : IValueObject) : void
		{
			invoke("findPersonsList",Projects(project).projectId);
		}

		override public function findById(id : int) : void
		{
			invoke("findById",id);
		}


	}
}

package com.adams.dt.business
{
	import com.adams.dt.model.vo.Persons;
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.rpc.IResponder;
	public final class ProfilesDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function ProfilesDAODelegate(handlers:IResponder = null, service:String='')
		{
			super(handlers, Services.PROFILE_SERVICE);
		} 		
		override public function findByMailProfileId(profileId : int) : void
		{
			invoke("findByMailProfileId",profileId);
		}
		override public function findAll() : void
		{
			invoke("findAll");
		}
		override public function findProfilesList(person : IValueObject) : void
		{
			invoke("findProfilesList",Persons(person).personId);
		}
		

		/* override public function findByNums(personId : int , projectId : int) : void
		{
			invoke("findByNums",personId , projectId);
		}
 
		override public function findProfilesList(person : IValueObject) : void
		{
			invoke("findProfilesList",Persons(person).personId);
		} */
	}
}

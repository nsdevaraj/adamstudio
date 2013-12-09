package com.adams.dt.controls
{
	import com.adams.dt.dao.CRUDObject;
	import com.adams.dt.events.ServiceEvent;
	import com.adams.dt.model.collections.ICollection;
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.utils.Destination;
	
	import org.spicefactory.lib.task.SequentialTaskGroup;

	public class LoginControl extends SequentialTaskGroup
	{
		[Inject(id="personDao")]
		public var personDao:CRUDObject;
		
		[Inject(id="profileDao")]
		public var profileDao:CRUDObject;
		
		[Inject(id="personCollection")]
		public var model:ICollection;
		
		[PostConstruct]
		public function LoginControl()
		{
			super();
		} 
		
		override protected function doStart () : void {
			assignTasks();
			super.doStart();
		}
		
		public function assignTasks():void{
			addTask(personDao.getListCommand);
			addTask(profileDao.getListCommand);
			addTask(personDao.countCommand); 
		} 
		
		[MessageHandler(selector="Count")] 
		public function countResult(event:ServiceEvent):void {
			if(event.destination == Destination.PERSON_DESTINATION){
				personDao.readCommand.id = Persons(model.items.getItemAt(0)).personId;
				personDao.readCommand.oldValueObject = null;
				//personDao.readCommand.oldValueObject = null;
				//personDao.readCommand.oldList= null;
				personDao.readCommand.start();
			}
		}
	}
}
package com.adams.dt.controls
{
	import com.adams.dt.dao.DAOObject;
	import com.adams.dt.model.collections.ICollection;
	import com.adams.dt.model.vo.IValueObject;
	import com.adams.dt.model.vo.Persons;
	
	import org.spicefactory.lib.task.SequentialTaskGroup;

	public class LoginControl extends SequentialTaskGroup
	{
		[Bindable]
		[Inject(id="personDao")]
		public var personDao:DAOObject;
		
		[Bindable]
		[Inject(id="personCollection")]
		public var model:ICollection;
		
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
			addTask(personDao.countCommand); 
		} 
		[MessageHandler(selector="personCount")] 
		public function findAllResult( ):void {
			personDao.readCommand.id = Persons(model.items.getItemAt(0)).personId;
			personDao.readCommand.oldValueObject = personDao.readCommand.valueObject;
			//personDao.readCommand.oldValueObject = null;
			personDao.readCommand.start();
		}
	}
}
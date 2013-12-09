package com.adams.scrum.models.processor
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.Files;
	import com.adams.scrum.models.vo.IValueObject;
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.Status;
	import com.adams.scrum.models.vo.Stories;
	import com.adams.scrum.models.vo.Tasks;
	import com.adams.scrum.models.vo.Tickets;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.Utils;
	
	import mx.collections.ArrayCollection;

	public class TaskProcessor extends AbstractProcessor
	{
		
		[Inject("fileDAO")]
		public var fileDAO:AbstractDAO;
		
		[Inject("ticketDAO")]
		public var ticketDAO:AbstractDAO;
		
		[Inject("personDAO")]
		public var personDAO:AbstractDAO;
		
		[Inject("statusDAO")]
		public var statusDAO:AbstractDAO;
		
		[Inject("storyDAO")]
		public var storyDAO:AbstractDAO;

		[Inject]
		public var fileProcessor:FileProcessor;
		
		[Inject]
		public var ticketProcessor:TicketProcessor;
		
		public function TaskProcessor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var task:Tasks = vo as Tasks;
				
				fileProcessor.processCollection(task.fileCollection);
				var fileCollection:ArrayCollection = new ArrayCollection();
				for each(var file:Files in task.fileCollection){
					fileCollection.addItem(file);
				}
				fileDAO.collection.modifyItems(fileCollection);
				
				ticketProcessor.processCollection(task.ticketCollection);
				var ticketCollection:ArrayCollection = new ArrayCollection();
				for each(var ticket:Tickets in task.ticketCollection){
					ticketCollection.addItem(ticket);
				}
				ticketDAO.collection.modifyItems(ticketCollection);
				
				task.personObject = GetVOUtil.getVOObject(task.personFk,personDAO.collection.items,personDAO.destination,Persons) as Persons;
				task.storyObject = GetVOUtil.getVOObject(task.storyFk,storyDAO.collection.items,storyDAO.destination,Stories) as Stories;
				Utils.addArrcStrictItem(task,task.storyObject.taskSet,Utils.TASKKEY);
				
				task.statusObject = GetVOUtil.getVOObject(task.taskStatusFk,statusDAO.collection.items,statusDAO.destination,Status) as Status;
				super.processVO(vo);
			}
		}
	}
}
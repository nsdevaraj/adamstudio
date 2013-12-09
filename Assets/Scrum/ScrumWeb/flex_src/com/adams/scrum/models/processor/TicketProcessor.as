package com.adams.scrum.models.processor
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.IValueObject;
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.Tasks;
	import com.adams.scrum.models.vo.Tickets;
	import com.adams.scrum.utils.GetVOUtil;

	public class TicketProcessor extends AbstractProcessor
	{
		[Inject("taskDAO")]
		public var taskDAO:AbstractDAO;

		[Inject("personDAO")]
		public var personDAO:AbstractDAO;

		public function TicketProcessor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var ticket:Tickets = vo as Tickets;
				ticket.personObject = GetVOUtil.getVOObject(ticket.personFk,personDAO.collection.items,personDAO.destination,Persons) as Persons;
				ticket.taskObject = GetVOUtil.getVOObject(ticket.taskFk,taskDAO.collection.items,taskDAO.destination,Tasks) as Tasks;
				super.processVO(vo);
			}
		}
	}
}
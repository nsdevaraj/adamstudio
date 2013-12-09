package com.adams.scrum.models.processor
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.Events;
	import com.adams.scrum.models.vo.IValueObject;
	import com.adams.scrum.models.vo.Status;
	import com.adams.scrum.utils.GetVOUtil;

	public class EventProcessor extends AbstractProcessor
	{
		[Inject("statusDAO")]
		public var statusDAO:AbstractDAO;
		
		[Inject]
		public var eventProcessor:EventProcessor;
		
		public function EventProcessor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var eventvo:Events = vo as Events;
				eventvo.statusObject = GetVOUtil.getVOObject(eventvo.eventStatusFk,statusDAO.collection.items,statusDAO.destination,Status) as Status;
				super.processVO(vo);
			}
		}
	}
}
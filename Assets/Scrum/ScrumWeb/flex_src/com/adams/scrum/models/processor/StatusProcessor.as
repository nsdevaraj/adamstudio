package com.adams.scrum.models.processor
{
	import com.adams.scrum.models.vo.IValueObject;
	import com.adams.scrum.models.vo.Status;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.Utils;

	public class StatusProcessor extends AbstractProcessor
	{
		public function StatusProcessor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var status:Status = vo as Status;
				switch(status.statusLabel){ 
					case Description.WAITING:
						statusLabelCase(status);
						break;
					case Description.INPROGRESS:
						statusLabelCase(status);
						break;
					case Description.FINISHED:
						statusLabelCase(status);
						break;
					case Description.STANDBY:
						statusLabelCase(status);
						break;
					default:
						eventLabelCase(status);
						break;
				}
				super.processVO(vo);
			}
		}
		private function eventLabelCase(status:Status):void{
			switch(status.statusLabel){ 
				default:
					Utils[status.type+status.statusLabel]= status.statusId;
					break;						
			}
		}
		private function statusLabelCase(status:Status):void{
			switch(status.type){ 
				case Description.PRODUCTSTATUS:
					Utils[status.type+status.statusLabel]= status.statusId;
					break;
				case Description.SPRINTSTATUS:
					Utils[status.type+status.statusLabel]= status.statusId;
					break;
				case Description.STORYSTATUS:
					Utils[status.type+status.statusLabel]= status.statusId;
					break;
				case Description.VERSIONSTATUS:
					Utils[status.type+status.statusLabel]= status.statusId;
					break;
				case Description.TASKSTATUS:
					Utils[status.type+status.statusLabel]= status.statusId;
					break;
				case Description.EVENTSTATUS:
					Utils[status.type+status.statusLabel]= status.statusId;
					break;
			}
		}
	}
}
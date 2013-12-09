package com.adams.dt.model.collections
{
	import com.adams.dt.events.ServiceEvent;
	import com.adams.dt.model.vo.IValueObject;
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.utils.ObjectUtil;
	
	public class PersonCollection extends AbstractCollection
	{
		public function PersonCollection():void {
			
		}
		
		[MessageHandler(selector="personFindAll")] 
		public function findAllResult(event:ServiceEvent ):void {
				addItems(event.list);
		}
		
		[MessageHandler(selector="personCount")] 
		public function countResult(event:ServiceEvent ):void {
				trace(event.count+' '+ event.type);			
		}
		
		[MessageHandler(selector="personCreate")]
		public function personCreateResult(event:ServiceEvent ):void {
				addItem(event.valueObject);			
		}

		[MessageHandler(selector="personDeleteAll")]
		public function personDeleteAllResult(event:ServiceEvent ):void {
				items.removeAll();			
		}
		
		[MessageHandler(selector="personDelete")]
		public function personDeleteResult(event:ServiceEvent ):void {
				items.removeItemAt(items.getItemIndex(event.valueObject)); 
		}
		
		[MessageHandler(selector="personUpdate")]
		public function personUpdateResult(event:ServiceEvent ):void {
			if(event.oldValueObject!=null){
				modifyItem( event.oldValueObject, event.valueObject );
			}else{
				addItem(event.valueObject);
			}
			trace(Persons(event.valueObject).personFirstname+' '+ event.type);
		}
		
		[MessageHandler(selector="personRead")] 
		public function personReadResult(event:ServiceEvent ):void {
			if(event.oldValueObject!=null){
				modifyItem( event.oldValueObject, event.valueObject );
			}else{
				addItem(event.valueObject);
			}
			trace(Persons(event.valueObject).personFirstname+' '+ event.type);			
		}
		
		[MessageHandler(selector="personBulkUpdate")]
		public function personBulkUpdateResult(event:ServiceEvent ):void {
				trace(Persons(event.valueObject).personFirstname);			
		}
		
	}
}
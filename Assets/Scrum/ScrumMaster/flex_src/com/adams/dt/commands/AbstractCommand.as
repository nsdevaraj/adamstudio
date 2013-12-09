package com.adams.dt.commands
{
	import com.adams.dt.service.IDTService;
	import com.adams.dt.signals.ServiceSignal;
	import com.adams.dt.utils.Action;
	import com.adams.dt.utils.Description;

	public class AbstractCommand
	{
		[Inject]
		public var service:IDTService;
		[Inject]
		public var serviceSignal:ServiceSignal;
		   
		public function execute():void{
			var operation:String = serviceSignal.action;
			var destination:String = serviceSignal.destination;
			var desc:Object = serviceSignal.description;
			switch( operation ) {
				case Action.GET_LIST: 
					service.getList(destination,desc);	
				break;		
				case Action.GET_COUNT:
					service.count(destination,desc);
				break;
				case Action.READ:
					service.read(destination,desc,serviceSignal.id);
				break;
				case Action.CREATE:
				    service.create(destination,desc,serviceSignal.valueObject);
				break;
				case Action.BULK_UPDATE: 
					service.bulkUpdate(destination,desc,serviceSignal.list);
				break;
				case Action.DELETE:
					service.deleteById(destination,desc,serviceSignal.valueObject);
				break;
				case Action.DELETE_ALL:
					service.deleteAll(destination,desc);
				break;
				case Action.UPDATE:
					 service.update(destination,desc,serviceSignal.valueObject);
				break;
				case Action.QUERY:
					switch( desc.type) {
						case Description.PERSONPROJECTLIST: 
						case Description.PERSONPROFILELIST: 
							 service.dbQuery(destination,desc,serviceSignal.id);
						break;
						default:
						break;	
					}
					
				break;
				case Action.FIND_ALL:
					service.findAll(destination,desc);
				break;
				case Action.FINDBY_ID:
					service.findById(destination,desc,serviceSignal.id);
				break;
				case Action.FINDBY_ID_NAME:
					service.findByIdName(destination,desc,serviceSignal.id,serviceSignal.name);
				break;
				case Action.FINDBY_NAME:
					service.findByName(destination,desc,serviceSignal.name);
				break;
				case Action.FINDBY_NAME_ID:
					service.findByNameId(destination,desc,serviceSignal.name,serviceSignal.id);
				break;
				case Action.FINDBY_TASKID:
					service.findByTaskId(destination,desc,serviceSignal.id);
				break;
				case Action.PUSH_MSG:
					service.produceMessage(destination,desc,serviceSignal.name,serviceSignal.receivers);
					break;
				case Action.CREATESUB_DIR:
					service.createSubDir(destination,desc,serviceSignal.description.ParentFolder,serviceSignal.name);
					break;
				default:
				break;	
			}
			trace('request called ' + operation+ ' '+destination);
		}
	}
}
package com.adams.dt.service
{
	import com.adams.dt.model.collections.*;
	import com.adams.dt.model.vo.CurrentInstanceVO;
	import com.adams.dt.model.vo.IValueObject;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.signals.InitSignal;
	import com.adams.dt.signals.ResultSignal;
	import com.adams.dt.signals.SignalSequence;
	import com.adams.dt.utils.Action;
	import com.adams.dt.utils.Description;
	import com.adams.dt.utils.Destination;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.messages.AsyncMessage;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	public class BaseService
	{
		
		[Inject]
		public var serviceCalled:ResultSignal;
		[Inject]
		public var loggedIn:InitSignal;
		[Inject]
		public var currentInstance:CurrentInstanceVO; 
		[Inject]
		public var signalSequence:SignalSequence; 

		public var service:RemoteObject = new RemoteObject();
		
		public var produce:NativeProducer = new NativeProducer();
		public var consume:NativeConsumer= new NativeConsumer();
		
		public var langservice:RemoteObject = new RemoteObject();
		private var token:AsyncToken;
		private var responder:Responder = new Responder(handleServiceResult, handleServiceFault);
		private var destination:String;
		private var description:Object;
		private var operation:String;
		

		public function BaseService()
		{ 
		}

		
		public function invoke(destn:String,action:String,desc:Object):void{
			service.destination = destn;
			operation = action;
			destination = destn;
			description = desc;
		}
		
		public function dbQuery(destination:String, desc:Object, ...args):void {
			invoke(destination,Action.QUERY,desc);
			switch( desc.type) {
				case Description.PERSONPROJECTLIST: 
					token = service.findPersonsList(args[0]);
				break;
				case Description.PERSONPROFILELIST: 
					token = service.findProfilesList(args[0]);
				break;
				default:
				break;	
			}
			token.addResponder(responder);
		}
		public function createSubDir( destination:String, desc:Object, parentFolder:String, folderName:String ):void {
			invoke(destination,Action.CREATESUB_DIR,desc);
			token = service.createSubDir(parentFolder,folderName);
			token.addResponder(responder);
		}
		public function create( destination:String, desc:Object, vo:IValueObject ):void {
			invoke(destination,Action.CREATE,desc);
			token = service.create(vo);
			token.addResponder(responder);
		}
		
		public function update( destination:String, desc:Object, vo:IValueObject ):void {
			invoke(destination,Action.UPDATE,desc);
			token = service.update(vo);
			token.addResponder(responder);
		}
		
		public function read( destination:String,desc:Object, id:int ):void {
			invoke(destination,Action.READ,desc);
			token = service.read( id );
			token.addResponder(responder);
		}
		
		public function deleteById( destination:String, desc:Object, vo:IValueObject ):void {
			invoke(destination,Action.DELETE,desc);
			token = service.deleteById( vo );
			token.addResponder(responder);
		}
		
		public function count(destination:String,desc:Object):void {
			invoke(destination,Action.GET_COUNT,desc);
			token = service.count();
			token.addResponder(responder);
		}
		
		public function getList(destination:String,desc:Object):void {
			invoke(destination,Action.GET_LIST,desc);
			if(destination != Destination.LANG_SERVICE){
				token = service.getList();
			}else{
				langservice.destination = destination;
				operation = Action.GET_LIST;
				destination = destination;
				description = desc;
				token = langservice.getList();
			}
			token.addResponder(responder);
		}
		
		public function bulkUpdate(destination:String, desc:Object, list:IList ):void {
			invoke(destination,Action.BULK_UPDATE,desc);
			token = service.bulkUpdate(list);
			token.addResponder(responder);
		}
		
		public function deleteAll(destination:String,desc:Object):void {
			invoke(destination,Action.DELETE_ALL,desc);
			token = service.deleteAll();
			token.addResponder(responder);
		}
		public function findByNameId(destination:String,desc:Object,name:String,id:int):void {
			invoke(destination,Action.FINDBY_NAME_ID,desc);
			token = service.findByNameId(name,id);
			token.addResponder(responder);
		} 
		public function findById(destination:String,desc:Object,subnum:int):void {
			invoke(destination,Action.FINDBY_ID,desc);
			token = service.findById(subnum);
			token.addResponder(responder);
		}
		public function findByName(destination:String,desc:Object,name:String ):void {
			invoke(destination,Action.FINDBY_NAME,desc);
			token = service.findByName(name);
			token.addResponder(responder);
		}
		public function findByIdName(destination:String,desc:Object,id:int,name:String):void {
			invoke(destination,Action.FINDBY_ID_NAME,desc);
			token = service.findByIdName(id,name);
			token.addResponder(responder);
		} 
		public function findByTaskId(destination:String,desc:Object,id:int):void {
			invoke(destination,Action.FINDBY_TASKID,desc);
			token = service.findByTaskId(id);
			token.addResponder(responder);
		}
		public function findAll(destination:String,desc:Object):void {
			invoke(destination,Action.FIND_ALL,desc);
			token = service.findAll();
			token.addResponder(responder);
		}
		protected function handleServiceResult(rpcevt:Object):void
		{   
			var list:ICollection = this[destination+'List']; 
			serviceCalled.action = operation;
			serviceCalled.destination = destination;
			serviceCalled.description = description;
			switch( operation ) {
				case Action.GET_LIST: 
					list.items = rpcevt.result as ArrayCollection;
				break;		
				case Action.GET_COUNT:
					list.count = rpcevt.result as int;
				break;
				case Action.READ:
					list.addItem(rpcevt.result as IValueObject); 
				break;
				case Action.CREATE:
					var vo:IValueObject = rpcevt.result as IValueObject; 
				    
					switch( destination) {
						case Destination.PROJECT_SERVICE: 
							currentInstance.currentProject = vo as Projects;
							list.addItem(vo);
							break;
						case Destination.TASK_SERVICE: 
							currentInstance.currentTask = vo as Tasks;
							//list.addItem(vo);
							break;
						default:
							break;
					}
				break;
				case Action.BULK_UPDATE: 
					/*signal.oldList = oldList;
					signal.list = rpcevt.result as IList; */
				break;
				case Action.DELETE:
					list.removeItem(rpcevt.result as IValueObject);
				break;
				case Action.DELETE_ALL:
					list.removeAllItems();
				break;
				case Action.UPDATE:
					/* signal.oldValueObject = oldValueObject;
					signal.valueObject = rpcevt.result as IValueObject; */
				break;
				case Action.QUERY:
					switch( description.type) {
						case Description.PERSONPROJECTLIST: 
							list.items = rpcevt.result as ArrayCollection;
						break;
						case Description.PERSONPROFILELIST: 
							list.collection = rpcevt.result as ArrayCollection;
						break;
						default:
						break;	
					}					
				break;
				case Action.FIND_ALL:
				break;
				case Action.FINDBY_ID:
					list.collection = rpcevt.result as ArrayCollection;
				break;
				case Action.FINDBY_ID_NAME:
				break;
				case Action.FINDBY_NAME:
				break;
				case Action.FINDBY_NAME_ID:
				break;
				case Action.FINDBY_TASKID:
				break;
				default:
				break;	
			}
			trace('result dispatched ' + operation+ ' '+destination);
			serviceCalled.dispatch();
		} 
		public function produceMessage(destination:String,desc:Object,msg:String,sentTo:Array) : void
		{
			invoke(destination,Action.PUSH_MSG,desc);
			var message:AsyncMessage = new AsyncMessage();
			message.headers = [];
			message.headers["destination"] = destination;
			message.headers["action"] = Action.PUSH_MSG;
			message.headers["desc"] = desc;
			message.headers["recepient"] = sentTo;
			message.body = msg;
			produce.produceMessage(message);
		}
		protected function handleServiceFault(event:Object):void
		{
			trace('failed' + event);
			
		}
		
		protected function consumeHandler(event:MessageEvent =null) : void
		{
			serviceCalled.action = event.message.headers["action"];
			serviceCalled.destination = event.message.headers["destination"];
			serviceCalled.description = event.message.headers["desc"];
			var receivers:Array = event.message.headers["recepient"];
			var message:String = " to "+event.message.headers["recepient"] + ": " + event.message.body;
			trace('result dispatched ' + serviceCalled.action+ ' '+serviceCalled.destination);
			if(receivers.indexOf(currentInstance.currentPerson.personId)!=-1){
				serviceCalled.dispatch();
			}else{
				signalSequence.onSignalDone();
			}			
		}
		public function login(username:String,password:String):void{
			amfChannelSet.login(username , password);
		}
		protected var amfChannel:AMFChannel;
		protected var langChannelSet:ChannelSet = new ChannelSet();   
		protected var pushChannel:AMFChannel;
		protected var pushChannelSet:ChannelSet = new ChannelSet();   
		protected static const CONTEXT_URL:String = "spring/messagebroker/amf";
		protected static const PUSH_URL:String = "spring/messagebroker/amfpolling";
		
		
		public function configServer():void{
			amfChannel= new AMFChannel('my-amf',baseURL+CONTEXT_URL);
			amfChannelSet.addChannel(amfChannel);
			
			pushChannel= new AMFChannel('my-polling-amf',baseURL+PUSH_URL);
			langChannelSet.addChannel(pushChannel);
			
			pushChannelSet.addChannel(pushChannel);
			pushChannel.pollingEnabled = true;
			pushChannel.pollingInterval = 5000;
			pushChannel.piggybackingEnabled = true;
			
			langservice.channelSet = langChannelSet;
			service.channelSet = amfChannelSet;
			
			produce.channelSet = pushChannelSet;
			consume.channelSet = pushChannelSet;
			produce.destination = 'chatonline';
			consume.destination = 'chatonline';
			consume.subscribe();
			consume.consumeAttempt.add(consumeHandler);
			
			amfChannelSet.loginAttempt.add(checkLogin);
			service.showBusyCursor = true;
		} 
		protected function checkLogin(ev:Object =null) : void
		{
			 //to be overridden
		}
		
		protected var amfChannelSet:NativeChannelSet = new NativeChannelSet();
		
		
		public function get baseURL():String
		{
			return _baseURL;
		}
		public function set baseURL(value:String):void
		{
			_baseURL = value;
		}
		protected var _baseURL:String;
		[Inject]
		public var langList: LangCollection;
		[Inject]
		public var projectList:ProjectCollection;
		[Inject]
		public var taskList: TaskCollection;
		[Inject]
		public var defaultTemplateList: DefaultTemplateCollection;
		[Inject]
		public var defaultTemplateValueList: DefaultTemplateValueCollection;
		[Inject]
		public var groupList: GroupCollection;
		[Inject]
		public var groupPersonList: GroupPersonCollection;
		[Inject]
		public var personList: PersonCollection;
		[Inject]
		public var chatList: ChatCollection;
		[Inject]
		public var categoryList: CategoryCollection;
		[Inject]
		public var companyList: CompanyCollection;
		[Inject]
		public var reportsList: ReportsCollection;
		[Inject]
		public var eventList: EventCollection;
		[Inject]
		public var phaseList: PhaseCollection;
		[Inject]
		public var moduleList: ModuleCollection;
		[Inject]
		public var phasestemplateList: PhasesTemplateCollection;
		[Inject]
		public var propertiespjList: PropertiesPjCollection;
		[Inject]
		public var propertiespresetList: PropertiesPresetCollection;
		[Inject]
		public var profileList: ProfileCollection;
		[Inject]
		public var statusList: StatusCollection;
		[Inject]
		public var workflowList: WorkflowCollection;
		[Inject]
		public var workflowstemplateList: WorkflowTemplateCollection;
		[Inject]
		public var noteList: NoteCollection;
		[Inject]
		public var fileDetailList: FileDetailCollection;
		[Inject]
		public var tagsList: TagsCollection;
		[Inject]
		public var teamtemplateList: TeamTemplateCollection;
		[Inject]
		public var teamlinestemplateList: TeamlinesTemplateCollection;
		[Inject]
		public var teamlineList: TeamlineCollection;
		[Inject]
		public var domainworkflowList: DomainworkflowCollection;
		[Inject]
		public var proppresetstemplatesList: PropPresetsTemplatesCollection;
		[Inject]
		public var presetstemplatesList: PresetsTemplatesCollection;
	}
}
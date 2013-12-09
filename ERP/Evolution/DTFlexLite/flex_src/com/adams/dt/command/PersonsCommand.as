package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.business.util.LoginUtils;
	import com.adams.dt.business.util.StringUtils;
	import com.adams.dt.event.CategoriesEvent;
	import com.adams.dt.event.ColumnsEvent;
	import com.adams.dt.event.CompaniesEvent;
	import com.adams.dt.event.DefaultTemplateEvent;
	import com.adams.dt.event.GroupPersonsEvent;
	import com.adams.dt.event.GroupsEvent;
	import com.adams.dt.event.PersonsEvent;
	import com.adams.dt.event.PhasestemplatesEvent;
	import com.adams.dt.event.ProfilesEvent;
	import com.adams.dt.event.StatusEvents;
	import com.adams.dt.event.TeamlineTemplatesEvent;
	import com.adams.dt.event.WorkflowstemplatesEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.GroupPersons;
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.model.vo.Teamlinestemplates;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	public final class PersonsCommand extends AbstractCommand 
	{
		private var userName : String;
		private var personsEvent : PersonsEvent   
		private var TeamArr : ArrayCollection;
		private var deletePerson:Persons
		
		/**
		 *  @param event The event that was dispatched by a caller
		 *  the Callbacks function used for reciving the result
		 */
		override public function execute( event:CairngormEvent ):void {	
			super.execute( event );
			personsEvent = PersonsEvent( event );
			this.delegate = DelegateLocator.getInstance().personDelegate;
			this.delegate.responder = new Callbacks( result, fault );
			switch( event.type ) {
			 	case PersonsEvent.EVENT_GET_ONLINE_PERSONS:
					delegate.responder = new Callbacks( findOnlineResult, fault );
					delegate.findOnlinePersonDelegate();
					break; 
				case PersonsEvent.EVENT_CREATE_PERSONS:
					delegate.responder = new Callbacks( createPersonResult, fault );
					delegate.create( personsEvent.persons );
					break;
				case PersonsEvent.EVENT_DELETE_PERSONS:
					delegate.deleteVO( personsEvent.persons );
					break;  
				case PersonsEvent.EVENT_GET_ALL_PERSONS:
				     // for My sql Sequence Command
					//delegate.responder = new Callbacks( getAllPersonsResult, fault );
					//for Orcale Command
					delegate.responder = new Callbacks(getAllPersonsResultServer,fault);
					delegate.findAll();
					break;
				case PersonsEvent.EVENT_UPDATE_PERSONS:
					delegate.responder = new Callbacks( updatePersonsResult, fault );
					delegate.directUpdate( PersonsEvent( event ).persons );
					break; 
				case PersonsEvent.EVENT_GETMSG_SENDER:
					delegate.responder = new Callbacks( getMsgSenderResult, fault );
					delegate.findById( personsEvent.persons.personId );
					break;
				case PersonsEvent.EVENT_GET_PERSONS:
					delegate.responder = new Callbacks( getPersonResult, fault );
					delegate.findById( personsEvent.getPersonId );
					break;
				case PersonsEvent.EVENT_BULK_DELETE_PERSONS:
					if( model.bulkDeletePersons.length > 0 ) {
	        			deletePerson = Persons( model.bulkDeletePersons.getItemAt( 0 ) ); 
	        			deleteSeletedPerson( deletePerson );
		        	}
				break;
				case PersonsEvent.EVENT_BULK_UPDATE_PERSONS:
					delegate.bulkUpdate( model.bulkUpdatePersons );
				break;
				case PersonsEvent.EVENT_CREATE_SINGLE_PERSONS:
					delegate.responder = new Callbacks( getId, fault );
					delegate.create( personsEvent.persons );
				break;
				case PersonsEvent.EVENT_UPDATE_ALL_PERSONS:
					delegate.responder = new Callbacks( onUpdateAllResult, fault );
					delegate.findAll();
				break;
				//Use this for making all the login sequence in server side; comment the above line;
				case PersonsEvent.EVENT_LOGIN_RESULT:
					this.delegate = DelegateLocator.getInstance().pagingDelegate;
					delegate.responder = new Callbacks(getAllCollectionAfterLogin,fault);
					delegate.getLoginListResult(personsEvent.personId,model.person.defaultProfile);
				break;
				default:
				break; 
			}
		}
		
		private function onUpdateAllResult( rpcEvent:Object ):void {
			model.personsArrCollection = rpcEvent.result as ArrayCollection;
			model.personsArrCollection.refresh();
			super.result( rpcEvent );
	 	}
		
		private function updatePersonsResult( rpcEvent:Object ):void {
			for ( var i:int = 0; i < model.personsArrCollection.source.length; i++ ) {
				if( model.personsArrCollection.source[ i ].personId == Persons( rpcEvent.message.body ).personId ) {
					model.personsArrCollection.source[ i ] = Persons( rpcEvent.message.body );
					model.personsArrCollection.refresh();
					break;
				}
			}
			super.result( rpcEvent );
		}
		
		private function getId( rpcEvent:Object ):void {
			var createdPer:Persons =Persons( rpcEvent.message.body );
			model.createdPerson = createdPer; 
			super.result( rpcEvent );
		}
		
		private function deleteSeletedPerson( selectedPer:Persons ):void {
    		delegate = DelegateLocator.getInstance().personDelegate;
    		delegate.responder = new Callbacks( deleteSeletedPersonResult, fault );
    		delegate.deleteVO( selectedPer ); 
    	}
    	
    	private function deleteSeletedPersonResult( rpcEvent:Object ):void { 
			super.result( rpcEvent );
			model.bulkDeletePersons.removeItemAt( 0 );
    		model.bulkDeletePersons.refresh();
    		if( model.bulkDeletePersons.length > 0 ) {
    			var personId:Persons = Persons( model.bulkDeletePersons.getItemAt( 0 ) ); 
    			deleteSeletedPerson( personId );
    		}
		}
		
		private function getPersonResult( rpcEvent:Object ):void {
			var found:Boolean;
			for ( var i:int = 0; i < model.personsArrCollection.source.length; i++ ) {
				var item:Persons = model.personsArrCollection.source[ 0 ];
        		if( item.personId == Persons( rpcEvent.message.body ).personId ) {
        			model.personsArrCollection.removeItemAt( i );
					model.personsArrCollection.addItemAt( Persons( rpcEvent.message.body ), i );
					model.personsArrCollection.refresh();
					found = true;
					break;
        		}
        	}
			if( !found ) {
				model.personsArrCollection.addItem( Persons( rpcEvent.message.body ) );
				model.personsArrCollection.refresh();
			}
			super.result( rpcEvent );
		}
		
		private function createPersonResult( rpcEvent:Object  ):void {
			var createdPer:Persons = Persons( rpcEvent.message.body );
			model.createdPerson = createdPer;
			super.result( rpcEvent );
	 		
	 		var evtArr:Array = [];
			
			var bulkUpdateGroupPerson:GroupPersonsEvent = new GroupPersonsEvent( GroupPersonsEvent.EVENT_BULKUPDATE_GROUPPERSONS );
			for each( var gp:GroupPersons in model.selectedGroupArr ) { 
				gp.personFk = createdPer.personId;
			} 
			bulkUpdateGroupPerson.groupPersonColl = model.selectedGroupArr;
			evtArr.push( bulkUpdateGroupPerson );
			
			var bulkUpdateteam:TeamlineTemplatesEvent = new TeamlineTemplatesEvent( TeamlineTemplatesEvent.EVENT_BULK_UPDATE_TEAMLINETEMPLATES );
			for each( var tmltmp:Teamlinestemplates in model.selecteTeamlineTemplateArr ) {
				tmltmp.personFk = createdPer.personId;
			} 
			bulkUpdateteam.teamlinetemplateArr = model.selecteTeamlineTemplateArr;
			if( model.selecteTeamlineTemplateArr.length > 0 )	evtArr.push( bulkUpdateGroupPerson );
			
			var handler:IResponder = new Callbacks( result, fault );
	 	 	var eventSeq:SequenceGenerator = new SequenceGenerator( evtArr, handler );
		    eventSeq.dispatch(); 
		}
		
		private function findOnlineResult( rpcEvent:Object ):void {
			super.result( rpcEvent );
			var arrc:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.personsArrCollection = arrc;
			var person:Persons = Persons( arrc.getItemAt( 0 ) );
			model.person = person;
		}
		
		private function getMsgSenderResult( rpcEvent:Object ):void {
			super.result( rpcEvent );
			model.messageSender = ArrayCollection( rpcEvent.result ).getItemAt( 0 ) as Persons;
			var profileevent : ProfilesEvent = new ProfilesEvent( ProfilesEvent.EVENT_MSGSENDER_PROFILES );
			profileevent.profiles = personsEvent.profiles;
			var handler:IResponder = new Callbacks( result, fault );
 			var createmsgSeq:SequenceGenerator = new SequenceGenerator( [ profileevent ], handler );
  			createmsgSeq.dispatch();
		}
		// for the Mysql Sequence  Get All Person...
		private function getAllPersonsResult( rpcEvent:Object ):void {
	 		super.result( rpcEvent );
	 		model.personsArrCollection = rpcEvent.result as ArrayCollection;
	 		 
			var getAllStatus:StatusEvents = new StatusEvents( StatusEvents.EVENT_GET_ALL_STATUS, handler );
			var getAllPhaseTemp:PhasestemplatesEvent = new PhasestemplatesEvent( PhasestemplatesEvent.EVENT_GET_ALL_PHASESTEMPLATESS, handler );
			var getAllworkflowTemplate:WorkflowstemplatesEvent = new WorkflowstemplatesEvent( WorkflowstemplatesEvent.EVENT_GET_ALL_WORKFLOWSTEMPLATESS );
			var compEvent:CompaniesEvent = new CompaniesEvent( CompaniesEvent.EVENT_GET_ALL_COMPANIESS );
		    var getDomainEvent:CategoriesEvent = new CategoriesEvent( CategoriesEvent.EVENT_GET_ALL_CATEGORIESS );
		    var profileevent : ProfilesEvent = new ProfilesEvent( ProfilesEvent.EVENT_GETPRJ_PROFILES );
   			var groupPer:GroupsEvent = new GroupsEvent( GroupsEvent.EVENT_GET_ALL_GROUPSS );
   			var columnsEv:ColumnsEvent= new ColumnsEvent( ColumnsEvent.EVENT_GET_ALL_COLUMNS );
   			var prof_event:ProfilesEvent = new ProfilesEvent( ProfilesEvent.EVENT_GET_ALL_PROFILESS );
   			var getDefaultTemplateEvt:DefaultTemplateEvent = new DefaultTemplateEvent( DefaultTemplateEvent.GET_COMMON_DEFAULT_TEMPLATE ); 
			 
			try {
				model.person = GetVOUtil.getPersonObjectLogin( model.person.personLogin );
				
				model.encryptorUserName = StringUtils.replace(escape(model.encryptor.encrypt(model.person.personLogin)),'+','%2B');
				model.encryptorPassword = StringUtils.replace(escape(model.encryptor.encrypt(model.person.personPassword)),'+','%2B');
			
				model.ChatPerson = model.person;
				model.businessCard = model.person;
				model.dataReach = true; 
			}
			catch( e:Error ) {
			}
			finally {
				if( model.person ) {
					var eventsArr:Array = [ compEvent, getAllPhaseTemp, getAllStatus, prof_event, getAllworkflowTemplate, getDomainEvent,
										    profileevent, groupPer, getDefaultTemplateEvt ]; 
         			var handler:IResponder = new Callbacks( result, fault );
         			var loginSeq:SequenceGenerator = new SequenceGenerator( eventsArr, handler );
          			loginSeq.dispatch();
          		}
			}
		}
		private function getAllPersonsResultServer( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
	 		var personsArrColl : ArrayCollection =new ArrayCollection();
			var arrc : ArrayCollection = rpcEvent.result as ArrayCollection; 
			model.personsArrCollection = rpcEvent.result as ArrayCollection;
			//model.teamLinePersonColl = rpcEvent.result as ArrayCollection;
			var person:Persons
			model.personLogins = [];
			for(var j : int = 0; j < arrc.length; j++)
			{
				  person = Persons( arrc.getItemAt( j ) );
				  model.personLogins.push( person.personLogin );
				  var tt:Boolean = 	checkDuplicateItem( person.personId)
				  if(!tt){
				  	personsArrColl.addItem(arrc.getItemAt( j ));
				  }
			}
			model.personsTotalCollection = personsArrColl;
			var personLoginEvt: PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_LOGIN_RESULT);
			try
			{
				model.person = GetVOUtil.getPersonObjectLogin(model.person.personLogin);
				model.encryptorUserName = StringUtils.replace(escape(model.encryptor.encrypt(model.person.personLogin)),'+','%2B');
				model.encryptorPassword = StringUtils.replace(escape(model.encryptor.encrypt(model.person.personPassword)),'+','%2B');
				personLoginEvt.personId = model.person.personId;
				model.ChatPerson = model.person;
				model.businessCard = model.person;
				model.dataReach = true; 
			}
			catch(e : Error)
			{
			}
			finally
			{
				if(model.person)
				{
					personLoginEvt.personId = model.person.personId;
					var eventsArr:Array = [personLoginEvt] 
	     			var handler:IResponder = new Callbacks(result,fault)
	     			var loginSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	      			loginSeq.dispatch();
				}
			}
		}
	
		private function checkDuplicateItem( item: int): Boolean {
			var found:Boolean;
			var Team :Teamlinestemplates;
			TeamArr = model.teamLinetemplatesCollection
		  	for(var j : int = 0; j < TeamArr.length; j++) {
				 Team = Teamlinestemplates(TeamArr[j])
				 if(Team.personFk == item ){
				 	  found = true;
				 	}
				 	
				}
            return found;
        }
        
		private function getAllCollectionAfterLogin( rpcEvent : Object ) : void {
			super.result(rpcEvent);
			var loginUtils: LoginUtils  = new LoginUtils();
			var resultArrColl : ArrayCollection = new ArrayCollection();
			resultArrColl  = rpcEvent.result as ArrayCollection;
			
			var companiesList:ArrayCollection 			= resultArrColl.getItemAt(0) as ArrayCollection;
			var phaesesTmeplatesList:ArrayCollection 	= resultArrColl.getItemAt(1) as ArrayCollection;
			var statusList:ArrayCollection 				= resultArrColl.getItemAt(2) as ArrayCollection;
			var profilesList:ArrayCollection 			= resultArrColl.getItemAt(3) as ArrayCollection;
			var workflowTemplatesList:ArrayCollection 	= resultArrColl.getItemAt(4) as ArrayCollection;
			var categoriesList:ArrayCollection 			= resultArrColl.getItemAt(5) as ArrayCollection;
			var personProfilesList:ArrayCollection 		= resultArrColl.getItemAt(6) as ArrayCollection;
			var groupsList:ArrayCollection 				= resultArrColl.getItemAt(7) as ArrayCollection;
			var domainworkflowsList:ArrayCollection 	= resultArrColl.getItemAt(8) as ArrayCollection;
			var modulesList:ArrayCollection 			= resultArrColl.getItemAt(9) as ArrayCollection;
			
			
			loginUtils.getAllCompanies(companiesList); //EVENT_GET_ALL_COMPANIESS
			loginUtils.getAllPhaseTemplates(phaesesTmeplatesList); //EVENT_GET_ALL_PHASESTEMPLATESS
			loginUtils.getAllStatuses(statusList); //EVENT_GET_ALL_STATUS
			loginUtils.getAllProfiles(profilesList); //EVENT_GET_ALL_PROFILESS
			loginUtils.getAllTemplate(workflowTemplatesList); //EVENT_GET_ALL_WORKFLOWSTEMPLATESS
			loginUtils.collectDomainResult(categoriesList); //EVENT_GET_ALL_CATEGORIESS
			loginUtils.getPrjProfilesResult(personProfilesList);//EVENT_GETPRJ_PROFILES
			loginUtils.getAllGroups(groupsList); //EVENT_GET_ALL_GROUPSS
		 	loginUtils.getAllDomainWorkFlowResult(domainworkflowsList); // Group continue -- EVENT_GET_ALL_DOMAIN_WORKLFLOW
			loginUtils.getAllModuleResult(modulesList); // Group continue -- EVENT_GET_ALL_MODULES
							
			loginUtils.commonDefaultTemplate(); //GET_COMMON_DEFAULT_TEMPLATE
		}
	}
}


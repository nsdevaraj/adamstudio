package com.adams.dt.command.authentication
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.event.LangEvent;
	import com.adams.dt.event.PersonsEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.events.PropertyChangeEvent;
	import mx.rpc.IResponder;
	import flash.utils.setTimeout;
	public final class AuthenticationCommand extends AbstractCommand implements ICommand , IResponder 
	{
		private var userName : String; 
		override public function execute( event : CairngormEvent ) : void
		{
			userName = event.data.userName;
			this.delegate = DelegateLocator.getInstance().authenticationDelegate;
			this.delegate.responder = this; 
			this.delegate.login(event.data.userName , event.data.password);
		}

		private var loginStatus : Boolean;
		public function checkLogin(ev : PropertyChangeEvent) : void
		{
			if(ev.currentTarget.authenticated)
			{
				loginStatus = true;
				model.loginErrorMesg = "";
				model.person.personLogin = this.userName;
				
				/* var eventconsumer:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_CONSU_STATUSONLINE);
				var eventsArr:Array = [eventconsumer]
         		var handler:IResponder = new Callbacks(result,fault)
         		var loginSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
          		loginSeq.dispatch();  */ 
          		
          		//var event:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_GET_AUTH_PERSONS);
				//event.loginName = model.person.personLogin;
				
				
				if(model.typeName!= 'Mail')
				{
					var event:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_GET_AUTH_PERSONS);
					event.loginName = model.person.personLogin;
	          		var levent :LangEvent = new LangEvent(LangEvent.EVENT_GET_ALL_LANGS);          		
	    			var eventconsumer:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_CONSU_STATUSONLINE);
					/* var event:TasksEvent = new TasksEvent(TasksEvent.EVENT_GET_TASKS);
					event.tasks = new Tasks();
					event.tasks.taskId = taskLocalId; */
	          		var evtArr:Array = [levent,eventconsumer,event]
				 	var handler:IResponder = new Callbacks(model.mainClass.Resultsview);
					var seq:SequenceGenerator = new SequenceGenerator(evtArr,handler)
		          	seq.dispatch();
		  		}


			}

			setTimeout(showErrorLogin , 2000);
		}

		public function showErrorLogin() : void
		{
			if( !loginStatus)
			{
				if(model.loc.language == 'en')
				{
					model.loginErrorMesg = "Incorrect UserName and password"
				}else
				{
					model.loginErrorMesg = "Nom d'utilisateur et votre mot de passe incorrect"		
				}
			}else{
				model.loginErrorMesg = ""
			}
		}
	}
}
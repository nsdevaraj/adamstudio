package com.adams.dt.command.authentication
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.event.PagingEvent;
	import com.adams.dt.event.PersonsEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.managers.SharedObjectManager;
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.utils.setTimeout;
	
	import mx.events.PropertyChangeEvent;
	import mx.rpc.IResponder;
	public final class AuthenticationCommand extends AbstractCommand implements ICommand , IResponder 
	{
		private var userName : String; 
		/**
		 * Send the username and the password to authentication delegate
		 */
		override public function execute( event : CairngormEvent ) : void
		{
			userName = event.data.userName;
			this.delegate = DelegateLocator.getInstance().authenticationDelegate;
			this.delegate.responder = this; 
			this.delegate.login(event.data.userName , event.data.password);
		}
		
		/**
		 * @private 
		 * Store login state true or false; 
		 */		
		private var loginStatus : Boolean;
		
		/**
         * @ev is the propertyChangeEvent passed from the AuthenticationDelegate.
         * IF loginStatus is true update the person online status
         * ELSE show Error Message
         */ 	
		public function checkLogin(ev : PropertyChangeEvent) : void
		{
			if(ev.currentTarget.authenticated)
			{
				loginStatus = true;
				model.loginErrorMesg = "";
				model.person.personLogin = this.userName;
				var eventconsumer:PersonsEvent = new PersonsEvent(PersonsEvent.EVENT_CONSU_STATUSONLINE);
				var eventsArr:Array = [eventconsumer]
         		var handler:IResponder = new Callbacks(result,fault)
         		var loginSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
          		loginSeq.dispatch();  
 

          		var SoM:SharedObjectManager = SharedObjectManager.instance;
          		if(SoM.data.filesToBeUpload)
				model.filesToUpload = SoM.data.filesToBeUpload;
				if(SoM.data.filesToBeDownload)
				model.filesToDownload = SoM.data.filesToBeDownload;
				if(SoM.data.fileDetailsArrays)
				model.fileDetailsArray = SoM.data.fileDetailsArrays; 
			}
			setTimeout( showErrorLogin , 2000 );
		}
		
		
		/**
	     * Login Error Message.
	     */ 
		public function showErrorLogin() : void
		{
			if( !loginStatus )
			{
				if( model.preloaderVisibility )	model.preloaderVisibility = false;
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
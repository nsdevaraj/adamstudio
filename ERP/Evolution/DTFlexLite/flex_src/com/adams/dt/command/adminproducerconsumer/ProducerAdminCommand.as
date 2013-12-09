package com.adams.dt.command.adminproducerconsumer
{
	import com.adams.dt.business.admin.ProducerAdminDelegate;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.event.PersonsEvent;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.enterprise.business.*;
	
	import mx.messaging.messages.AsyncMessage;
	import mx.messaging.messages.IMessage;
	import mx.rpc.IResponder;
	
	public final class ProducerAdminCommand extends AbstractCommand implements IResponder
	{	
				
		override public function execute( event : CairngormEvent ) : void
		{	 
			
			var delegate:ProducerAdminDelegate = new ProducerAdminDelegate( this );
			var personsEvent : PersonsEvent = PersonsEvent(event);
			
			var message:IMessage = new AsyncMessage();
			message.body.pushadminmonitorpersonId = model.ChatPerson.personId;
			message.body.pushadminmonitorusername = model.ChatPerson.personFirstname;
			message.body.pushadminmonitorscreen = personsEvent.adminmonitorscreen;			
			/* if(personsEvent.OnlineOffline!="Offline")
			{
				message.body.pushadminuserstatus = "Online";
			}
			else
			{
				message.body.pushadminuserstatus = "Offline";
			} */
			delegate.adminsenddetails(message);			
			
		}
	}
}

package com.adams.dt.command.producerconsumer
{
	import com.adams.dt.business.PushProducerDelegate;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.event.PersonsEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Persons;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.enterprise.business.*;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.messaging.messages.AsyncMessage;
	import mx.messaging.messages.IMessage;
	import mx.rpc.IResponder;
	
	public final class ProducerLogout extends AbstractCommand implements IResponder
	{	 
		override public function execute( event : CairngormEvent ) : void
		{
		    var delegate:PushProducerDelegate = new PushProducerDelegate( this );
			var personsEvent : PersonsEvent = PersonsEvent(event);
			
			var message:IMessage = new AsyncMessage();
			message.body.onlineuserid = model.ChatPerson.personId;
			message.body.onlineusername = model.ChatPerson.personFirstname;
			if(personsEvent.OnlineOffline!="Offline")
			{
				message.body.onlineuserstatus = "Online";
			}
			else
			{
				message.body.onlineuserstatus = "Offline";
			}
				
			message.body.onlineuserUNIID = model.ChatPerson.activeChatid;						
			delegate.senddetails(message);
			
		}
	}
}

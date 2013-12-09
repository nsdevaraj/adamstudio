package com.adams.dt.command.producerconsumer
{
	import com.adams.dt.business.chat.ProducerChatDelegate;
	import com.adams.dt.command.AbstractCommand;
	import com.adams.dt.event.PersonsEvent;
	import com.adams.dt.event.chatevent.ChatDBEvent;
	import com.adams.dt.model.vo.Chat;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Teamlines;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.enterprise.business.*;
	
	import mx.messaging.messages.AsyncMessage;
	import mx.messaging.messages.IMessage;
	import mx.rpc.IResponder;
	
	public final class ProducerChatCommand extends AbstractCommand implements IResponder
	{	 
		override public function execute( event : CairngormEvent ) : void
		{
		    var delegate:ProducerChatDelegate = new ProducerChatDelegate( this );
			var personsEvent : PersonsEvent = PersonsEvent(event);
			
			var message:IMessage = new AsyncMessage();
			message.body.chat = "Chat";
			message.body.senderId = model.chatvo.senderId;
			message.body.senderName = model.chatvo.senderName;
			message.body.description = model.chatvo.description;
			message.body.projectId = model.chatvo.projectFk;
			message.body.receiverId = model.chatvo.receiverId;
			message.body.receiverName = model.chatvo.receiverName;
			var arrPerson:Array = sendingProjectPersons();
			message.body.personarray = arrPerson;			
			delegate.senddetails(message);
			
			var createChatEvt:ChatDBEvent = new ChatDBEvent( ChatDBEvent.EVENT_CREATE_CHAT );
			model.chatvo.receiverId = 0;
			model.chatvo.receiverName = '';
			createChatEvt.chat = model.chatvo;
			createChatEvt.dispatch();
					
		}
		private var tempPersonArray:Array = new Array();
		private function sendingProjectPersons():Array{
			if(model.chatTeamLineCollection.length!=0)   //model.teamlLineCollection
			{	
				tempPersonArray = [];
				for each( var team:Teamlines in model.chatTeamLineCollection) 
				{	
					var profileObj:Profiles = Profiles( checkProfile( team.profileID ) );
					if( ( profileObj.profileCode != 'EPR' ) 
				    	&& ( profileObj.profileCode != 'AGN' ) 
				    	&& ( profileObj.profileCode != 'COM' ) 
				    	&& ( profileObj.profileCode != 'CHP' ) 
				    	&& ( profileObj.profileCode != 'CPP' )  
				    	&& ( profileObj.profileCode != 'IND' )
				    	&& ( profileObj.profileCode != 'BAT' )) {
				    		var personId:int = ( team.personID );
				    		if(model.person.personId!= personId){
				    			tempPersonArray.push(personId);
				    		}
					}
				}
				return tempPersonArray;
			}
			return null;
		}
		private function checkProfile( id:int ):Profiles {
			for each( var item:Profiles in model.teamProfileCollection	) {
        		if( item.profileId == id ) {
        			return item; 
        		}
    		}
    		return null;
		}
	}
}

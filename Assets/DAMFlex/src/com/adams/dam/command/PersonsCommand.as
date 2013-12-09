package com.adams.dam.command
{
	import com.adams.dam.business.DelegateLocator;
	import com.adams.dam.business.utils.StringUtils;
	import com.adams.dam.business.utils.VOUtils;
	import com.adams.dam.event.PersonsEvent;
	import com.adams.dam.model.ModelLocator;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	public class PersonsCommand extends AbstractCommand
	{
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		private var _personsEvent:PersonsEvent;
		private var handler:IResponder;
		
		override public function execute( event:CairngormEvent ):void {
			super.execute( event );
			
			_personsEvent = PersonsEvent( event );
			delegate = DelegateLocator.getInstance().personsDelegate;
			
			switch( _personsEvent.type ) {
				case PersonsEvent.EVENT_GET_ALL_PERSONS:
					handler = new Callbacks( onGetAllPersonsResult, fault );
					delegate.responder = handler;
					delegate.findAll();
					break;
				default :
					break;
			}
		}	
		
		protected function onGetAllPersonsResult( callResult:Object ):void {
			model.totalPersonsCollection = callResult.result as ArrayCollection; 
			model.persons = VOUtils.getPersonObjectLogin( model.userName, model.totalPersonsCollection );
			model.encryptorUserName = StringUtils.replace( escape( model.encryptor.encrypt( model.persons.personLogin ) ), '+' , '%2B' );
			model.encryptorPassword = StringUtils.replace( escape( model.encryptor.encrypt( model.persons.personPassword ) ), '+', '%2B' );
			super.result( callResult );
		}
	}
}
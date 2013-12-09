package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.DefaultTemplateValueEvent;
	import com.adams.dt.model.vo.DefaultTemplateValue;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	
	public final class DefaultTemplateValueCommand extends AbstractCommand 
	{
		private var _defaultTemplateValueEvent : DefaultTemplateValueEvent;
		
		override public function execute( event:CairngormEvent ):void {	
			super.execute( event );
			_defaultTemplateValueEvent = DefaultTemplateValueEvent( event );
			this.delegate = DelegateLocator.getInstance().defaultTemplateValueDelegate;
			this.delegate.responder = new Callbacks( result, fault );
			
			 switch( event.type ) { 
			 	case DefaultTemplateValueEvent.EVENT_CREATE_DEFAULT_TEMPLATE_VALUE:
			 		delegate.responder = new Callbacks( createNewDefaultTempValueResult, fault );
			    	delegate.create( _defaultTemplateValueEvent.defaultTemplateValues );
			 	break;
			 	case DefaultTemplateValueEvent.EVENT_GET_ALL_DEFAULT_TEMPLATE_VALUE:
			 		delegate.responder = new Callbacks( findAllResult, fault );
			        delegate.findAll();
			 	break;
			 	case DefaultTemplateValueEvent.BULK_UPDATE_DEFAULT_TEMPLATE_VALUE:
			 		delegate.bulkUpdate( _defaultTemplateValueEvent.defaultTempValuesArr );
			 	break;
			 	case DefaultTemplateValueEvent.UPDATE_DEFAULT_TEMPLATE_VALUE:
			 		delegate.update( _defaultTemplateValueEvent.defaultTemplateValues );
			 	break;
			 	case DefaultTemplateValueEvent.GET_DEFAULT_TEMPLATE_VALUE:
			 		delegate.responder = new Callbacks( findByIdResult, fault ); 
			 		delegate.findById( _defaultTemplateValueEvent.defaultTemplateValuesID );
			 	break;			 	
			 	case DefaultTemplateValueEvent.DELETE_DEFAULT_TEMPLATE_VALUE:
			 		if( model.defaultTempValueColl.length > 0 ) {
		        		 deleteSeletedDefaultTemplateValue( model.defaultTempValueColl.getItemAt( 0 ) as DefaultTemplateValue );
		        	 }
			 	break;
			 	case DefaultTemplateValueEvent.QUERY_DELETE_DEFAULT_TEMPLATE_VALUE:
			 		delegate = DelegateLocator.getInstance().pagingDelegate;
			 		delegate.responder = new Callbacks( queryDeleteDefTempValue, fault ); 
			 		delegate.bulkDeleteId( _defaultTemplateValueEvent.defaultTemplateValuesID );
			 	break;	
			 			 	
			 }
		}
		private function queryDeleteDefTempValue( rpcEvent:Object ):void {
			super.result( rpcEvent );
		}
		private function deleteSeletedDefaultTemplateValue( toDeleteTemplateValue:DefaultTemplateValue ):void {
    		delegate = DelegateLocator.getInstance().teamlineDelegate;
    		delegate.responder = new Callbacks( deleteSeletedTempValueResult, fault );
    		delegate.deleteVO( toDeleteTemplateValue ); 
    	}
    	
    	private function deleteSeletedTempValueResult( rpcEvent:Object ):void { 
    		model.defaultTempValueColl.removeItemAt( 0 );
			if( model.defaultTempValueColl.length > 0 ) {
    			deleteSeletedDefaultTemplateValue( model.defaultTempValueColl.getItemAt( 0 ) as DefaultTemplateValue );
    		}
    		else {
    			model.defaultTempValueColl.refresh();
    		}
    		super.result( rpcEvent );
    	}
		
		private function createNewDefaultTempValueResult( rpcEvent:Object ):void {
			super.result( rpcEvent );
		}
		
		private function findAllResult( rpcEvent:Object ):void {
			super.result( rpcEvent );
		}
		
		private function findByIdResult( rpcEvent:Object ):void {
			model.projectDefaultValue = rpcEvent.result as ArrayCollection;
			model.projectDefaultValue.refresh();
			super.result( rpcEvent );
		}
	}
}

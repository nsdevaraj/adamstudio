package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.DefaultTemplateEvent;
	import com.adams.dt.model.vo.Companies;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	
	public final class DefaultTemplateCommand extends AbstractCommand 
	{
		private var _defaultTemplateEvent:DefaultTemplateEvent;
		
		override public function execute( event:CairngormEvent ):void {	
			 super.execute( event );
			 _defaultTemplateEvent = DefaultTemplateEvent( event );
			 this.delegate = DelegateLocator.getInstance().defaultTemplateDelegate;
			 this.delegate.responder = new Callbacks( result, fault );
			
			 switch( event.type ) { 
			 	case DefaultTemplateEvent.EVENT_CREATE_DEFAULT_TEMPLATE:
			 		delegate.responder = new Callbacks( createNewDefaultTempResult, fault );
			    	delegate.create( _defaultTemplateEvent.defaultTemplates );
			 	break;
			 	case DefaultTemplateEvent.EVENT_GET_ALL_DEFAULT_TEMPLATE:
			 		delegate.responder = new Callbacks( findAllResult,fault );
			        delegate.findAll(); 
			 	break;
			 	case DefaultTemplateEvent.BULK_UPDATE_DEFAULT_TEMPLATE:
			 	break;
			 	case DefaultTemplateEvent.UPDATE_DEFAULT_TEMPLATE:
			 		delegate.directUpdate( _defaultTemplateEvent.defaultTemplates );
			 	break;
			 	case DefaultTemplateEvent.GET_DEFAULT_TEMPLATE:
			 		delegate.responder = new Callbacks( findByIdResult, fault );
			 	    delegate.findById( _defaultTemplateEvent.companyId );
			 	break;
			 	case DefaultTemplateEvent.GET_COMMON_DEFAULT_TEMPLATE:
			 		model.totalCompaniesColl.filterFunction = commercialFilter;
			    	model.totalCompaniesColl.refresh();
			 		delegate.responder = new Callbacks( findByCommonIdResult, fault );
			 		model.clientCompanyId = ( model.totalCompaniesColl.getItemAt( 0 ) as Companies ).companyid ;
			 	    delegate.findById( model.clientCompanyId );
			 	    model.totalCompaniesColl.filterFunction = null;
			 	    model.totalCompaniesColl.refresh();
			 	break;
			 	case DefaultTemplateEvent.DELETE_DEFAULT_TEMPLATE:
			 		delegate.responder = new Callbacks( onDeleteTemplateResult, fault );
			 		delegate.deleteVO( _defaultTemplateEvent.defaultTemplates );
			 	break;
			 }
		}
		
		private function commercialFilter( obj:Companies ):Boolean {
	    	var retVal:Boolean = false;
			if ( obj.companyCategory == 'PHOTOGRAVURE' ) { 
				retVal = true;
			}
			return retVal;
	    }
	    
		private function createNewDefaultTempResult( rpcEvent:Object ):void {
			model.specificDefaultTemplateCollect.addItem( rpcEvent.message.body );
			model.specificDefaultTemplateCollect.refresh();
			super.result( rpcEvent );
		}
		
		
		private function findAllResult( rpcEvent:Object ):void {
			model.getAllDefaultTemplateCollect = rpcEvent.result as ArrayCollection;
			super.result( rpcEvent );
		}
		
		private function findByCommonIdResult( rpcEvent:Object ):void {
			model.commonDefaultTemplateCollect = rpcEvent.result as ArrayCollection; 
			trace("************ DefaultTemplateCommand findByCommonIdResult :"+model.commonDefaultTemplateCollect.length);

			super.result( rpcEvent );
		}
		
		private function findByIdResult( rpcEvent:Object ):void {
			var result:ArrayCollection = rpcEvent.result as ArrayCollection;
			model.specificDefaultTemplateCollect = new ArrayCollection( model.commonDefaultTemplateCollect.source.concat( result.source ) );
			trace("************ DefaultTemplateCommand findByIdResult :"+model.specificDefaultTemplateCollect.length);
 
			super.result( rpcEvent );
		}
		
		private function onDeleteTemplateResult( rpcEvent:Object ):void {
			super.result( rpcEvent );
		}
	}
}

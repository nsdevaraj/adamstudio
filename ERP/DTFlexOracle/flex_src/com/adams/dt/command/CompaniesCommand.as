package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.CompaniesEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.Companies;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	public final class CompaniesCommand extends AbstractCommand 
	{ 
		private var companiesEvent : CompaniesEvent;		
		override public function execute( event : CairngormEvent ) : void
		{	 
			super.execute(event);
			companiesEvent =CompaniesEvent(event);
			this.delegate = DelegateLocator.getInstance().companyDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type){    
				case CompaniesEvent.EVENT_GET_ALL_COMPANIESS:
					delegate.responder = new Callbacks(findAllResult,fault);
					delegate.findAll();
					break; 
				case CompaniesEvent.EVENT_GET_COMPANIES:
					delegate.findById(companiesEvent.companies.companyid);
					break; 
				case CompaniesEvent.EVENT_CREATE_COMPANIES:
				    delegate.responder = new Callbacks(getCompanies,fault);
					delegate.create(companiesEvent.companies);
					break; 
				case CompaniesEvent.EVENT_UPDATE_COMPANIES:
					delegate.directUpdate(companiesEvent.companies);
					break; 
				case CompaniesEvent.EVENT_DELETE_COMPANIES:
					delegate.deleteVO(companiesEvent.companies);
					break; 
				case CompaniesEvent.EVENT_SELECT_COMPANIES:
					delegate.select(companiesEvent.companies);
					break; 
				case CompaniesEvent.EVENT_CREATE_COMPANIES_SEQ:
					var handler:IResponder = new Callbacks(result,fault);
			 	 	var eventSeq:SequenceGenerator = new SequenceGenerator(model.createCompanyEvents ,handler);
				    eventSeq.dispatch(); 
				default:
					break; 
				}
		}
		
		private function getCompanies( rpcEvent : Object  ):	void {
			model.totalCompaniesColl.addItem( Companies( rpcEvent.message.body ) );
			model.totalCompaniesColl.refresh();
			model.clientCompanies = Companies( rpcEvent.message.body );
			super.result( rpcEvent );
		}
		/**
		 * get All compani details
		 */
		public function findAllResult( rpcEvent : Object ) : void
		{ 
			model.totalCompaniesColl = rpcEvent.result as ArrayCollection;
			super.result(rpcEvent);
		}
	}
}

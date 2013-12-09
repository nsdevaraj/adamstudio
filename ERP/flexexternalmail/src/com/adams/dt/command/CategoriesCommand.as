package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.CategoriesEvent;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Profiles;
	import com.adams.dt.model.vo.Projects;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	public final class CategoriesCommand extends AbstractCommand 
	{
		private var categories2:Categories;
		private var categories1:Categories;
		private var projects:Projects;
		private var categories:Categories;
		private var categoriesEvent : CategoriesEvent 
		override public function execute( event : CairngormEvent ) : void
		{	
			super.execute(event);
			categoriesEvent = CategoriesEvent(event);
			this.delegate = DelegateLocator.getInstance().categoryDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type)
			{				         
				case CategoriesEvent.EVENT_GET_DOMAIN:
					delegate.responder = new Callbacks(getDomainResult,fault);
					//delegate.findDomain(model.person.company.companycode);
				break; 
				case CategoriesEvent.EVENT_GET_ALL_CATEGORIES:					
					delegate.responder = new Callbacks(collectDomainResult,fault);
					//delegate.findAll();
					delegate.getList();
					break;
				default:
					break; 
			}
		}
		public function collectDomainResult( rpcEvent : Object ) : void {
	  		super.result(rpcEvent);
	  		//june 08 2010
	  		model.delayUpdateTxt = "All Categories"; 		
	  		model.categoriesCollection = ArrayCollection(rpcEvent.result)
		}
		public function getDomainResult( rpcEvent : Object ) : void
		{
			model.domainCollection = ArrayCollection(rpcEvent.result);
			if(model.domainCollection.length > 0)
			{
				var profile : Profiles = new Profiles()
				profile.profileId = 2;
				profile.profileCode = 'CLT'
				model.profilesCollection.addItem(profile);
				model.domain = Categories(ArrayCollection(rpcEvent.result).getItemAt(0));
			}
			super.result(rpcEvent);
		}
		
		public function getDomains(categories : Categories) : Categories
		{
			var tempCategories : Categories = new Categories();
			if(categories.categoryFK != null)
			{
				tempCategories = getDomains(categories.categoryFK);
			}else
			{
				return categories;
			}
			return tempCategories;
		}
 	}
}

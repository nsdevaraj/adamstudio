package com.adams.dam.command
{
	import com.adams.dam.business.DelegateLocator;
	import com.adams.dam.event.CategoriesEvent;
	import com.adams.dam.model.CategoryFilter;
	import com.adams.dam.model.ModelLocator;
	import com.adams.dam.model.vo.Categories;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.IResponder;
	
	public class CategoriesCommand extends AbstractCommand
	{
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		private var _categoriesEvent:CategoriesEvent;
		private var handler:IResponder;
		
		override public function execute( event:CairngormEvent ):void {
			super.execute( event );
			
			_categoriesEvent = CategoriesEvent( event );
			delegate = DelegateLocator.getInstance().categoriesDelegate;
			
			switch( _categoriesEvent.type ) {
				case CategoriesEvent.EVENT_GET_ALL_CATEGORIES:
					handler = new Callbacks( onGetAllCategoriesResult, fault );
					delegate.responder = handler;
					delegate.findAll();
					break;
				default :
					break;
			}
		}	
		
		protected function onGetAllCategoriesResult( callResult:Object ):void {
			model.totalCategoriesCollection = callResult.result as ArrayCollection; 
			makeDomainCollection();
			super.result( callResult );
		}
		
		protected function makeDomainCollection():void {
			model.domainCollection = new ArrayCollection();
			for each( var domain:Categories in model.totalCategoriesCollection ) {
				if( !domain.categoryFK ) {
					model.domainCollection.addItem( domain );
				}
			}
			model.domainCollection.refresh();
			makeCategoryOneCollection();
		}
		
		protected function makeCategoryOneCollection():void {
			model.categoryOneCollection = new ArrayCollection();
			for each( var categoryOne:Categories in model.totalCategoriesCollection ) {
				if( ( categoryOne.categoryFK ) && ( belongToDomain( categoryOne ) ) ) {
					model.categoryOneCollection.addItem( categoryOne );
				}
			}
			model.categoryOneCollection.refresh();
			makeCategoryTwoCollection();
		}
		
		protected function makeCategoryTwoCollection():void {
			model.categoryTwoCollection = new ArrayCollection();
			for each( var categoryTwo:Categories in model.totalCategoriesCollection ) {
				if( ( categoryTwo.categoryFK ) && ( belongToCategoryOne( categoryTwo ) ) ) {
					model.categoryTwoCollection.addItem( categoryTwo );
				}
			}
			model.categoryTwoCollection.refresh();
			makeCategoryFilterList();
		}
		
		protected function makeCategoryFilterList():void {
			model.categoryFilterList = new ArrayCollection();
			for each( var categoryTwo:Categories in model.categoryTwoCollection ) {
				var categoryFilter:CategoryFilter = new CategoryFilter();
				categoryFilter.categoryTwo = categoryTwo;
				categoryFilter.categoryOne = categoryTwo.categoryFK;
				categoryFilter.categoryFilterName = categoryFilter.categoryTwo.categoryName + " - " + categoryFilter.categoryOne.categoryName;
				model.categoryFilterList.addItem( categoryFilter );
			}
			model.categoryFilterList.refresh();
		}
		
		protected function belongToDomain( value:Categories ):Boolean {
			for each( var domain:Categories in model.domainCollection ) {
				if( value.categoryFK.categoryId == domain.categoryId ) {
					return true;
				}
			}
			return false;
		}
		
		protected function belongToCategoryOne( value:Categories ):Boolean {
			for each( var categoryOne:Categories in model.categoryOneCollection ) {
				if( value.categoryFK.categoryId == categoryOne.categoryId ) {
					return true;
				}
			}
			return false;
		}
	}
}
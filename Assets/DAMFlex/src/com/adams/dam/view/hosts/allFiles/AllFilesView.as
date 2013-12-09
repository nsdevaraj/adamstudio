package com.adams.dam.view.hosts.allFiles
{
	import com.adams.dam.business.utils.VOUtils;
	import com.adams.dam.event.CurrentDataSetEvent;
	import com.adams.dam.event.FileDetailsEvent;
	import com.adams.dam.model.CategoryFilter;
	import com.adams.dam.model.ModelLocator;
	import com.adams.dam.model.vo.Categories;
	import com.adams.dam.model.vo.FileDetails;
	import com.adams.dam.model.vo.Projects;
	import com.adams.dam.view.skins.allFiles.AllFilesSkin;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.FlexEvent;
	import mx.messaging.messages.ErrorMessage;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	public class AllFilesView extends SkinnableComponent
	{
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		private var fileDelailsSource:ArrayCollection;
		
		[Bindable]
		public var filesDataProvider:ArrayCollection = new ArrayCollection();
		[Bindable]
		public var categoryList:ArrayCollection;
		[Bindable]
		public var projectList:ArrayCollection;
		
		
		[Bindable]
		public var selectedIndex:int;
		
		private var skinComponent:AllFilesSkin;
		
		public function AllFilesView()
		{
			super();
			addEventListener( FlexEvent.INITIALIZE, onInitialize, false, 0, true );
			addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true );
		}
		
		protected function onInitialize( event:FlexEvent ):void {
			fileDelailsSource = new ArrayCollection();
			for each( var prj:Projects in  model.totalProjectsCollection ) {
				for each( var file:FileDetails in model.totalFileDetailsCollection ) {
					if( ( prj.projectId == file.projectFK ) && ( file.visible != 0 ) ) {
						fileDelailsSource.addItem( file );
					}
				}
			}
			fileDelailsSource.refresh();	
			
			categoryList = new ArrayCollection( model.categoryFilterList.source );
			projectList = new ArrayCollection( model.totalProjectsCollection.source );
		}
		
		protected function onCreationComplete( event:FlexEvent ):void {
			if( skin ) {
				skinComponent = AllFilesSkin( skin );
				
				skinComponent.filtersKey.addEventListener( Event.CHANGE, onFilterOptionChange, false, 0, true );
				
				skinComponent.domain.addEventListener( IndexChangeEvent.CHANGE, onDomainChange, false, 0, true );
				skinComponent.category.addEventListener( IndexChangeEvent.CHANGE, onCategoryChange, false, 0, true );
				skinComponent.project.addEventListener( IndexChangeEvent.CHANGE, onProjectChange, false, 0, true );
				skinComponent.searchSelector.addEventListener( IndexChangeEvent.CHANGE, onSearchSelectorChange, false, 0, true );
				
				domainCategoryFiltersApply();
				
				setNamesPropertyOnAutoComplete();
				
				skinComponent.filtersKey.dispatchEvent( new Event( Event.CHANGE ) );
			}
		}
		
		protected function setNamesPropertyOnAutoComplete():void {
			var namesArray:Array = [];
			var searchSelectProvider:ArrayCollection = new ArrayCollection();
			
			var obj:Object = {};
			obj.label = 'All';
			obj.field = obj.label;
			searchSelectProvider.addItem( obj );
			
			for each( var column:DataGridColumn in skinComponent.dashBoardGrid.columns ) {
				obj = {};
				obj.label = column.headerText;
				
				if( ( column.dataField ) && ( column.dataField != '' ) ) {
					obj.field = column.dataField;
					namesArray.push( column.dataField );
				}
				else {
					obj.field = column.headerText;
					namesArray.push( column.headerText );
				}
				
				searchSelectProvider.addItem( obj );
			}
			
			searchSelectProvider.refresh();
			skinComponent.autoComplete.nameProperty = namesArray;
			skinComponent.searchSelector.dataProvider = searchSelectProvider as IList;
			skinComponent.searchSelector.selectedIndex = 0;
		}
		
		protected function onFilterOptionChange( event:Event ):void {
			if( skinComponent.filtersKey.selected ) {
				updateFileDetailsProvider();
			}
			else {
				var currentProjectSetEvent:CurrentDataSetEvent = new CurrentDataSetEvent( CurrentDataSetEvent.EVENT_SET_PROJECTS );
				currentProjectSetEvent.project = null;
				currentProjectSetEvent.dispatch();
				
				filesDataProvider = filterFileSource( false );
			}
		}
		
		protected function domainCategoryFiltersApply():void {
			categoryList.filterFunction = categoryFilter;
			categoryList.refresh();
			skinComponent.category.selectedIndex = 0;
			
			projectList.filterFunction = projectFilter;
			projectList.refresh();
			skinComponent.project.selectedIndex = 0;
		}
		
		protected function onDomainChange( event:IndexChangeEvent ):void {
			domainCategoryFiltersApply();
			updateFileDetailsProvider();
		}
		
		protected function onCategoryChange( event:IndexChangeEvent ):void {
			projectList.filterFunction = projectFilter;
			projectList.refresh();
			skinComponent.project.selectedIndex = 0;
			updateFileDetailsProvider();
		}
		
		protected function onProjectChange( event:IndexChangeEvent ):void {
			updateFileDetailsProvider();
		}
		
		protected function updateFileDetailsProvider():void {
			if( projectList.length == 0 ) {
				filesDataProvider.removeAll();
			}
			else {
				
				var currentProjectSetEvent:CurrentDataSetEvent = new CurrentDataSetEvent( CurrentDataSetEvent.EVENT_SET_PROJECTS );
				currentProjectSetEvent.project = skinComponent.project.selectedItem as Projects;
				currentProjectSetEvent.dispatch();
				
				filesDataProvider = filterFileSource();
			}
			filesDataProvider.refresh();
		}
		
		protected function onSearchSelectorChange( event:IndexChangeEvent ):void {
			skinComponent.autoComplete.labelField = skinComponent.searchSelector.selectedItem.field;
		}
		
		protected function filterFileSource( filterable:Boolean = true ):ArrayCollection {
			var returnCollection:ArrayCollection = new ArrayCollection();
			for each( var fd:FileDetails in fileDelailsSource ) {
				if( filterable && ( fd.projectFK == model.project.projectId ) ) {
					returnCollection.addItem( fd );
				}
				else if( !filterable ) {
					returnCollection.addItem( fd );
				}
			}
			returnCollection.refresh();
			return returnCollection;
		}
		
		protected function categoryFilter( category:CategoryFilter ):Boolean {
			if( category.categoryOne.categoryFK.categoryId == Categories( skinComponent.domain.selectedItem ).categoryId ) {
				return true;
			}
			return false;
		}
		
		protected function projectFilter( project:Projects ):Boolean {
			if( project.categoryFKey == CategoryFilter( skinComponent.category.selectedItem ).categoryTwo.categoryId ) {
				return true;
			}
			return false;
		}
		
		public function getProjectName(  obj:FileDetails, column:DataGridColumn ):String {
			return VOUtils.getProjectObject( obj.projectFK ).projectName;
		}
	}
}
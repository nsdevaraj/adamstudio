package com.adams.dam.view.hosts.dummyHosts
{
	import com.adams.dam.event.FileDetailsEvent;
	import com.adams.dam.model.ModelLocator;
	import com.adams.dam.model.vo.FileDetails;
	import com.adams.dam.model.vo.Projects;
	import com.adams.dam.view.skins.dummySkins.DummySkin;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	import mx.messaging.messages.ErrorMessage;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	
	import spark.components.ToggleButton;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	public class DummyHost extends SkinnableComponent
	{
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		[Bindable]
		public var filesDataProvider:ArrayCollection;
		
		private var skinComponent:DummySkin;
		
		public function DummyHost()
		{
			super();
			addEventListener( FlexEvent.INITIALIZE, onInitialize, false, 0, true );
			addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true );
		}
		
		protected function onInitialize( event:FlexEvent ):void {
			filesDataProvider = new ArrayCollection();
			for each( var prj:Projects in  model.totalProjectsCollection ) {
				for each( var file:FileDetails in model.totalFileDetailsCollection ) {
					if( ( prj.projectId == file.projectFK ) && ( file.visible != 0 ) ) {
						filesDataProvider.addItem( file );
					}
				}
			}
			filesDataProvider.refresh();	
		}
		
		protected function onCreationComplete( event:FlexEvent ):void {
			if( skin ) {
				skinComponent = DummySkin( skin );
				skinComponent.comboMenu.addEventListener( IndexChangedEvent.CHANGE, dropdownlist1_changeHandler );
				skinComponent.listBtn.addEventListener( MouseEvent.CLICK, switchView );
				skinComponent.thumbBtn.addEventListener( MouseEvent.CLICK, switchView );
			}
		}
		
		protected function dropdownlist1_changeHandler( event:IndexChangeEvent ):void {
			skinComponent.autoComplete.displayField = skinComponent.comboMenu.selectedItem;
		}
		
		protected function switchView( event:MouseEvent ):void {
			if( ( event.currentTarget == skinComponent.listBtn ) && ( ToggleButton( event.currentTarget ).selected ) ) {
				skinComponent.currentState = 'listView';
				skinComponent.thumbBtn.selected = false;
			}
			else if( ( event.currentTarget == skinComponent.thumbBtn ) && ( ToggleButton( event.currentTarget ).selected ) ) {
				skinComponent.currentState = 'thumbView';
				skinComponent.listBtn.selected = false;
			}
		}
		
		public function getProjectName(  obj:FileDetails, column:DataGridColumn ):String {
			return getProject( obj.projectFK ).projectName;
		}
		
		protected function getProject( id:int ):Projects {
			for each( var prj:Projects in model.totalProjectsCollection ) {
				if( prj.projectId == id ) {
					return prj;
				}
			}
			return null;
		}
		
		protected function onServiceCallFault( faultInfo:Object ):void {
			var faultEvt:FaultEvent = faultInfo as FaultEvent;
			var errorMessage:ErrorMessage = faultEvt.message as ErrorMessage;
			Alert.show( errorMessage.faultString );
		}
	}
}
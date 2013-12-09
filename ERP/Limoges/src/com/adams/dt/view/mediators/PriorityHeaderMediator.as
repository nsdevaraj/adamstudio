package com.adams.dt.view.mediators
{
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.signal.ControlSignal;
	import com.adams.dt.util.ProcessUtil;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.PriorityHeaderSkinView;
	import com.adams.swizdao.model.vo.CurrentInstance;
	import com.adams.swizdao.model.vo.SignalVO;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.collections.ArrayList;
	
	import spark.events.IndexChangeEvent;
	
	public class PriorityHeaderMediator extends AbstractViewMediator
	{ 		 
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject]
		public var mainViewMediator:MainViewMediator;
		
		[Inject("propertiespresetsDAO")]
		public var propertiespresetsDAO:AbstractDAO;
		
		private var menuAc:ArrayList;
		
		[Embed('assets/images/mail.png')]
		private var mailclass:Class;
		
		private var _priortyWatcher:ChangeWatcher;
		
		private var _homeState:String;
		public function get homeState():String {
			return _homeState;
		}
		public function set homeState( value:String ):void {
			_homeState = value;
			switch( value ) {
				case Utils.GENERAL_INDEX:
				case Utils.NOTES_INDEX:
				case Utils.FILE_INDEX:
				case Utils.MAIL_INDEX:
				case Utils.CORRECTION_INDEX:
				case Utils.PROJECTCORRECTION_INDEX:	
					if( !visible ) {
						visible = true;
						init();
					}
					break;
				default:
					if( visible ) {
						visible = false;
					}
					break;
			}
		}
		
		/**
		 * Constructor.
		 */
		public function PriorityHeaderMediator( viewType:Class=null )
		{
			super( PriorityHeaderSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():PriorityHeaderSkinView {
			return _view as PriorityHeaderSkinView;
		}
		
		[MediateView( "PriorityHeaderSkinView" )]
		override public function setView( value:Object ):void { 
			super.setView( value );	
		}  
		
		override protected function setViewDataBindings():void 	{
			//remove Effect
		}
		
		/**
		 * The <code>init()</code> method is fired off automatically by the 
		 * AbstractViewMediator when the creation complete event fires for the
		 * corresponding ViewMediator's view. This allows us to listen for events
		 * and set data bindings on the view with the confidence that our view
		 * and all of it's child views have been created and live on the stage.
		 */
		override protected function init():void {
			super.init();  
			view.correctionBack.visible = false;
			if( currentInstance.mapConfig.currentProject ) {
				view.projectNameLabel.text = currentInstance.mapConfig.currentProject.projectName;
				currentInstance.mapConfig.currentVersionPDFFilePathID = 0;
				
				if( !view.priority.dataProvider ) {
					var propPreset:Object = {};
					propPreset.fieldName = 'priority';
					propPreset = propertiespresetsDAO.collection.findExistingPropItem( propPreset, 'fieldName' );
					view.priority.dataProvider = new ArrayList( propPreset.fieldOptionsValue.toString().split( "," ) );
				}
				view.priority.selectedState = Utils.reportLabelFuction( currentInstance.mapConfig.currentProject, 'priority' ); 
				
				if( !_priortyWatcher ) {
					_priortyWatcher = BindingUtils.bindSetter( onPriortyChange, view.priority, 'selectedState', false, true );
				}
				else {
					_priortyWatcher.reset( view.priority );
				}
				
				ProcessUtil.existFileSelection = false;
				
				if( currentInstance.mapConfig.currentTasks ) {
					if( currentInstance.mapConfig.currentTasks.previousTask ) {
						if(currentInstance.mapConfig.currentTasks.previousTask.fileObj ) {
							ProcessUtil.existFileSelection = true;
							currentInstance.mapConfig.currentVersionPDFFilePathID = currentInstance.mapConfig.currentTasks.previousTask.fileObj.fileId;
						}
					}
				}
				else if( currentInstance.mapConfig.currentProject.finalTask ) {
					if( currentInstance.mapConfig.currentProject.finalTask.previousTask ) {
						if( currentInstance.mapConfig.currentProject.finalTask.previousTask.fileObj ) {
							ProcessUtil.existFileSelection = true;
							currentInstance.mapConfig.currentVersionPDFFilePathID = currentInstance.mapConfig.currentProject.finalTask.previousTask.fileObj.fileId;
						}
					}
				}
				menuAc = new ArrayList();
				if( mainViewMediator.view.currentState == Utils.CORRECTION_INDEX ) {
					menuAc.addItem( { generalLabel:Utils.PROJECT_CORRECTION } );
				}
				if( mainViewMediator.view.currentState == Utils.PROJECTCORRECTION_INDEX ) {
					menuAc.addItem( { generalLabel:Utils.PROJECT_CORRECTIONREQUEST } );
				}
				menuAc.addItem( { generalLabel:Utils.PROJECT_GENERAL } );
				menuAc.addItem( { generalLabel:Utils.PROJECT_NOTE } );
				menuAc.addItem( { generalLabel:Utils.PROJECT_FILE } );
				menuAc.addItem( { generalLabel:Utils.PROJECT_MAIL, generalIcon:mailclass } );
				view.projectTab.dataProvider = menuAc; 
				view.projectTab.selectedIndex = 0;
			}
		}  
		
		override protected function serviceResultHandler( obj:Object, signal:SignalVO ):void {  
		}
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
			view.projectTab.addEventListener( IndexChangeEvent.CHANGE, onProjectViewChange );
		}
		
		private function backToCorrection( event:MouseEvent ):void {
			controlSignal.changeStateSignal.dispatch( Utils.CORRECTION_INDEX );
		}
		
		
		[ControlSignal(type='changeStateSignal')]
		public function setBackButton( state:String ):void {
			if( ( state == Utils.PROJECTCORRECTION_INDEX ) && ( view.projectTab.dataProvider.getItemAt(0).generalLabel == Utils.PROJECT_CORRECTION  ) ) {
				view.correctionBack.visible = true;
				view.correctionBack.addEventListener( MouseEvent.CLICK, backToCorrection );
			}
		}
		
		private function onProjectViewChange( event:IndexChangeEvent ):void {
			view.correctionBack.visible = false;
			switch( event.currentTarget.selectedItem.generalLabel ) {
				case Utils.PROJECT_GENERAL:
					controlSignal.changeStateSignal.dispatch( Utils.GENERAL_INDEX );
					break;
				case Utils.PROJECT_NOTE:
					controlSignal.changeStateSignal.dispatch( Utils.NOTES_INDEX );
					break;
				case Utils.PROJECT_FILE:
					controlSignal.changeStateSignal.dispatch( Utils.FILE_INDEX );
					break;
				case Utils.PROJECT_MAIL:
					controlSignal.changeStateSignal.dispatch( Utils.MAIL_INDEX );
					break;
				case Utils.PROJECT_CORRECTION:
					controlSignal.changeStateSignal.dispatch( Utils.CORRECTION_INDEX );
					break;
				case Utils.PROJECT_CORRECTIONREQUEST: 
					controlSignal.changeStateSignal.dispatch( Utils.PROJECTCORRECTION_INDEX );
					break;
			}
		} 
		
		private function onPriortyChange( priority:String ):void {
			var index:int = view.priority.selectedIndex;
			var propPreset:Object = {};
			propPreset.fieldName = 'priority';
			propPreset = propertiespresetsDAO.collection.findExistingPropItem( propPreset, 'fieldName' );
			controlSignal.bulkUpdatePrjPropertiesSignal.dispatch( null, currentInstance.mapConfig.currentProject.projectId, propPreset.propertyPresetId.toString(), index.toString(), 0, '' );
		}
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			if( _priortyWatcher ) {
				_priortyWatcher.unwatch();
			}
			super.cleanup( event ); 		
		} 
	}
}
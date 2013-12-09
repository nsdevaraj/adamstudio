package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.AbstractVO;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Domains;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Sprints;
	import com.adams.scrum.models.vo.Stories;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.BurnDownSkinView;
	import com.adams.scrum.views.DomainSkinView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.events.CloseEvent;
	
	public class BurnDownMediator extends AbstractViewMediator
	{
		[Inject]
		public var currentInstance:CurrentInstance;
		
		/**
		 * Constructor.
		 */
		public function BurnDownMediator( viewType:Class = null )
		{
			super( BurnDownSkinView );
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():BurnDownSkinView {
			return _view as BurnDownSkinView;
		}
		
		[MediateView( "BurnDownSkinView" )]
		override public function setView( value:Object ):void { 
			super.setView( value );	
		}
		
		private var _productOpenState:String;
		
		/**
		 * Getter setter functions to store the current state, thus to manage the in case of opening 
		 * the currentView again using the state the init is called by eventHandler set 
		 * which was removed by cleanup at very first showup instance
		 */		
		public function get productOpenState():String {
			return _productOpenState;
		}
		
		public function set productOpenState( value:String ):void {
			_productOpenState = value;
			if( value == Utils.BURNDOWNSTATE ) {
				addEventListener( Event.ADDED_TO_STAGE, addedtoStage );	
			}
		}
		
		protected function addedtoStage( event:Event ):void {
			init();
		}
		
		/**
		 * The <code>init()</code> method is fired off automatically by the 
		 * AbstractViewMediator when the creation complete event fires for the
		 * corresponding ViewMediator's view. This allows us to listen for events
		 * and set data bindings on the view with the confidence that our view
		 * and all of it's child views have been created and live on the stage.
		 * the form values were assigned
		 */
		override protected function init():void {
			super.init();
			viewState = Utils.BURNDOWNSTATE;
			view.bdChart.dataProvider = makeChartProvider( currentInstance.currentProducts );
			//view.legend.dataProvider = view.bdChart;  
		}
		
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			view.containerWindow.addEventListener( CloseEvent.CLOSE, onTileClose );
		}
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			super.cleanup( event ); 
			if( hasEventListener( Event.ADDED_TO_STAGE ) ) {
				removeEventListener( Event.ADDED_TO_STAGE,addedtoStage );	
			}
		}
		
		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */
		override protected function gcCleanup( event:Event ):void {
			if( viewState != Utils.DOMAINSTATE ) {
				cleanup( event );	
			}
		}
		
		private function onTileClose( event:CloseEvent ):void {
			currentInstance.productOpenState = Utils.BASICSTATE;
		}
		
		private function makeChartProvider( currentProduct:Products ):ArrayCollection {
			var chartProvider:ArrayCollection = new ArrayCollection();
			for each( var sprint:Sprints in currentProduct.sprintCollection ) {
				var chartObject:Object = {};
				chartObject.label = sprint.sprintLabel;
				chartObject.sprintId = sprint.sprintId;
				chartObject.totalEstimation = Utils.headingTotalStoryEstimated( GetVOUtil.sortArrayCollection( Utils.STORYKEY, ( sprint.storySet ) ) );
				chartObject.totalDone = Utils.headingTotalStoryDone( GetVOUtil.sortArrayCollection( Utils.STORYKEY, ( sprint.storySet ) ) );	
				chartObject.totalBalance = Utils.totalStoryRemainingTime( chartObject.totalEstimation, chartObject.totalDone );
				chartProvider.addItem( chartObject );
			}
			GetVOUtil.sortArrayCollection( Utils.SPRINTKEY, chartProvider );
			return chartProvider;
		}
	}
}
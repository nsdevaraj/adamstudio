package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Domains;
	import com.adams.scrum.models.vo.Events;
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.models.vo.PushMessage;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Status;
	import com.adams.scrum.models.vo.Tasks;
	import com.adams.scrum.models.vo.Themes;
	import com.adams.scrum.models.vo.Versions; 
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.HistorySkinView;
	import com.adams.scrum.views.ProductSkinView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
 	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
		
	public class HistoryViewMediator extends AbstractViewMediator
	{
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject("eventDAO")]
		public var eventDAO:AbstractDAO;
		
		private var domainsArr:ArrayCollection;
		private var productsArr:ArrayCollection;
		private var sprintArr:ArrayCollection;
		private var versionArr:ArrayCollection;
		private var themeArr:ArrayCollection;
		private var storyArr:ArrayCollection;
		private var taskArr:ArrayCollection;
		private var ticketArr:ArrayCollection;
		private var teamArr:ArrayCollection;
		private var teamMemberArr:ArrayCollection;
		/**
		 * Constructor.
		 */
		public function HistoryViewMediator(viewType:Class=null)
		{
			super(HistorySkinView); 
		} 
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():HistorySkinView
		{
			return _view as HistorySkinView;
		}
		
		[MediateView( "HistorySkinView" )]
		override public function setView(value:Object):void
		{ 
			super.setView(value);	
		}
		
		/**
		 * The <code>init()</code> method is fired off automatically by the 
		 * AbstractViewMediator when the creation complete event fires for the
		 * corresponding ViewMediator's view. This allows us to listen for events
		 * and set data bindings on the view with the confidence that our view
		 * and all of it's child views have been created and live on the stage.
		 */
		private var myDataGrid:DataGrid;
		override protected function init():void
		{
			super.init(); 
			currentInstance.mainViewStackIndex = Utils.HISTORY_INDEX;
						
			if( !eventDAO.collection.findAll ) {
				var eventSignal:SignalVO = new SignalVO(this,eventDAO,Action.GET_LIST); 
				signalSeq.addSignal(eventSignal); 
			} 
			var eventsArray:Array = getEventCatagories(ArrayCollection(eventDAO.collection.items));
			var filteredArr:Array = eventsArray.filter(removedDuplicates);
			for( var i:Number = 0; i < filteredArr.length; i++ ){
				switch(filteredArr[i].data)
				{
					case Utils.DOMAIN_EVENT:
						view.eventsAccordion.addChild(listEvents(filteredArr[i].data,domainsArr));
					break;
					case Utils.PRODUCT_EVENT:
						view.eventsAccordion.addChild(listEvents(filteredArr[i].data,productsArr));
					break;
					case Utils.SPRINT_EVENT:
						view.eventsAccordion.addChild(listEvents(filteredArr[i].data,sprintArr));
					break;
					case Utils.VERSION_EVENT:
						view.eventsAccordion.addChild(listEvents(filteredArr[i].data,versionArr));
					break;
					case Utils.THEME_EVENT:
						view.eventsAccordion.addChild(listEvents(filteredArr[i].data,themeArr));
					break;
					case Utils.STORY_EVENT:
						view.eventsAccordion.addChild(listEvents(filteredArr[i].data,storyArr));
					break;
					case Utils.TASK_EVENT:
						view.eventsAccordion.addChild(listEvents(filteredArr[i].data,taskArr));
					break;			
					case Utils.TICKET_EVENT:
						view.eventsAccordion.addChild(listEvents(filteredArr[i].data,ticketArr));
					break;
					case Utils.TEAM_EVENT:
						view.eventsAccordion.addChild(listEvents(filteredArr[i].data,teamArr));
					break;
					case Utils.TEAMMEMBER_EVENT:
						view.eventsAccordion.addChild(listEvents(filteredArr[i].data,teamMemberArr));
					break;
				}
			}
		}
		private function listEvents(title:String,arrColletion:ArrayCollection):VBox{
			var vbox:VBox = new VBox();
			vbox.label = title;
			vbox.percentWidth = 100;
			vbox.percentHeight = 100;
			var myDataGrid:DataGrid = new DataGrid();
			myDataGrid.percentWidth=100;
			myDataGrid.percentHeight=100;
			var col1:DataGridColumn=new DataGridColumn("eventId")
			var col2:DataGridColumn=new DataGridColumn("eventLabel")
			var col3:DataGridColumn=new DataGridColumn("eventDate")
			var col4:DataGridColumn=new DataGridColumn("eventStatusFk")
			var col5:DataGridColumn=new DataGridColumn("personFk")
			var col6:DataGridColumn=new DataGridColumn("taskFk")
			var col7:DataGridColumn=new DataGridColumn("productFk")
			var col8:DataGridColumn=new DataGridColumn("storyFk")
			var col9:DataGridColumn=new DataGridColumn("sprintFk")
			var col10:DataGridColumn=new DataGridColumn("ticketFk")
				
			var columnsArr:Array=[col1,col2,col3,col4,col5,col6,col7,col8,col9,col10]
			myDataGrid.columns=columnsArr;
			myDataGrid.dataProvider=arrColletion;
			vbox.addChild(myDataGrid);	
			return vbox;
		}

		private  function getEventCatagories(eventArray:ArrayCollection):Array{
			var arr:Array = [];
			domainsArr=new ArrayCollection();
			productsArr=new ArrayCollection();
			sprintArr=new ArrayCollection();
			versionArr=new ArrayCollection();
			themeArr=new ArrayCollection();
			storyArr=new ArrayCollection();
			taskArr=new ArrayCollection();
			ticketArr=new ArrayCollection();
			teamArr=new ArrayCollection();
			teamMemberArr=new ArrayCollection();
			for each(var obj:Events in eventArray)
			{
				if(obj.eventStatusFk==Utils.eventStatusDomainCreate || obj.eventStatusFk==Utils.eventStatusDomainUpdate || obj.eventStatusFk==Utils.eventStatusDomainDelete )
				{
					arr.push({data:Utils.DOMAIN_EVENT});
					domainsArr.addItem(obj);
					
				}else if(obj.eventStatusFk==Utils.eventStatusProductCreate || obj.eventStatusFk==Utils.eventStatusProductUpdate || obj.eventStatusFk==Utils.eventStatusProductDelete)
				{
					arr.push({data:Utils.PRODUCT_EVENT});
					productsArr.addItem(obj);
				}else if(obj.eventStatusFk==Utils.eventStatusSprintCreate || obj.eventStatusFk==Utils.eventStatusSprintUpdate || obj.eventStatusFk==Utils.eventStatusSprintDelete)
				{
					arr.push({data:Utils.SPRINT_EVENT});
					sprintArr.addItem(obj);
				}else if(obj.eventStatusFk==Utils.eventStatusVersionCreate || obj.eventStatusFk==Utils.eventStatusVersionUpdate || obj.eventStatusFk==Utils.eventStatusVersionDelete)
				{
					arr.push({data:Utils.VERSION_EVENT});
					versionArr.addItem(obj);
				}
				else if(obj.eventStatusFk==Utils.eventStatusThemeCreate || obj.eventStatusFk==Utils.eventStatusThemeUpdate || obj.eventStatusFk==Utils.eventStatusThemeDelete)
				{
					arr.push({data:Utils.THEME_EVENT});
					themeArr.addItem(obj);
				}				
				else if(obj.eventStatusFk==Utils.eventStatusStoryCreate || obj.eventStatusFk==Utils.eventStatusStoryUpdate || obj.eventStatusFk==Utils.eventStatusStoryDelete)
				{
					arr.push({data:Utils.STORY_EVENT});
					storyArr.addItem(obj);
				}
				else if(obj.eventStatusFk==Utils.eventStatusTaskCreate || obj.eventStatusFk==Utils.eventStatusTaskUpdate || obj.eventStatusFk==Utils.eventStatusTaskDelete)
				{
					arr.push({data:Utils.TASK_EVENT});
					taskArr.addItem(obj);
				}
				else if(obj.eventStatusFk==Utils.eventStatusTicketCreate || obj.eventStatusFk==Utils.eventStatusTicketUpdate || obj.eventStatusFk==Utils.eventStatusTicketDelete)
				{
					arr.push({data:Utils.TICKET_EVENT});
					ticketArr.addItem(obj);
				}				
				else if(obj.eventStatusFk==Utils.eventStatusTeamCreate || obj.eventStatusFk==Utils.eventStatusTeamUpdate || obj.eventStatusFk==Utils.eventStatusTeamDelete)
				{
					arr.push({data:Utils.TEAM_EVENT});
					teamArr.addItem(obj);
				}
				else if(obj.eventStatusFk==Utils.eventStatusTeamMemberCreate || obj.eventStatusFk==Utils.eventStatusTeamMemberUpdate || obj.eventStatusFk==Utils.eventStatusTeamMemberDelete)
				{
					arr.push({data:Utils.TEAMMEMBER_EVENT});
					teamMemberArr.addItem(obj);
				}
			}
			return arr;
		}
		private var keys:Object = {};
		private function removedDuplicates(item:Object, idx:uint, arr:Array):Boolean {
			if (keys.hasOwnProperty(item.data)) {
				return false;
			} else {
				keys[item.data] = item;
				return true;
			}
		}
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners();   
			view.splPanel.panelSignal.add( closedPanel ); 
		} 
		
		private function closedPanel():void{
			cleanup(null);
			currentInstance.mainViewStackIndex= Utils.HOME_INDEX;
		}
		private var _mainViewStackIndex:int
		public function get mainViewStackIndex():int
		{
			return _mainViewStackIndex;
		}
		
		public function set mainViewStackIndex(value:int):void
		{
			_mainViewStackIndex = value;
			/*if(value == Utils.HISTORY_INDEX){
				init();
			}*/
		}
		private var _historyOpenState:String = new String();
		public function get historyOpenState():String
		{
			return _historyOpenState;
		}
		//@TODO
		public function set historyOpenState(value:String):void
		{
			_historyOpenState = value;			
		}	 
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void
		{
			super.cleanup(event);
		}

		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */
		override protected function gcCleanup( event:Event ):void
		{
			if(viewState!= Utils.PRODUCT_STATUS)cleanup(event);
		}
	}
}
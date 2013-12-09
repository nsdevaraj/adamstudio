package com.adams.scrum.views.mediators
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.AbstractVO;
	import com.adams.scrum.models.vo.Companies;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.PushMessage;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.response.SignalSequence;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.Description;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.ObjectUtils;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.CompanySkinView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;

	public class CompanyViewMediator extends AbstractViewMediator
	{
		[Inject]
		public var currentInstance:CurrentInstance;
		
		[Inject("companyDAO")]
		public var companyDAO:AbstractDAO;
		
		public var changeTeamViewSignal:Signal = new Signal();
		
		/**
		 * the object contains the binded values assigned to 
		 * person properties from the view's form using formProcessor
		 */			 	
		[Form(form="view.companyForm")]
		public var companyObj:Object;
		
		
		/**
		 * Constructor.
		 */
		public function CompanyViewMediator(viewType:Class = null)
		{
			super(CompanySkinView);
		} 
		
		private var _editable:Boolean;
		public function get editable():Boolean
		{
			return _editable;
		}
		
		/**
		 * the editable property to set the purpose of this double purpose
		 * form intended for both edit or create new object
		 * thus, with editable true the form used for edit otherwise for creation of new object
		 */		
		public function set editable(value:Boolean):void
		{
			_editable = value;
			view.companyCreateBtn.visible = !_editable;
			view.companyEditBtn.includeInLayout = _editable;
			view.companyEditBtn.visible= _editable;
			showData();
		}
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():CompanySkinView
		{
			return _view as CompanySkinView;
		}
		
		[MediateView( "CompanySkinView" )]
		override public function setView(value:Object):void
		{ 
			super.setView(value);	
		}
		
		/**
		 * set the Companies Object when the ueser changed the person from the 
		 * combo box for Edit.
		 */
		private var _selectedCompany:Companies;
		public function get selectedCompany():Companies
		{
			return _selectedCompany;
		}

		public function set selectedCompany(value:Companies):void
		{
			_selectedCompany = value;
			
		} 
		
		/**
		 * The <code>init()</code> method is fired off automatically by the 
		 * AbstractViewMediator when the creation complete event fires for the
		 * corresponding ViewMediator's view. This allows us to listen for events
		 * and set data bindings on the view with the confidence that our view
		 * and all of it's child views have been created and live on the stage.
		 */
		override protected function init():void
		{
			super.init();  	 
			viewState = Utils.COMPANYVIEW;
			showData();
		}
		/**
		 * used to Show/reset the Field when User Clicked 
		 * the edit and Create Button.
		 */
		public function showData() :void
		{
			if(editable == false){
				resetForm();
			}else {
				ObjectUtils.setUpForm(_selectedCompany,view.companyForm);
			}
		}
		public function resetForm():void{
			view.companyname.text = "";
			view.companycode.text = "";
			view.companyCategory.text = "";
			view.companyAddress.text = "";
			view.companyPostalCode.text = "";
			view.companyCountry.text = "";
			view.companyPhone.text = "";
		}
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void
		{
			super.setViewListeners();
			view.companyCreateBtn.clicked.add( companyBtnHandler );
			view.companyEditBtn.clicked.add( companyBtnHandler );
			view.companyCancelBtn.clicked.add( companyBtnHandler );

		}
		
		/**
		 * handler for both edit,create and cancel buttons
		 * invokes respective functions
		 */
		private function companyBtnHandler( eve:MouseEvent ):void{
			if( eve.currentTarget == view.companyCreateBtn ){
				createNewCompany();
			}else if( eve.currentTarget == view.companyCancelBtn ){
				changeTeamViewSignal.dispatch(Utils.TEAMSTATE);
			}else if( eve.currentTarget == view.companyEditBtn ){
				editCompany();
			}
		}
		private function createNewCompany():void
		{
			var companySignal:SignalVO = new SignalVO(this,companyDAO,Action.CREATE);
			var newCompanies:Companies = new Companies();
			newCompanies = ObjectUtils.getCastObject(companyObj,newCompanies) as Companies;
			companySignal.valueObject = newCompanies;
			signalSeq.addSignal( companySignal );
		}
		private function editCompany():void
		{
			var editCompanySignal:SignalVO = new SignalVO(this,companyDAO,Action.UPDATE);
			var editCompanies:Companies =  _selectedCompany;
			editCompanies = ObjectUtils.getCastObject(companyObj,editCompanies) as Companies;
			editCompanySignal.valueObject = editCompanies; 
			signalSeq.addSignal( editCompanySignal );
		}
			
		override protected function serviceResultHandler(obj:Object,signal:SignalVO):void {			
			if(signal.destination == companyDAO.destination){
				var addedCompanies:Companies = obj as Companies;
				
				/*var receivers:Array = GetVOUtil.getSprintMembers(currentInstance.currentSprint,currentInstance.currentPerson.personId);
				var pushMessage:PushMessage = new PushMessage( Description.UPDATE, receivers, addedCompanies.companyId );
				var pushSignal:SignalVO = new SignalVO( this, companyDAO, Action.PUSH_MSG, pushMessage );
				signalSeq.addSignal( pushSignal );*/
				
				changeTeamViewSignal.dispatch(Utils.TEAMSTATE);
			}
		}
		
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void
		{
			super.cleanup(event); 
			view.companyCreateBtn.clicked.removeAll();
			view.companyEditBtn.clicked.removeAll();
			view.companyCancelBtn.clicked.removeAll();
		}
		//@TODO

		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */
		override protected function gcCleanup( event:Event ):void
		{
			if(viewState!= Utils.COMPANYVIEW)cleanup(event);
		}
	}
}
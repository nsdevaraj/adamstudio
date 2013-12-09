/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.view.mediators
{ 
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.model.vo.*;
	import com.adams.dt.signal.ControlSignal;
	import com.adams.dt.util.ProcessUtil;
	import com.adams.dt.util.Utils;
	import com.adams.dt.view.MailSkinView;
	import com.adams.dt.view.renderers.MailListRenderer;
	import com.adams.swizdao.dao.PagingDAO;
	import com.adams.swizdao.model.vo.*;
	import com.adams.swizdao.response.SignalSequence;
	import com.adams.swizdao.util.Action;
	import com.adams.swizdao.util.ArrayUtil;
	import com.adams.swizdao.util.Description;
	import com.adams.swizdao.util.EncryptUtil;
	import com.adams.swizdao.util.GetVOUtil;
	import com.adams.swizdao.util.ObjectUtils;
	import com.adams.swizdao.util.StringUtils;
	import com.adams.swizdao.views.components.NativeList;
	import com.adams.swizdao.views.mediators.AbstractViewMediator;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.ClassFactory;
	import mx.events.CollectionEvent;
	

	public class MailViewMediator extends AbstractViewMediator
	{ 		 
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		[Inject]
		public var controlSignal:ControlSignal;
		
		[Inject("personsDAO")]
		public var personDAO:AbstractDAO;
		
		[Inject("profilesDAO")]
		public var profilesDAO:AbstractDAO;
		
		[Bindable]
		public var mailCollection:ArrayCollection = new ArrayCollection();
		
		private var _homeState:String;
		private var _mailperson:Persons;
		private var _urlLinkDetails:String;
		public function get homeState():String
		{
			return _homeState;
		}
		
		public function set homeState(value:String):void
		{
			_homeState = value;
			if(value==Utils.MAIL_INDEX) addEventListener(Event.ADDED_TO_STAGE,addedtoStage);
		}
		[Bindable]
		private var propertyList:IList;
		
		private var _autoViewCollection:ArrayCollection;
		[Bindable]
		public function get autoViewCollection():ArrayCollection
		{
			return _autoViewCollection;
		}
		
		public function set autoViewCollection(value:ArrayCollection):void
		{
			_autoViewCollection = value;
			propertyList = new ArrayList();
			propertyList.addItem( 'personFirstname' );
		}
		
		
		
		protected function addedtoStage(ev:Event):void{
			init();
		}
		     
		/**
		 * Constructor.
		 */
		public function MailViewMediator( viewType:Class=null )
		{
			super( MailSkinView ); 
		}

		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():MailSkinView 	{
			return _view as MailSkinView;
		}
		
		[MediateView( "MailSkinView" )]
		override public function setView( value:Object ):void { 
			super.setView(value);	
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
			viewState = Utils.MAIL_INDEX;
			resetMailForm();
			setDataProviders();
		} 
		protected function resetMailForm():void{
			mailCollection = new ArrayCollection();
			view.autoSearch.text = "";
			view.bodyTxt.text = "";
			findCollectionLength();
		}
		protected function setDataProviders():void {
			view.mailList.dataProvider = mailCollection;
			view.mailList.allowMultipleSelection = false;
			view.mailList.itemRenderer = new ClassFactory(MailListRenderer);
			
			autoViewCollection = ArrayCollection( personDAO.collection.items );
		
			view.autoSearch.dataProvider = autoViewCollection;
			view.autoSearch.labelField = "personFirstname";
			mailCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE, findCollectionLength );
			
			
		}
		
		public function updateMailProvider ( personObj:Object ):void{
			if( personObj ) {
				if( mailCollection.getItemIndex( personObj ) == -1 )  {
					mailCollection.addItem( personObj );
				}
			}
		}
		
		public function findCollectionLength( event:CollectionEvent=null ):void
		{
			(mailCollection.length>0)?view.sendMailBtn.enabled = true:view.sendMailBtn.enabled = false;
		}
		
		override protected function setRenderers():void {
			super.setRenderers();  
		} 
 
		override protected function serviceResultHandler( obj:Object,signal:SignalVO ):void {  
			if( signal.action == Action.CREATE && signal.destination == Utils.TASKSKEY ){
				var createdTask:Tasks  = obj as Tasks;
				if( createdTask.deadlineTime == 0 && signal.emailBody == Utils.SEND_EMAIL ) {
					var userId:String = StringUtils.replace( escape( EncryptUtil.encrypt( _mailperson.personLogin ) ), '+', '%2B' );
					var password:String = StringUtils.replace( escape( EncryptUtil.encrypt( _mailperson.personPassword ) ), '+', '%2B' );
					_urlLinkDetails = currentInstance.config.serverLocation + "ExternalMail/Limoges.html?type=All%23ampuser=" + userId + "%23amppass=" + password + "%23amptaskId=" + createdTask.taskId + "%23ampprojId=" + createdTask.projectObject.projectId;
					controlSignal.sendEmailSignal.dispatch( this , _mailperson.personEmail, view.bodyTxt.text , _urlLinkDetails );
					
				}
			} 
		}
 		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
			view.sendMailBtn.clicked.add(sendMailHandler);
			view.autoSearch.selectedSignal.add( updateMailProvider );
		}
		
		protected function sendMailHandler( event : MouseEvent ):void {
			controlSignal.showAlertSignal.dispatch( this, Utils.SENDMAIL_MESSAGE, Utils.APPTITLE, 0, Utils.SENDMAIL_MESSAGE );
		}
		
		override public function alertReceiveHandler( obj:Object ):void {
			var messageStatus:String;
			if( obj == Utils.SENDMAIL_MESSAGE ) {
				var subject:String = '';
				for each( var mailPerson:Persons in mailCollection ) {
					_mailperson = mailPerson;
					var mailTaskData:Tasks = new Tasks();
					mailTaskData.taskId = NaN;
					mailTaskData.projectFk = currentInstance.mapConfig.currentProject.projectId;
					mailTaskData.projectObject = currentInstance.mapConfig.currentProject;
					mailTaskData.deadlineTime = 0;
					mailTaskData.personFK  = mailPerson.personId;
					mailTaskData.domainDetails = currentInstance.mapConfig.currentProject.categories.categoryFK.categoryFK;
					mailTaskData.taskFilesPath = currentInstance.mapConfig.currentPerson.personId+","+currentInstance.mapConfig.currentPerson.defaultProfile;
					var by:ByteArray = new ByteArray();
					var str:String = _mailperson.personFirstname+Utils.SEPERATOR+view.bodyTxt.text+
						Utils.SEPERATOR+currentInstance.mapConfig.currentPerson.personId+","+currentInstance.mapConfig.currentPerson.defaultProfile;
					by.writeUTFBytes( str );
					mailTaskData.taskComment = by;
					var status:Status = new Status();
					status.statusId = TaskStatus.WAITING;
					mailTaskData.taskStatusFK= status.statusId;
					mailTaskData.tDateCreation = new Date();
					var toPersonProfile:Profiles = GetVOUtil.getVOObject( mailPerson.defaultProfile, profilesDAO.collection.items, profilesDAO.destination, Profiles ) as Profiles;
					mailTaskData.wftFK = ProcessUtil.getMessageTemplate( toPersonProfile.profileCode, currentInstance.mapConfig.messageTemplatesCollection ).workflowTemplateId;
					mailTaskData.tDateEndEstimated = new Date(); 
					mailTaskData.onairTime = 0;
					var message:String = "Messieurs,<div><div><br></div><div>Nous sommes en charge de la photogravure de la reference citee en objet.</div><div>Merci de bien vouloir consulter et valider le process technique en cliquant le lien suivant :</div><div><br></div><div><a href=";
					var postmessage:String  = "</div><div><br></div><div>Vous y trouverez le fichier PDF agence dans l'onglet 'Files'.</div><div>Nous realiserons les photogravures sur reception de votre validation en ligne.</div><div>Merci de votre collaboration.</div><div><br></div></div>";
					controlSignal.createTaskSignal.dispatch( this, mailTaskData , Utils.SEND_EMAIL);
				}
				resetMailForm();
			}
		}
			
			
 		override protected function pushResultHandler( signal:SignalVO ): void { 
		} 
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			super.cleanup( event ); 		
		} 
	}
}
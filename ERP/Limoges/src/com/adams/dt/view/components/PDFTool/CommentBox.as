package com.adams.dt.view.components.PDFTool
{
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.model.vo.CommentVO;
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.util.ProcessUtil;
	import com.adams.swizdao.model.vo.CurrentInstance;
	import com.adams.swizdao.util.GetVOUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.graphics.SolidColor;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.NumericStepper;
	import spark.components.TextArea;
	import spark.components.TextInput;
	import spark.components.VGroup;
	import spark.primitives.Rect;
	
	[Event(name="commentBoxMove", type="flash.events.Event")]
	[Event(name="commentAdd", type="flash.events.Event")]
	[Event(name="commentUpdate", type="flash.events.Event")]
	[Event(name="commentCancel", type="flash.events.Event")]
	[Event(name="commentRemove", type="flash.events.Event")]
	public class CommentBox extends Group
	{
		
		[Inject("personsDAO")]
		public var personsDAO:AbstractDAO;
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		public static const COMMENT_BOX_MOVE:String = "commentBoxMove";
		
		public static const COMMENT_REMOVE:String  = "commentRemove";
		public static const COMMENT_CANCEL:String  = "commentCancel";
		public static const COMMENT_ADD:String  = "commentAdd";
		public static const COMMENT_UPDATE:String  = "commentUpdate";
		
		public static const SHAPE_FIRST_NOTE_SPLITTER:String = "*@**"
		
		private var vGroup:VGroup;
		
		private var titleHGroup:HGroup;
		
		private var minMaxBtn:Button;
		
		private var titleTxt:TextInput;
		private var descriptionTxt:TextArea;
		
		private var saveEditBtn:Button;
		private var cancelRemoveBtn:Button;
		
		private var totalCommentsLbl:Label;
		private var historyNumStepper:NumericStepper;
		
		private var createdByAndDateLbl:Label;
		
		private var _historyCollection:ArrayCollection = new ArrayCollection();
		public function get historyCollection():ArrayCollection
		{
			return _historyCollection;
		}
		
		[Bindable]
		public function set historyCollection(value:ArrayCollection):void
		{
			_historyCollection = value;
		}
		
		private var _currentPersonID:int = 0;
		public function get currentPersonID():int
		{
			return _currentPersonID;
		}
		
		[Bindable]
		public function set currentPersonID(value:int):void
		{
			_currentPersonID = value;
		}
		
		
		private var hGroup:HGroup;
		
		private var rectBackground:Rect;
		
		private var _commentItemName:String = "";
		public function get commentItemName():String
		{
			return _commentItemName;
		}
		
		[Bindable]
		public function set commentItemName(value:String):void
		{
			_commentItemName = value;
		}
		
		
		private var _commentMode:Boolean = false;
		public function get commentMode():Boolean
		{
			return _commentMode;
		}
		
		[Bindable]
		public function set commentMode(value:Boolean):void
		{
			_commentMode = value;
			if(value)
			{
				if(descriptionTxt && titleTxt && saveEditBtn && cancelRemoveBtn)
				{
					descriptionTxt.enabled = true;
					titleTxt.enabled = true;
					var id:int = (historyCollection.getItemAt(historyCollection.length-1) as CommentVO).createdby;
					if(currentPersonID == id){
						saveEditBtn.label = "Update";
						cancelRemoveBtn.label = "Cancel";
					}else
					{
						descriptionTxt.text = "";
						titleTxt.text = "";
						var person:Persons = Persons(currentInstance.mapConfig.currentPerson);
						var creationDate:String = (commentVO.creationDate)?commentVO.creationDate.toString():(new Date()).toString();
						createdByAndDateLbl.text = "- "+person.personFirstname+" "+person.personLastname+", "+creationDate.split(" ")[2]+" "+creationDate.split(" ")[1]+" "+creationDate.split(" ")[5];
						saveEditBtn.label = "Save";
						cancelRemoveBtn.label = "Cancel";
						cancelRemoveBtn.visible = true;
						isChatNewComment = true;
					}
				}
			}else
			{
				if(descriptionTxt && titleTxt && saveEditBtn && cancelRemoveBtn)
				{
					descriptionTxt.enabled = false;
					titleTxt.enabled = false;
					saveEditBtn.label = "Edit";
					cancelRemoveBtn.label = "Remove";
					isChatNewComment = false;
					updateFieldValue();
				}
			}
		}
		
		private var _isChatNewComment:Boolean = false;
		public function get isChatNewComment():Boolean
		{
			return _isChatNewComment;
		}
		
		[Bindable]
		public function set isChatNewComment(value:Boolean):void
		{
			_isChatNewComment = value;
		}
		
		
		private var _isNewComment:Boolean = false;
		public function get isNewComment():Boolean
		{
			return _isNewComment;
		}
		
		[Bindable]
		public function set isNewComment(value:Boolean):void
		{
			_isNewComment = value;
			commentMode = isNewComment;
		}
		
		private var _isInCommentList:Boolean = false;
		public function get isInCommentList():Boolean
		{
			return _isInCommentList;
		}
		
		[Bindable]
		public function set isInCommentList(value:Boolean):void
		{
			_isInCommentList = value;
		}
		
		
		private var _sealed:Boolean = true;
		public function get sealed():Boolean
		{
			return _sealed;
		}
		
		[Bindable]
		public function set sealed(value:Boolean):void
		{
			_sealed = value;
		}
		
		
		private var _title:String = "";
		public function get title():String
		{
			return _title;
		}
		
		[Bindable]
		public function set title(value:String):void
		{
			_title = value;
			if(titleTxt){
				titleTxt.text = _title;
			}
		}
		
		private var _description:String = "";
		public function get description():String
		{
			return _description;
		}
		
		[Bindable]
		public function set description(value:String):void
		{
			_description = value;
			if(descriptionTxt){
				descriptionTxt.text = _description;
			}
		}
		
		private var totalHistory:int = 0;
		
		private var _commentVO:CommentVO;
		public function get commentVO():CommentVO
		{
			return _commentVO;
		}
		
		[Bindable]
		public function set commentVO(value:CommentVO):void
		{
			_commentVO = value;
		}
		
		private var _chatCommentVO:CommentVO;
		public function get chatCommentVO():CommentVO
		{
			return _chatCommentVO;
		}

		[Bindable]
		public function set chatCommentVO(value:CommentVO):void
		{
			_chatCommentVO = value;
		}

		
		public function CommentBox()
		{
			super();
			
			
			commentVO = new CommentVO();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			width = 230;
			height = 150;
			this.clipAndEnableScrolling = true;
			if(!rectBackground)
			{
				rectBackground = new Rect();
				var solidColor:SolidColor = new SolidColor(0,0.75);
				rectBackground.fill = solidColor;
				rectBackground.percentWidth = 100;
				rectBackground.percentHeight = 100;
				addElement(rectBackground);
			}
			
			if(!vGroup)
			{
				vGroup = new VGroup();
				vGroup.left = 5;
				vGroup.right = 5;
				vGroup.top = 5;
				vGroup.bottom = 5;
				vGroup.percentWidth = 100;
				vGroup.percentHeight = 100;
				addElement(vGroup);
			}
			
			//minMaxBtn titleHGroup
			
			if(!titleHGroup)
			{
				titleHGroup = new HGroup();
				titleHGroup.percentWidth = 100;
				vGroup.addElement(titleHGroup);
			}
			
			if(!minMaxBtn)
			{
				minMaxBtn = new Button();
				minMaxBtn.label = "-"
				minMaxBtn.setStyle("fontSize","10");
				minMaxBtn.width = minMaxBtn.height = 25;
				minMaxBtn.visible = !_isInCommentList;
				minMaxBtn.includeInLayout = !_isInCommentList;
				titleHGroup.addElement(minMaxBtn);
			}
			
			if(!titleTxt)
			{
				titleTxt = new TextInput();
				titleTxt.percentWidth = 100;
				titleTxt.setStyle("color","#ececec");
				titleTxt.enabled = isNewComment;
				titleHGroup.addElement(titleTxt);
				titleTxt.text = _title;
			}
			
			if(!descriptionTxt)
			{
				descriptionTxt = new TextArea();
				descriptionTxt.percentWidth = 100;
				descriptionTxt.percentHeight = 100;
				descriptionTxt.setStyle("color","#ececec");
				descriptionTxt.enabled = isNewComment;
				vGroup.addElement(descriptionTxt);
				descriptionTxt.text = _description;
			}
			
			if(!createdByAndDateLbl)
			{
				createdByAndDateLbl = new Label();
				createdByAndDateLbl.setStyle("color","#cccccc");
				var person:Persons = (commentVO.createdby!=0)?(GetVOUtil.getVOObject( commentVO.createdby, personsDAO.collection.items, personsDAO.destination, Persons ) as Persons):Persons(currentInstance.mapConfig.currentPerson);
				var creationDate:String = (commentVO.creationDate)?commentVO.creationDate.toString():(new Date()).toString();
				createdByAndDateLbl.text = "- "+person.personFirstname+" "+person.personLastname+", "+creationDate.split(" ")[2]+" "+creationDate.split(" ")[1]+" "+creationDate.split(" ")[5];
				vGroup.addElement(createdByAndDateLbl);
			}
			
			if(!hGroup)
			{
				hGroup = new HGroup();
				hGroup.clipAndEnableScrolling = true;
				vGroup.addElement(hGroup);
				hGroup.verticalAlign = "middle";
			}
			
			if(!historyNumStepper)
			{
				historyNumStepper = new NumericStepper();
				hGroup.addElement(historyNumStepper);
				historyNumStepper.minimum = 1;
				historyNumStepper.maximum=historyCollection.length;
				historyNumStepper.value=historyCollection.length;
				
			}
			
			if(!totalCommentsLbl)
			{
				totalCommentsLbl = new Label();
				totalCommentsLbl.height = 10;
				hGroup.addElement(totalCommentsLbl);
				totalCommentsLbl.text = "/ "+historyCollection.length;
			}
			
			if(!saveEditBtn)
			{
				saveEditBtn = new Button();
				saveEditBtn.label = (isNewComment)?"Save":"Edit";
				saveEditBtn.styleName = "commentBoxBtnSkin";
				saveEditBtn.visible = sealed;
				saveEditBtn.focusEnabled = false;
				hGroup.addElement(saveEditBtn);
			}
			
			if(!cancelRemoveBtn)
			{
				cancelRemoveBtn = new Button();
				cancelRemoveBtn.label = (isNewComment)?"Cancel":"Remove";
				cancelRemoveBtn.styleName = "commentBoxBtnSkin";
				cancelRemoveBtn.visible = sealed;
				cancelRemoveBtn.focusEnabled = false;
				hGroup.addElement(cancelRemoveBtn);
			}
			updateFieldValue();
		}
		
		override protected function initializationComplete():void
		{
			super.initializationComplete();
			addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			saveEditBtn.addEventListener(MouseEvent.CLICK, saveEditBtnClickHandler);
			cancelRemoveBtn.addEventListener(MouseEvent.CLICK, cancelRemoveBtnClickHandler);
			historyCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE, historyACChangeHandler);
			minMaxBtn.addEventListener(MouseEvent.CLICK, minMaxBtnClickHandler);
			historyNumStepper.addEventListener(Event.CHANGE, numericStepperChangeHandler);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		protected function historyACChangeHandler(event:CollectionEvent):void
		{
			if(!historyNumStepper){
				updateFieldValue();
			}
		}
		
		public function updateFieldValue():void
		{
			if(historyCollection.length>0){
				totalCommentsLbl.text = "/ "+historyCollection.length;
				historyNumStepper.maximum=historyCollection.length;
				historyNumStepper.value=historyCollection.length;
				totalHistory = historyCollection.length;
				updateDisplay();
			}
		}
		
		private function updateDisplay():void
		{
			titleTxt.text = (historyCollection.getItemAt(historyNumStepper.value-1) as CommentVO).commentTitle;
			descriptionTxt.text = (historyCollection.getItemAt(historyNumStepper.value-1) as CommentVO).commentDescription.toString().split(SHAPE_FIRST_NOTE_SPLITTER)[1];
			var person:Persons = (GetVOUtil.getVOObject( (historyCollection.getItemAt(historyNumStepper.value-1) as CommentVO).createdby, personsDAO.collection.items, personsDAO.destination, Persons ) as Persons);
			var creationDate:String = commentVO.creationDate.toString();
			createdByAndDateLbl.text = "- "+person.personFirstname+" "+person.personLastname+", "+creationDate.split(" ")[2]+" "+creationDate.split(" ")[1]+" "+creationDate.split(" ")[5];
			cancelRemoveBtn.visible = ((currentPersonID == person.personId) && (historyCollection.length == historyNumStepper.value && sealed) || isNewComment)
		}
		
		protected function mouseHandler(event:MouseEvent):void
		{
			if(event.type == MouseEvent.MOUSE_DOWN && !isInCommentList)
			{
				startDrag(false, new Rectangle(0,0,parent.width-width,parent.height-height));
				addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				addEventListener(MouseEvent.MOUSE_MOVE, mouseHandler);
			}
			else if(event.type == MouseEvent.MOUSE_MOVE){
				dispatchEvent(new Event(COMMENT_BOX_MOVE));
			}
			else if(event.type == MouseEvent.MOUSE_UP)
			{
				removeEventListener(MouseEvent.MOUSE_MOVE, mouseHandler);
				removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				stopDrag();
			}
		}
		
		protected function minMaxBtnClickHandler(event:MouseEvent):void
		{
			this.width = (event.currentTarget.label == "-")?35:230;
			this.height = (event.currentTarget.label == "-")?35:150; 
			event.currentTarget.label = (event.currentTarget.label == "-")?"+":"-";
		}
		
		public function expandCollapse(event:MouseEvent):void
		{
			minMaxBtn.label = (event.currentTarget.selected)?"+":"-";
			this.width = (minMaxBtn.label == "+")?35:230;
			this.height = (minMaxBtn.label == "+")?35:150; 
		}
		
		protected function saveEditBtnClickHandler(event:MouseEvent):void
		{
			var desc:String = "";
			if(isNewComment || isChatNewComment){
				if(isNewComment){
					saveEditBtn.label = "Edit";
					cancelRemoveBtn.label = "Remove";
					commentVO.commentTitle = titleTxt.text;
					desc = String(commentVO.commentDescription)+CommentBox.SHAPE_FIRST_NOTE_SPLITTER+descriptionTxt.text;
					commentVO.commentDescription = ProcessUtil.convertToByteArray(desc);
					chatCommentVO  = commentVO;
					this.dispatchEvent(new Event(COMMENT_ADD));
					isNewComment = false;
					commentMode = false;
				}
				else if(isChatNewComment){
					chatCommentVO = new CommentVO();
					chatCommentVO.filefk = commentVO.filefk;
					chatCommentVO.createdby = Persons(currentInstance.mapConfig.currentPerson).personId;
					chatCommentVO.creationDate = new Date();
					chatCommentVO.history = commentVO.commentID;
					chatCommentVO.commentTitle = titleTxt.text;
					desc = commentVO.commentDescription.toString().split(SHAPE_FIRST_NOTE_SPLITTER)[0]+SHAPE_FIRST_NOTE_SPLITTER+descriptionTxt.text;
					chatCommentVO.commentDescription = ProcessUtil.convertToByteArray(desc);
					this.dispatchEvent(new Event(COMMENT_ADD));
					isChatNewComment = false;
					commentMode = false;
					}
			}else if(!isNewComment && commentMode){
				//commentVO.commentTitle = titleTxt.text;
				desc = String(commentVO.commentDescription).split(CommentBox.SHAPE_FIRST_NOTE_SPLITTER)[0]+CommentBox.SHAPE_FIRST_NOTE_SPLITTER+descriptionTxt.text;
				//commentVO.commentDescription = ProcessUtil.convertToByteArray(desc);
				chatCommentVO = CommentVO(historyCollection.getItemAt(historyCollection.length -1));
				chatCommentVO.commentTitle = titleTxt.text;
				chatCommentVO.commentDescription = ProcessUtil.convertToByteArray(desc);
				//updateLastEntry(commentVO, "update");
				this.dispatchEvent(new Event(COMMENT_UPDATE));
				commentMode = false;
			}else{
				commentMode = true;
			}
		}
		
		protected function cancelRemoveBtnClickHandler(event:MouseEvent):void
		{
			if(isNewComment && commentMode){
				// Cancel New Comment creation
				this.dispatchEvent(new Event(COMMENT_CANCEL));
			}
			else if(!isNewComment && !commentMode){
				// Remove Comment
				chatCommentVO = CommentVO(historyCollection.getItemAt(historyCollection.length -1));
				this.dispatchEvent(new Event(COMMENT_REMOVE));
			}
			else if(!isNewComment && commentMode)
			{
				// Cancel Updation 
				commentMode = false;
			}
		}
		
		protected function numericStepperChangeHandler(event:Event):void
		{
			updateDisplay();
		}
		
		public function updateCollection(coll:ArrayCollection):void
		{
			historyCollection = coll;
			updateFieldValue();
		}
		
		public function updateLastEntry(commentVO:CommentVO, action:String):void
		{
			if(action == "add")
			{
				historyCollection.addItem(commentVO);
			}
			else if(action == "update")
			{
				historyCollection.setItemAt(commentVO, historyCollection.length-1);
			}
			updateFieldValue();
		}
	}
}
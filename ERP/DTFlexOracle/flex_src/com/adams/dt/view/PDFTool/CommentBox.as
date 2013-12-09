package com.adams.dt.view.PDFTool
{
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.event.PDFTool.CommentEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.PDFTool.CommentVO;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.NumericStepper;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	import mx.effects.Resize;
	import mx.effects.easing.Circular;
	import mx.events.CollectionEvent;
	import mx.events.EffectEvent;
	import mx.events.NumericStepperEvent;

	[Event(name="commentItemMove", type="flash.events.Event")]
	
	public class CommentBox extends Canvas
	{
		
		[Bindable]
		private var model : ModelLocator = ModelLocator.getInstance();
		
		private var _historyCollection : ArrayCollection = new ArrayCollection();
		public function set historyCollection (value : ArrayCollection) : void
		{
			_historyCollection = value;
		}

		public function get historyCollection () : ArrayCollection
		{
			return _historyCollection;
		} 
		
		public var commentVO:CommentVO = new CommentVO();
		
		private var profileLabel:Label;
		private var titleText:TextInput;
		private var descText:TextArea;
		private var moveCanvas:Canvas;
		private var miniMaxBtn:Button;
		private var editBtn:Button;
		private var deleteBtn:Button;
		private var discussBtn:Button;
		private var historyStepper:NumericStepper;
		private var historyMaxItem:TextInput;
		private var _commentTargetName:String="";
		
		public static const COMMENT_MOVE:String = "commentItemMove";
		
		private var boxWidth:Number = 220;
		private var boxHeight:Number = 150;

		private var resize:Resize = new Resize(this);
		
		private var resizeStatus:Boolean = false;

		[Bindable]
		public function set commentTargetName (value:String):void
		{
			_commentTargetName = value;
		}

		public function get commentTargetName ():String
		{
			return _commentTargetName;
		}

		private var _title:String;
		[Bindable]
		public function set title (value:String):void
		{
			_title = value;
			titleText.text = value;
		}

		public function get title ():String
		{
			return _title;
		}
		
		
		private var _description:String;
		[Bindable]
		public function set description (value:String):void
		{
			_description = value;
			descText.text = value;
		}

		public function get description ():String
		{
			return _description;
		}
		
		
		private var _profile:String;
		[Bindable]
		public function set profile (value:String):void
		{
			_profile = value;
			profileLabel.text = value.toUpperCase().substr(0,3)+" : ";
		}

		public function get profile ():String
		{
			return _profile;
		}

		private var _parentID:int;
		[Bindable]
		public function set parentID (value:int):void
		{
			_parentID = value;
		}

		public function get parentID ():int
		{
			return _parentID;
		}		
		
		
		private var _pdf:Number;
		[Bindable]
		public function set pdf (value:Number):void
		{
			_pdf = value;
			if(value == SinglePageCanvas.PDF1)
			editBtn.visible = deleteBtn.visible = false;
		}
		
		public function get pdf ():Number
		{
			return _pdf;
			
		}
		
		public function CommentBox()
		{
			super();
			
			profileLabel = new Label();
			titleText = new TextInput();
			descText =  new TextArea();
			moveCanvas = new Canvas();
			miniMaxBtn = new Button();
			editBtn = new Button();
			deleteBtn = new Button();
			discussBtn = new Button();
			historyStepper = new NumericStepper();
			historyMaxItem = new TextInput();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			addChild(moveCanvas);
			addChild(titleText);
			addChild(descText);
			addChild(profileLabel);
			addChild(historyMaxItem);
			
			addChild(discussBtn);
			addChild(miniMaxBtn);
			addChild(editBtn);
			addChild(deleteBtn);
			addChild(historyStepper);
			
			titleText.enabled = false;
			descText.enabled = false;
			styleName = "commentBox"; 
			titleText.styleName = "commentBoxTitleStyle";
			
			descText.styleName = "commentBoxDescDisable";
			moveCanvas.styleName = "moveCanvasStyle";
			miniMaxBtn.styleName = "noteMaxMinBtn";
			editBtn.styleName = "noteEditBtn";
			deleteBtn.styleName = "noteDeleteBtn";
			discussBtn.styleName = "noteDiscussBtn";
			historyStepper.styleName = "noteHistoryNumStp";
			
			historyStepper.minimum = 1
			historyStepper.maxChars = 3;
			
			historyMaxItem.styleName = "commentBoxTitleStyle";
			historyMaxItem.setStyle("left","90");
			historyMaxItem.setStyle("top","117");
			historyMaxItem.width = 30;
			historyMaxItem.enabled = false;
			
			
			titleText.setStyle("left","40");
			titleText.setStyle("paddingLeft","40");
			
			titleText.setStyle("right","10");
			
			editBtn.setStyle("top", "115");
			deleteBtn.setStyle("top", "115");
			discussBtn.setStyle("top", "115");
			
			editBtn.setStyle("right", "35");
			deleteBtn.setStyle("right", "10");
			discussBtn.setStyle("left", "10");
			
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
			
			profileLabel.setStyle("top","11");
			profileLabel.setStyle("left","43");
			profileLabel.setStyle("fontWeight","bold");
			profileLabel.setStyle("color","#FFFFFF");
			
			miniMaxBtn.toggle=true;
			
			miniMaxBtn.addEventListener(MouseEvent.CLICK, onMouseClick_MinMax,false,0,true);
			addEventListener(EffectEvent.EFFECT_END, onEffectEnd,false,0,true);
			moveCanvas.addEventListener(MouseEvent.MOUSE_DOWN, onMouseAction,false,0,true);
			
			historyCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE,historyCollectionChange,false,0,true);
			historyStepper.addEventListener(NumericStepperEvent.CHANGE,stepperChange,false,0,true);
			
			setChildIndex(moveCanvas, this.numChildren-5);
			
			editBtn.addEventListener(MouseEvent.CLICK, editSaveMouseClick,false,0,true);
			editBtn.toggle = true;
			
			deleteBtn.addEventListener(MouseEvent.CLICK, deleteMouseClick,false,0,true);
			
			handCursor(miniMaxBtn, "Minimize/Maximize");
			handCursor(editBtn);
			handCursor(deleteBtn, "Delete Comment");
			
			
			resize.easingFunction = Circular.easeInOut;
			resize.duration = 100;
			
			setStyle("resizeEffect",resize);
			
			
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		override protected function measure():void {
            super.measure();

            measuredWidth = measuredMinWidth = boxWidth;
            measuredHeight = measuredMinHeight = boxHeight;
        }
        private function invalidateAction():void{
        	invalidateProperties();
            invalidateSize();
            invalidateDisplayList(); 
        }
        private function historyCollectionChange(event:CollectionEvent):void
        {
       		historyMaxItem.text="/"+historyCollection.length;
			historyStepper.maximum=historyCollection.length;
			historyStepper.value=historyCollection.length;
			title = CommentVO(historyCollection.getItemAt(historyStepper.value-1)).commentTitle;
			description = String(CommentVO(historyCollection.getItemAt(historyStepper.value-1)).commentDescription);
			if(commentVO.commentType == SinglePageCanvas.SHAPE_NOTE_INT && (historyStepper.value-1)==0)
				description = String(CommentVO(historyCollection.getItemAt(historyStepper.value-1)).commentDescription).split(SinglePageCanvas.SHAPE_FIRST_NOTE_SPLITTER)[1];
			profile = CommentVO(historyCollection.getItemAt(historyStepper.value-1)).misc;
			
			editBtn.visible = (pdf == SinglePageCanvas.PDF2);
			deleteBtn.visible = ((pdf == SinglePageCanvas.PDF2 ) && (CommentVO(historyCollection.getItemAt(historyStepper.value-1)).createdby == model.person.personId));
       	}
       	private function stepperChange(event:NumericStepperEvent):void
       	{
       		title = CommentVO(historyCollection.getItemAt(historyStepper.value-1)).commentTitle;
			description = String(CommentVO(historyCollection.getItemAt(historyStepper.value-1)).commentDescription);
			if(commentVO.commentType == SinglePageCanvas.SHAPE_NOTE_INT && (historyStepper.value-1)==0)
				description = String(CommentVO(historyCollection.getItemAt(historyStepper.value-1)).commentDescription).split(SinglePageCanvas.SHAPE_FIRST_NOTE_SPLITTER)[1];
			profile = CommentVO(historyCollection.getItemAt(historyStepper.value-1)).misc;
			
			editBtn.visible = ((historyCollection.length == historyStepper.value) && pdf == SinglePageCanvas.PDF2);
			deleteBtn.visible = ((historyCollection.length == historyStepper.value) && pdf == SinglePageCanvas.PDF2 && (CommentVO(historyCollection.getItemAt(historyStepper.value-1)).createdby == model.person.personId));
       	}
        private function onEffectEnd(event:EffectEvent):void
        {
  			invalidateAction();      	
        }
        public function editFirstTime():void
        {
        	editBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
        	descText.setFocus();
        }
        private function onMouseClick_MinMax(event:MouseEvent):void
      	{
        	if(resizeStatus)
        	{
        		boxWidth = 220;
        		boxHeight = 150;
        	}
        	else{
        		boxWidth = 43;
        		boxHeight = 43;
        	}
        	invalidateAction();
        	resizeStatus = !resizeStatus;
        }
        private function handCursor(comp:UIComponent, tooltip:String="", value:Boolean=true):void
        {
        	comp.useHandCursor = value;
			comp.buttonMode= value;
			comp.toolTip = tooltip;
        }
        private function onMouseAction(event:MouseEvent):void
        {
        	if(event.type == MouseEvent.MOUSE_DOWN)
        	{
        		this.startDrag(false, new Rectangle(0,0,parent.width-this.width,parent.height-this.height));
        		moveCanvas.addEventListener(MouseEvent.MOUSE_UP, onMouseAction,false,0,true);
        		moveCanvas.addEventListener(MouseEvent.MOUSE_MOVE, onMouseAction,false,0,true);
        	}
        	if(event.type == MouseEvent.MOUSE_MOVE)
        	{
        		dispatchEvent(new Event(COMMENT_MOVE));	
        	}
        	if(event.type == MouseEvent.MOUSE_UP)
        	{
        		moveCanvas.removeEventListener(MouseEvent.MOUSE_UP, onMouseAction);
        		moveCanvas.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseAction);
        		dispatchEvent(new Event(COMMENT_MOVE));
        		this.stopDrag();
        	}
        }
        private var newComment:Boolean = false;
       private function editSaveMouseClick(event:MouseEvent):void{
			titleText.enabled = descText.enabled = event.target.selected;
			if(event.target.selected){
				setChildIndex(moveCanvas, 0);
				if((ModelLocator.getInstance().person.personId == CommentVO(historyCollection.getItemAt(historyStepper.value-1)).createdby) && (historyCollection.length == historyStepper.value))
				{
					newComment = false;
				}
				else{
					newComment = true;
					//profileLabel.text = GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode + " : ";
					profileLabel.text = GetVOUtil.getProfileObject(model.person.defaultProfile).profileLabel.substr(0,3).toUpperCase() + " : ";
					titleText.text = "";
					descText.text = "";
				}
				historyStepper.enabled = false;
			}
			else{
				setChildIndex(moveCanvas, this.numChildren-5);
				
				/* var commentEvent:CommentEvent; 
				commentEvent = new CommentEvent(CommentEvent.UPDATE_COMMENT, commentVO.commentID, descText.text, titleText.text, String(commentVO.commentX), String(commentVO.commentY), String(commentVO.commentWidth), String(commentVO.commentHeight), String(commentVO.commentColor),"2",String(commentVO.commentType),false,commentVO.createdby,this.x,this.y,true,String(commentVO.misc));
				commentEvent.dispatch(); */
				if(!newComment){
					trace("Update Comment");
					var commentTemp:CommentVO = CommentVO(historyCollection.getItemAt(historyStepper.value-1));
					var commentEvent:CommentEvent;
					var descStr:String = ""; 
					if(commentVO.commentType == SinglePageCanvas.SHAPE_NOTE_INT && historyCollection.length ==1)
					{
						descStr = String(commentVO.commentDescription).split(SinglePageCanvas.SHAPE_FIRST_NOTE_SPLITTER)[0]+SinglePageCanvas.SHAPE_FIRST_NOTE_SPLITTER+descText.text
					}
					else
					{
						descStr = descText.text;
					}	
					commentEvent = new CommentEvent(CommentEvent.UPDATE_COMMENT, commentTemp.commentID, descStr, titleText.text, String(commentVO.commentX), String(commentVO.commentY), String(commentVO.commentWidth), String(commentVO.commentHeight), String(commentVO.commentColor),"2",String(commentVO.commentType),false,commentTemp.createdby,this.x,this.y,true,String(commentTemp.misc),Number(commentTemp.history));
					commentEvent.dispatch();
					model.pdfDetailVO.notesModificationHistoryAC.addItem({name:model.person.personFirstname +"( "+ (GetVOUtil.getProfileObject(model.person.defaultProfile).profileLabel.substr(0,3)) +" )",title:titleText.text,desc:descText.text, status: "Update"});
				}else
				{
					trace("New Comment");
					var commentEvent:CommentEvent;
					//commentEvent = new CommentEvent(CommentEvent.ADD_COMMENT, null, descText.text, titleText.text, String(commentVO.commentX),String(commentVO.commentY) ,String(commentVO.commentWidth),String(commentVO.commentHeight), String(commentVO.commentColor), "2", String(commentVO.commentType), false,ModelLocator.getInstance().person.personId, commentVO.commentBoxY, commentVO.commentBoxY, true,GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode, commentVO.commentID);
					commentEvent = new CommentEvent(CommentEvent.ADD_COMMENT, null, descText.text, titleText.text, String(commentVO.commentX),String(commentVO.commentY) ,String(commentVO.commentWidth),String(commentVO.commentHeight), String(commentVO.commentColor), "2", String(commentVO.commentType), false,ModelLocator.getInstance().person.personId, commentVO.commentBoxY, commentVO.commentBoxY, true,GetVOUtil.getProfileObject(model.person.defaultProfile).profileLabel.substr(0,3).toUpperCase(), commentVO.commentID);
					commentEvent.dispatch();
				}
				historyStepper.enabled = true;
			}
		}
       private function deleteMouseClick(event:MouseEvent):void{
       		model.pdfDetailVO.notesModificationHistoryAC.addItem({name:model.person.personFirstname +"( "+ (GetVOUtil.getProfileObject(model.person.defaultProfile).profileLabel.substr(0,3)) +" )",title:titleText.text,desc:descText.text, status: "Deleted"});
			var commentEvent:CommentEvent;
			var commentTemp:CommentVO = CommentVO(historyCollection.getItemAt(historyStepper.value-1));
			commentEvent = new CommentEvent(CommentEvent.REMOVE_COMMENT, commentTemp.commentID);
			commentEvent.dispatch();
	   }
	}
}
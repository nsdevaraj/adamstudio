package com.adams.dt.view.PDFTool
{
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.event.PDFTool.CommentEvent;
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.PDFTool.CommentVO;
	import com.adams.dt.view.PDFTool.events.GotoCommentEvent;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.HRule;
	import mx.controls.Label;
	import mx.controls.NumericStepper;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	import mx.events.NumericStepperEvent;

	[Event(name="gotoComment", type="com.adams.dt.view.PDFTool.events.GotoCommentEvent")]
	
	public class CommentListItem extends Canvas
	{
		
		[Bindable]
		private var model : ModelLocator = ModelLocator.getInstance();
		
		public var historyCollection:ArrayCollection = new ArrayCollection();
		
		public var commentVO:CommentVO = new CommentVO();
		
		private var profileLabel:Label;
		private var titleText:TextInput;
		private var descText:TextArea;
		private var hrule:HRule;
		private var editBtn:Button;
		private var deleteBtn:Button;
		private var gotoBtn:Button;

		private var _title:String="";
		[Bindable]
		public function set title (value:String):void
		{
			_title = value;
			titleText.text=value;
		}

		public function get title ():String
		{
			return _title;
		}
		
		private var _PDF:int;
		public function set PDF (value:int):void
		{
			_PDF = value;
			if(value==SinglePageCanvas.PDF1){
				editBtn.visible=deleteBtn.visible=false;
			}
			else{
				/* if(type == SinglePageCanvas.SHAPE_NOTE){
					deleteBtn.visible=(commentVO.createdby == model.person.personId);
				}
				else{ */
					editBtn.visible=deleteBtn.visible=true;
				//}
			}
			
		}
		public function get PDF ():int
		{
			return _PDF;
		}
	
		
		private var _desc:String;
		[Bindable]
		public function set desc (value:String):void
		{
			_desc = value;
			descText.text=value;
		}

		public function get desc ():String
		{
			return _desc;
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
		
		public var xPos:Number;
		public var yPos:Number;
		public var boxX:Number;
		public var boxY:Number;
		public var commentWidth:Number;
		public var commentHeight:Number;
		public var commentID:Number;
		public var tcommentID:Number;
		public var commColor:uint;
		public var maximize:Boolean;
		
		private var _type:String;
		public function set type (value:String):void
		{
			_type = value;
			/* if(value == SinglePageCanvas.SHAPE_NOTE){
				height = 40;
				editBtn.visible = false;
				deleteBtn.visible = (commentVO.createdby == model.person.personId);
			} */
			
		}

		public function get type ():String
		{
			return _type;
		}

		private var historyStepper:NumericStepper;
		private var historyHbox:HBox;
		private var historyMaxItem:Label;
		private var discussBtn:Button;
		public function CommentListItem()
		{
			super();
			
			hrule = new HRule()
			titleText=new TextInput();
			editBtn=new Button();
			deleteBtn=new Button();
			gotoBtn= new Button();
			descText=new TextArea();
			historyHbox=new HBox();
			profileLabel=new Label();
			discussBtn=new Button();
			historyStepper=new NumericStepper();
			historyMaxItem=new Label();
			
			historyCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE, historyCollectionChange,false,0,true);
			historyStepper.addEventListener(NumericStepperEvent.CHANGE,stepperChange,false,0,true);
			
		}
		override protected function createChildren():void
		{
			super.createChildren();
			
			addChild(titleText);
			addChild(hrule);
			addChild(editBtn);
			addChild(deleteBtn);
			addChild(gotoBtn);
			addChild(descText);
			addChild(historyHbox);
			addChild(discussBtn);
			addChild(profileLabel);
			historyHbox.addChild(historyStepper);
			historyHbox.addChild(historyMaxItem);
			
			hrule.setStyle("top","35");
			hrule.setStyle("left","10");
			hrule.setStyle("right","10");
			hrule.setStyle("horizontalCenter","0");
			hrule.setStyle("strokeColor","#999999");
			
			discussBtn.buttonMode=true;
			discussBtn.useHandCursor=true;
			discussBtn.toolTip="Discussion History"
			discussBtn.setStyle("left","10");
			discussBtn.setStyle("top","120");
		
			editBtn.toggle=true;
			editBtn.addEventListener(MouseEvent.CLICK,editSaveMouseClick,false,0,true);
			editBtn.setStyle("right","50");
			editBtn.setStyle("top","5");
			
			deleteBtn.addEventListener(MouseEvent.CLICK,deleteMouseClick,false,0,true);
			deleteBtn.setStyle("right","18");
			deleteBtn.setStyle("top","5");
			
			historyHbox.setStyle("backgroundColor","#000000");
			historyHbox.setStyle("backgroundAlpha",".5");
			historyHbox.width=90;
			historyHbox.height=24;
			
			historyHbox.setStyle("horizontalAlign","center");
			historyHbox.setStyle("verticalAlign","middle");
			historyHbox.setStyle("horizontalGap","2");
			
			historyMaxItem.setStyle("fontWeight","bold");
			historyMaxItem.setStyle("color","#FFFFFF");
			
			historyHbox.setStyle("left","36");
			historyHbox.setStyle("top","120"); 
			historyHbox.verticalScrollPolicy="off";
			historyHbox.horizontalScrollPolicy="off";
			
			historyStepper.setStyle("left","5");
			historyStepper.setStyle("top","2");
			
			historyStepper.width=50;
			historyStepper.minimum=1;
			historyStepper.maxChars=3;
			
			titleText.styleName = "commentBoxTitleStyle";
			descText.styleName = "commentBoxDescDisable";
			editBtn.styleName = "noteEditBtn";
			deleteBtn.styleName = "noteDeleteBtn";
			discussBtn.styleName = "noteDiscussBtn";
			historyStepper.styleName = "noteHistoryNumStp";
			
			titleText.setStyle("left","10");
			titleText.setStyle("paddingLeft","40");
			
			gotoBtn.setStyle("right","10");
			gotoBtn.setStyle("top","120");
			gotoBtn.label = "Go";
			gotoBtn.width = 45;
			gotoBtn.toolTip = "Go To Corresponding\nComment Box";
			gotoBtn.addEventListener(MouseEvent.CLICK,onGotoComment,false,0,true);
			gotoBtn.visible = true;
			
			titleText.setStyle("right","85");
			profileLabel.setStyle("top","11");
			profileLabel.setStyle("left","13");
			profileLabel.setStyle("fontWeight","bold");
			profileLabel.setStyle("color","#FFFFFF");
			
			useHandCursorAction(editBtn);
			useHandCursorAction(deleteBtn);
			useHandCursorAction(gotoBtn);
			
			this.percentWidth = 100;
			
			titleText.enabled = descText.enabled = false;
			
			//this.setStyle("backgroundColor","#424242");
			//this.setStyle("backgroundColor","#AEAEAE");
			styleName = "commentListItemStyle";
			this.horizontalScrollPolicy="off";
			this.verticalScrollPolicy="off";
			
			
			//(commentVO.createdby == model.person.personId)
		}
		private function initObject(event:FlexEvent):void{
			
		}
		private function useHandCursorAction(target:Button, value:Boolean=true):void
		{
			target.buttonMode = value;
			target.useHandCursor = value;
		} 
		private function historyCollectionChange(event:CollectionEvent):void
		{
			historyMaxItem.text="/"+historyCollection.length;
			historyStepper.maximum = historyCollection.length;
			historyStepper.value = historyCollection.length;
			title = CommentVO(historyCollection.getItemAt(historyStepper.value-1)).commentTitle;
			desc = String(CommentVO(historyCollection.getItemAt(historyStepper.value-1)).commentDescription);
			if(commentVO.commentType == SinglePageCanvas.SHAPE_NOTE_INT && (historyStepper.value-1)==0)
				desc = String(CommentVO(historyCollection.getItemAt(historyStepper.value-1)).commentDescription).split(SinglePageCanvas.SHAPE_FIRST_NOTE_SPLITTER)[1];
			profile = CommentVO(historyCollection.getItemAt(historyStepper.value-1)).misc;
			
			editBtn.visible = (PDF == SinglePageCanvas.PDF2);
			deleteBtn.visible = ((PDF == SinglePageCanvas.PDF2) && (CommentVO(historyCollection.getItemAt(historyStepper.value-1)).createdby == model.person.personId));
		}
		private function stepperChange(event:NumericStepperEvent):void
		{ 
			title = CommentVO(historyCollection.getItemAt(historyStepper.value-1)).commentTitle;
			desc = String(CommentVO(historyCollection.getItemAt(historyStepper.value-1)).commentDescription);
			profile = CommentVO(historyCollection.getItemAt(historyStepper.value-1)).misc;
			if(commentVO.commentType == SinglePageCanvas.SHAPE_NOTE_INT && (historyStepper.value-1)==0)
				desc = String(CommentVO(historyCollection.getItemAt(historyStepper.value-1)).commentDescription).split(SinglePageCanvas.SHAPE_FIRST_NOTE_SPLITTER)[1];
			editBtn.visible = ((historyCollection.length == historyStepper.value) && PDF == SinglePageCanvas.PDF2)
			deleteBtn.visible = ((historyCollection.length == historyStepper.value) && (PDF == SinglePageCanvas.PDF2) && (CommentVO(historyCollection.getItemAt(historyStepper.value-1)).createdby == model.person.personId))
		} 
		private function removeObject(event:FlexEvent):void{
			
		}
		private var newComment:Boolean = false;
		private function editSaveMouseClick(event:MouseEvent):void
		{
			titleText.enabled = descText.enabled = event.target.selected;
			if(!event.target.selected){
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
					model.pdfDetailVO.notesModificationHistoryAC.addItem({name:model.person.personFirstname +"( "+ (GetVOUtil.getProfileObject(model.person.defaultProfile).profileLabel.substr(0,3)) +" )",title:titleText.text,desc:descText.text, status: "Update"});
					commentEvent = new CommentEvent(CommentEvent.UPDATE_COMMENT, commentTemp.commentID, descStr, titleText.text, String(commentVO.commentX), String(commentVO.commentY), String(commentVO.commentWidth), String(commentVO.commentHeight), String(commentVO.commentColor),"2",String(commentVO.commentType),false,commentTemp.createdby,commentVO.commentBoxX,commentVO.commentBoxY,true,String(commentTemp.misc),Number(commentTemp.history));
					commentEvent.dispatch();
				}else
				{
					model.pdfDetailVO.notesModificationHistoryAC.addItem({name:model.person.personFirstname +"( "+ (GetVOUtil.getProfileObject(model.person.defaultProfile).profileLabel.substr(0,3)) +" )",title:titleText.text,desc:descText.text, status: "Replay Comment"});
					trace("New Comment");
					var commentEvent:CommentEvent;
					//commentEvent = new CommentEvent(CommentEvent.ADD_COMMENT, null, descText.text, titleText.text, String(commentVO.commentX),String(commentVO.commentY) ,String(commentVO.commentWidth),String(commentVO.commentHeight), String(commentVO.commentColor), "2", String(commentVO.commentType), false,ModelLocator.getInstance().person.personId, commentVO.commentBoxY, commentVO.commentBoxY, true,GetVOUtil.getProfileObject(model.person.defaultProfile).profileCode, commentVO.commentID);
					commentEvent = new CommentEvent(CommentEvent.ADD_COMMENT, null, descText.text, titleText.text, String(commentVO.commentX),String(commentVO.commentY) ,String(commentVO.commentWidth),String(commentVO.commentHeight), String(commentVO.commentColor), "2", String(commentVO.commentType), false,ModelLocator.getInstance().person.personId, commentVO.commentBoxY, commentVO.commentBoxY, true,GetVOUtil.getProfileObject(model.person.defaultProfile).profileLabel.substr(0,3), commentVO.commentID);
					commentEvent.dispatch();
				}
			}
			else{
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
			}
			
		}
		 
		private function deleteMouseClick(event:MouseEvent):void{
			//if(type!=SinglePageCanvas.SHAPE_NOTE){
			model.pdfDetailVO.notesModificationHistoryAC.addItem({name:model.person.personFirstname +"( "+ (GetVOUtil.getProfileObject(model.person.defaultProfile).profileLabel.substr(0,3)) +" )",title:titleText.text,desc:descText.text, status: "Deleted"});
			//}
			var commentEvent:CommentEvent;
			var commentTemp:CommentVO = (type == SinglePageCanvas.SHAPE_NOTE)?commentVO:CommentVO(historyCollection.getItemAt(historyStepper.value-1));
			commentEvent = new CommentEvent(CommentEvent.REMOVE_COMMENT, commentTemp.commentID);
			commentEvent.dispatch();
		}
		private function onGotoComment(event:MouseEvent):void
		{
			dispatchEvent(new GotoCommentEvent(GotoCommentEvent.GOTO_COMMENT, commentVO)); 
		}
	}
}
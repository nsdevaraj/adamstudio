package com.adams.dt.view.PDFTool
{
	import com.adams.dt.event.PDFTool.CommentEvent;
	import com.adams.dt.model.ModelLocator;
	
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.HRule;
	import mx.controls.Label;
	import mx.controls.TextArea;
	import mx.events.FlexEvent;

	public class CommentItem extends Canvas
	{
		private var title_lbl:Label;
		private var desc_txt:TextArea;
		private var hrule:HRule;
		private var edit_btn:Button;
		private var delete_btn:Button;
		
		[Bindable]
		private var model : ModelLocator = ModelLocator.getInstance();
		
		private var _title:String="";
		public function set title (value:String):void
		{
			_title = value;
			title_lbl.text=value;
		}

		public function get title ():String
		{
			return _title;
		}
		
		private var _PDF:int;
		public function set PDF (value:int):void
		{
			_PDF = value;
			if(value==1){
				edit_btn.visible=delete_btn.visible=false;
			}
			if(value==2){
				delete_btn.visible=true;
			}
			
		}

		public function get PDF ():int
		{
			return _PDF;
		}
		
		private var _desc:String;
		public function set desc (value:String):void
		{
			_desc = value;
			desc_txt.text=value;
		}

		public function get desc ():String
		{
			return _desc;
		}
		
		public var xPos:Number;
		public var yPos:Number;
		public var boxX:Number;
		public var boxY:Number;
		public var commentWidth:Number;
		public var commentHeight:Number;
		public var commentID:Number;
		public var commColor:uint;
		public var maximize:Boolean;
		public var profile:String;
		
		private var _commentType:int;
		public function set commentType (value:int):void
		{
			_commentType = value;
			if(value==3) edit_btn.visible=false;
		}

		public function get commentType ():int
		{
			return _commentType;
		}
		
		
		public function CommentItem()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE,initObject);
			this.addEventListener(FlexEvent.REMOVE,removeObject);
			hrule = new HRule()
			title_lbl=new Label();
			edit_btn=new Button();
			delete_btn=new Button();
			desc_txt=new TextArea();
			
			addChild(title_lbl);
			addChild(hrule);
			addChild(edit_btn);
			addChild(delete_btn);
			addChild(desc_txt);
			
			hrule.setStyle("top","35");
			hrule.setStyle("left","10");
			hrule.setStyle("right","10");
			hrule.setStyle("horizontalCenter","0");
			hrule.setStyle("strokeColor","#999999");
			
			
			title_lbl.text=title;
			title_lbl.setStyle("left","10");
			title_lbl.setStyle("top","10");
			title_lbl.setStyle("color","#FFFFFF");
			title_lbl.setStyle("fontWeight","bold");
			title_lbl.setStyle("fontSize","10");
			title_lbl.width=100;
			
			
			edit_btn.label="Edit"
			edit_btn.toggle=true;
			edit_btn.addEventListener(MouseEvent.CLICK,editSaveMouseClick);
			edit_btn.setStyle("right","50");
			edit_btn.setStyle("top","5");
			
			delete_btn.addEventListener(MouseEvent.CLICK,deleteMouseClick);
			delete_btn.setStyle("right","18");
			delete_btn.setStyle("top","5");
			delete_btn.styleName="deleteNoteSkin";
			
			desc_txt.enabled=false;
			desc_txt.setStyle("top","40");
			desc_txt.setStyle("left","10");
			desc_txt.setStyle("right","10");
			desc_txt.setStyle("bottom","10");
			desc_txt.setStyle("color","#ECECEC");
			desc_txt.setStyle("backgroundAlpha","0.3");
			desc_txt.setStyle("backgroundColor","#FFFFFF");
			desc_txt.setStyle("backgroundDisabledColor","#000000");
			desc_txt.setStyle("borderStyle","none");
			this.setStyle("backgroundColor","#222222");
			this.horizontalScrollPolicy="off";
			this.verticalScrollPolicy="off";
		}
		private function initObject(event:FlexEvent):void{
			
		}
		private function removeObject(event:FlexEvent):void{
			//trace("Me Removed"+this.title);
			this.edit_btn.removeEventListener(MouseEvent.CLICK,editSaveMouseClick);
			this.delete_btn.removeEventListener(MouseEvent.CLICK,deleteMouseClick);
			this.removeEventListener(FlexEvent.CREATION_COMPLETE,initObject);
			this.removeEventListener(FlexEvent.REMOVE,removeObject);
		}
		private function editSaveMouseClick(event:MouseEvent):void{
			if(Button(event.target).selected){
				Button(event.target).label="Update"
				CommentItem(Button(event.target).parent).desc_txt.enabled=true;
			}else{
				Button(event.target).label="Edit";
				var commentEvent:CommentEvent;
				commentEvent = new CommentEvent(CommentEvent.UPDATE_COMMENT, this.commentID, desc_txt.text, title_lbl.text,String(this.xPos),String(this.yPos),String(this.commentWidth),String(this.commentHeight),String(this.commColor),"2", String(this.commentType), false, this.boxX, this.boxY,this.maximize,this.profile);
				commentEvent.dispatch();
				/* var tempArrColl:ArrayCollection=model.pdfDetailVO.commentListArrayCollection;
				model.pdfDetailVO.commentListArrayCollection=new ArrayCollection();
				model.pdfDetailVO.commentListArrayCollection=tempArrColl; */
				CommentItem(Button(event.target).parent).desc_txt.enabled=false;
			}  
		}
		private function deleteMouseClick(event:MouseEvent):void{
			var commentEvent:CommentEvent;
			commentEvent = new CommentEvent(CommentEvent.REMOVE_COMMENT, this.commentID);
			commentEvent.dispatch();
		}
	}
}
package com.adams.dt.view.PDFTool
{
	import com.adams.dt.event.PDFTool.CommentEvent;
	import com.adams.dt.model.ModelLocator;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.Label;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;

	public class CommentDescBox extends Canvas
	{
		
		
		private var _PDF:int;
		private var title_txt:TextInput;;
		private var desc_txt:TextArea;
		public var edit_btn:Button;
		private var minMaxBtn:Button;
		private var delete_btn:Button;
		private var profile_lbl:Label;
		private var status_cb:ComboBox;
		public var mouseArea:Canvas;
		
		[Bindable]
		private var model : ModelLocator = ModelLocator.getInstance();
		
		public function set PDF (value:int):void
		{
			_PDF = value;
			if(value==1){
				edit_btn.visible=delete_btn.visible=false;
				this.desc_txt.setStyle("bottom","20");
			}
			if(value==2){
				edit_btn.visible=delete_btn.visible=true;
				this.desc_txt.setStyle("bottom","40");
			}
			
		}

		public function get PDF ():int
		{
			return _PDF;
		}

		
		private var _targetX:int;
		public function set targetX (value:int):void
		{
			_targetX = value;
			trace(value);
		}

		public function get targetX ():int
		{
			return _targetX;
		}

		
		private var _targetY:int;
		public function set targetY (value:int):void
		{
			_targetY = value;
			trace(value);
		}

		public function get targetY ():int
		{
			return _targetY;
		}

		private var _target:Object;
		public function set target (value:Object):void
		{
			_target = value;
		}

		public function get target ():Object
		{
			return _target;
		}
		
		private var _title:String="";
		public function set title (value:String):void
		{
			_title = value;
			title_txt.text=value;
		}

		public function get title ():String
		{
			return _title;
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
		
		private var _maximize:Boolean;
		public function set maximize (value:Boolean):void
		{
			_maximize = value;
			if(value){
				this.width = this.mouseArea.width = 220;
				this.height= this.mouseArea.height=150;
				this.minMaxBtn.selected=false;
			}else{
				this.width = this.mouseArea.width=40;
				this.height=this.mouseArea.height=40;
				this.minMaxBtn.selected=true;
			}
			
		}

		public function get maximize ():Boolean
		{
			return _maximize;
		}
		
		private var _update_lbl:String; 
		public function set update_lbl (value:String):void
		{
			_update_lbl = value;
			edit_btn.label = value;
			if(value=="Edit") { 
			desc_txt.enabled=title_txt.enabled=false;
			this.title_txt.setStyle("styleName","commentTitleDisable");
			this.title_txt.mouseChildren=this.desc_txt.mouseChildren=false;
			this.desc_txt.setStyle("styleName","commentDescDisable");
			}
			if(value=="Save")
			{
				desc_txt.enabled=title_txt.enabled=true;
				//this.setChildIndex(mouseArea,this.numChildren-2);
			} 
		}

		public function get update_lbl ():String
		{
			return _update_lbl;
		}

		private var _profile:String; 
		public function set profile (value:String):void
		{
			_profile = value;
			profile_lbl.text=value+" :";			
			
		}

		public function get profile ():String
		{
			return _profile;
		}
		
		private var _cancel_lbl:String;
		public function set cancel_lbl (value:String):void
		{
			_cancel_lbl = value;
			delete_btn.label = value;
		}

		public function get cancel_lbl ():String
		{
			return _cancel_lbl;
		}
		
		
		
		public function CommentDescBox()
		{
			super();
			mouseArea=new Canvas();
			target=new Object();
			title_txt=new TextInput();
			desc_txt=new TextArea();
			edit_btn=new Button();
			delete_btn=new Button();
			minMaxBtn=new Button();
			profile_lbl=new Label();
			
			
			addChild(mouseArea);
			addChild(title_txt);
			addChild(desc_txt);
			addChild(profile_lbl);
			addChild(edit_btn);
			addChild(delete_btn);
			addChild(minMaxBtn);
			
			/* mouseArea.name="mouseArea";
			title_txt.name="title_txt";
			desc_txt.name="desc_txt";
			edit_btn.name="edit_btn";
			delete_btn.name="delete_btn";
			profile_lbl.name="profile_lbl";
			minMaxBtn.name="minMaxBtn";	 */		
			
			profile_lbl.setStyle("color","#FFFFFF");
			profile_lbl.setStyle("fontWeight","bold");
			profile_lbl.setStyle("left","47");
			profile_lbl.setStyle("top","11");
			//profile_lbl.text="CLT :";
			
			title_txt.setStyle("paddingLeft","90");
			
			title_txt.setStyle("styleName","commentTitleEnable");
			
			minMaxBtn.setStyle("styleName","noteMaxMinBtn");
			minMaxBtn.setStyle("left","10");
			minMaxBtn.setStyle("top","10");
			minMaxBtn.buttonMode=true;
			minMaxBtn.toggle=true;
			
			desc_txt.setStyle("styleName","commentDescEnable");
						
			delete_btn.setStyle("right","10");
			delete_btn.setStyle("top","115");
			
			edit_btn.setStyle("right","90");
			edit_btn.setStyle("top","115");
			
			mouseArea.setStyle("backgroundColor","#222222");
			mouseArea.setStyle("backgroundAlpha","0.1");
			mouseArea.setStyle("cornerRadius","10");
			mouseArea.setStyle("borderStyle","soild");
			mouseArea.horizontalScrollPolicy="off";
			mouseArea.verticalScrollPolicy="off";
			
			
			this.setStyle("backgroundColor","#222222");
			this.setStyle("backgroundAlpha","0.5");
			this.edit_btn.addEventListener(MouseEvent.CLICK,editCommentEvent);
			this.delete_btn.addEventListener(MouseEvent.CLICK,deleteComment);
			this.minMaxBtn.addEventListener(MouseEvent.CLICK,noteMinMaxFunc);
			this.setStyle("cornerRadius","10");
			this.setStyle("borderStyle","soild");
			this.horizontalScrollPolicy="off";
			this.verticalScrollPolicy="off";
			
			this.setChildIndex(mouseArea,3);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,creationComplete);
		}
		override protected function createChildren():void{
			super.createChildren();
			
		}
		private function creationComplete(event:FlexEvent):void{
			title_txt.setStyle("paddingLeft",String(profile_lbl.width));
		}
		public function editComment():void{
			var commentEvent:CommentEvent;
			
			
			
			switch (this.edit_btn.label)
			{
			case "Save":
				commentEvent = new CommentEvent(CommentEvent.ADD_COMMENT, null, desc_txt.text, title_txt.text,target.x,target.y,target.width,target.height,target.fillColor,"2", target.type, false, this.x, this.y, maximize,this.profile);
				commentEvent.dispatch();
				break;
			case "Update":
				this.edit_btn.label="Edit";
				this.title_txt.setStyle("styleName","commentTitleDisable");
				this.desc_txt.setStyle("styleName","commentDescDisable");
				this.desc_txt.enabled=this.title_txt.enabled=false;
				this.title_txt.mouseChildren=this.desc_txt.mouseChildren=false;
				commentEvent = new CommentEvent(CommentEvent.UPDATE_COMMENT, target.commentID, desc_txt.text, title_txt.text,target.x,target.y,target.width,target.height,target.fillColor,"2", target.type, false, this.x, this.y, maximize,this.profile);
				commentEvent.dispatch();
				break;
			case "Edit":
				this.edit_btn.label="Update";
				this.title_txt.setStyle("styleName","commentTitleEnable");
				this.desc_txt.setStyle("styleName","commentDescEnable");
				this.desc_txt.enabled=this.title_txt.enabled=true;
				this.title_txt.mouseChildren=this.desc_txt.mouseChildren=true;
				this.setChildIndex(mouseArea,0);
				break;
			}
		}
		private var editTextStatus:Boolean=false;
		private function editCommentEvent(event:MouseEvent):void{
			editComment();
			//editTextStatus=true;
		}
		private function noteMinMaxFunc(event:MouseEvent):void{
			 if(event.target.selected){
				_maximize=false;
				this.width =this.mouseArea.width= 40;
				this.height =this.mouseArea.height=40;
			}else{
				_maximize=true;
				this.width = this.mouseArea.width = 220;
				this.height= this.mouseArea.height=150;
			}
			if(this.PDF==2){
				this.edit_btn.label="Update";
				editComment();
			}else{
				PDFToolSimpleArc(this.parent.parent.parent).img1.linkNoteFunc();	
			}
		}
		private function deleteComment(event:MouseEvent):void{
			if(delete_btn.label=="Remove"){
				var commentEvent:CommentEvent;
				commentEvent = new CommentEvent(CommentEvent.REMOVE_COMMENT, target.commentID);
				commentEvent.dispatch();
			}
			if(delete_btn.label=="Cancel"){
				var tempArrColl:ArrayCollection=model.pdfDetailVO.commentListArrayCollection;
				model.pdfDetailVO.commentListArrayCollection=new ArrayCollection();
				model.pdfDetailVO.commentListArrayCollection=tempArrColl;
			}
		}
	}
}
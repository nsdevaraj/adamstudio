package com.adams.dt.view.PDFTool
{
	
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.PDFTool.CommentVO;
	import com.adams.dt.view.PDFTool.events.GotoCommentEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.events.CollectionEvent;
	import mx.events.EffectEvent;
	
	[Event(name="tabChange", type="flash.events.Event")]
	[Event(name='gotoComment', type='com.adams.dt.view.PDFTool.events.GotoCommentEvent')]
	
	public class CommentList extends Canvas
	{
		
		public static const TAB_CHANGE:String = "tabChange";
		
		[Bindable]
		private var model : ModelLocator = ModelLocator.getInstance();
		
		private var _openStatus:Boolean=true;
		[Bindable]
		public function set openStatus (value:Boolean):void
		{
			_openStatus = value;
		}

		public function get openStatus ():Boolean
		{
			return _openStatus;
		}
				
		private var _listWidth:Number;
		[Bindable]
		public function set listWidth (value:Number):void
		{
			_listWidth = value;
			invalidateAction();
		}

		public function get listWidth ():Number
		{
			return _listWidth;
		}

		
		private var _listHeight:Number;
		[Bindable]
		public function set listHeight (value:Number):void
		{
			_listHeight = value;
			invalidateAction();
		}

		public function get listHeight ():Number
		{
			return _listHeight;
		}
 		
		private var _dataProvider:ArrayCollection=new ArrayCollection();
		[Bindable]
		public function set dataProvider (value:ArrayCollection):void
		{
			_dataProvider.list = value.list;
		}

		public function get dataProvider ():ArrayCollection
		{
			return _dataProvider;
		}
		
		
		private var _pdffile:Number;
		public function set pdffile (value:Number):void
		{
			_pdffile = value;
			if(value==1){
				pdffile1_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			if(value==2){
				pdffile2_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			dispatchEvent(new Event(TAB_CHANGE));
		}
		[Bindable]
		public function get pdffile ():Number
		{
			return _pdffile;
		}
		
		
		private var _compareMode:Boolean;
		public function set compareMode (value:Boolean):void
		{
			_compareMode = value;
			if(value)
			{ 
				menu_hb.height=50;
				pdfListCanvas.setStyle("top",50);
			}
			else
			{
				menu_hb.height=0;
				pdfListCanvas.setStyle("top",10);
				pdf1_comment_vb.visible=pdf1_comment_vb.includeInLayout=false;
				pdf2_comment_vb.visible=pdf2_comment_vb.includeInLayout=true;
			} 
		}

		public function get compareMode ():Boolean
		{
			return _compareMode;
		}

		private var pdf1_comment_vb:VBox;
		private var pdf2_comment_vb:VBox;
		private var pdfListCanvas:Canvas;	
		private var pdffile1_btn:Button;
		private var pdffile2_btn:Button;
		private var menu_hb:HBox=new HBox();
	
		public function CommentList()
		{
			super();
			
			menu_hb=new HBox();
			
			pdf1_comment_vb=new VBox();
			pdf2_comment_vb=new VBox();
			pdfListCanvas=new Canvas();
			
			pdffile1_btn= new Button();
			pdffile2_btn= new Button();
			
		}
		override protected function createChildren():void
		{
			super.createChildren();
			dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,dataProviderChangeEvent,false,0,true);
			
			addChild(menu_hb);
			addChild(pdfListCanvas);
			pdfListCanvas.addChild(pdf1_comment_vb);
			pdfListCanvas.addChild(pdf2_comment_vb);
			
			pdfListCanvas.percentWidth=100;
			pdfListCanvas.setStyle("top",50);
			pdfListCanvas.setStyle("bottom",0);
			
			pdf1_comment_vb.percentWidth=100;
			pdf1_comment_vb.percentHeight=100;
			pdf2_comment_vb.percentWidth=100;
			pdf2_comment_vb.percentHeight=100;
			pdf2_comment_vb.visible=false;
			pdf2_comment_vb.includeInLayout=false;
			
			pdfListCanvas.horizontalScrollPolicy="off";
			//pdf2_comment_vb.horizontalScrollPolicy="off";
			 
			menu_hb.addChild(pdffile1_btn);
			menu_hb.addChild(pdffile2_btn);
			menu_hb.setStyle("horizontalGap","0");
			menu_hb.percentWidth=100;
			menu_hb.height=50;
			pdffile1_btn.percentWidth=50;
			pdffile1_btn.percentHeight=100;
			pdffile2_btn.percentWidth=50;
			pdffile2_btn.percentHeight=100;
			pdffile1_btn.label="PDF File 1";
			pdffile2_btn.label="PDF File 2";
			pdffile1_btn.selected=true;
			pdffile2_btn.selected=false;
			pdffile1_btn.name="pdffile1_btn";
			pdffile2_btn.name="pdffile2_btn";
			pdffile1_btn.addEventListener(MouseEvent.CLICK,pdfCommentSwitch,false,0,true);
			pdffile2_btn.addEventListener(MouseEvent.CLICK,pdfCommentSwitch,false,0,true);
			
			//this.setStyle("backgroundColor","#222222");
			//this.setStyle("backgroundColor","#DCDCDC");
			styleName = "commentListStyle";
			
			this.addEventListener(EffectEvent.EFFECT_END, onEffectEnd,false,0,true);
						
			invalidateAction();
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
		}
		/* override protected function measure():void
		{
			super.measure();
			
			measuredMinWidth = measuredWidth = _listWidth;
			measuredMinHeight = measuredHeight = _listHeight; 
		} */
		private function invalidateAction():void{
        	invalidateProperties();
            invalidateSize();
            invalidateDisplayList(); 
        }
        private function onEffectEnd(event:EffectEvent):void
        {
        	clearStyle("resizeEffect");
        }
        private var historyTempCollection:ArrayCollection;
		private function dataProviderChangeEvent(event:CollectionEvent):void{
			
			pdf1_comment_vb.removeAllChildren();
			pdf2_comment_vb.removeAllChildren();
			
			var i:int;
			var j:int;
			historyTempCollection = new ArrayCollection();
			for(i=0;i<dataProvider.length;i++){
				var commentDetail : CommentVO =  model.pdfDetailVO.commentListArrayCollection.getItemAt(i) as CommentVO;
				if(commentDetail.history == 0){
					var cPDF:Number = Number((commentDetail.filefk == model.currentSwfFile.remoteFileFk)?"2":"1");
					var cType:String = ((Number(commentDetail.commentType)==SinglePageCanvas.RECTANGLE_NOTE_INT)?SinglePageCanvas.RECTANGLE_NOTE:(Number(commentDetail.commentType)==SinglePageCanvas.VERTICAL_NOTE_INT)?SinglePageCanvas.VERTICAL_NOTE:(Number(commentDetail.commentType)==SinglePageCanvas.HORIZONTAL_NOTE_INT)?SinglePageCanvas.HORIZONTAL_NOTE:SinglePageCanvas.SHAPE_NOTE);
					var comment:CommentListItem =  new CommentListItem();
					comment.commentVO = commentDetail;
					commentDetail.commentPDFfile = String(cPDF); 
					comment.title = commentDetail.commentTitle;
					comment.desc = String(commentDetail.commentDescription);
					comment.profile = commentDetail.misc;
					comment.type = cType;
					comment.PDF = cPDF;
					//if(cType != SinglePageCanvas.SHAPE_NOTE){
						comment.historyCollection.addItem(commentDetail);
					//}
					if(cPDF == SinglePageCanvas.PDF1){
						pdf1_comment_vb.addChild(comment);
					}
					else
					{
						pdf2_comment_vb.addChild(comment);
					}
					comment.addEventListener(GotoCommentEvent.GOTO_COMMENT, onGotoComment,false,0,true);
				}else{
					historyTempCollection.addItem(commentDetail);
				}
			}
			for(i=0;i<pdf1_comment_vb.numChildren;i++){
				for(j=0;j<historyTempCollection.length;j++){
					if(CommentListItem(pdf1_comment_vb.getChildAt(i)).commentVO.commentID == CommentVO(historyTempCollection.getItemAt(j)).history){
						CommentListItem(pdf1_comment_vb.getChildAt(i)).historyCollection.addItem(historyTempCollection.getItemAt(j));
					}
				}
			}
			for(i=0;i<pdf2_comment_vb.numChildren;i++){
				for(j=0;j<historyTempCollection.length;j++){
					if(CommentListItem(pdf2_comment_vb.getChildAt(i)).commentVO.commentID == CommentVO(historyTempCollection.getItemAt(j)).history){
						CommentListItem(pdf2_comment_vb.getChildAt(i)).historyCollection.addItem(historyTempCollection.getItemAt(j));
					}
				}
			}
			/* 
			historyTrackListAC= new ArrayCollection();
			var sort:Sort = new Sort(); 
			sort.fields = [ new SortField( 'commentID' ) ];
			var pdfNoteCollection :ArrayCollection =ArrayCollection(event.target)
			var pdfHistoryNoteCollection :ArrayCollection = new ArrayCollection()
			 for(i=0;i<pdfNoteCollection.length;i++){
			 	
			 	var commentDetail : CommentVO =  model.pdfDetailVO.commentListArrayCollection.getItemAt(i) as CommentVO;
			 	commentDetail.commentPDFfile = (commentDetail.filefk == model.currentSwfFile.remoteFileFk)?"2":"1";
				commentDetail.editable=(ModelLocator.getInstance().person.personId ==  commentDetail.createdby)?true:false;
				var comment:CommentItem=new CommentItem();	
				if(commentDetail.commentType==3){
					comment.height=40;
					comment.tcommentID=commentDetail.commentID;
					modifyItem(comment, commentDetail );
			   }else if(commentDetail.history == 0){
			  		modifyItem(comment, commentDetail );
			  		comment.height=150;
			  		comment.historyCollection.addItem(commentDetail)
			  		historyTrackListAC.addItem(comment);
					updateHistoryItem(comment,commentDetail);
				}else{
						pdfHistoryNoteCollection.addItem(commentDetail)
				} 
			 	if(commentDetail.commentPDFfile == "1"){
					pdf1_comment_vb.addChild(comment);
				}else{
					pdf2_comment_vb.addChild(comment);
				} 
			} */
		
		}
		
		private function onGotoComment(event:GotoCommentEvent):void
		{
			dispatchEvent(new GotoCommentEvent(GotoCommentEvent.GOTO_COMMENT, event.commentVO));
		}
		
		private function pdfCommentSwitch(event:MouseEvent):void{
			if(event.target.name=="pdffile1_btn"){
				pdffile1_btn.selected=true;
				pdffile2_btn.selected=false;
				pdf1_comment_vb.visible=pdf1_comment_vb.includeInLayout=true;
				pdf2_comment_vb.visible=pdf2_comment_vb.includeInLayout=false;
				pdffile = SinglePageCanvas.PDF1;
			}
			if(event.target.name=="pdffile2_btn"){
				pdffile1_btn.selected=false;
				pdffile2_btn.selected=true;
				pdf1_comment_vb.visible=pdf1_comment_vb.includeInLayout=false;
				pdf2_comment_vb.visible=pdf2_comment_vb.includeInLayout=true;
				pdffile = SinglePageCanvas.PDF2;
			}
		}
	}
}
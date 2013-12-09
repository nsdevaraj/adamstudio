package com.adams.dt.view.PDFTool
{
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.PDFTool.CommentVO;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Button;
	import mx.events.CollectionEvent;

	public class CommentList extends Canvas
	{
		
		[Bindable]
		private var model : ModelLocator = ModelLocator.getInstance();
 		
		private var _dataProvider:ArrayCollection=new ArrayCollection();
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
			dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,dataProviderChangeEvent);
			
			menu_hb=new HBox();
			
			pdf1_comment_vb=new VBox();
			pdf2_comment_vb=new VBox();
			pdfListCanvas=new Canvas();
			
			pdffile1_btn= new Button();
			pdffile2_btn= new Button();
			
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
			pdffile1_btn.addEventListener(MouseEvent.CLICK,pdfCommentSwitch);
			pdffile2_btn.addEventListener(MouseEvent.CLICK,pdfCommentSwitch);
		}
		private function dataProviderChangeEvent(event:CollectionEvent):void{
			var i:int;
			pdf1_comment_vb.removeAllChildren();
			pdf2_comment_vb.removeAllChildren();
			 for(i=0;i<ArrayCollection(event.target).length;i++){
			 	var commentDetail : CommentVO =  model.pdfDetailVO.commentListArrayCollection.getItemAt(i) as CommentVO;
				commentDetail.commentPDFfile = (commentDetail.filefk == model.currentSwfFile.remoteFileFk)?"2":"1";
			 	var comment:CommentItem=new CommentItem();
				 if(commentDetail.commentPDFfile == "1")
					pdf1_comment_vb.addChild(comment);
				else
					pdf2_comment_vb.addChild(comment);
					
				comment.title = commentDetail.commentTitle;
				comment.desc = String(commentDetail.commentDescription);
				comment.boxX=commentDetail.commentBoxX;
				comment.boxY=commentDetail.commentBoxY;
				comment.commColor=commentDetail.commentColor;
				comment.commentWidth=commentDetail.commentWidth;
				comment.commentHeight=commentDetail.commentHeight;
				comment.xPos=commentDetail.commentX;
				comment.yPos=commentDetail.commentY;
				comment.commentType=commentDetail.commentType;
				comment.commentID=commentDetail.commentID;
				comment.maximize=commentDetail.commentMaximize;
				comment.profile=commentDetail.misc;
				
				comment.PDF=(commentDetail.editable)?Number(commentDetail.commentPDFfile):1;
				
				comment.percentWidth=100;
				comment.height=(commentDetail.commentType == 3)?40:150;  
			}
		}
		private function pdfCommentSwitch(event:MouseEvent):void{
			if(event.target.name=="pdffile1_btn"){
				pdffile1_btn.selected=true;
				pdffile2_btn.selected=false;
				pdf1_comment_vb.visible=pdf1_comment_vb.includeInLayout=true;
				pdf2_comment_vb.visible=pdf2_comment_vb.includeInLayout=false;
				pdffile=PDFMainContainer.PDF1;
			}
			if(event.target.name=="pdffile2_btn"){
				pdffile1_btn.selected=false;
				pdffile2_btn.selected=true;
				pdf1_comment_vb.visible=pdf1_comment_vb.includeInLayout=false;
				pdf2_comment_vb.visible=pdf2_comment_vb.includeInLayout=true;
				pdffile=PDFMainContainer.PDF2;
			}
		}
	}
}
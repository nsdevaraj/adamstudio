package com.adams.dt.event.PDFTool
{
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.PDFTool.CommentVO;
	import com.universalmind.cairngorm.events.UMEvent;
	
	import flash.utils.ByteArray;
	public final class CommentEvent extends UMEvent
	{
		[Bindable]
		private var model : ModelLocator = ModelLocator.getInstance();
		public static const ADD_COMMENT : String = "addComment";
		public static const REMOVE_COMMENT : String = "removeComment";
		public static const UPDATE_COMMENT : String = "updateComment";
		public static const BULK_UPDATE_COMMENT : String = "bulkUpdateComment";
		public static const GET_COMMENT : String = "getComment";
		public static const DELETEALL_COMMENT : String = "deleteAllComment";
		public var commentVO : CommentVO;
		public var commentID : Number;
		public var commentDescription : String;
		public var taskId : int;
		public var fileFk : int;
		public var compareFileFk : int;
		public function CommentEvent(EVENT_TYPE : String , ID : Number = 0 , description : String = "" , title : String = "" , x : String = "" , y : String = "" , width : String = "" , height : String = "" , color : String = "" , pdffile : String = "" , type : String = "1" , editable : Boolean = false,createdBy:int = 0, boxX:Number=0, boxY:Number=0, commentMax:Boolean=true, profile:String="",history:int = 0)
		{
			this.commentID = ID;
			this.commentDescription = description;
			var commentVO : CommentVO = new CommentVO();
			var desc:ByteArray = new ByteArray();
			desc.writeUTFBytes(description);
			if(model.currentSwfFile.remoteFileFk !=0)
			commentVO.update( ID , Number(type) , Number(x) , Number(y) , Number(width) , Number(height) , title , desc , uint(Number((uint(Number(color)) != 0)?color : model.pdfDetailVO.commentColor)) , pdffile , editable , model.currentSwfFile.remoteFileFk,createdBy, boxX, boxY, commentMax,profile,history);
			this.commentVO = commentVO;
			super(EVENT_TYPE);
		}
	}
}

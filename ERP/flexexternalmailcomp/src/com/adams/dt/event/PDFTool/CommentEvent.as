package com.adams.dt.event.PDFTool
{
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.vo.PDFTool.CommentVO;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class CommentEvent extends CairngormEvent
	{
		
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		 
		public static const ADD_COMMENT : String = "addComment";
		public static const REMOVE_COMMENT : String = "removeComment";
		public static const UPDATE_COMMENT : String = "updateComment";
		public static const BULK_UPDATE_COMMENT : String = "bulkUpdateComment";
		public static const GET_COMMENT : String = "getComment";
		 
		public var commentVO : CommentVO;
		
		public var commentID : Number;
		public var commentDescription : String;
		public var taskId:int;
		public function CommentEvent(EVENT_TYPE:String, ID:Number=0, description:String="",  
						title:String="", x:String="", y:String="", width:String="",   
		     			height:String="", color:String="", pdffile:String="", type:String = "1" ,editable:Boolean = false )
		{
			this.commentID = ID;
			this.commentDescription = description;
			var commentVO:CommentVO = new CommentVO();
			commentVO.update( ID, Number(type),Number(x) , Number(y), Number(width), Number(height), title, description, 
			uint(Number((uint(Number(color))!=0)?color:model.pdfDetailVO.commentColor)),  pdffile, editable,model.currentTasks );
			this.commentVO = commentVO;
			
			super(EVENT_TYPE);
			
		}

	}
}
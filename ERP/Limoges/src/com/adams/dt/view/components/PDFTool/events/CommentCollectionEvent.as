package com.adams.dt.view.components.PDFTool.events
{
	
	import com.adams.dt.model.vo.CommentVO;
	
	import flash.events.Event;
	
	public class CommentCollectionEvent extends Event
	{
		private var _commentVO:CommentVO = new CommentVO();
		
		private var _commentItemName:String = "";
		
		public static const COMMENT_COLLECTION_UPDATE:String = "commentCollectionUpdate";
		
		public function get commentItemName():String
		{
			return _commentItemName;
		}
		
		public function get commentVO():CommentVO
		{
			return _commentVO;
		}
		public function CommentCollectionEvent(type:String, commentVO:CommentVO, commentItemName:String="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this._commentVO = commentVO;
			this._commentItemName = commentItemName;
			super(type, bubbles, cancelable);
		}
		override public function clone():Event
		{
			return new CommentCollectionEvent(type, commentVO, commentItemName, bubbles, cancelable);
		}
	}
}
package com.adams.dt.view.PDFTool.events
{
	import com.adams.dt.model.vo.PDFTool.CommentVO;
	
	import flash.events.Event;

	public class GotoCommentEvent extends Event
	{
		private var _commentVO:CommentVO = new CommentVO();
		
		public static const GOTO_COMMENT:String = "gotoCommentEvent";
		
		public function GotoCommentEvent(type:String, commentVOValue:CommentVO, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this._commentVO = commentVOValue;	
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new GotoCommentEvent(type, commentVO, bubbles, cancelable);
		}
		
		public function get commentVO (): CommentVO
		{
			return _commentVO;
		}
		
	}
}
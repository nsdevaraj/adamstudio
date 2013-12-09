package com.adams.dt.view.PDFTool
{
	import mx.containers.Canvas;

	public class ExternalCommentCanvas extends Canvas
	{
		[Bindable]
		private var _clearExternelComment:Boolean;
		public function set clearExternelComment (value:Boolean):void
		{
			_clearExternelComment = value;
			if(value){
				this.removeAllChildren();
				this.graphics.clear();
				this.graphics.lineStyle(0.75, 0xFF0000, 0.8);
			}
		}
		[Bindable]
		public function get clearExternelComment ():Boolean
		{
			return _clearExternelComment;
		}
		public function ExternalCommentCanvas()
		{
			super();
		}
		
	}
}
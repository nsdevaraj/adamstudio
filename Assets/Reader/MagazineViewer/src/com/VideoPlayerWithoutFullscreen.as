package com
{
	import spark.components.VideoPlayer;
	
	public class VideoPlayerWithoutFullscreen extends VideoPlayer
	{
		public function VideoPlayerWithoutFullscreen()
		{
			super();
		}
		override protected function createChildren():void
		{
			super.createChildren();
			//super.fullScreenButton.visible = false;
			super.fullScreenButton.enabled = false;
			//super.fullScreenButton.includeInLayout = false;
		}
	}
}
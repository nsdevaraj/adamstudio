package com.ra.view.mediaplayer
{
	import com.ra.view.controls.VolumeBar;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.events.FlexEvent;
	import spark.components.supportClasses.TextBase;
	import spark.components.ToggleButton;
	import com.ra.view.controls.ScrubBar;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.TrackBaseEvent;
	
	[Style(name="symbolColor", type="uint", format="Color", inherit="yes", theme="spark")]
	
	public class YoutubePlayer extends SkinnableComponent
	{
		public function YoutubePlayer()
		{
			timer = new Timer(1);
			timer.addEventListener(TimerEvent.TIMER,handleTimer);			
		}
		[SkinPart(required="true")]
		public var playPauseButton:ToggleButton;
		
		[SkinPart(required="false")]
		public var scrubBar:ScrubBar;
		
		[SkinPart(required="true")]
		public var volumeBar:VolumeBar;
		
		[SkinPart(required="false")]
		public var playheadTimeDisplay:TextBase;
		
		[SkinPart(required="false")]
		public var totalTimeDisplay:TextBase;
		
		[SkinPart(required="true")]
		public var player:YoutubeVideo;
		
		private var _source:String;
		private var prevVol:Number;
		public var autoPlay:Boolean = true;
		private var timer:Timer;
		private var playtime:Number; //ms
		private var scrubBarMouseCaptured:Boolean = false;
		private var wasPlayingBeforeSeeking:Boolean = false;
		private var scrubBarChanging:Boolean = false;
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if (instance == playPauseButton)
			{
				playPauseButton.addEventListener(MouseEvent.CLICK, playPauseButton_clickHandler);
			}
			/*else if(instance == scrubBar)
			{
				scrubBar.addEventListener(TrackBaseEvent.THUMB_PRESS,scrub_thumbPressHandler);
				scrubBar.addEventListener(TrackBaseEvent.THUMB_RELEASE,scrub_thumbReleaseHandler);
				scrubBar.addEventListener(FlexEvent.CHANGING, scrubBar_changingHandler);
				scrubBar.addEventListener(Event.CHANGE,scrubBar_changeHandler);
			}*/
			else if(instance == volumeBar)
			{
				volumeBar.addEventListener(Event.CHANGE,volumeBar_changeHandler);
				volumeBar.addEventListener(FlexEvent.MUTED_CHANGE,volumeBar_mutedChangeHandler);
				volumeBar.value = 0.5;
			}
		}
		private function playPauseButton_clickHandler(event:Event):void
		{
			if(_source)
				player.pause_play();
			if(!timer.running)
				timer.start();
		}
		private function volumeBar_changeHandler(event:Event):void
		{
			player.volume = volumeBar.value;
		}	
		private function handleSongCompleted(event:Event):void
		{
			
		}				
		private function volumeBar_mutedChangeHandler(event:FlexEvent):void
		{
			if(volumeBar.muted)
			{
				prevVol = volumeBar.value;
				player.volume = 0;
				volumeBar.value = 0;
			}
			else
			{
				player.volume = prevVol;
				volumeBar.value = prevVol;
			}
		}	
		private function scrubBar_changingHandler(event:Event):void
		{
			scrubBarChanging = true;
		}					
		private function scrubBar_changeHandler(event:Event):void
		{
			//if (scrubBarMouseCaptured)
			//{
				// check if streaming and play()...then don't seek to last value
				/*if (player.player.isBuffering && scrubBar.value >= player.player.bytesLoaded)
				{
					
					player.player = player.player.seekTo(;
				}
				else
				{
					player.player.position = scrubBar.value;
				}*/
			//}
			//else
			//{
				player.player.seekTo(scrubBar.value,true);;
			//}
			
			scrubBarChanging = false;
		}
		private function scrub_thumbReleaseHandler(event:Event):void
		{
			scrubBarMouseCaptured = false;
			if(wasPlayingBeforeSeeking)
			{
				player.player.pause_play();
				wasPlayingBeforeSeeking = false;
			}
		}
		private function scrub_thumbPressHandler(event:Event):void
		{
			scrubBarMouseCaptured = true;
			if(player.player.playing)
			{
				player.player.pause_play(); // paused
				wasPlayingBeforeSeeking = true;
			}
		}	    	
		public function get volume():Number
		{
			return player.player.volume;
		}
		public function stop():void
		{
			player.player.stopVideo();
			timer.stop();
			timer.reset();
			volumeBar.value = 0.5;
			scrubBar.value = 0;
			this.playPauseButton.selected = false;
		} 
		public function set source(url:String):void
		{
			_source = url;
			if(autoPlay && url)
			{
				//var path:String = 'files'+value.path.toString()+value.name.toString();
				playPauseButton.selected = true;
				player.source = url.toString();				
				timer.start();

			}
		} 
		public function get playing():Boolean
		{
			return player.player.playing;
		} 	
		private function handleTimer(event:Event):void
		{	
			if(player.player)
			{
				playtime = player.player.getDuration();
				scrubBar.maximum = playtime;
				totalTimeDisplay.text = this.formatTimeValue(playtime);
				scrubBar.bufferedEnd = player.player.getVideoBytesLoaded() / player.player.getVideoBytesTotal() * playtime;
				if(!this.scrubBarChanging && !this.scrubBarMouseCaptured)
				{
					scrubBar.value = player.player.getCurrentTime();
					playheadTimeDisplay.text = formatTimeValue(player.player.getCurrentTime());
				}
			}
		}
		protected function formatTimeValue(value:Number):String
		{
			if (isNaN(value))
				value = 0;
			
			// default format: hours:minutes:seconds
			var hours:uint = Math.floor(value/3600) % 24;
			var minutes:uint = Math.floor(value/60) % 60;
			var seconds:uint = Math.round(value) % 60;
			
			var result:String = "";
			if (hours != 0)
				result = hours + ":";
			
			if (result && minutes < 10)
				result += "0" + minutes + ":";
			else
				result += minutes + ":";
			
			if (seconds < 10)
				result += "0" + seconds;
			else
				result += seconds;
			
			return result;
		}
		
	}
}
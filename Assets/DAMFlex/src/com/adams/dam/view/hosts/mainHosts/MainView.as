package com.adams.dam.view.hosts.mainHosts
{
	import com.adams.dam.model.ModelLocator;
	
	import mx.events.FlexEvent;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	public class MainView extends SkinnableComponent
	{
		
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		
		public function MainView()
		{
			super();
			addEventListener( FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true );
		}
		
		protected function onCreationComplete( event:FlexEvent ):void {
			var channel:AMFChannel = new AMFChannel( "my-amf", model.serverLocation + "spring/messagebroker/amf" );
			var channelSet:ChannelSet = new ChannelSet();
			channelSet.addChannel( channel );
			model.channelSet = channelSet;	
		}
	}
}
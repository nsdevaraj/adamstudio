package com.adams.dt.command
{
	import com.adams.dt.business.DelegateLocator;
	import com.adams.dt.event.AuthenticationEvent;
	import com.adams.dt.event.ChannelSetEvent;
	import com.adams.dt.event.LangEvent;
	import com.adams.dt.event.TranslationEvent;
	import com.adams.dt.event.generator.SequenceGenerator;
	import com.adams.dt.model.vo.LoginVO;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.serialization.json.JSON;
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	public final class InitializeDTCommand extends AbstractCommand 
	{ 
		private var translatorEvent : TranslationEvent;	
		private var loginVO : LoginVO;
		private var channelSet : ChannelSet;
		override public function execute( event : CairngormEvent ) : void
		{	
			super.execute(event);
			this.delegate = DelegateLocator.getInstance().languageDelegate;
			this.delegate.responder = new Callbacks(result,fault);
			switch(event.type){  
				case ChannelSetEvent.SET_CHANNEL:
					var channel : AMFChannel = new AMFChannel("my-amf" , model.serverLocation + "spring/messagebroker/amf");
					channelSet = new ChannelSet();
					channelSet.addChannel(channel);
					model.channelSet = channelSet;
	         		//model.mainClass.debug('login called '+model.serverLocation + "spring/messagebroker/amf")
					var authenticationEvent : AuthenticationEvent = new AuthenticationEvent( ChannelSetEvent( event ).loginVO );
 					var eventsArr:Array = [authenticationEvent]
	         		var handler:IResponder = new Callbacks(result,fault)
	         		var loginSeq:SequenceGenerator = new SequenceGenerator(eventsArr,handler)
	          		loginSeq.dispatch();  
					break; 
				case LangEvent.EVENT_GET_ALL_LANGS:
					delegate.responder = new Callbacks(findAllLangResult,fault); 
					delegate.findAll();
					break;                   
				case TranslationEvent.GOOGLE_TRANSLATE:
					translatorEvent = TranslationEvent(event);
					delegate = DelegateLocator.getInstance().translateDelegate;
					delegate.responder = new Callbacks(translationResult,fault);
					model.currentTranslation = translatorEvent.translateVO;
					if(model.currentTranslation.sourceLanguage == model.ENGLISH)
					{
						model.textSource = model.currentTranslation.englishText;
						delegate.changetoFrench();
					}else
					{
						model.textSource = model.currentTranslation.frenchText;
						delegate.changetoEnglish();
					}
					break;                   
				
				default:
					break; 
				}
		} 
		
		public function findAllLangResult( rpcEvent : Object ) : void
		{ 
			super.result(rpcEvent);
			model.langEntriesCollection = rpcEvent.result as ArrayCollection;
			var sort : Sort = new Sort();
			sort.fields = [new SortField("formid")];
			model.langEntriesCollection.sort = sort;
			model.langEntriesCollection.refresh();
			model.myLoc.langXML = model.langEntriesCollection;
			model.loc = model.myLoc;
			model.loc.language = "Fr";
			trace("findAllLangResult :"+model.loc.language);
		}
		public function translationResult( rpcEvent : Object ) : void
		{
			super.result(rpcEvent);
			var rawData : String = String(rpcEvent.result);
			if(JSON.decode(rawData).responseData.translatedText != null)
			{
				var decoded : String = JSON.decode(rawData).responseData.translatedText;
			}else
			{
				decoded = "No support";
			}

			if(model.currentTranslation.sourceLanguage == model.ENGLISH)
			{
				translatorEvent.translateVO.frenchText = decoded;
			}else
			{
				translatorEvent.translateVO.englishText = decoded;
			}
		}			 
 	}
}
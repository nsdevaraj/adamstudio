package com.adams.dt.business
{
	import com.adobe.cairngorm.enterprise.business.EnterpriseServiceLocator;
	
	import mx.rpc.http.HTTPService;
	public final class TranslateDAODelegate extends AbstractDelegate implements IDAODelegate
	{
		public function TranslateDAODelegate(service:HTTPService = null)
		{
			this.httpService = EnterpriseServiceLocator.getInstance().getHTTPService( "translate" );
			this.httpService = service;
		}

		override public function changetoEnglish() : void
		{
			model.destLanguage = model.ENGLISH;
			model.textSource = model.currentTranslation.frenchText;
			var call : Object = httpService.send();
			call.addResponder( responder );
		}

		override public function changetoFrench() : void
		{
			model.destLanguage = model.FRENCH;
			model.textSource = model.currentTranslation.englishText;
			var call : Object = httpService.send();
			call.addResponder( responder );
		}
	}
}

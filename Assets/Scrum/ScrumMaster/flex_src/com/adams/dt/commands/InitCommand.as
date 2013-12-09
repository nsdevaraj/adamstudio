package com.adams.dt.commands
{
	import com.adams.dt.model.vo.SignalVO;
	import com.adams.dt.service.IDTService;
	import com.adams.dt.signals.SignalSequence;
	import com.adams.dt.utils.Action;
	import com.adams.dt.utils.Description;
	import com.adams.dt.utils.Destination;
	

	public class InitCommand
	{
		[Inject]
		public var signalSequence:SignalSequence;
		
		[Inject]
		public var server:IDTService;
		
		public function execute():void
		{
			trace('logged in ');
			var getCompanySignal:SignalVO = new SignalVO(Action.GET_LIST, Destination.COMPANY_SERVICE);
			var getProfilesSignal:SignalVO = new SignalVO(Action.GET_LIST, Destination.PROFILE_SERVICE);
			var getPersonsSignal:SignalVO = new SignalVO(Action.GET_LIST, Destination.PERSON_SERVICE,{type:Description.LOGIN});
			signalSequence.addSignal(getCompanySignal);
			signalSequence.addSignal(getProfilesSignal);
			signalSequence.addSignal(getPersonsSignal);
			var getPushSignal:SignalVO = new SignalVO(Action.PUSH_MSG, Destination.PERSON_SERVICE,{type:Description.LOGIN});
			getPushSignal.name = "Message";
			getPushSignal.receivers = [1,4,3];
			signalSequence.addSignal(getPushSignal);
		}
	}
}
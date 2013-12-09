package org.spicefactory.parsley.core.scope {

/**
 * @author Jens Halm
 */
public class ScopeMessagingTestConfig {
	
	
	public function get globalSender () : GlobalSender {
		return new GlobalSender();
	}
	
	public function get localSender () : LocalSender {
		return new LocalSender();
	}
	
	public function get localReceiver () : LocalReceiver {
		return new LocalReceiver();
	}
	
	
}
}

package org.spicefactory.parsley.core.decorator.lifecycle {
import org.spicefactory.parsley.core.decorator.lifecycle.model.LifecycleEventCounterMetadata;

/**
 * @author Jens Halm
 */
public class ObserveCounterConfig {
	
	
	public function get counter () : LifecycleEventCounterMetadata {
		return new LifecycleEventCounterMetadata();
	}

	
}
}

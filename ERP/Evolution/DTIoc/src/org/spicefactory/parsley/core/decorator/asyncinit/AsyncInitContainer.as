package org.spicefactory.parsley.core.decorator.asyncinit {
import org.spicefactory.parsley.core.decorator.asyncinit.model.AsyncInitModelMetadata;

/**
 * @author Jens Halm
 */
public class AsyncInitContainer {
	
	
	public function get asyncInitModel () : AsyncInitModelMetadata {
		return new AsyncInitModelMetadata();
	}
	
	
}
}

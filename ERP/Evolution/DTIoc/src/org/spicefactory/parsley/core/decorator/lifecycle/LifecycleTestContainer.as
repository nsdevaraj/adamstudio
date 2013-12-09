package org.spicefactory.parsley.core.decorator.lifecycle {
import org.spicefactory.parsley.core.decorator.lifecycle.model.PostConstructMetadata;
import org.spicefactory.parsley.core.decorator.lifecycle.model.PreDestroyMetadata;

/**
 * @author Jens Halm
 */
public class LifecycleTestContainer {
	
	

	[ObjectDefinition(lazy="true")]
	public function get preDestroyModel () : PreDestroyMetadata {
		return new PreDestroyMetadata();
	}

	[ObjectDefinition(lazy="true")]
	public function get postConstructModel () : PostConstructMetadata {
		return new PostConstructMetadata();
	}
	
	
}
}

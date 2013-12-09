package org.spicefactory.parsley.core.decorator.lifecycle {
import mx.containers.Box;
import mx.containers.HBox;
import mx.containers.VBox;
import mx.controls.Text;

/**
 * @author Jens Halm
 */
public class ObserveTestConfig {
	
	
	[ObjectDefinition(lazy="true")]
	public function get box () : Box {
		return new Box();
	}

	[ObjectDefinition(lazy="true")]
	public function get hBox () : HBox {
		return new HBox();
	}
	
	[ObjectDefinition(lazy="true")]
	public function get vBox () : VBox {
		return new VBox();
	}
	
	[ObjectDefinition(lazy="true")]
	public function get text () : Text {
		return new Text();
	}
	
	[ObjectDefinition(lazy="true")]
	public function get text2 () : Text {
		return new Text();
	}
	
	
}
}

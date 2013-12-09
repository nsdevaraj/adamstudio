package org.spicefactory.parsley.flex.view.module.model {

/**
 * @author Jens Halm
 */
public class ModuleDependency {
	
	
	function ModuleDependency () {
		trace("ModuleDependency constr");
	}
	
	[Init]
	public function init () : void {
		trace("++++ PostConstruct");
	}
	
	[Destroy]
	public function destroy () : void {
		trace("++++ PreDestroy");
	}
	
	
}
}

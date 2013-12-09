/*
 * Copyright 2007 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
package org.spicefactory.lib.util {

/**
 * A Command wraps a method and its parameters for deferred execution.
 * 
 * @author Jens Halm
 */
public class Command {
	
	
	private var method:Function;
	private var params:Array;


	/**
	 * Creates a new Command for deferred execution.
	 * 
	 * @param method the method to execute
	 * @param params the parameters to pass to the method
	 */
	public function Command (method:Function, params:Array = null) {
		this.method = method;
		this.params = (params == null) ? [] : params;
	}
	
	/**
	 * Executes the Command.
	 * 
	 * @return the return value of the executed method
	 */
	public function execute () : * {
		return method.apply(null, params);
	}
	
}

}
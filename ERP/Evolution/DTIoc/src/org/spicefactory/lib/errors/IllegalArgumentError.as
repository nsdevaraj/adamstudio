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
 
package org.spicefactory.lib.errors {

/**
 * Error thrown when a method is called with illegal arguments.
 * 
 * @author Jens Halm
 */
public class IllegalArgumentError extends NestedError {

	/**
	 * Creates a new instance.
	 * 
	 * @param message the error message
	 * @param cause the cause of this Error
	 * @param id an optional reference number
	 */
	function IllegalArgumentError (message:String = "", cause:Error = null, id:int = 0) {
		super(message, cause, id);
	}

}

}
/*
 * Copyright 2008 the original author or authors.
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
 
package org.spicefactory.lib.reflect.metadata {

/**
 * Constants representing the types that metadata tags can be placed on. 
 * 
 * @author Jens Halm
 */
public class Types {


	/**
	 * Constant for classes.
	 */
	public static const CLASS:String = "class";
	
	/**
	 * Constant for constructors.
	 * 
	 * <p>This type is included for future use.
	 * Currently the Flex SDK compiler ignores all metadata tags placed on constructors.</p>
	 */
	public static const CONSTRUCTOR:String = "constructor";
	
	/**
	 * Constant for properties. This includes properties declared with public getter and/or setter
	 * methods as well as properties declared with <code>var</code> or <code>const</code>.
	 */
	public static const PROPERTY:String = "property";
	
	/**
	 * Constant for methods.
	 */
	public static const METHOD:String = "method";
	
	
}

}

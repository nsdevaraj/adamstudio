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

package org.spicefactory.lib.reflect {
import org.spicefactory.lib.reflect.MetadataAware;

/**
 * Represents a named member of a Class (a Constructor, Property or Method).
 * 
 * @author Jens Halm
 */
public class Member extends MetadataAware {


	private var _name:String;
	private var _owner:ClassInfo;


	/**
	 * @private
	 */
	function Member (name:String, owner:ClassInfo, metadata:MetadataCollection) {
		super(metadata);
		_name = name;
		_owner = owner;
	}
	
	/**
	 * The name of this member. For Constructors the value is the same as the name
	 * of the class the Constructor belongs to (not fully qualified). Otherwise the 
	 * value is simply the name of the method or property.
	 */
	public function get name () : String  {	
		return _name; 
	}
	
	/**
	 * The owner of this member. The owner is the Class that was reflected on 
	 * to retrieve an instance of this Member. This may differ from the Class
	 * that this Member is declared on which may be a supertype. The <code>declaredBy</code> attribute
	 * provided by the <code>describeType</code> method is currently ignored
	 * for consistency reasons, since it is not provided for all Member types.
	 */
	public function get owner () : ClassInfo {
		return _owner;
	}
	

}

}
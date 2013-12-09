/*
 * Copyright 2009 the original author or authors.
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

package org.spicefactory.parsley.tag.core {
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

import mx.core.IMXMLObject;

import flash.errors.IllegalOperationError;

/**
 * Extension of the default object definition tag that handles ids set in MXML.
 * To be used for root MXML object defintions only.
 * 
 * @author Jens Halm
 */
public class MxmlObjectDefinitionFactoryTag extends ObjectDefinitionFactoryTag implements IMXMLObject {


	/**
	 * @private
	 */
	public override function createNestedDefinition (registry:ObjectDefinitionRegistry) : ObjectDefinition {
		throw new IllegalOperationError("This tag may only be used for root object declarations");
	}
	
	/**
	 * @private
	 */
	public function initialized (document:Object, id:String) : void {
		this.id = id;
	}
	
	
}
}

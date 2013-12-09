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

package org.spicefactory.parsley.tag.messaging {
import org.spicefactory.parsley.core.scope.ScopeName;

/**
 * Convenient base class that tags for message receivers can extend if they
 * wish to allow the standard set of attributes: type, selector and scope.
 * When creating a custom tag where one or more of these values will be
 * set implicitly it is recommended to extend AbstractMessageReceiverDecorator
 * directly which does not contain any public properties.
 *
 * @author Jens Halm
 */
public class AbstractStandardReceiverDecorator extends AbstractMessageReceiverDecorator {


	/**
	 * The type of the messages the receiver wants to handle.
	 */
	public var type:Class;

	/**
	 * An optional selector value to be used in addition to selecting messages by type.
	 * Will be checked against the value of the property in the message marked with <code>[Selector]</code>
	 * or against the event type if the message is an event and does not have a selector property specified explicitly.
	 */
	public var selector:String;
	
	/**
	 * The scope this receiver wants to be applied to.
	 * The default is ScopeName.GLOBAL.
	 */
	public var scope:String = ScopeName.GLOBAL;

	
}

}

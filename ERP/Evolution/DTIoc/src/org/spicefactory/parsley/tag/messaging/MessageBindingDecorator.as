/*
 * Copyright 2008-2009 the original author or authors.
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
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.messaging.receiver.MessageReceiver;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.core.messaging.receiver.impl.MessageBinding;
import org.spicefactory.parsley.core.registry.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.scope.ScopeName;
import org.spicefactory.parsley.core.scope.ScopeManager;

[Metadata(name="MessageBinding", types="property", multiple="true")]
/**
 * Represents a Metadata, MXML or XML tag that can be used on properties which wish to be bound to a property value
 * of a particular message type dispatched through Parsleys central message router.
 * 
 * @author Jens Halm
 */
public class MessageBindingDecorator extends AbstractMessageReceiverDecorator implements ObjectDefinitionDecorator {


	[Required]
	/**
	 * The type of the messages the property wants to bind to.
	 */
	public var type:Class;

	/**
	 * @copy org.spicefactory.parsley.tag.messaging.AbstractStandardReceiverDecorator#selector
	 */
	public var selector:String;
	
	/**
	 * The scope this binding wants to be applied to.
	 * The default is ScopeName.GLOBAL.
	 */
	public var scope:String = ScopeName.GLOBAL;
	
	[Required]
	/**
	 * The name of the property of the message type whose value should be bound to the target property.
	 */
	public var messageProperty:String;

	[Target]
	/**
	 * The name of the property of the managed object whose value should be bound to the message property.
	 */
	public var targetProperty:String;
	
	/**
	 * @private
	 */
	protected override function createReceiver (provider:ObjectProvider, scopeManager:ScopeManager) : MessageReceiver {
		var messageType:ClassInfo = (type != null) ? ClassInfo.forClass(type, domain) : null;
		var target:MessageTarget = new MessageBinding(provider,	targetProperty, messageType, messageProperty, selector);
		scopeManager.getScope(scope).messageReceivers.addTarget(target);
		return target;
	}
	
	/**
	 * @private
	 */
	protected override function removeReceiver (receiver:MessageReceiver, scopeManager:ScopeManager) : void {
		scopeManager.getScope(scope).messageReceivers.removeTarget(MessageTarget(receiver));
	}

	
}

}

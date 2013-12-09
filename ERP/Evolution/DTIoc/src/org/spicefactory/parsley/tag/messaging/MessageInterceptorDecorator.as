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
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.messaging.receiver.MessageInterceptor;
import org.spicefactory.parsley.core.messaging.receiver.MessageReceiver;
import org.spicefactory.parsley.core.messaging.receiver.impl.DefaultMessageInterceptor;
import org.spicefactory.parsley.core.registry.ObjectDefinitionDecorator;
import org.spicefactory.parsley.core.scope.ScopeManager;

[Metadata(name="MessageInterceptor", types="method", multiple="true")]
/**
 * Represents a Metadata, MXML or XML tag that can be used on methods that want to intercept messages of a particular type
 * dispatched through Parsleys central message router.
 * 
 * @author Jens Halm
 */
public class MessageInterceptorDecorator extends AbstractStandardReceiverDecorator implements ObjectDefinitionDecorator {


	[Target]
	/**
	 * The name of the interceptor method.
	 */
	public var method:String;
	
	/**
	 * @private
	 */
	protected override function createReceiver (provider:ObjectProvider, scopeManager:ScopeManager) : MessageReceiver {
		var ic:MessageInterceptor = new DefaultMessageInterceptor(provider, method, type, selector);
		scopeManager.getScope(scope).messageReceivers.addInterceptor(ic);
		return ic;
	}
	
	/**
	 * @private
	 */
	protected override function removeReceiver (receiver:MessageReceiver, scopeManager:ScopeManager) : void {
		scopeManager.getScope(scope).messageReceivers.removeInterceptor(MessageInterceptor(receiver));
	}
	
	
}

}

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

package org.spicefactory.parsley.core.messaging.receiver.command {
import org.spicefactory.parsley.core.context.DynamicContext;
import org.spicefactory.parsley.core.context.DynamicObject;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.core.messaging.receiver.impl.AbstractMessageReceiver;

/**
 * @private 
 * Prepared for inclusion in version 2.2.0.
 * 
 * @author Jens Halm
 */
public class CommandProxy extends AbstractMessageReceiver implements MessageTarget {

	
	private var target:MessageTarget;
	private var context:DynamicContext;
	private var provider:DynamicInstanceProvider;
	
	
	function CommandProxy (provider:DynamicInstanceProvider, target:MessageTarget) {
		super(target.messageType, target.selector);
		this.provider = provider;
		this.target = target;
	}

	
	public function init (context:DynamicContext) : void {
		this.context = context;
	}

	
	public function handleMessage (message:Object) : void {
		
		var targetInstance:DynamicObject = provider.newInstance(context);
		
		try {
			target.handleMessage(message);
		}
		finally {
			targetInstance.remove();			
		}
	}
	
	
}
}

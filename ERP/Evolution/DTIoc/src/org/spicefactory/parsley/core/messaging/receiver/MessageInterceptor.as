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

package org.spicefactory.parsley.core.messaging.receiver {
import org.spicefactory.parsley.core.messaging.MessageProcessor;

/**
 * Represent a message interceptor that may be used to optionally cancel or suspend message processing.
 * 
 * @author Jens Halm
 */
public interface MessageInterceptor extends MessageReceiver {
	
	
	/**
	 * Intercepts a message. Processing further interceptors and regular targets will
	 * only happen if proceed is called on the specified processor.
	 * 
	 * @param processor the processor for the message
	 */
	function intercept (processor:MessageProcessor) : void ;

	
}
}

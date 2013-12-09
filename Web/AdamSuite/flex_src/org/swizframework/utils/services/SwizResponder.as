/*
 * Copyright 2010 Swiz Framework Contributors
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

package org.swizframework.utils.services
{
	import mx.rpc.IResponder;
	
	[ExcludeClass]
	
	public class SwizResponder implements IResponder
	{
		private var resultHandler:Function;
		private var faultHandler:Function;
		private var handlerArgs:Array;
		
		public function SwizResponder( resultHandler:Function, faultHandler:Function = null, handlerArgs:Array = null )
		{
			this.resultHandler = resultHandler;
			this.faultHandler = faultHandler;
			this.handlerArgs = handlerArgs;
		}
		
		public function result( data:Object ):void
		{
			if( handlerArgs == null )
			{
				resultHandler( data );
			}
			else
			{
				handlerArgs.unshift( data );
				resultHandler.apply( null, handlerArgs );
			}
		}
		
		public function fault( info:Object ):void
		{
			if( faultHandler != null )
			{
				try
				{
					faultHandler( info );
				}
				catch( error:Error )
				{
					handlerArgs.unshift( info );
					faultHandler.apply( null, handlerArgs );
				}
			}
			else
			{
				// todo: what if there is no fault handler applied to dynamic responder
				// ben says fails silently, maybe logging is smarter...
			}
		}
	}
}
package org.spicefactory.lib.logging {

import org.spicefactory.lib.flash.logging.LogEvent;
import flash.utils.Dictionary;

import org.spicefactory.lib.flash.logging.impl.AbstractAppender;
	
	
public class CachingAppender extends AbstractAppender {
	
	
	private var cache:Dictionary = new Dictionary();
	

	
	protected override function handleLogEvent (event:LogEvent) : void {
		if (isBelowThreshold(event.level)) return;
		var loggerName:String = Logger(event.target).name;
		var targetCache:Array = null;
		if (cache[loggerName] == undefined) {
			targetCache = new Array();
			cache[loggerName] = targetCache;
		} else {
			targetCache = cache[loggerName];
		}		
		trace(event.message);
		targetCache.push(event.message);
	}		
	
	
	public function getCount (loggerName:String) : uint {
		return (cache[loggerName] == undefined) ? 0 : cache[loggerName].length;
	}
	
	public function getCache (loggerName:String) : Array {
		return (cache[loggerName] == undefined) ? [] : cache[loggerName];
	}
	
	
}

}
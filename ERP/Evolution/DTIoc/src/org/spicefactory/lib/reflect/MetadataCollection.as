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
import org.spicefactory.lib.reflect.metadata.AssignableTo;
import org.spicefactory.lib.reflect.metadata.DefaultProperty;
import org.spicefactory.lib.reflect.metadata.MappedMetadata;
import org.spicefactory.lib.reflect.metadata.Required;

import flash.utils.Dictionary;

/**
 * @private
 * 
 * @author Jens Halm
 */
internal class MetadataCollection {
	
	
	private var unresolvedTags:Array;
	private var resolvedTags:Dictionary = new Dictionary();
	
	
	function MetadataCollection (unresolved:Array) {
		this.unresolvedTags = unresolved;
		for each (var type:Class in [MappedMetadata, Required, DefaultProperty, AssignableTo]) {
			resolvedTags[type] = [];
		}
		resolve(false);
	}
	
	private function resolve (force:Boolean) : void {
		if (unresolvedTags == null) return;
		var remaining:Array = new Array();
		for each (var meta:Metadata in unresolvedTags) {
			if (!meta.resolve() && !force) {
				remaining.push(meta);
				continue;
			}
			var tagsForName:Array = resolvedTags[meta.getKey()];
			if (tagsForName == null) {
				tagsForName = new Array();
				resolvedTags[meta.getKey()] = tagsForName;
			}
			tagsForName.push(meta);
		}
		unresolvedTags = (force) ? null : remaining;
	}
	
	internal function getMetadata (type:Object, validate:Boolean) : Array {
		if (resolvedTags[type] != undefined) {
			return prepareMetadata(resolvedTags[type] as Array, validate);
		}
		resolve(true);
		return (resolvedTags[type] == undefined) ? [] : prepareMetadata(resolvedTags[type] as Array, validate);
	}
	
	internal function getAllMetadata (validate:Boolean) : Array {
		resolve(true);
		var all:Array = new Array();
		for each (var metadata:Array in resolvedTags) {
			all = all.concat(prepareMetadata(metadata, validate));
		}
		return all;
	}
	
	private function prepareMetadata (metas:Array, validate:Boolean) : Array {
		var prepared:Array = new Array();
		for (var i:uint = 0; i < metas.length; i++) {
			prepared[i] = Metadata(metas[i]).getExternalValue(validate, i == 0);
		}
		return prepared;
	}
	
	
}
}

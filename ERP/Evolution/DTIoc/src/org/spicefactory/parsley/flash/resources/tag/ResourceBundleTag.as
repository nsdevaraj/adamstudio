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

package org.spicefactory.parsley.flash.resources.tag {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.task.SequentialTaskGroup;
import org.spicefactory.lib.task.TaskGroup;
import org.spicefactory.lib.task.events.TaskEvent;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.registry.ObjectDefinitionFactory;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.registry.RootObjectDefinition;
import org.spicefactory.parsley.core.registry.impl.DefaultObjectDefinitionFactory;
import org.spicefactory.parsley.flash.resources.impl.DefaultBundleLoaderFactory;
import org.spicefactory.parsley.flash.resources.impl.DefaultResourceBundle;
import org.spicefactory.parsley.flash.resources.spi.BundleLoaderFactory;
import org.spicefactory.parsley.flash.resources.spi.ResourceBundleSpi;
import org.spicefactory.parsley.flash.resources.spi.ResourceManagerSpi;

import flash.errors.IllegalOperationError;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.getQualifiedClassName;

/**
 * Represent the resource-bundle XML tag.
 * 
 * @author Jens Halm
 */
[AsyncInit]
public class ResourceBundleTag extends EventDispatcher implements ObjectDefinitionFactory {
	
	
	[Required]
	/**
	 * The id of the bundle.
	 */
	public var id:String;
	
	[Required]
	/** 
     * The basename of files containing messages for this bundle.
	 * For the locale #cdi en_US #cdi for example the basename messages/tooltips will instruct Parsley to load the 
	 * following files: #cdi messages/tooltips_en_US.xml #cdi, #cdi messages/tooltips_en.xml #cdi and #cdi messages/tooltips.xml #cdi.
     */ 
	public var basename:String;

	/**
	 * The type of the ResourceBundle implementation.
	 */
	public var type:Class = DefaultResourceBundle;
	
	/**
	 * The type of the BundleLoaderFactory to use when loading bundle files.
	 */
	public var loaderFactory:Class = DefaultBundleLoaderFactory;
	
	/**
	 * Indicates whether the bundle is localized.
	 * If set to false the framework will only load 
     * the resources for the basename like #cdi messages/tooltips.xml #cdi and not look for files with localized messages.
	 */
	public var localized:Boolean = true;
	
	/**
	 * Indicates whether the framework should 
     * ignore the country code of the active locale for this bundle.
	 */
	public var ignoreCountry:Boolean = false;
	
	
	[Inject]
	/**
	 * The ResourceManager this bundle belongs to.
	 */
	public var resourceManager:ResourceManagerSpi;
	
	
	[Init]
	/**
	 * Loads the bundle configured by this tag class and adds it to the ResourceManager.
	 */
	public function loadBundle () : void {
		var bundleInstance:Object = new type();
		if (!(bundleInstance is ResourceBundleSpi)) {
			throw new IllegalArgumentError("Specified type " + getQualifiedClassName(type) 
					+ " does not implement ResourceBundleSpi"); 
		}
		var bundle:ResourceBundleSpi = bundleInstance as ResourceBundleSpi;
		var factoryInstance:Object = new loaderFactory();
		if (!(factoryInstance is BundleLoaderFactory)) {
			throw new IllegalArgumentError("Specified loaderFactory " + getQualifiedClassName(type) 
					+ " does not implement BundleLoaderFactory"); 
		}
		bundle.bundleLoaderFactory = factoryInstance as BundleLoaderFactory;
		bundle.init(id, basename, localized, ignoreCountry);
		
		var tg:TaskGroup = new SequentialTaskGroup();
		tg.data = bundle;
		bundle.addLoaders(resourceManager.currentLocale, tg);
		tg.addEventListener(TaskEvent.COMPLETE, loaderComplete);
		tg.addEventListener(ErrorEvent.ERROR, loaderError);
		tg.start();
	}
	
	
	private function loaderComplete (event:Event) : void {
		var bundle:ResourceBundleSpi = event.target.data as ResourceBundleSpi;
		bundle.applyNewMessages();
		resourceManager.addBundle(bundle);
		dispatchEvent(new Event(Event.COMPLETE));
	}
	
	private function loaderError (event:Event) : void {
		dispatchEvent(event.clone());
	}
	
	public function createRootDefinition (registry:ObjectDefinitionRegistry) : RootObjectDefinition {
		var factory:ObjectDefinitionFactory 
				= new DefaultObjectDefinitionFactory(ResourceBundleTag, id, false, true, int.MIN_VALUE, new TagInstantiator(this));		
		return factory.createRootDefinition(registry);
	}
	
	public function createNestedDefinition (registry:ObjectDefinitionRegistry) : ObjectDefinition {
		throw new IllegalOperationError("This tag can only be used as a root definition");
	}
}
}

import org.spicefactory.parsley.flash.resources.tag.ResourceBundleTag;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.registry.definition.ObjectInstantiator;

class TagInstantiator implements ObjectInstantiator {
	private var tag:ResourceBundleTag;
	function TagInstantiator (tag:ResourceBundleTag) {
		this.tag = tag;
	}
	public function instantiate (context:Context):Object {
		return tag;
	}
}

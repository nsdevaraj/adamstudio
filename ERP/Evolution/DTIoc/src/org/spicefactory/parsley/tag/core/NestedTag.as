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

/**
 * Marker interface for configuration tags that are not intended for use as root object tags 
 * in MXML or XML configuration. The distinction is necessary as the mxmlc compiler creates
 * public properties for all nested tags with bindings so that they are indistinguishable from
 * the real root object tags, causing unintended side effects.
 * 
 * @author Jens Halm
 */
public interface NestedTag {
}
}

package org.spicefactory.lib.xml.mapper {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.xml.XmlObjectMapper;
import org.spicefactory.lib.xml.XmlProcessorContext;

/**
 * @private
 * 
 * @author Jens Halm
 */
internal class PropertyMapperDelegate implements XmlObjectMapper {

	
	private var builder:PropertyMapperBuilder;
	private var mapper:XmlObjectMapper;
	
	
	function PropertyMapperDelegate (builder:PropertyMapperBuilder) {
		this.builder = builder;
	}

	
	public function get objectType () : ClassInfo {
		return builder.objectType;
	}
	
	public function get elementName () : QName {
		return builder.elementName;
	}
	
	public function mapToObject (element:XML, context:XmlProcessorContext) : Object {
		if (mapper == null) mapper = builder.mapper;
		return mapper.mapToObject(element, context);
	}
	
	public function mapToXml (object:Object, context:XmlProcessorContext) : XML {
		if (mapper == null) mapper = builder.mapper;
		return mapper.mapToXml(object, context);
	}


}
}
/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.model.processor
{
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.model.vo.Propertiespresets;
	import com.adams.dt.model.vo.Proppresetstemplates;
	import com.adams.swizdao.model.processor.AbstractProcessor;
	import com.adams.swizdao.model.vo.IValueObject;
	import com.adams.swizdao.util.GetVOUtil;

	public class ProppresetstemplatesProcessor extends AbstractProcessor
	{   
		
		[Inject("propertiespresetsDAO")]
		public var propertiespresetsDAO:AbstractDAO;
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var proppresetstemplatesvo:Proppresetstemplates = vo as Proppresetstemplates;
				proppresetstemplatesvo.propertiesPresets = GetVOUtil.getVOObject( proppresetstemplatesvo.propertypresetFK, propertiespresetsDAO.collection.items, propertiespresetsDAO.destination, Propertiespresets ) as Propertiespresets;
				super.processVO(vo);
			}
		}
	}
}
/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.model.processor
{
	import com.adams.dt.model.vo.Propertiespresets;
	import com.adams.swizdao.model.processor.AbstractProcessor;
	import com.adams.swizdao.model.vo.IValueObject;

	public class PropertiespresetsProcessor extends AbstractProcessor
	{   
		/**
		 * 
		 * @param vo
		 * 
		 */		 
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var propertiespresetsvo:Propertiespresets = vo as Propertiespresets;
				super.processVO(vo);
			}
		}
	}
}
/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.model.processor
{
	import com.adams.dt.model.vo.Teamlinestemplates;
	import com.adams.swizdao.model.processor.AbstractProcessor;
	import com.adams.swizdao.model.vo.IValueObject;

	public class TeamlinestemplatesProcessor extends AbstractProcessor
	{    
		
		//@TODO
		override public function processVO( vo:IValueObject ):void {
			if( !vo.processed ) {
				var teamlinestemplatesvo:Teamlinestemplates = vo as Teamlinestemplates;
				super.processVO( vo );
			}
		}
	}
}
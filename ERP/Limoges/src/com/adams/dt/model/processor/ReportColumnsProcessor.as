/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.model.processor
{
	import com.adams.dt.model.vo.ReportColumns;
	import com.adams.swizdao.model.processor.AbstractProcessor;
	import com.adams.swizdao.model.vo.IValueObject;

	public class ReportColumnsProcessor extends AbstractProcessor
	{   
		public function ReportColumnsProcessor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var reportcolumnsvo:ReportColumns = vo as ReportColumns;
				super.processVO(vo);
			}
		}
	}
}
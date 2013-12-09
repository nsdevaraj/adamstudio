/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  PDFTool

@internal 

*/
package com.adams.pdf.model.processor
{
	import com.adams.pdf.model.AbstractDAO;
	import com.adams.pdf.model.vo.FileDetails;
	
	import com.adams.swizdao.model.vo.IValueObject;
	import com.adams.swizdao.model.processor.AbstractProcessor;

	public class FileDetailsProcessor extends AbstractProcessor
	{   
		public function FileDetailsProcessor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var filedetailsvo:FileDetails = vo as FileDetails;
				super.processVO(vo);
			}
		}
	}
}
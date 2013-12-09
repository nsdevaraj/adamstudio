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
	import com.adams.pdf.model.vo.CommentVO;
	import com.adams.pdf.model.vo.Persons;
	import com.adams.swizdao.model.processor.AbstractProcessor;
	import com.adams.swizdao.model.vo.IValueObject;
	import com.adams.swizdao.util.GetVOUtil;

	public class CommentVOProcessor extends AbstractProcessor
	{   
		[Inject("personsDAO")]
		public var personsDAO:AbstractDAO;
		public function CommentVOProcessor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var commentvo:CommentVO = vo as CommentVO;
				commentvo.personDetails = GetVOUtil.getVOObject( commentvo.createdby, personsDAO.collection.items, personsDAO.destination, Persons ) as Persons;
				super.processVO(vo);
			}
		}
	}
}
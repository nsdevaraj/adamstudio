package com.adams.scrum.models.processor
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.Companies;
	import com.adams.scrum.models.vo.IValueObject;
	import com.adams.scrum.models.vo.Persons;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.utils.GetVOUtil;

	public class PersonProcessor extends AbstractProcessor
	{
		[Inject("companyDAO")]
		public var companyDAO:AbstractDAO;
		
		[Inject]
		public var companyProcessor:CompanyProcessor;
		
		public function PersonProcessor()
		{
			super();
		} 	
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var person:Persons = vo as Persons;
				person.companyObject = GetVOUtil.getVOObject(person.companyFk,companyDAO.collection.items,companyDAO.destination,Companies) as Companies;
				super.processVO(vo);
			}
		}
	}
}
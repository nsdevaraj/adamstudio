package com.adams.scrum.models.processor
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.Domains;
	import com.adams.scrum.models.vo.IValueObject;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.utils.GetVOUtil;
	
	import mx.collections.ArrayCollection;

	public class DomainProcessor extends AbstractProcessor
	{
		[Inject("productDAO")]
		public var productDAO:AbstractDAO;
		
		[Inject]
		public var productProcessor:ProductProcessor;
		
		public function DomainProcessor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var domain:Domains = vo as Domains;
				GetVOUtil.sortArrayCollection(productDAO.destination,domain.productSet);
				productProcessor.processCollection(domain.productSet);
				var productCollection:ArrayCollection = new ArrayCollection();
				for each(var product:Products in domain.productSet){
					productCollection.addItem(product);
				}
				productDAO.collection.modifyItems(productCollection);
				super.processVO(vo);
			}
		}
	}
}
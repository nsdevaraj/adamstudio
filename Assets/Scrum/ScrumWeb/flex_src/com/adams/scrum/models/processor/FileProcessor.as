package com.adams.scrum.models.processor
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.Files;
	import com.adams.scrum.models.vo.IValueObject;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.models.vo.Stories;
	import com.adams.scrum.models.vo.Tasks;
	import com.adams.scrum.utils.GetVOUtil;

	public class FileProcessor extends AbstractProcessor
	{
		[Inject("taskDAO")]
		public var taskDAO:AbstractDAO;
		
		[Inject("productDAO")]
		public var productDAO:AbstractDAO;
		
		[Inject("storyDAO")]
		public var storyDAO:AbstractDAO;
		
		public function FileProcessor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var file:Files = vo as Files;
				
				file.productObject = GetVOUtil.getVOObject(file.productFk,productDAO.collection.items ,productDAO.destination,Products) as Products;
	
				if(file.taskFk!=0)
				file.taskObject = GetVOUtil.getVOObject(file.taskFk,taskDAO.collection.items ,taskDAO.destination,Tasks) as Tasks;
				
				if(file.storyFk!=0)
				file.storyObject = GetVOUtil.getVOObject(file.storyFk,storyDAO.collection.items ,storyDAO.destination,Stories) as Stories;
				super.processVO(vo);
			}
		}
	}
}
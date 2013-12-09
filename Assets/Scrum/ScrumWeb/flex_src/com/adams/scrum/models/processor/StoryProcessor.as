package com.adams.scrum.models.processor
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.Files;
	import com.adams.scrum.models.vo.IValueObject;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.models.vo.Status;
	import com.adams.scrum.models.vo.Stories;
	import com.adams.scrum.models.vo.Tasks;
	import com.adams.scrum.models.vo.Themes;
	import com.adams.scrum.models.vo.Versions;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.Utils;
	
	import mx.collections.ArrayCollection;

	public class StoryProcessor extends AbstractProcessor
	{
		
		[Inject("themeDAO")]
		public var themeDAO:AbstractDAO;
		
		[Inject("taskDAO")]
		public var taskDAO:AbstractDAO;
		
		[Inject("fileDAO")]
		public var fileDAO:AbstractDAO; 
		
		[Inject("statusDAO")]
		public var statusDAO:AbstractDAO;
		
		[Inject]
		public var taskProcessor:TaskProcessor;
		
		[Inject]
		public var themeProcessor:ThemeProcessor;
		
		[Inject]
		public var fileProcessor:FileProcessor;
		
		[Inject("productDAO")]
		public var productDAO:AbstractDAO;
		 
		[Inject("versionDAO")]
		public var versionDAO:AbstractDAO;

		public function StoryProcessor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var story:Stories = vo as Stories;
				 
				themeProcessor.processCollection(story.themeSet);
				var themeCollection:ArrayCollection = new ArrayCollection();
				for each(var theme:Themes in story.themeSet){
					themeCollection.addItem(theme);
				}
				themeDAO.collection.modifyItems(themeCollection);
				
				taskProcessor.processCollection(story.taskSet);
				var taskCollection:ArrayCollection = new ArrayCollection();
				for each(var task:Tasks in story.taskSet){
					taskCollection.addItem(task);
				}
				taskDAO.collection.modifyItems(taskCollection);
				
				fileProcessor.processCollection(story.fileCollection);
				var fileCollection:ArrayCollection = new ArrayCollection()
				for each(var file:Files in story.fileCollection){
					fileCollection.addItem(file);
				}
				fileDAO.collection.modifyItems(fileCollection);
				story.versionObject = GetVOUtil.getVOObject(story.versionFk,versionDAO.collection.items,versionDAO.destination,Versions) as Versions;
				story.productObject = GetVOUtil.getVOObject(story.productFk,productDAO.collection.items,productDAO.destination,Products) as Products;
				Utils.addArrcStrictItem(story,story.productObject.storyCollection,Utils.STORYKEY);
				story.statusObject = GetVOUtil.getVOObject(story.storyStatusFk,statusDAO.collection.items,statusDAO.destination,Status) as Status;
				super.processVO(vo);
			}
		}
	}
}
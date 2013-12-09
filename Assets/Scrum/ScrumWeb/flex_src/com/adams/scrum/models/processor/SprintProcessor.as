package com.adams.scrum.models.processor
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.IValueObject;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.models.vo.Sprints;
	import com.adams.scrum.models.vo.Status;
	import com.adams.scrum.models.vo.Stories;
	import com.adams.scrum.models.vo.Teams;
	import com.adams.scrum.models.vo.Versions;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.Utils;
	
	import mx.collections.ArrayCollection;

	
	public class SprintProcessor extends AbstractProcessor
	{
		[Inject("storyDAO")]
		public var storyDAO:AbstractDAO;
		
		[Inject("teamDAO")]
		public var teamDAO:AbstractDAO;
		
		[Inject("productDAO")]
		public var productDAO:AbstractDAO;
		
		[Inject("statusDAO")]
		public var statusDAO:AbstractDAO;
		
		[Inject]
		public var storyProcessor:StoryProcessor;
		
		[Inject("versionDAO")]
		public var versionDAO:AbstractDAO;

		public function SprintProcessor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var sprint:Sprints = vo as Sprints;
				
				storyProcessor.processCollection(sprint.storySet);
				var storyCollection:ArrayCollection = new ArrayCollection();
				for each(var story:Stories in sprint.storySet){
					storyCollection.addItem(story);
				}
				storyDAO.collection.modifyItems(storyCollection);
				sprint.versionObject = GetVOUtil.getVOObject(sprint.versionFk,versionDAO.collection.items,versionDAO.destination,Versions) as Versions;
				sprint.teamObject = GetVOUtil.getVOObject(sprint.teamFk,teamDAO.collection.items,teamDAO.destination,Teams) as Teams;
				sprint.productObject = GetVOUtil.getVOObject(sprint.productFk,productDAO.collection.items,productDAO.destination,Products) as Products;
				Utils.addArrcStrictItem(sprint,sprint.productObject.sprintCollection,Utils.SPRINTKEY);
				
				sprint.statusObject = GetVOUtil.getVOObject(sprint.sprintStatusFk,statusDAO.collection.items,statusDAO.destination,Status) as Status;
				super.processVO(vo);
			}			
		}
	}
}
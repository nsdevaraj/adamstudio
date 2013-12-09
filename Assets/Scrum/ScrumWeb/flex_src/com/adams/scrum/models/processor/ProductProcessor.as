package com.adams.scrum.models.processor
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.Domains;
	import com.adams.scrum.models.vo.IValueObject;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.models.vo.Sprints;
	import com.adams.scrum.models.vo.Status;
	import com.adams.scrum.models.vo.Stories;
	import com.adams.scrum.models.vo.Themes;
	import com.adams.scrum.models.vo.Versions;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.Utils;
	
	import mx.collections.ArrayCollection;

	public class ProductProcessor extends AbstractProcessor
	{
		[Inject("sprintDAO")]
		public var sprintDAO:AbstractDAO;
		
		[Inject("domainDAO")]
		public var domainDAO:AbstractDAO;
		
		[Inject("themeDAO")]
		public var themeDAO:AbstractDAO;
		
		[Inject("versionDAO")]
		public var versionDAO:AbstractDAO;
		
		[Inject("storyDAO")]
		public var storyDAO:AbstractDAO;
		
		[Inject("statusDAO")]
		public var statusDAO:AbstractDAO;
		
		[Inject]
		public var storyProcessor:StoryProcessor;
		 
		[Inject]
		public var sprintProcessor:SprintProcessor;
		
		[Inject]
		public var domainProcessor:DomainProcessor;
		
		public function ProductProcessor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var product:Products = vo as Products; 
				var storyCollection:ArrayCollection = new ArrayCollection();
				
				storyProcessor.processCollection(product.storyCollection);
				for each(var story:Stories in product.storyCollection){
					storyCollection.addItem(story);
				}
				storyDAO.collection.modifyItems(storyCollection);
				
				sprintProcessor.processCollection(product.sprintCollection);
				var sprintCollection:ArrayCollection = new ArrayCollection();				
				for each(var sprint:Sprints in product.sprintCollection){
					sprintCollection.addItem(sprint);
				}
				sprintDAO.collection.modifyItems(sprintCollection);
				
				var versionCollection:ArrayCollection = new ArrayCollection();
				for each(var version:Versions in product.versionSet){
					versionCollection.addItem(version);
				}
				versionDAO.collection.modifyItems(versionCollection);
				
				var themeCollection:ArrayCollection = new ArrayCollection();
				for each(var theme:Themes in product.themeSet){
					themeCollection.addItem(theme);
				}
				themeDAO.collection.modifyItems(themeCollection);
				
				product.domainObject = GetVOUtil.getVOObject(product.domainFk,domainDAO.collection.items,domainDAO.destination,Domains) as Domains;
				Utils.addArrcStrictItem(product,product.domainObject.productSet,Utils.PRODUCTKEY);
				product.statusObject = GetVOUtil.getVOObject(product.productStatusFk,statusDAO.collection.items,statusDAO.destination,Status) as Status;
				if(product.productRoles)if(product.productRoles.length>0) product.productRolesArr = product.productRoles.toString().split(',');
				if(product.productTasktypes)if(product.productTasktypes.length>0)  product.productTaskTypeArr = product.productTasktypes.toString().split(',');
				super.processVO(vo);
			}
		}
	}
}
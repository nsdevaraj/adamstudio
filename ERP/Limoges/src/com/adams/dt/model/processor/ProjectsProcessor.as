/*

Copyright (c) 2011 Adams Studio India, All Rights Reserved 

@author   NS Devaraj
@contact  nsdevaraj@gmail.com
@project  Limoges

@internal 

*/
package com.adams.dt.model.processor
{
	import com.adams.dt.model.AbstractDAO;
	import com.adams.dt.model.vo.Categories;
	import com.adams.dt.model.vo.Presetstemplates;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adams.swizdao.model.processor.AbstractProcessor;
	import com.adams.swizdao.model.vo.IValueObject;
	import com.adams.swizdao.util.GetVOUtil;

	public class ProjectsProcessor extends AbstractProcessor
	{   
		
		[Inject("presetstemplatesDAO")]
		public var presetstemplatesDAO:AbstractDAO;
		
		[Inject("categoriesDAO")]
		public var categoriesDAO:AbstractDAO;
		
		[Inject("propertiespjDAO")]
		public var propertiespjDAO:AbstractDAO;
		
		[Inject("workflowstemplatesDAO")]
		public var workflowstemplatesDAO:AbstractDAO;
		
		[Inject("tasksDAO")]
		public var taskDAO:AbstractDAO; 
		
		//@TODO
		override public function processVO( vo:IValueObject ):void {
			if( !vo.processed ) {
				var projectsvo:Projects = vo as Projects;
				projectsvo.presetTemplateFK = GetVOUtil.getVOObject( projectsvo.presetTemplateID, presetstemplatesDAO.collection.items, presetstemplatesDAO.destination, Presetstemplates ) as Presetstemplates;
				projectsvo.categories = GetVOUtil.getVOObject( projectsvo.categoryFKey, categoriesDAO.collection.items, categoriesDAO.destination, Categories ) as Categories;
				projectsvo.workflowTemplate = GetVOUtil.getVOObject( projectsvo.wftFK, workflowstemplatesDAO.collection.items, workflowstemplatesDAO.destination, Workflowstemplates ) as Workflowstemplates;
				categoriesDAO.processor.processVO( projectsvo.categories );
				workflowstemplatesDAO.processor.processVO(projectsvo.workflowTemplate);
				propertiespjDAO.processor.processCollection( projectsvo.propertiespjSet );
				if(projectsvo.finalTask)
				{
					if(!projectsvo.finalTask.processed)projectsvo.finalTask.workflowtemplateFK = GetVOUtil.getVOObject( projectsvo.finalTask.wftFK, workflowstemplatesDAO.collection.items, workflowstemplatesDAO.destination, Workflowstemplates ) as Workflowstemplates;
				}
				super.processVO( vo ); 
			}
		}
	}
}
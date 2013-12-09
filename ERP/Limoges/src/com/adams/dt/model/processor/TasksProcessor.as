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
	import com.adams.dt.model.vo.Persons;
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.model.vo.Workflowstemplates;
	import com.adams.swizdao.model.processor.AbstractProcessor;
	import com.adams.swizdao.model.vo.IValueObject;
	import com.adams.swizdao.util.GetVOUtil;

	public class TasksProcessor extends AbstractProcessor
	{   
		[Inject("projectsDAO")]
		public var projectsDAO:AbstractDAO;
		
		[Inject("workflowstemplatesDAO")]
		public var workflowstemplatesDAO:AbstractDAO;
		
		[Inject("personsDAO")]
		public var personsDAO:AbstractDAO;
		
		public function TasksProcessor()
		{
			super();
		}
		
		//@TODO
		override public function processVO( vo:IValueObject ):void {
			if( !vo.processed ) {
				var tasksvo:Tasks = vo as Tasks;
				tasksvo.projectObject = GetVOUtil.getVOObject( tasksvo.projectFk, projectsDAO.collection.items, projectsDAO.destination, Projects ) as Projects;
				tasksvo.workflowtemplateFK = GetVOUtil.getVOObject( tasksvo.wftFK, workflowstemplatesDAO.collection.items, workflowstemplatesDAO.destination, Workflowstemplates ) as Workflowstemplates;
				tasksvo.personDetails = GetVOUtil.getVOObject( tasksvo.personFK, personsDAO.collection.items, personsDAO.destination, Persons ) as Persons;
				if(!tasksvo.projectObject.processed) projectsDAO.processor.processVO( tasksvo.projectObject);
				super.processVO( vo );
				if(tasksvo.nextTask)
				{
					if(!tasksvo.nextTask.processed)processVO( tasksvo.nextTask );
				}
				if(tasksvo.previousTask)
				{
					if(!tasksvo.previousTask.processed)processVO( tasksvo.previousTask );
				}
			}
		}
	}
}
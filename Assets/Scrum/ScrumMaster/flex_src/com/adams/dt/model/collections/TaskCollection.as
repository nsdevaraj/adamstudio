package com.adams.dt.model.collections
{
	import com.adams.dt.model.vo.Tasks;
	import com.adams.dt.utils.GetVOUtil;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	public final class TaskCollection extends AbstractCollection
	{ /*
		[Inject]
		public var projectList:ProjectCollection; */
		public function TaskCollection()
		{
			super();
		}
			
	/*	override public function set items(v:IList):void {
			for each(var task:Tasks in v){
				var tsk:Tasks = task as Tasks;
				tsk.projectObject = GetVOUtil.getProjectObject(task.projectFK, projectList.items as ArrayCollection);
				_items.addItem(tsk); 
			}
		}*/
			 
	}
}
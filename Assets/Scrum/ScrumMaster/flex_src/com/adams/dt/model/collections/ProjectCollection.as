package com.adams.dt.model.collections
{
	import com.adams.dt.model.vo.Projects;
	import com.adams.dt.model.vo.Tasks;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	public final class ProjectCollection extends AbstractCollection
	{
		public function ProjectCollection()
		{
			super();
		}
			
		override public function set items(v:IList):void {
			var resultAC:ArrayCollection = v as ArrayCollection;
			for each(var arr:Array in resultAC){
				var prj:Projects = arr[0] as Projects;
				var tsk:Tasks = arr[1] as Tasks; 
				prj.currentTaskDateStart = tsk.tDateCreation;
				prj.wftFK = tsk.wftFK;
				_items.addItem(prj); 
			}
		}
			 
	}
}
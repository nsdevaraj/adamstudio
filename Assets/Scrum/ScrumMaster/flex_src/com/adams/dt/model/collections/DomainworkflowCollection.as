package com.adams.dt.model.collections
{
	import com.adams.dt.model.vo.DomainWorkflow;
	
	import mx.collections.IList;

	public class DomainworkflowCollection extends AbstractCollection
	{
		public function DomainworkflowCollection()
		{
			super();
		}
		override public function set items(v:IList):void {
			for each(var obj:Object in v){
				_items.addItem(obj as DomainWorkflow); 
			}
		}
	}
}
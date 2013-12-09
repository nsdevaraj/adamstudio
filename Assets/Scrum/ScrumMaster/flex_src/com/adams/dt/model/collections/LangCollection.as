package com.adams.dt.model.collections
{
	import com.adams.dt.model.vo.LangEntries;
	
	import mx.collections.IList;

	public class LangCollection extends AbstractCollection
	{
		public function LangCollection()
		{
			super();
		}
		override public function set items(v:IList):void {
			for each(var obj:Object in v){
				_items.addItem(obj as LangEntries); 
			}
		}
	}
}
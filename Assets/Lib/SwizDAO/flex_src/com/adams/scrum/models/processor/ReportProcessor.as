package com.adams.scrum.models.processor
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.vo.Columns;
	import com.adams.scrum.models.vo.IValueObject;
	import com.adams.scrum.models.vo.Reports;
	import com.adams.scrum.utils.GetVOUtil;
	
	import mx.collections.ArrayCollection;

	public class ReportProcessor extends AbstractProcessor
	{
		[Inject("columnDAO")]
		public var columnDAO:AbstractDAO;
			
		public function ReportProcessor()
		{
			super();
		}
		//@TODO
		override public function processVO(vo:IValueObject):void
		{
			if(!vo.processed){
				var report:Reports = vo as Reports;
				
				var columnCollection:ArrayCollection = new ArrayCollection();
				for each(var col:Columns in report.columnSet){
					columnCollection.addItem(col);
				}
				columnDAO.collection.modifyItems(columnCollection);
				
				report.barCol = GetVOUtil.getVOObject(report.barcolFk,report.columnSet,columnDAO.destination,Columns) as Columns;
				report.seriesCol = GetVOUtil.getVOObject(report.seriescolFk,report.columnSet,columnDAO.destination,Columns) as Columns;
				super.processVO(vo);
			}
		}
	}
}
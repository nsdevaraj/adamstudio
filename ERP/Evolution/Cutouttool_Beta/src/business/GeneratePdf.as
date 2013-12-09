package business
{
	import flash.display.DisplayObject;
	
	import mx.collections.ICollectionView;
	import mx.controls.DataGrid;
	
	public class GeneratePdf
	{
		import business.org.alivepdf.pdf.PDF;
		import business.org.alivepdf.image.ImageFormat;
		import business.org.alivepdf.drawing.DashedLine;
		import business.org.alivepdf.display.*;
		import business.org.alivepdf.layout.*;
		import business.org.alivepdf.colors.*;
		import business.org.alivepdf.transitions.Transition;
		import business.org.alivepdf.fonts.FontFamily;
		import business.org.alivepdf.transitions.Dimension;
		import business.org.alivepdf.display.PageMode;
		import business.org.alivepdf.fonts.Style;
		import business.org.alivepdf.viewing.*;
		import business.org.alivepdf.saving.Download;
		import business.org.alivepdf.saving.Method;
		private var displayData:ICollectionView;
		public function GeneratePdf(data:ICollectionView)
		{
			displayData = data;
			genrate()
		}
		
		private function generate():void{
			var display:DisplayObject = new DisplayObject();
			var dataGrid:DataGrid = new DataGrid();
			dataGrid.dataProvider = 
			display.
			
		}

	}
}
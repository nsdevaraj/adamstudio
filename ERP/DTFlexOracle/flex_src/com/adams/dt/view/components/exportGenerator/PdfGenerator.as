package com.adams.dt.view.components.exportGenerator
{
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.model.ModelLocator;
	
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	import org.alivepdf.colors.RGBColor;
	import org.alivepdf.data.Grid;
	import org.alivepdf.data.GridColumn;
	import org.alivepdf.display.Display;
	import org.alivepdf.drawing.Joint;
	import org.alivepdf.fonts.FontFamily;
	import org.alivepdf.fonts.Style;
	import org.alivepdf.layout.Align;
	import org.alivepdf.layout.Layout;
	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	import org.alivepdf.saving.Method; 
	
	public class PdfGenerator extends PDF
	{
		[Bindable]
	    public var model:ModelLocator = ModelLocator.getInstance();
	    private var _propertiesArr:Array = [];
		private var _pdfBytes:ByteArray = new ByteArray();	
		private var _generatePDF:PDF;
		public function PdfGenerator()
		{
			super( Orientation.LANDSCAPE,Unit.MM,Size.A4,0 ) 
			setDisplayMode( Display.REAL, Layout.SINGLE_PAGE ); 
		}
		private var _getIntialY:int = 40;
		private var _getGridY:int = 40;
		private var _pdGrid:Grid
		public function createPdf( pdfColl:ArrayCollection , projectsComments:String ):void
		{
			generateGridColumns();
			addPage();
	        textStyle( new RGBColor(0), 1 );
	        setFont( FontFamily.ARIAL, Style.NORMAL, 12 );
	        addText( model.currentProjects.projectName + ' Reports', 5, 10);
	        addText( Utils.getDomains(model.currentProjects.categories).categoryName, 5, 20);
	        addText( model.currentTime.toDateString(), 180, 20);
	        addText( GetVOUtil.getWorkflowTemplate(model.currentProjects.wftFK).taskLabel+', '+GetVOUtil.getPhaseTemplateObject(GetVOUtil.getWorkflowTemplate(model.currentProjects.wftFK).phaseTemplateFK).phaseName + ' PHASE', 5, 30);
	        setFont( FontFamily.ARIAL, Style.NORMAL, 12 );
	        addText( "Projects Comments:-"+projectsComments, 5, 25); 
			for(var i:int=0;i<pdfColl.length;i++)
			{
				_pdGrid = new Grid( pdfColl[i].properties,200, 100, new RGBColor( 0x666666 ), new RGBColor( 0xCCCCCC ), new RGBColor( 0 ), true, new RGBColor( 0x0 ), 1, Joint.MITER );
                _pdGrid.columns = _propertiesArr;	
                if(currentY >160)
         		{
         			addPage();
         			_getIntialY = 15;
                } 
           		setFont( FontFamily.ARIAL, Style.BOLD, 10 );      
            	addText( pdfColl[i].Category ,5, _getIntialY);
            	setFont( FontFamily.ARIAL, Style.NORMAL, 10 ); 
         		addGrid(_pdGrid, 5,_getGridY); 
         		_getIntialY = currentY+5
         		_getGridY = 10
	         }
			_pdfBytes = save( Method.LOCAL );
			var fileRef:FileReference = new FileReference();
			fileRef.save(_pdfBytes , model.currentProjects.projectName+".pdf");
			
		}
		private function generateGridColumns() :void 
		{
			var gridArr:Array = ["Field","Value"]
			for( var i:int =0;i<gridArr.length;i++)
			{
				var pdfGridColumn:GridColumn = new GridColumn( gridArr[i], gridArr[i], 90, Align.LEFT, Align.LEFT );
            	_propertiesArr.push( pdfGridColumn );
			}
		}
	}
}
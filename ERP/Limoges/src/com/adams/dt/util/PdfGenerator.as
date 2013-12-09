package com.adams.dt.util
{
	import com.adams.swizdao.model.vo.CurrentInstance;
	
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	import org.alivepdf.colors.RGBColor;
	import org.alivepdf.data.Grid;
	import org.alivepdf.data.GridColumn;
	import org.alivepdf.display.Display;
	import org.alivepdf.drawing.Joint;
	import org.alivepdf.fonts.CoreFont;
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
		public var _gridHeaderData:Array = [];
		public var _gridDataField:Array = [];
		public var _gridHeader:Array = [];
		private var saveByte:ByteArray = new ByteArray();
		public function PdfGenerator()
		{
			super(Orientation.PORTRAIT,Unit.MM,Size.A4,0);
			setDisplayMode( Display.REAL, Layout.SINGLE_PAGE );
		}
		
		private function gridHeaderCreation():void{
			_gridHeader = [];
			for(var i:int = 0; i<_gridHeaderData.length;i++){
				var gridHeader:GridColumn = new GridColumn(_gridHeaderData[i],_gridDataField[i],25,Align.CENTER,Align.LEFT);
				_gridHeader.push(gridHeader)
			}
		}
		
		public function createPdf(dataCollection:ArrayCollection):void{
			var datestr:Date = new Date();
			var str:String = datestr.date + '-' + String((datestr.month)+1) + '-' + datestr.fullYear;
			gridHeaderCreation()
			for(var i:int = 0; i<dataCollection.length;i++){
				if(dataCollection.getItemAt(i).bat_date == 'NULL'){
					dataCollection.getItemAt(i).bat_date = dataCollection.getItemAt(i).clt_date
				}
			}
			var _gridData:Grid = new Grid(dataCollection.toArray(),250,250,new RGBColor( 0xaedaff ), 
				new RGBColor( 0xffffff ),  false, new RGBColor( 0x00387c ), 1, Joint.MITER)
			_gridData.columns = _gridHeader;
			addPage();
			var boldFont:CoreFont = new CoreFont( FontFamily.TIMES_BOLD );
			var font:CoreFont = new CoreFont( FontFamily.TIMES );
			setFont(boldFont,  12);
			textStyle( new RGBColor(0x00387c),1); 
			setFont(font, 10)
			textStyle( new RGBColor(0x00387c),1); 
			addText("DashBoard Details",80,40)
			addText(str,160,20)
			setFont(font,  8)
			textStyle( new RGBColor(0x00387c),1); 
			addGrid(_gridData,5,45)
			savePdf();
		}
		
		private function savePdf():void{
			saveByte = save( Method.LOCAL );
			var fileRef:FileReference = new FileReference();
			fileRef.save(saveByte , "DocTrack.pdf");
		}
	}
}
package com.adams.dt.view.PDFTool
{
	import com.adams.dt.view.PDFTool.cl.huerta.pdf.PDFi;
	
	import flash.geom.Rectangle;
	
	import org.alivepdf.colors.RGBColor;
	import org.alivepdf.fonts.FontFamily;
	import org.alivepdf.fonts.Style;
	import org.alivepdf.pages.Page;

	public class MyPDF extends PDFi
	{
		public var headerText:String = "Title";
		public var footerLeft:String = "Creator";
		public var footerRight:String = "Date";
		public function MyPDF(orientation:String='Portrait', unit:String='Mm', pageSize:Object=null, rotation:int=0)
		{
			super(orientation, unit, pageSize, rotation);
		}
		override public function header():void
		{
			super.header();
			
			this.setXY(20,5);
           	this.setFont( FontFamily.ARIAL, Style.ITALIC, 8 );
           	this.textStyle(new RGBColor(uint(0x666666)));
 			this.addCell(this.currentPage.width - 40,20,this.headerText,0,0,'L');
 			this.setXY(20,5);
 			this.textStyle(new RGBColor(uint(0x666666)));
 			this.setFont( FontFamily.ARIAL, Style.ITALIC, 8 );
 			this.addCell(this.currentPage.width - 40,20,this.totalPages.toString(),0,0, 'R');
     		this.newLine(35);
     		
     		this.lineStyle(new RGBColor(uint(0x999999)),0.3);
     		this.drawRect(new Rectangle(20,25,this.currentPage.width - 40, 0.2));
		}  
		override public function footer():void
		{
			super.footer();
			
			this.setXY(20,this.currentPage.height - 25);
           	this.setFont( FontFamily.ARIAL, Style.ITALIC, 8 );
           	this.textStyle(new RGBColor(uint(0x666666)));
 			this.addCell(this.currentPage.width - 40,10,this.footerLeft,0,0,'L');
 			this.setXY(20,this.currentPage.height - 25);
 			this.textStyle(new RGBColor(uint(0x666666)));
 			this.setFont( FontFamily.ARIAL, Style.ITALIC, 8 );
 			this.addCell(this.currentPage.width - 40,10,this.footerRight,0,0, 'R');
     		
     		this.lineStyle(new RGBColor(uint(0x999999)),0.3);
     		this.drawRect(new Rectangle(20, this.currentPage.height - 30,this.currentPage.width - 40, 0.2));
			this.newLine(35);
		}
		
	}
}
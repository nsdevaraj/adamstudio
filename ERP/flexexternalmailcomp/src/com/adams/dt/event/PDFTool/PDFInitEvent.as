package com.adams.dt.event.PDFTool
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class PDFInitEvent extends CairngormEvent
	{
		
		public static const PDF_INIT : String = "pdfInit";
		
		public function PDFInitEvent()
		{
			
			super(PDF_INIT);
			
		}

	}
}
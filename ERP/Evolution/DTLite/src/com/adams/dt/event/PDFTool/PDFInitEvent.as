package com.adams.dt.event.PDFTool
{
	import com.universalmind.cairngorm.events.UMEvent;
	public final class PDFInitEvent extends UMEvent
	{
		public static const PDF_INIT : String = "pdfInit";
		public function PDFInitEvent()
		{
			super(PDF_INIT);
		}
	}
}

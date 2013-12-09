package com.adams.dt.util
{
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	import org.alivepdf.colors.RGBColor;
	import org.alivepdf.data.Grid;
	import org.alivepdf.data.GridColumn;
	import org.alivepdf.drawing.Joint;
	import org.alivepdf.layout.Align;
	import org.alivepdf.saving.Method;
	
	import spark.formatters.DateTimeFormatter;

	public class ExcelGenerator
	{
		public var _gridHeaderData:Array = [];
		public var _gridDataField:Array = [];
		public var _gridHeader:Array = [];
		private var saveByte:ByteArray = new ByteArray();
		private var template:String = "" +
			"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2//EN\"> " +
			"<HTML>" +
			"<HEAD>" +
			"    <META HTTP-EQUIV=\"CONTENT-TYPE\" CONTENT=\"application/octet_stream; charset=utf8\">" +
			"    <STYLE>" +
			"        <!-- " +
			"        BODY,DIV,TABLE,THEAD,TBODY,TFOOT,TR,TH,TD,P { font-family:\"Verdana\"; font-size:x-small }" +
			"         -->" +
			"    </STYLE>" +
			"</HEAD>" +
			"    <TR><TD></TD><TD></TD><TD></TD>" +
			"    <TR><TD></TD><TD></TD><TD></TD>" +
			"<BR>"+
			"<BODY TEXT=\"#000000\">" + 
			"<TABLE WIDTH=600 HEIGHT=600 BORDER=0>" +
			"<TR></TR>"+
			"<TD></TD>"+
			"<TD></TD>"+
			"<TABLE Border=\"0\">" +
			"    <TR><TD ColSpan=\"7\" ALIGN=\"RIGHT\" ><FONT Size=\"2\">##CURRENTDATE##</FONT></TD></TR>" + 
			"    <TR><TD></TD><TD></TD><TD></TD>" + 
			"</TABLE>" +
			"</TABLE>" + 
			"<TABLE HEIGHT=600 BORDER=0>" +
			"<TR></TR>"+
			"</TABLE>" + 
			"<TABLE Border=\"0\">" +
			"    <TR><TD></TD><TD></TD><TD></TD>" +
			"	 <TR><TD ColSpan=\"7\" ALIGN=\"CENTER\"><FONT Size=\"+2\">##PROJECTNAME##</FONT></TD></TR> " +  
			"</TABLE>" + 
			"</TABLE>" + 
			"<TABLE HEIGHT=600 BORDER=0>" +
			"<TR></TR>"+
			"</TABLE>" + 
			
			"<TABLE Border=\"0\">" +
			"    <TR><TD></TD><TD></TD><TD></TD>" +
			"</TABLE>" + 
			"<TABLE FRAME=VOID span=3 CELLSPACING=0 COLS=50 BORDER=1>" +
			"    <COLGROUP>##PROJCOLDESC##</COLGROUP>" +
			"    <TBODY >" +
			"        ##PROJHEADERS##" +
			"        ##PROJROWS##" +
			"    </TBODY>" +
			"</TABLE>" +
			"<TABLE WIDTH=600 BORDER=0>" +
			"<TR></TR>"+
			"<TR></TR>"+
			"<TR></TR>"+
			"</TABLE>" + 
			"<TABLE HEIGHT=600 BORDER=0>" +
			"<TR></TR>"+
			"<TR></TR>"+
			"<TR></TR>"+
			"</TABLE>" + 
			"</TD>"+
			"</BODY>" +
			"</HTML>";
		
		private var cContents:String = template;
		public function ExcelGenerator()
		{
		}
		
		private function createGridHeader():void{
			_gridHeader = [];
			for(var i:int = 0; i<_gridHeaderData.length;i++){
				var gridHeader:GridColumn = new GridColumn(_gridHeaderData[i],_gridDataField[i],25,Align.CENTER,Align.LEFT);
				_gridHeader.push(gridHeader)
			}
		}
		
		public function createExcel(dataCollection:ArrayCollection):void{
			var colDesc:String = "";
			var cHeaders:String = "";
			var cRows:String = "";
			var columnWidth:Array;
			var colunmData:Array = dataCollection.source
			createGridHeader()
			for(var i:int = 0; i<dataCollection.length;i++){
				if(dataCollection.getItemAt(i).bat_date == 'NULL'){
					dataCollection.getItemAt(i).bat_date = dataCollection.getItemAt(i).clt_date
				}
			}
			var _gridData:Grid = new Grid(dataCollection.toArray(),250,250,new RGBColor( 0xaedaff ), new RGBColor( 0xffffff ), false, new RGBColor( 0x00387c ), 1, Joint.MITER)
			_gridData.columns = _gridHeader;
			columnWidth = _gridData.columns;
			
			 // Column Width
			for(var j:int = 0; j<columnWidth.length;j++){
				colDesc += "<COL WIDTH=" + columnWidth[ j ].width + ">"; 
			}
			cContents = cContents.replace( "##PROJCOLDESC##", colDesc );
			
			cHeaders = "<TR>"
				
			for( var k:int = 0; k < columnWidth.length; k++ ) {
				cHeaders +="<TD BGCOLOR=\"#aedaff\" ALIGN=\"CENTRE\"><B><FONT Size=3 COLOR=#00387c>" + columnWidth[ k ].headerText + "</FONT></B></TD>";
			}
			cHeaders += "</TR>"
			cContents = cContents.replace( "##PROJHEADERS##",cHeaders );
			
			for( var m:int = 0; m < colunmData.length; m++ ) {
				cRows += "<TR>";
				for( var n:int = 0; n < _gridData.columns.length; n++ ) {
					var fieldEntry:String;
					var numVal:Number = Number( colunmData[ m ][ _gridData.columns[ n ].dataField ] )
					if( isNaN( numVal ) ){
						fieldEntry = colunmData[ m ][ _gridData.columns[ n ].dataField ];
					}
					else {
						fieldEntry = String( colunmData[ m ][ _gridData.columns[ n ].dataField ] );
						if(fieldEntry == "0"){
							fieldEntry = ""
						}
					}
					
					cRows += "<TD ALIGN=\"LEFT\"><FONT Size=2 COLOR=#00387c>" +fieldEntry + "</FONT></TD>";
				}
				cRows += "</TR>";
			}
			var datestr:Date = new Date();
			var str:String = datestr.date + '-' + String((datestr.month)+1) + '-' + datestr.fullYear;
			cContents = cContents.replace( "##PROJROWS##", cRows ); 
			cContents = cContents.replace( "##PROJECTNAME##", 'DashBoard Details');
			cContents = cContents.replace( "##CURRENTDATE##",str);
			saveExcel()
		}
		
		private function saveExcel():void{
			saveByte.writeMultiByte(cContents, "utf-8"  );
			var fileRef:FileReference = new FileReference();
			fileRef.save(saveByte , "DocTrack.xls");
		}
	}
}
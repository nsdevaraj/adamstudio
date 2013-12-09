package com.adams.dt.view.components.exportGenerator
{
	
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.business.util.Utils;
	import com.adams.dt.model.ModelLocator;
	
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	import org.alivepdf.colors.RGBColor;
	import org.alivepdf.data.Grid;
	import org.alivepdf.data.GridColumn;
	import org.alivepdf.drawing.Joint;
	import org.alivepdf.layout.Align;

	public class ExcelGenerator
	{
		private var gXLStemplate:String = "" +
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
										"<BODY TEXT=\"#000000\">" + 
										"<TR><TD></TD></TR>" +
										"<TR><TD></TD></TR>" +
										"<BR>" +
										"<BR>" +
										"<TABLE Border=\"0\">" +
							            "    <TR><TD ColSpan=\"6\"><FONT Size=\"+2\">##PROJECTTITLE##</FONT></TD></TR>" + 
							            "    <TR><TD></TD><TD></TD><TD></TD>" + 
							            "        <TD ColSpan=\"3\"><FONT Size=\"+3\">##DOMAIN##</FONT></TD></TR>" +
							            "    <TR><TD></TD><TD></TD><TD></TD>" + 
							            "        <TD ColSpan=\"3\">##DATE##</TD></TR>" +
							            "    <TR><TD ColSpan=\"6\"><FONT Size=\"+3\">##WORKFLOW##</FONT></TD></TR>" +
							            "    <TR><TD ColSpan=\"6\"><FONT Size=\"+3\">##PHASE##</FONT></TD></TR>" +
							            "    <TR><TD ColSpan=\"6\"><FONT Size=\"+3\">##RESULTS##</FONT></TD></TR>" +
							            "</TABLE>" +
										"<BR>" +
										"<BR>" +
										"##PROJECTHEADER##"+
										"<TR><TD></TD><TD></TD><TD><FONT Size=\"+1\">End of report</FONT></TD></TR>" +
										"<TR><TD></TD></TR>" +
										"<TR><TD></TD></TR>" +
										"<BR>" + 
										"</TABLE>" +
										"</BODY>" +
										"</HTML>";
		
		
		private var _techTableContent:String ="\n" +
										    "<BR>" + 
											"<TABLE Border=\"0\">" +
											"<TR><TD ColSpan=\"6\"><FONT Size=\"+3\">##TITLE##</FONT></TD></TR>" + 
											"<TR><TD></TD><TD></TD><TD></TD>" + 
											"<TR></TD></TR>" +
											"</TABLE>" + 
											"<BR>" +
											"<BR>" +
											"<TABLE FRAME=VOID CELLSPACING=0 COLS=4 BORDER=1>" +
											"<COLGROUP>##COLDESC##</COLGROUP>" +
											"<TBODY>" +
											"##HEADERS##" +
											"##ROWS##" +
											"</TBODY>" +
											"</TABLE>" 
											
		private var _propertiesArr:Array;
		private var _excelBytes:ByteArray = new ByteArray();
		
		private var cContents:String;
		private var _techTableData:String;
		private var _createTechTable:String='';
		[Bindable]
	    public var model:ModelLocator = ModelLocator.getInstance();
		private function generateGridColumns() :void 
		{
			_propertiesArr = [];
			var gridArr:Array = ["Field","Value"]
			for( var i:int =0;i<gridArr.length;i++)
			{
				var excelColumn:GridColumn = new GridColumn( gridArr[i], gridArr[i], 90, Align.LEFT, Align.LEFT );
            	_propertiesArr.push( excelColumn );
			}
		}
		public function createExcel( excelColl :ArrayCollection , projectsComments:String ):void
		{
			generateGridColumns();
			cContents = gXLStemplate;
			for each (  var excelObj:Object in excelColl )
			{
				generateGrid( excelObj.properties,excelObj.Category )
				 
			}
			cContents = cContents.replace( "##DOMAIN##",Utils.getDomains(model.currentProjects.categories).categoryName);
			cContents = cContents.replace( "##DATE##", ( model.currentTime ).toDateString() );
			cContents = cContents.replace( "##PROJECTTITLE##", model.currentProjects.projectName );
			cContents = cContents.replace( "##WORKFLOW##", GetVOUtil.getWorkflowTemplate(model.currentProjects.wftFK).taskLabel);
			
			
			cContents = cContents.replace( "##RESULTS##", 'Notes : ' +projectsComments);
			cContents = cContents.replace( "##PHASE##", GetVOUtil.getPhaseTemplateObject(GetVOUtil.getWorkflowTemplate(model.currentProjects.wftFK).phaseTemplateFK).phaseName + ' PHASE');
			cContents = cContents.replace( "##PROJECTHEADER##",_createTechTable );
			
			
			_excelBytes.writeMultiByte( cContents, "utf-8" );   
			var fileRef:FileReference = new FileReference();
			fileRef.save(_excelBytes , model.currentProjects.projectName+".xls");
		}
		
		private function generateGrid(techObjArr:Array ,title:String ) :void
		{
			var techColDesc:String = "";
			var techHeader:String = "";
			var techRows:String = "";
			var techCols:Array;
			_techTableData = _techTableContent
			
			_techTableData = _techTableData.replace( "##TITLE##", title );
			
			var excelGrid:Grid = new Grid( techObjArr,200, 100, new RGBColor( 0x666666 ), new RGBColor( 0xCCCCCC ), new RGBColor( 0 ), true, new RGBColor( 0x0 ), 1, Joint.MITER );
            excelGrid.columns = _propertiesArr;
		    techCols = excelGrid.columns;
			for( var j:int = 0; j < techCols.length; j++ ) {
				techColDesc += "<COL WIDTH=" + techCols[j].width + ">";
			}
			
			_techTableData = _techTableData.replace( "##COLDESC##", techColDesc );
			techHeader = "<TR>"
			
			for( var k:int = 0; k < techCols.length; k++ ) {
				techHeader += "<TD><FONT Size=2>" + techCols[ k ].headerText + "</FONT></TD>";
			}
			techHeader += "</TR>"
			_techTableData = _techTableData.replace( "##HEADERS##", techHeader );
			
			for( var m:int = 0; m < techObjArr.length; m++ ) {
				techRows += "<TR>";
				for( var n:int = 0; n < excelGrid.columns.length; n++ ) {
					var fieldEntry:String
					var numVal:Number = Number( techObjArr[ m ][ excelGrid.columns[ n ].dataField ] )
					if( isNaN( numVal ) ){
						fieldEntry = techObjArr[ m ][ excelGrid.columns[ n ].dataField ];
					}
					else {
						fieldEntry = "'"+String( techObjArr[ m ][ excelGrid.columns[ n ].dataField ] );
					}
					techRows += "<TD>" +fieldEntry + "</TD>";
					
					
				}
				techRows += "</TR>";
				
			}
			_techTableData = _techTableData.replace( "##ROWS##", techRows );
			_createTechTable += _techTableData;
		}
		
	
	}
}
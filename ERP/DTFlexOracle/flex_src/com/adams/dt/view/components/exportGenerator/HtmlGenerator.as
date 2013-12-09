package com.adams.dt.view.components.exportGenerator
{
	import com.adams.dt.business.util.GetVOUtil;
	import com.adams.dt.model.ModelLocator;
	
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	public class HtmlGenerator
	{
		public function HtmlGenerator()
		{
			
		}
		[Bindable]
	    public var model:ModelLocator = ModelLocator.getInstance();
		private var _htmTemplate:String="<html>" +
										"<head>"+
										"<title>##fileName##</title>"+
										"<style>" +
										"table.sample {"+
										"background-color:#FFFFFF;"+
										"border: solid #000 1px;"+
										"border-left:0px;"+
										"font-size:13px;"+
										"width:500;"+
										"font-family:verdana;"+
										"}"+
										"table.sample td {"+
										"border-LEFT: solid #666 1px;"+
										"border-TOP: solid #666 1px;"+
										"PADDING-LEFT:2PX;"+
										"WIDTH:120px;"+
										"text-align:center;"+
										"vertical-align:bottom;"+
										"}"+
										".toprow {"+
										"text-align: center;"+
										"background-color: #aaaaaa;"+
										"border-LEFT:solid #666 1px;"+
										"}"+
										"tr.d0 td {"+
										"background-color: #CC9999; color: black;"+
										"}"+
										"tr.d1 td {"+
										"background-color: #9999CC; color: black;"+
										"}"+
										"p span {margin-left:500px;}"+
										"</style>"+
										"<body>"+
										"##_tabelContent##"+
										"</body>"+
										"</html>";
										
		/**
		 * Stores the Grid Tag and Grid Value of the table
		 **/
		private var _gridColumn:String="";
		private var _gridColumvalue:String="";
		private var _gridContainer:String="";
		private var _htmlContent:String="";
		private var gBytes:ByteArray = new ByteArray();	
		public function createHtml( tableColl:ArrayCollection , projectsComments:String ):void
		{
			generateGridColumns();
			for each( var exportHtmlObj:Object in tableColl)
		  	{
		  		generateGrid(exportHtmlObj.properties,exportHtmlObj.Category)
		  	}
			var header:String = "<br/><br/>"+model.currentProjects.projectName+"<br/><br/>"+"<p>"+model.domain.categoryName+"<span></span>"+( model.currentTime ).toDateString()
								+"</p><br></br>"
								+GetVOUtil.getPhaseTemplateObject(GetVOUtil.getWorkflowTemplate(model.currentProjects.wftFK).phaseTemplateFK).phaseName + ' PHASE    ,'
								+GetVOUtil.getWorkflowTemplate(model.currentProjects.wftFK).taskLabel+"<br></br>"
			
								
			var projectsComments:String = "Project Comments :"+projectsComments+"<br></br>";
			var cContents:String = header+projectsComments+_htmTemplate;
			cContents = cContents.replace( "##fileName##",  model.currentProjects.projectName +"_reports.html" );
			cContents = cContents.replace( "##_tabelContent##", _htmlContent );
			gBytes.writeMultiByte( cContents, "utf-8" );
			var fileRef:FileReference = new FileReference();
			fileRef.save(gBytes ,  model.currentProjects.projectName +"_reports.html");
		}
		private function generateGrid(arr:Array ,title:String ) :void
		{
			_gridContainer = '';
			for( var j:int = 0; j < arr.length; j++ ) {
				_gridContainer += "<tr class=d"+(j%2==0?1:0)+">" +
					"<td>"+arr[j].Field+"</td>" +
					"<td>"+arr[j].Value+"</td>" +
					"</tr>"
			}
			_gridColumn= "<table border=0 class=sample cellPadding=0 cellSpacing=0 ><thead>"+
				"<tr>"+_gridColumvalue+"</tr></thead>";
			_gridContainer = "<tbody><tr>"+_gridContainer+"</tbody></table><br/>";
			_htmlContent += title+"<br/><br/>"+_gridColumn+_gridContainer;
		}
		/**
		 * Generate the Tabel Name for the task.
		 **/
		private function generateGridColumns() :void 
		{
			var gridArr:Array = ["Field","Value"]
			for( var i:int =0;i<gridArr.length;i++)
			{
				_gridColumvalue += "<th bgcolor=#aaaaaa class=toprow>"+gridArr[i]+"</th>";
			}
		}
		
		
	}
}
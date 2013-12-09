package business
{
	import flash.printing.PrintJob;
	
	import mx.controls.DataGrid;
	import mx.core.Application;
	import mx.printing.FlexPrintJob;
	import mx.printing.FlexPrintJobScaleType;
	import mx.printing.PrintDataGrid;
	
	public class PrintFunc
	{
		public function PrintFunc()
		{
		}
		public function doprint(dg:DataGrid):void{
			
			 var pj : PrintJob = new PrintJob();
		      //Save the current vertical scroll position of the DataGrid control. 
		      var prev_vPosition:Number = dg.verticalScrollPosition;
		
		      if(pj.start() != true)            {
		         
		         return;
		      }
		
		      //Calculate the number of visible rows.       
		      var rowsPerPage:Number = Math.floor((dg.height -  dg.rowHeight)/ 	dg.rowHeight);
		
		      //Calculate the number of pages required to print all rows. 
		      var pages:Number = Math.ceil(dg.dataProvider.length / rowsPerPage);
		
		      //Scroll down each page of rows, then call addPage() once for each page. 
		      for (var i:int=0;i<pages;i++) { 
		         dg.verticalScrollPosition = i*rowsPerPage;
		         pj.addPage(dg);         
		       }
		
		      pj.send();
		
		      // Restore vertical scroll position.
		      dg.verticalScrollPosition = prev_vPosition;  
		      
		      
		 	/*  var printJob:FlexPrintJob = new FlexPrintJob();
			if ( printJob.start() )
				{
					var printDataGrid:PrintDataGrid = new PrintDataGrid();
					printDataGrid.width = printJob.pageWidth;
					printDataGrid.height = printJob.pageHeight;
					printDataGrid.columns = dg.columns;
					printDataGrid.dataProvider = dg.dataProvider;
					printDataGrid.visible = false;
					Application.application.addChild(printDataGrid);
					while (printDataGrid.validNextPage)
					 {
					 	printDataGrid.rotation = 90
						printDataGrid.nextPage();
						printJob.addObject(printDataGrid,FlexPrintJobScaleType.NONE);
					}
				printJob.send();
				Application.application.removeChild(printDataGrid);
		  }     */
		}
	}
}
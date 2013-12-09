/*
_________________            __________________________
___    |__  /__(_)__   _________  __ \__  __ \__  ____/
__  /| |_  /__  /__ | / /  _ \_  /_/ /_  / / /_  /_    
_  ___ |  / _  / __ |/ //  __/  ____/_  /_/ /_  __/
/_/  |_/_/  /_/  _____/ \___//_/     /_____/ /_/  
     
*/

/**
* This class lets you decode generate PDF files with the Flash Player
* AlivePDF is based on the FPDF PHP library (http://www.fpdf.org/)
* @author Thibault Imbert
* @version 0.1.4 Current Release
*/

package business.org.alivepdf.pdf
{

	import business.org.alivepdf.colors.CMYKColor;
	import business.org.alivepdf.colors.Color;
	import business.org.alivepdf.colors.GrayColor;
	import business.org.alivepdf.colors.RGBColor;
	import business.org.alivepdf.display.Display;
	import business.org.alivepdf.display.PageMode;
	import business.org.alivepdf.drawing.Caps;
	import business.org.alivepdf.drawing.DashedLine;
	import business.org.alivepdf.encoding.JPEGEncoder;
	import business.org.alivepdf.encoding.PNGEnc;
	import business.org.alivepdf.fonts.CoreFonts;
	import business.org.alivepdf.image.ImageFormat;
	import business.org.alivepdf.layout.Layout;
	import business.org.alivepdf.layout.Orientation;
	import business.org.alivepdf.layout.Size;
	import business.org.alivepdf.layout.Unit;
	import business.org.alivepdf.metrics.FontMetrics;
	import business.org.alivepdf.parsers.PNGParser;
	import business.org.alivepdf.saving.Method;
	import business.org.alivepdf.tools.sprintf;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**
	 * Dispatched when PDF is generated. The finish() method generate this event
	 *
	 * @eventType flash.events.Event.COMPLETE
	 *
	 * * @example
	 * This example shows how to create a valid PDF document :
	 * <div class="listing">
	 * <pre>
	 *
	 * myPDF.addEventListener ( Event.COMPLETE, generated );
	 * </pre>
	 * </div>
 	 */
	[Event(name='complete', type='flash.events.Event.COMPLETE')]

	/**
	* The PDF class represents a PDF document.
	*/
	public final class PDF implements IEventDispatcher
	{

		private static const PDF_VERSION:String = '1.3';
		private static const ALIVEPDF_VERSION:String = '0.1.4';

		private var page:int;               //current page number
		private var n:int;                  //current object number
		private var offsets:Array;            //array of object offsets
		private var state:int;              //current document state
		private var compress:Boolean;           //compression flag
		private var defaultOrientation:String;    //default orientation
		private var defaultFormat:Size;    //default format
		private var currentOrientation:String;     //current orientation
		private var orientationChanges:Array; //array indicating orientation changes
		private var k:Number;                  //scale factor (number of points in user unit)
		private var lMargin:Number;            //left margin
		private var tMargin:Number;            //top margin
		private var rMargin:Number;            //right margin
		private var bMargin:Number;          //page break margin
		private var cMargin:Number;            //cell margin
		private var x:Number;
		private var y:Number;
		private var orientation:String;        //current position in user unit for cell positioning
		private var lasth:Number;              //height of last cell printed
		private var lineWidth:Number;          //line width in user unit
		private var standardFonts:Object;          //array of standard font names
		private var fonts:Object;           //array of used fonts
		private var fontFiles:Array;          //array of font files
		private var diffs:Array;              //array of encoding differences
		private var links:Array;              //array of internal links
		private var fontFamily:String;         //current font family
		private var fontStyle:String;          //current font style
		private var underline:Boolean;          //underlining flag
		private var fontSizePt:Number;         //current font size in points
		private var strokeStyle:String;          //commands for drawing color
		private var fillColor:String;          //commands for filling color
		private var addTextColor:String;          //commands for text color
		private var colorFlag:Boolean;          //indicates whether fill and text colors are different
		private var ws:Number;                 //word spacing
		private var autoPageBreak:Boolean;      //automatic page breaking
		private var pageBreakTrigger:Number;   //threshold used to trigger page breaks
		private var inFooter:Boolean;           //flag set when processing footer
		private var zoomMode:*;           //zoom display mode
		private var layoutMode:String;         //layout display mode
		private var pageMode:String;
		private var title:String;              //title
		private var subject:String;            //subject
		private var author:String;             //author
		private var keywords:String;           //keywords
		private var creator:String;            //creator
		private var aliasNbPagesMethod:String;       //alias for total number of pages
		private var pdfVersion:String;         //PDF version number
		private var buffer:ByteArray;
		private var images:Dictionary;
		private var fontSize:Number;
		private var name:String;
		private var type:String;
		private var desc:String;
		private var up:Number;
		private var ut:Number;
		private var cw:Object;
		private var enc:Number;
		private var diff:Number;
		private var d:Number;
		private var nb:*;
		private var originalsize:Number;
		private var size1:Number;
		private var size2:Number;
		private var fontkey:String;
		private var file:String;
		private var currentFont:Object;
		private var b2:String;
		private var pageLinks:Array;
		private var mtd:*
		private var filter:String;
		private var inited:Boolean;
		private var bFilled:Boolean
		private var dispatcher:EventDispatcher;
		private var arrayPages:Array;
		private var arrayNotes:Array;
		private var extgstates:Array;
		private var currentPage:Page;
		private var outlines:Array;
		private var outlineRoot:int;
		private var angle:Number;
		private var textRendering:int;
		private var autoPagination:Boolean;
		private var viewerPreferences:String;
		private var defaultUnit:String;
		private var drawingRule:String;

		/**
		* The PDF class represents a PDF document.
		*
		* @author Thibault Imbert
		*
		* @example
		* This example shows how to create a valid PDF document :
		* <div class="listing">
		* <pre>
		*
		* var myPDF:PDF = new PDF ( Orientation.PORTRAIT, Unit.MM, Size.A4 );
		* </pre>
		* </div>
		*/

		public function PDF ( pOrientation:String='Portrait', pUnit:String='Mm', pageSize:Object=null )
		{
			
			var pFormat:Size = ( pageSize != null ) ? Size.getSize(pageSize) : Size.A4;
						
			if ( pFormat == null ) throw new RangeError ('Unknown page format : ' + pageSize +', please use a org.alivepdf.layout.' + 
														 'Size object or any of those strings : A3, A4, A5, Letter, Legal, Tabloid');

			dispatcher = new EventDispatcher ( this );

			viewerPreferences = new String();
			outlines = new Array();
			arrayPages = new Array();
			arrayNotes = new Array();
			extgstates = new Array();
			orientationChanges = new Array();
			var format:Array;
			page = 0;
			n = 2;
			angle = 0;
			buffer = new ByteArray;
			offsets = new Array;
			state =0;
			fonts = new Object;
			pageLinks = new Array;
			fontFiles = new Array;
			diffs = new Array;
			images = new Dictionary;
			links = new Array;
			inFooter = false;
			lasth = 0;
			fontFamily = new String;
			fontStyle = new String;
			fontSizePt = 12;
			underline = false;
			strokeStyle = new String ('0 G');
			fillColor = new String ('0 g');
			addTextColor = new String ('0 g');
			colorFlag = false;
			ws = 0;
			inited = true;

			//Standard fonts
			standardFonts = new CoreFonts();
			
			// Scaling factor
			defaultUnit = setUnit ( pUnit );
				
			// format & orientation
			defaultFormat = pFormat;
			defaultOrientation = pOrientation;
			//this.currentOrientation = this.defaultOrientation;

			//Page margins (1 cm)
			var margin:Number = 28.35/k;
			setMargins ( margin, margin );

			//Interior cell margin (1 mm)
			cMargin = margin/10;

			//Line width (0.2 mm)
			lineWidth = .567/k;

			//Automatic page break
			setAutoPageBreak (true, margin << 1 );

			//Full width display mode
			setDisplayMode( Display.FULL_WIDTH );

			//Set default PDF version number
			pdfVersion = PDF.PDF_VERSION;

		}

		/**
		* Lets you specify the left, top, and right margins
		*
		* @param pLeft Left margin
		* @param pTop Right number
		* @param pRight Top number
		* @example
		* This example shows how set margins for the PDF document :
		* <div class="listing">
		* <pre>
		*
		* myPDF.setMargins ( 10, 10, 10 );
		* </pre>
		* </div>
		*/
		public function setMargins( pLeft:Number, pTop:Number, pRight:Number=-1, pBottom:Number=20):void
		{

			//Set left, top and right margins
			lMargin = pLeft;
			tMargin = pTop;
			if( pRight == -1 ) pRight = pLeft;
			bMargin = pBottom;
			rMargin = pRight;

		}

		/**
		* Lets you retrieve the margins dimensions
		*
		* @return Rectangle
		* @example
		* This example shows how to get the margins dimensions :
		* <div class="listing">
		* <pre>
		*
		* var marginsDimensions:Rectangle = myPDF.getMargins ();
		* // output : (x=10.001249999999999, y=10.001249999999999, w=575.2774999999999, h=811.88875)
		* trace( marginsDimensions )
		* </pre>
		* </div>
		*/
		public function getMargins():Rectangle
		{

			return new Rectangle( lMargin, tMargin, getCurrentPage().width - rMargin - lMargin, getCurrentPage().height - bMargin - tMargin );

		}

		/**
		* Lets you specify the left margin
		*
		* @param pMargin Left margin
		* @example
		* This example shows how set left margin for the PDF document :
		* <div class="listing">
		* <pre>
		*
		* myPDF.setLeftMargin ( 10 );
		* </pre>
		* </div>
		*/
		public function setLeftMargin(pMargin:Number):void
		{

			//Set left margin
			lMargin = pMargin;
			if( page > 0 && x < pMargin ) x = pMargin;

		}

		/**
		* Lets you specify the top margin
		*
		* @param pMargin Top margin
		* @example
		* This example shows how set top margin for the PDF document :
		* <div class="listing">
		* <pre>
		*
		* myPDF.setTopMargin ( 10 );
		* </pre>
		* </div>
		*/
		public function setTopMargin(pMargin:Number):void
		{

			//Set top margin
			tMargin = pMargin;

		}

		/**
		* Lets you specify the bottom margin
		*
		* @param pMargin Bottom margin
		* @example
		* This example shows how set bottom margin for the PDF document :
		* <div class="listing">
		* <pre>
		*
		* myPDF.setBottomMargin ( 10 );
		* </pre>
		* </div>
		*/
		public function setBottomMargin (pMargin:Number):void
		{

			//Set top margin
			bMargin = pMargin;

		}

		/**
		* Lets you specify the right margin
		*
		* @param pLeft Right margin
		* @example
		* This example shows how set right margin for the PDF document :
		* <div class="listing">
		* <pre>
		*
		* myPDF.setRightMargin ( 10 );
		* </pre>
		* </div>
		*/
		public function setRightMargin(pMargin:Number):void
		{

			//Set right margin
			rMargin = pMargin;

		}

		/**
		* Lets you specify the left, top, and right margins
		*
		* @param pLeft Left margin
		* @param pTop Right number
		* @param pRight Top number
		* @example
		* This example shows how to rotate the first page 90 cw
		* <div class="listing">
		* <pre>
		*
		* myPDF.setMargins ( 10, 10, 10 );
		* </pre>
		* </div>
		*/
		private function setAutoPageBreak( auto:Boolean,margin:int,t:Number=0 ):void
		{

			//Set auto page break mode and triggering margin
			autoPageBreak = auto;
			bMargin = margin;
			if ( currentPage != null ) pageBreakTrigger = currentPage.h-margin;

		}

		/**
		* Lets you set a specific display mode, the DisplayMode takes care of the general layout of the PDF in Acrobat Reader
		*
		* @param pZoom Zoom mode, can be Display.FULL_PAGE, Display.FULL_WIDTH, Display.REAL, Display.DEFAULT
		* @param pLayout Layout of the PDF document, can be Layout.SINGLE_PAGE, Layout.ONE_COLUMN, Layout.TWO_COLUMN_LEFT, Layout.TWO_COLUMN_RIGHT
		* @param pPageMode PageMode can be pageMode.USE_NONE, PageMode.USE_OUTLINES, PageMode.USE_THUMBS, PageMode.FULL_SCREEN
		* @example
		* This example creates a PDF which opens at full page scaling, one page at a time
		* <div class="listing">
		* <pre>
		*
		* myPDF.setDisplayMode (Display.FULL_PAGE, Layout.SINGLE_PAGE);
		* </pre>
		* </div>
		*/
		public function setDisplayMode ( pZoom:String='FullWidth', pLayout:String='SinglePage', pPageMode:String='UseNone' ):void
		{

			//Set display mode in viewer
			zoomMode = pZoom;
			layoutMode = pLayout;
			pageMode = pPageMode;

		}

		/**
		* Lets you set a subject for the PDF tags
		*
		* @param pTitle The title
		* @example
		* This example shows how to set a specific title to the PDF document :
		* <div class="listing">
		* <pre>
		*
		* myPDF.setTitle ( "AlivePDF !" );
		* </pre>
		* </div>
		*/
		public function setTitle( pTitle:String ):void
		{
			//Title of document
			title = pTitle;
		}

		/**
		* Lets you set a subject for the PDF tags
		*
		* @param pSubject The subject
		* @example
		*  This example shows how to set a specific subject to the PDF document :
		* <div class="listing">
		* <pre>
		*
		* myPDF.setSubject ( "Any topic" );
		* </pre>
		* </div>
		*/
		public function setSubject( pSubject:String ):void
		{
			//Subject of document
			subject = pSubject;
		}

		/**
		* Sets the specified author for the PDF tags
		*
		* @param pAuthor The author
		* @example
		* This example shows how to add a specific author to the tags :
		* <div class="listing">
		* <pre>
		*
		* myPDF.setAuthor ( "Bob" );
		* </pre>
		* </div>
		*/
		public function setAuthor( pAuthor:String ):void
		{
			//Author of document
			author = pAuthor;
		}

		/**
		* Sets the specified keywords for the PDF tags
		*
		* @param pKeywords The keywords
		* @example
		* This example shows how to add keywords to the tags :
		* <div class="listing">
		* <pre>
		*
		* myPDF.setKeywords ( "Design, Agency, Communication, etc." );
		* </pre>
		* </div>
		*/
		public function setKeywords( pKeywords:String ):void
		{
			//Keywords of document
			keywords = pKeywords;
		}

		/**
		* Sets the specified creator for the PDF tags
		*
		* @param pPage Page number
		* @param pRotation Page rotation (must be a multiple of 90)
		* @example
		* This example shows how to rotate the first page 90 cw
		* <div class="listing">
		* <pre>
		*
		* myPDF.rotatePage ( 1, 90 );
		* </pre>
		* </div>
		*/
		public function setCreator( pCreator:String ):void
		{
			//Creator of document
			creator = pCreator;
		}

		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/*
		* AlivePDF paging API
		*/
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		/**
		* Lets you rotate a specific page (between 1 and last one)
		*
		* @param pPage Page number
		* @param pRotation Page rotation (must be a multiple of 90)
		* @example
		* This example shows how to rotate the first page 90 cw
		* <div class="listing">
		* <pre>
		*
		* myPDF.rotatePage ( 1, 90 );
		* </pre>
		* </div>
		*/
		public function aliasNbPagesMethodMethod(alias:String='{nb}'):void
		{
			//Define an alias for total number of pages
			aliasNbPagesMethod = alias;
		}

		/**
		* Lets you rotate a specific page (between 1 and last one)
		*
		* @param pPage Page number
		* @param pRotation Page rotation (must be a multiple of 90)
		* @throws RangeError
		* @example
		* This example shows how to rotate the first page 90 cw
		* <div class="listing">
		* <pre>
		*
		* myPDF.rotatePage ( 1, 90 );
		* </pre>
		* </div>
		*/
		public function rotatePage ( pPage:int, pRotation:Number ):void
		{

			if ( pPage > 0 && pPage <= arrayPages.length ) arrayPages[pPage-1].rotate ( pRotation );

			else throw new RangeError ("No page available, please select a page from 1 to " + arrayPages.length);

		}

		/**
		* Lets you add a page to the current PDF
		*
		* @param pOrientation Page orientation can be Orientation.PORTRAIT or Orientation.LANDSCAPE
		* @param pUnit Page Unit, can be Unit.MM, Unit.CM, Unit.POINT, Unit.INCHES
		* @param pSize Format, can be a custom Size object, or any of the following : Size.A3, Size.A4, Size.A5, Size.LETTER, Size.LEGAL
		* @param pRotation Page rotation (must be a multiple of 90)
		* @param 
		* @example
		* This example shows how to add an A4 page with a landscape orientation
		* <div class="listing">
		* <pre>
		*
		* myPDF.addPage( Size.A4, 0, Orientation.LANDSCAPE );
		* </pre>
		* </div>
		* This example shows how to add an custom page size :
		* <div class="listing">
		* <pre>
		*
		* myPDF.addPage( Orientation.LANDSCAPE, Unit.MM,  new Size ([500, 500], "myFavoriteSize", [11.7, 16.5],[297, 420] ));
		* </pre>
		* </div>
		*/
		public function addPage ( pOrientation:String='', pUnit:String="Mm", pSize:Object = null, pRotation:Number=0 ):void
		{
			
			var pFormat:Size = Size.getSize( pSize );
			var fwPt:Number;
			var fhPt:Number;
			var wPt:Number;
			var hPt:Number;
			var fw:Number;
			var fh:Number;
			var format:Array;

			format = ( pFormat != null ) ? pFormat.dimensions : defaultFormat.dimensions;
			
			fwPt = format[0];
			fhPt = format[1];
			
			if ( pUnit != defaultUnit ) setUnit ( pUnit );

			fw = fwPt/k;
			fh = fhPt/k;

			if ( pOrientation != '' )
			{
				// Orientation
				if ( pOrientation == Orientation.PORTRAIT )
				{

					wPt = fwPt;
					hPt = fhPt;

				} else if ( pOrientation == Orientation.LANDSCAPE )
				{
					
					wPt = fhPt;
					hPt = fwPt;

				} else throw new RangeError ('Incorrect orientation: ' + pOrientation);

			} else
			{

				if ( defaultOrientation == Orientation.PORTRAIT )
				{

					wPt = fwPt;
					hPt = fhPt;

				} else if ( defaultOrientation == Orientation.LANDSCAPE )
				{
					
					wPt = fhPt;
					hPt = fwPt;

				} else throw new RangeError ('Incorrect orientation: ' + defaultOrientation);

			}

			arrayPages.push ( new Page ( wPt, hPt, pRotation, fwPt, fhPt, fwPt, fhPt, fw, fh ) );

			//Start a new page
			if ( state == 0 ) Open();

			var family:String = fontFamily;
			var style:String = fontStyle+(underline ? 'U' : '');
			var size:Number = fontSizePt;
			var lw:Number = lineWidth;
			var dc:String = strokeStyle;
			var fc:String = fillColor;
			var tc:String = addTextColor;
			var cf:Boolean = colorFlag;

			if( page > 0 ) finishPage();

			//Start new page
			startPage ( pOrientation );
			//Set line cap style to square
			write ( Caps.SQUARE );
			//Set line width
			lineWidth = lw;
			write( sprintf('%.2f w',lw*k) );
			//Set font
			if( family ) setFont(family,style, size);
			//Set colors
			strokeStyle = dc;
			if( dc != '0 G' ) write (dc);
			fillColor = fc;
			if( fc != '0 g' ) write (fc);
			addTextColor = tc;
			colorFlag = cf;
			//Restore line width
			if(lineWidth!=lw)
			{
				lineWidth=lw;
				write(sprintf('%.2f w',lw*k));
			}
			//Restore font
			if ( family ) setFont ( family, style, size );
			//Restore colors
			if(strokeStyle != dc)
			{
				strokeStyle = dc;
				write(dc);
			}
			if(fillColor != fc)
			{
				fillColor = fc;
				write(fc);
			}
			
			addTextColor = tc;
			colorFlag = cf;

		}

		/**
		* Lets you retrieve a Page object
		*
		* @param pPage page number, from 1 to total numbers of pages
		* @return Page
		* @example
		* This example shows how to retrieve the first page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.getPage ( 1 );
		* </pre>
		* </div>
		*/
		public function getPage ( pPage:int ):Page
		{

			if ( pPage > 0 && pPage <= this.arrayPages.length ) return this.arrayPages [pPage-1];

			else throw new RangeError ("Can't retrieve page " + pPage + ".");

		}

		/**
		* Lets you remove a Page from the PDF
		*
		* @param pPage page number, from 1 to total numbers of pages
		* @return Page
		* @example
		* This example shows how to remove the first page :
		* <div class="listing">
		* <pre>
		* myPDF.removePage(1);
		* </pre>
		* If you want to remove pages each by each, you can combine removePage with getPageCount
		* <pre>
		* myPDF.removePage(myPDFEncoder.getPageCount());
		* </pre>
		* </div>
		*/
		public function removePage ( pPage:int ):Page
		{

			if ( pPage > 0 && pPage <= arrayPages.length ) return arrayPages.splice ( pPage-1, 1 )[0];

			else throw new RangeError ("Can't remove page " + pPage + ".");

		}
		
		/**
		* Lets you remove all the pages from the PDF
		*
		* @example
		* This example shows how to remove all the pages :
		* <div class="listing">
		* <pre>
		* myPDF.removeAllPages();
		* </pre>
		* </div>
		*/
		public function removeAllPages ( ):void 
		
		{
			
			arrayPages = new Array();
			
		}

		/**
		* Lets you retrieve the current Page
		*
		* @return Page A Page object
		* @example
		* This example shows how to retrieve the current page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.getCurrentPage ();
		* </pre>
		* </div>
		*/
		public function getCurrentPage ():Page
		{

			if( arrayPages.length > 0 ) return arrayPages[ arrayPages.length - 1 ];

			else throw new RangeError ("Can't retrieve the current page, " + arrayPages.length + " pages available.");

		}

		/**
		* Lets you retrieve the number of pages in the PDF document
		*
		* @return int Number of pages in the PDF
		* @example
		* This example shows how to retrieve the number of pages :
		* <div class="listing">
		* <pre>
		*
		* var totalPages:int = myPDF.getPageCount ();
		* </pre>
		* </div>
		*/
		public function getPageCount():int
		{

			return arrayPages.length;

		}
		
		/**
		* Lets you insert a line break for text
		*
		* @param pHeight Line break height
		* @example
		* This example shows how to add a line break :
		* <div class="listing">
		* <pre>
		*
		* myPDF.newLine ( 10 );
		* </pre>
		* </div>
		*/
		public function newLine ( pHeight:*='' ):void
		{

			//Line feed; default value is last cell height
			x = lMargin;
			y += (pHeight is String) ? lasth : pHeight;

		}

		/**
		* Lets you retrieve the X position for the current page
		*
		* @return Number the X position
		*/
		public function getX():Number
		{

			//Get x position
			return x;

		}

		/**
		* Lets you retrieve the Y position for the current page
		*
		* @return Number the Y position
		*/
		public function getY():Number
		{

			//Get y position
			return y;

		}

		/**
		* Lets you specify the X position for the current page
		*
		* @param Number the X position
		*/
		public function setX( pX:Number ):void
		{

			//Set x position
			x = ( pX >= 0 ) ? pX : currentPage.w+pX;

		}

		/**
		* Lets you specify the Y position for the current page
		*
		* @param Number the Y position
		*/
		public function setY ( pY:Number ):void
		{

			//Set y position and reset x
			x = lMargin;
			y = ( pY >= 0 ) ? pY : currentPage.h + y;

		}

		/**
		* Lets you specify the X and Y position for the current page
		*
		* @param pX The X position
		* @param pY The Y position
		*/
		public function setXY( pX:Number, pY:Number ):void
		{

			//Set x and y positions
			setY( pY );
			setX( pX );

		}

		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/*
		* AlivePDF Drawing API
		*
		* moveTo()
		* lineTo()
		* end()
		* curveTo()
		* lineStyle()
		* beginFill()
		* endFill()
		* drawRect()
		* drawRoundRect()
		* drawCircle()
		* drawEllipse()
		* drawPolygone()
		* drawRegularPolygone()
		*/
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		/**
		* Lets you move the current drawing point to the specified destination
		*
		* @param pAlpha Opacity
		* @param pBlendMode Blend mode, can be Blend.DIFFERENCE, BLEND.HARDLIGHT, etc.
		* @example
		* This example shows how to set the alpha for any following drawing, image or text operation.
		* <div class="listing">
		* <pre>
		*
		* myPDF.setAlpha ( .5 );
		* </pre>
		* </div>
		*/
		public function setAlpha ( pAlpha:Number, pBlendMode:String='Normal' ):void
		{

			var graphicState:int = addExtGState( { 'ca' : pAlpha, 'SA' : true, 'CA' : pAlpha, 'BM' : '/' + pBlendMode } );

			setExtGState ( graphicState );

		}

		/**
		* Lets you move the current drawing point to the specified destination
		*
		* @param pX X position
		* @param pY Y position
		* @example
		* This example shows how to move the pen to 120,200 :
		* <div class="listing">
		* <pre>
		*
		* myPDF.moveTo ( 120, 200 );
		* </pre>
		* </div>
		*/
		public function moveTo ( pX:Number, pY:Number ):void

		{

			write (pX*k + " " + (currentPage.h-pY)*k + " m")

		}

		/**
		* Lets you draw a stroke from the current point to the new point
		*
		* @param pX X position
		* @param pY Y position
		* @example
		* This example shows how to draw some dashed lines in the current page with specific caps style and joint style :
		* <br><b>Important : Always call the end() method when you're done</b>
		* <div class="listing">
		* <pre>
		*
		* myPDF.lineStyle( new RGBColor ( 255, 200, 0), 1, 1 );
		* myPDF.moveTo ( 10, 20 );
		* myPDF.lineTo ( 40, 20 );
		* myPDF.lineTo ( 40, 40 );
		* myPDF.lineTo ( 10, 40 );
		* myPDF.lineTo ( 10, 20 );
		* myPDF.end();
		* </pre>
		* </div>
		*/
		public function lineTo ( pX:Number, pY:Number ):void

		{

			write (pX*k + " " + (currentPage.h-pY)*k+ " l");

		}

		/**
		* The end method closes the stroke
		*
		* @example
		* This example shows how to draw some dashed lines in the current page with specific caps style and joint style :
		* <br><b>Important : Always call the end() method when you're done</b>
		* <div class="listing">
		* <pre>
		*
		* myPDF.lineStyle( new RGBColor ( 255, 200, 0), 1, 1 );
		* myPDF.moveTo ( 10, 20 );
		* myPDF.lineTo ( 40, 20 );
		* myPDF.lineTo ( 40, 40 );
		* myPDF.lineTo ( 10, 40 );
		* myPDF.lineTo ( 10, 20 );
		* // end the stroke
		* myPDF.end();
		* </pre>
		* </div>
		*/
		public function end ():void

		{

			write ( bFilled ? "b" : "S");

		}

		/**
		* The curveTo method draws a cubic bezier curve
		* @param pControlX1
		* @param pControlY1
		* @param pControlX2
		* @param pControlY2
		* @param pFinalX3
		* @param pFinalY3
		* @example
		* This example shows how to draw some curves lines in the current page :
		* <br><b>Important : Always call the end() method when you're done</b>
		* <div class="listing">
		* <pre>
		*
		*myPDF.lineStyle ( new RGBColor ( Math.random()*255, Math.random()*255, Math.random()*255 ), 1, 1, null, CapsStyle.NONE, JointStyle.MITER);
		* myPDF.moveTo ( 10, 200 );
		* myPDF.curveTo ( 120, 210, 196, 280, 139, 195 );
		* myPDF.curveTo ( 190, 110, 206, 190, 179, 205 );
		* myPDF.end();
		* </pre>
		* </div>
		*/
		public function curveTo ( pControlX1:Number, pControlY1:Number, pControlX2:Number, pControlY2:Number, pFinalX3:Number, pFinalY3:Number ):void

		{

			write (pControlX1*k + " " + (currentPage.h-pControlY1)*k + " " + pControlX2*k + " " + (currentPage.h-pControlY2)*k+ " " + pFinalX3*k + " " + (currentPage.h-pFinalY3)*k + " c");

		}

		/**
		* Sets the stroke style
		* @param pColor Color object, can be CMYKColor, GrayColor, or RGBColor
		* @param pThickness
		* @param pAlpha 
		* @param pStyle
		* @param pCaps
		* @param pJoints
		* @param pMiterLimit
		* @param pMatrix
		* @example
		* This example shows how to set a specific stroke style :
		* <div class="listing">
		* <pre>
		*
		* myPDF.lineStyle ( new RGBColor ( Math.random()*255, Math.random()*255, Math.random()*255 ), 1, 1, null, Caps.NONE, Joint.MITER);
		* </pre>
		* </div>
		*/
		public function lineStyle ( pColor:Color, pThickness:Number=1, pAlpha:Number = 1.0, pBlend:String="Normal", pStyle:DashedLine = null, pCaps:String = null, pJoints:String = null, pMiterLimit:Number = 3, pMatrix:Matrix = null):void

		{

			strokeColor ( pColor );

			lineWidth = pThickness;
			
		 	setAlpha ( pAlpha, pBlend );

			if ( pMatrix != null ) write ( pMatrix.a + " " + pMatrix.b + " " + pMatrix.c + " " + pMatrix.d + " 0 0 cm" );

			if( page > 0 ) write ( sprintf ('%.2f w', pThickness*k) );

			write ( pStyle != null ? pStyle.pattern : '[] 0 d' );

			// handle line capsstyle
			if ( pCaps != null ) write ( pCaps );
			
			// handle line joints
			if ( pJoints != null ) write ( pJoints );
			
			write ( pMiterLimit + " M" );

		}

		/**
		* Sets the stroke color for differents color spaces CMYK/RGB/DEVICEGRAY
		*/
		private function strokeColor ( pColor:Color ):void

		{

			var op:String;

			// RGB ColorSpace
			if ( pColor is RGBColor )

			{

				op = "RG";

				var r:Number = RGBColor(pColor).r/255;
				var g:Number = RGBColor(pColor).g/255;
				var b:Number = RGBColor(pColor).b/255;

				write ( r + " " + g + " " + b + " " + op );

			// CMYK ColorSpace
			} else if ( pColor is CMYKColor )

			{

				op = "K";

				var c:Number = CMYKColor(pColor).cyan / 100;
				var m:Number = CMYKColor(pColor).magenta / 100;
				var y:Number = CMYKColor(pColor).yellow / 100;
				var k:Number = CMYKColor(pColor).black / 100;

				write ( c + " " + m + " " + y + " " + k + " " + op );

			// Gray ColorSpace
			} else

			{

				op = "G";

				var gray:Number = GrayColor(pColor).gray / 100;

				write ( gray + " " + op );

			}

		}

		/**
		* Sets the text color for differents color spaces CMYK/RGB/DEVICEGRAY
		* @param
		*/

		private function textColor ( pColor:Color ):void

		{

			var op:String;

			// RGB ColorSpace
			if ( pColor is RGBColor )

			{

				op = !textRendering ? "rg" : "RG"

				var r:Number = RGBColor(pColor).r/255;
				var g:Number = RGBColor(pColor).g/255;
				var b:Number = RGBColor(pColor).b/255;

				addTextColor = r + " " + g + " " + b + " " + op;

			// CMYK ColorSpace
			} else if ( pColor is CMYKColor )

			{

				op = !textRendering ? "k" : "K"

				var c:Number = CMYKColor(pColor).cyan / 100;
				var m:Number = CMYKColor(pColor).magenta / 100;
				var y:Number = CMYKColor(pColor).yellow / 100;
				var k:Number = CMYKColor(pColor).black / 100;

				addTextColor = c + " " + m + " " + y + " " + k + " " + op;

			// Gray ColorSpace
			} else

			{

				op = !textRendering ? "g" : "G"

				var gray:Number = GrayColor(pColor).gray / 100;

				addTextColor = gray + " " + op;

			}

		}

		/**
		* Sets the filling color for differents color spaces CMYK/RGB/DEVICEGRAY
		*
		* @param pColor Color object, can be CMYKColor, GrayColor, or RGBColor
		* @example
		* This example shows how to create a red rectangle in the current page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.beginFill ( new RGBColor ( 255, 0, 0 ) );
		* myPDF.drawRect ( new Rectangle ( 10, 26, 50, 25 ) );
		* </pre>
		* </div>
		*/
		public function beginFill ( pColor:Color ):void

		{

			bFilled = true;

			var op:String;

			// RGB ColorSpace
			if ( pColor is RGBColor )

			{

				op = "rg";

				var r:Number = RGBColor(pColor).r/255;
				var g:Number = RGBColor(pColor).g/255;
				var b:Number = RGBColor(pColor).b/255;

				write ( r + " " + g + " " + b + " " + op );

			// CMYK ColorSpace
			} else if ( pColor is CMYKColor )

			{

				op = "k";

				var c:Number = CMYKColor(pColor).cyan / 100;
				var m:Number = CMYKColor(pColor).magenta / 100;
				var y:Number = CMYKColor(pColor).yellow / 100;
				var k:Number = CMYKColor(pColor).black / 100;

				write ( c + " " + m + " " + y + " " + k + " " + op );

			// Gray ColorSpace
			} else

			{

				op = "g";

				var gray:Number = GrayColor(pColor).gray / 100;

				write ( gray + " " + op );

			}

		}

		/**
		* Ends all previous filling
		*
		* @example
		* This example shows how to create a red rectangle in the current page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.beginFill ( new RGBColor ( Math.random()*255, Math.random()*255, Math.random()*255 ) );
		* myPDF.moveTo ( 10, 10 );
		* myPDF.lineTo ( 20, 90 );
		* myPDF.lineTo ( 90, 50);
		* myPDF.end()
		* myPDF.endFill();
		* </pre>
		* </div>
		*/
		public function endFill ( ):void

		{

			bFilled = false;

		}

		/**
		* The drawRect method draws a rectangle shape
		* @param pRect A flash.geom.Rectange object
		* @example
		* This example shows how to create a blue rectangle in the current page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.lineStyle ( new RGBColor ( Math.random()*255, Math.random()*255, Math.random()*255 ), 1, .3, null, CapsStyle.ROUND, JointStyle.MITER);
		* myPDF.beginFill ( new RGBColor ( 0, 0, 190 ) );
		* myPDF.drawRect ( new Rectangle ( 20, 46, 100, 45 ) );
		* </pre>
		* </div>
		*/
		public function drawRect (pRect:Rectangle):void
		{

			var style:String = bFilled ? 'b' : 'S';

			write (sprintf('%.2f %.2f %.2f %.2f re %s', pRect.x*k, (currentPage.h-pRect.y)*k, pRect.width*k, -pRect.height*k, style));

		}

		/**
		* The drawRoundedRect method draws a rounded rectangle shape
		* @param pRect A flash.geom.Rectange object
		* @param pR Angle radius
		* @example
		* This example shows how to create a rounded green rectangle in the current page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.lineStyle ( new RGBColor ( Math.random()*255, Math.random()*255, Math.random()*255 ), 1, .3, null, CapsStyle.ROUND, JointStyle.MITER);
		* myPDF.beginFill ( new RGBColor ( 0, 190, 0 ) );
		* myPDF.drawRoundedRect ( new Rectangle ( 20, 46, 100, 45 ), 20 );
		* </pre>
		* </div>
		*/
		public function drawRoundRect( pRect:Rectangle, pR:*):void
		{
			
			var k:Number = k;
			var hp:Number = currentPage.h;
			var MyArc:Number = 4/3 * (Math.sqrt(2) - 1);
			write(sprintf('%.2f %.2f m',(pRect.x+pR)*k,(hp-pRect.y)*k ));
			var xc:Number = pRect.x+pRect.width-pR;
			var yc:Number = pRect.y+pR;
			write(sprintf('%.2f %.2f l', xc*k,(hp-pRect.y)*k ));
			curve(xc + pR*MyArc, yc - pR, xc + pR, yc - pR*MyArc, xc + pR, yc);
			xc = pRect.x+pRect.width-pR ;
			yc = pRect.y+pRect.height-pR;
			write(sprintf('%.2f %.2f l',(pRect.x+pRect.width)*k,(hp-yc)*k));
			curve(xc + pR, yc + pR*MyArc, xc + pR*MyArc, yc + pR, xc, yc + pR);
			xc = pRect.x+pR;
			yc = pRect.y+pRect.height-pR;
			write(sprintf('%.2f %.2f l',xc*k,(hp-(pRect.y+pRect.height))*k));
			curve(xc - pR*MyArc, yc + pR, xc - pR, yc + pR*MyArc, xc - pR, yc);
			xc = pRect.x+pR ;
			yc = pRect.y+pR;
			write(sprintf('%.2f %.2f l',(pRect.x)*k,(hp-yc)*k ));
			curve(xc - pR, yc - pR*MyArc, xc - pR*MyArc, yc - pR, xc, yc - pR);
			var style:String = bFilled ? 'b' : 'S';
			write(style);
			
		}

		/**
		* The drawEllipse method draws an ellipse
		* @param pX X Position
		* @param pY Y Position
		* @param pRx X Radius
		* @param pRy Y Radius
		* @example
		* This example shows how to create a rounded red ellipse in the current page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.lineStyle ( new RGBColor ( Math.random()*255, Math.random()*255, Math.random()*255 ), 1, .3, new DashedLine ([0, 1, 2, 6]), CapsStyle.NONE, JointStyle.ROUND);
		* myPDF.beginFill ( new RGBColor ( 150, 0, 0 ) );
		* myPDF.drawEllipse( 45, 275, 40, 15 );
		* </pre>
		* </div>
		*/
		public function drawEllipse ( pX:Number, pY:Number, pRx:Number, pRy:Number):void
		{

			var style:String = bFilled ? 'b' : 'S';

			var lx:Number = 4/3*(1.41421356237309504880-1)*pRx;
			var ly:Number = 4/3*(1.41421356237309504880-1)*pRy;
			var k:Number = k;
			var h:Number = currentPage.h;

			write(sprintf('%.2f %.2f m %.2f %.2f %.2f %.2f %.2f %.2f c',
				(pX+pRx)*k,(h-pY)*k,
				(pX+pRx)*k,(h-(pY-ly))*k,
				(pX+lx)*k,(h-(pY-pRy))*k,
				pX*k,(h-(pY-pRy))*k));
			write(sprintf('%.2f %.2f %.2f %.2f %.2f %.2f c',
				(pX-lx)*k,(h-(pY-pRy))*k,
				(pX-pRx)*k,(h-(pY-ly))*k,
				(pX-pRx)*k,(h-pY)*k));
			write(sprintf('%.2f %.2f %.2f %.2f %.2f %.2f c',
				(pX-pRx)*k,(h-(pY+ly))*k,
				(pX-lx)*k,(h-(pY+pRy))*k,
				pX*k,(h-(pY+pRy))*k));
			write(sprintf('%.2f %.2f %.2f %.2f %.2f %.2f c %s',
				(pX+lx)*k,(h-(pY+pRy))*k,
				(pX+pRx)*k,(h-(pY+ly))*k,
				(pX+pRx)*k,(h-pY)*k,
				style));
		}

		/**
		* The drawCircle method draws a circle
		* @param pX X Position
		* @param pY Y Position
		* @param pRadius Circle Radius
		* @example
		* This example shows how to create a rounded red ellipse in the current page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.beginFill ( new RGBColor ( Math.random()*255, Math.random()*255, Math.random()*255 ) );
		* myPDF.drawCircle( 30, 180, 20 );
		* </pre>
		* </div>
		*/
		public function drawCircle( pX:Number, pY:Number, pRadius:Number):void
		{

			this.drawEllipse (pX,pY,pRadius,pRadius);

		}

		/**
		* The drawPolygone method draws a polygone
		* @param pPoints Array of points
		* @example
		* This example shows how to create a polygone with a few points :
		* <div class="listing">
		* <pre>
		*
		* myPDF.beginFill ( new RGBColor ( Math.random()*255, Math.random()*255, Math.random()*255 ) );
		* myPDF.drawPolygone( [10, 30, 100, 5, 80, 18]  );
		* </pre>
		* </div>
		*/
		public function drawPolygone ( pPoints:Array ):void

		{

			var lng:int = pPoints.length;
			var i:int = 0;

			while ( i < lng )

			{

				!i ? moveTo ( pPoints[i], pPoints[i+1] ) : lineTo ( pPoints[i], pPoints[i+1] );

				i+=2;

			}

			end();

		}

		/*
		* TBD
		*/
		private function drawRegularPolygone ( ):void

		{


		}

		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/*
		* AlivePDF Interactive API
		*
		* addNote()
		* addTransition()
		* addBookmark()
		* addLink()
		*
		*/
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		/**
		* Lets you add a text annotation to the current page
		*
		* @param pX Note X position
		* @param pY Note Y position
		* @param pWidth Note width
		* @param pHeight Note height
		* @param pText Text for the note
		* @example
		* This example shows how to add a note annotation in the current page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.addNote (100, 75, 50, 50, "A note !");
		* </pre>
		* </div>
		*/
		public function addTextNote ( pX:Number, pY:Number, pWidth:Number, pHeight:Number, pText:String="A note !" ):void

		{

			var rectangle:String = pX*k + ' ' + (((currentPage.h-pY)*k) - (pHeight*k)) + ' ' + ((pX*k) + (pWidth*k)) + ' ' + (currentPage.h-pY)*k;

			currentPage.annotations += ( '<</Type /Annot /Name /Help /Border [0 0 1] /Subtype /Text /Rect [ '+rectangle+' ] /Contents ('+pText+')>>' );

		}
		
		/**
		* Lets you add a stamp annotation to the current page
		*
		* @param pStyle Stamp style can be StampStyle.CONFIDENTIAL, StampStyle.FOR_PUBLIC_RELEASE, etc.
		* @param pX Note X position
		* @param pY Note Y position
		* @param pWidth Note width
		* @param pHeight Note height
		* @example
		* This example shows how to add a stamp annotation in the current page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.addStamp( StampStyle.CONFIDENTIAL, 15, 15, 50, 50 );
		* </pre>
		* </div>
		*/
		private function addStampNote ( pStyle:String, pX:Number, pY:Number, pWidth:Number, pHeight:Number ):void
		
		{
			
			var rectangle:String = pX*k + ' ' + (((currentPage.h-pY)*k) - (pHeight*k)) + ' ' + ((pX*k) + (pWidth*k)) + ' ' + (currentPage.h-pY)*k;
			
			currentPage.annotations += ( '<</Type /Annot /Name /'+pStyle+' /Subtype /Stamp /Rect [ '+rectangle+' ]>>' );
			
		}

		/**
		* Lets you add a bookmark
		*
		* @param pText Text appearing in the outline panel
		* @param pLevel Specify the bookmark's level
		* @param pY Position in the current page to go
		* @param pRed Red offset for the text color
		* @param pGreen Green offset for the text color
		* @param pBlue Blue offset for the text color
		* @example
		* This example shows how to add a bookmark for the current page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.addBookmark("A bookmark", 0, 0, 0, .9, 0);
		* myPDF.addPage();
		* myPDF.addBookmark("Another bookmark", 0, 60, .9, .9, 0);
		* </pre>
		* </div>
		*/
		public function addBookmark ( pText:String, pLevel:int=0, pY:Number=0, pRed:Number=0, pGreen:Number=0, pBlue:Number=0 ):void
		{

			if( pY == -1 ) pY = getY();

			outlines.push ( { 't' : pText == null ? 'Page ' + page : pText, 'l' : pLevel,'y' : pY,'p' : page, redMultiplier : pRed, greenMultiplier : pGreen, blueMultiplier : pBlue } );

		}
		
		/**
		* Lets you add clickable link at a specific position
		*
		* @param pPage Page Format, can be Size.A3, Size.A4, Size.A5, Size.LETTER or Size.LEGAL
		* @return Page
		* @example
		* This example shows how to add an invisible clickable link in the current page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.addLink ( 70, 4, 60, 16, "http://www.alivepdf.org");
		* </pre>
		* </div>
		*/
		public function addLink ( pX:Number, pY:Number, pWidth:Number, pHeight:Number, pLink:*, pHighlight:String="I" ):void
		{

			var rectangle:String = pX*k + ' ' + (((currentPage.h-pY)*k) - (pHeight*k)) + ' ' + ((pX*k) + (pWidth*k)) + ' ' + (currentPage.h-pY)*k;

			currentPage.annotations += "<</Type /Annot /Subtype /Link /Rect ["+rectangle+"] /Border [0 0 0] /H /"+pHighlight+" ";

			if ( pLink is String ) currentPage.annotations += "/A <</S /URI /URI "+_textstring(pLink)+">>>>";

			else
			{

				var l:String = links[pLink];
				var h:Number = orientationChanges[l[0]] != null ? currentPage.wPt : currentPage.hPt;
				currentPage.annotations += sprintf('/Dest [%d 0 R /XYZ 0 %.2f null]>>',1+2*l[0],h-l[1]*k);

			}

		}

		/**
		* Lets you add a transition between each PDF page
		*
		* @param pStyle Transition style, can be Transition.SPLIT, Transition.BLINDS, BLINDS.BOX, Transition.WIPE, etc.
		* @param pDuration The transition duration
		* @param pDimension The dimension in which the the specified transition effect occurs
		* @param pMotionDirection The motion's direction for the specified transition effect
		* @param pTransitionDirection The direction in which the specified transition effect moves
		* @example
		* This example shows how to add a 4 seconds "Wipe" transition between the first and second page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.addPage();
		* myPDF.addTransition (Transition.WIPE, 4, Dimension.VERTICAL);
		* myPDF.addPage();
		* </pre>
		* </div>
		*/
		public function addTransition ( pStyle:String='R', pDuration:Number=1, pDimension:String='H', pMotionDirection:String='I', pTransitionDirection:int=0 ):void

		{

			currentPage.addTransition ( pStyle, pDuration, pDimension, pMotionDirection, pTransitionDirection );

		}

		/**
		* Lets you control the way the document is to be presented on the screen or in print.
		*
		* @param pToolBar Toolbar behavior
		* @param pMenuBar Menubar behavior
		* @param pWindowUI WindowUI behavior
		* @param pFitWindow Specify whether to resize the document's window to fit the size of the first displayed page.
		* @param pCenteredWindow Specify whether to position the document's window in the center of the screen.
		* @param pDisplayTitle Specify whether the window's title bar should display the document title taken from the value passed to the setTitle method
		* @example
		* This example shows how to present the document centered on the screen with no toolbars :
		* <div class="listing">
		* <pre>
		*
		* myPDF.setViewerPreferences (ToolBar.HIDE, MenuBar.HIDE, WindowUI.HIDE, FitWindow.DEFAULT, CenterWindow.CENTERED);
		* </pre>
		* </div>
		*/
		public function setViewerPreferences ( pToolBar:String='false', pMenuBar:String='false', pWindowUI:String='false', pFitWindow:String='false', pCenteredWindow:String='false', pDisplayTitle:String='false' ):void

		{

			viewerPreferences = '/ViewerPreferences << /HideToolbar '+pToolBar+' /HideMenubar '+pMenuBar+' /HideWindowUI '+pWindowUI+' /FitWindow '+pFitWindow+' /CenterWindow '+pCenteredWindow+' /DisplayDocTitle '+pDisplayTitle+' >>';

		}

		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/*
		* AlivePDF font API
		*
		* setFont()
		* setFontSize()
		*
		*/
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		/**
		* Lets you retrieve a Page object
		*
		* @param pPage Page Format, can be Size.A3, Size.A4, Size.A5, Size.LETTER or Size.LEGAL
		* @return Page
		* @example
		* This example shows how to retrieve the first page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.getPage ( 1 );
		* </pre>
		* </div>
		*/
		private function addFont (family:String,style:String='',file:String=''):void
		{
			var family:String = family.toLowerCase();
			
			if( file=='' ) file = str_replace(' ','',family) + style.toLowerCase()+'.php';
			if( family=='arial' ) family='helvetica';
			style = style.toUpperCase();
			if ( style=='IB' ) style='BI';
			var fontkey:String = family + style;
			if( this.fonts[fontkey] != null ) throw new Error ('Font already added: ' + family + ' ' + style);
			if( name == null ) throw new Error ('Could not include font definition file');
			var i:int = this.getNumImages ( this.fonts.length )+1;
			this.fonts[fontkey] = { i : i, type : type, name : name, desc : desc, up : up, ut : ut, cw : cw, enc : enc, file : file };
			if(diff)
			{
				//Search existing encodings
				d=0;
				nb = this.diffs.length;
				for ( var j:int = 1; j <= nb ;j++ )
				{
					if(this.diffs[j]==diff)
					{
						d=j;
						break;
					}
				}
				if( d==0 )
				{
					d = nb+1;
					this.diffs[d]=diff;
				}
				this.fonts[fontkey].diff = d;
			}
			if(file)
			{
				if(type=='TrueType') this.fontFiles[file]={ length1 : originalsize };
				else this.fontFiles[file]= { length1 : size1, length2 : size2 };
			}
		}

		/**
		* Lets you set a specific font
		*
		* @param pFamily Font family, can be any of FontFamily.COURIER, FontFamily.HELVETICA, FontFamily.ARIAL, FontFamily.TIMES, FontFamily.SYMBOL, FontFamily.ZAPFDINGBATS.
		* @param pStyle Any font style, can be Style.BOLD, Style.ITALIC, Style.BOLD_ITALIC, Style.NORMAL
		* @return Page
		* @example
		* This example shows how to set the Helvetica font, with a bold style :
		* <div class="listing">
		* <pre>
		*
		* myPDF.setFont( FontFamily.HELVETICA, Style.BOLD );
		* </pre>
		* </div>
		*/
		public function setFont ( pFamily:String , pStyle:String='', pSize:int=0 ):void
		{
			pFamily = pFamily.toLowerCase();
			
			if ( pFamily == '' ) pFamily = fontFamily;
			if ( pFamily == 'arial' ) pFamily = 'helvetica';
			else if ( pFamily == 'symbol' || pFamily == 'zapfdingbats' ) pStyle='';
			pStyle = pStyle.toUpperCase();

			if( pStyle.indexOf ('U')!= -1 )
			{

				underline=true;
				pStyle = str_replace( 'U','', pStyle );

			} else underline = false;

			if( pStyle == 'IB' ) pStyle =' BI';
			if( pSize == 0 ) pSize = fontSizePt;
			if( fontFamily == pFamily && fontStyle == pStyle && fontSizePt == pSize ) return;
			
			fontkey = pFamily+pStyle;
			
			if( (fonts[fontkey] == null ))
			{
				if((standardFonts[fontkey] != null ))
				{
					if((FontMetrics[fontkey] == null ))
					{
						file = pFamily;
						if( pFamily == 'times' || pFamily == 'helvetica' ) file += pStyle.toLowerCase();
						if( FontMetrics[fontkey] == null ) throw new Error('Could not include font metric file');

					}
					var i:int = getNumImages(fonts)+1;
					fonts[fontkey]= { i : i, type : 'core', name : standardFonts[fontkey], up : -100, ut : 50, cw : FontMetrics[fontkey] };

				} else throw new Error ('Undefined font: '+pFamily+' '+pStyle);
			}
			//Select it
			fontFamily = pFamily;
			fontStyle = pStyle;
			fontSizePt = pSize;
			fontSize = pSize/k;
			currentFont = fonts[fontkey];
			if ( page>0 ) write(sprintf('BT /F%d %.2f Tf ET',currentFont.i,fontSizePt));
		}

		/**
		* Lets you retrieve a Page object
		*
		* @param pPage Page Format, can be Size.A3, Size.A4, Size.A5, Size.LETTER or Size.LEGAL
		* @return Page
		* @example
		* This example shows how to retrieve the first page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.getPage ( 1 );
		* </pre>
		* </div>
		*/
		public function setFontSize(size:int):void
		{
			//Set font size in points
			if(fontSizePt == size) return;
			fontSizePt = size;
			fontSize = size/k;
			if(page>0) write(sprintf('BT /F%d %.2f Tf ET',currentFont.i,fontSizePt));
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/*
		* AlivePDF text API
		*
		* addText()
		* textStyle()
		* addCell()
		* addMultiCell()
		* writeText()
		*
		*/
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		/**
		* Lets you set some text to any position on the page
		*
		* @param pTxt The text to add
		* @param pX X position
		* @param pY Y position
		* @example
		* This example shows how to set some text to a specific place :
		* <div class="listing">
		* <pre>
		*
		* myPDF.addText ('Cubic Bezier curve with curveTo', 14, 110);
		* </pre>
		* </div>
		*/
		public function addText ( pTxt:String, pX:Number=0, pY:Number=0 ):void
		{

			var s:String = sprintf('BT %.2f %.2f Td (%s) Tj ET',pX*k, (currentPage.h-pY)*k, _escape(pTxt));
			if(underline && pTxt !='') s+=' '+_dounderline(pX,pY,pTxt);
			if(colorFlag) s = 'q ' + addTextColor + ' ' + s +' Q';
			write(s);

		}

		/**
		* Sets the text style
		*
		* @param pColor Color object, can be CMYKColor, GrayColor, or RGBColor
		* @param pAlpha Text opacity
		* @param pRendering pRendering Specify the text rendering mode
		* @param pWordSpace Spaces between each words
		* @param pCharSpace Spaces between each characters
		* @param pScale Text scaling
		* @param pLeading Text leading
		* @example
		* This example shows how to set a specific black text style with full opacity :
		* <div class="listing">
		* <pre>
		*
		* myPDF.textStyle ( new RGBColor ( 0, 0, 0 ), 1 ); 
		* </pre>
		* </div>
		*/
		public function textStyle ( pColor:Color, pAlpha:int=1, pRendering:int=0, pWordSpace:Number=0, pCharSpace:Number=0, pScale:Number=100, pLeading:Number=0 ):void
		{

			write ( sprintf ( '%d Tr', textRendering = pRendering ) );
			textColor ( pColor );
			setAlpha ( pAlpha );
			write ( pWordSpace + ' Tw ' + pCharSpace + ' Tc ' + pScale + ' Tz ' + pLeading + ' TL ' );
			colorFlag = ( fillColor != addTextColor );

		}

		/**
		* Add a cell with some text to the current page
		*
		* @param pWidth Cell width
		* @param pHeight Cell height
		* @param pText Text to add into the cell
		* @param pLn Sets the new position after cell is drawn, default value is 0
		* @param pAlign Lets you center or align the text into the cell
		* @param pFill Lets you specify if the cell is colored (1) or transparent (0)
		* @param pLink Any http link, like http://www.mylink.com
		* @return Page
		* @example
		* This example shows how to write some text within a cell :
		* <div class="listing">
		* <pre>
		*
		* myPDF.setFont(FontFamily.HELVETICA, 'B', 12);
		* myPDF.textStyle ( new RGBColor ( 255, 0, 0 ) );
		* myPDF.addCell(50,10,'Some text into a cell !',1,1);
		* </pre>
		* </div>
		* This example shows how to write some clikable text within a cell :
		* <div class="listing">
		* <pre>
		*
		* myPDF.setFont(FontFamily.HELVETICA, 'B', 12);
		* myPDF.textStyle ( new RGBColor ( 200, 50, 50 ) );
		* myPDF.addCell(50,10,'A clikable cell !',1,1, null, 0, "http://www.alivepdf.org");
		* </pre>
		* </div>
		*/
		public function addCell ( pWidth:Number=0, pHeight:Number=0, pText:String='', pBorder:*=0, pLn:Number=0, pAlign:String='', pFill:Number=0, pLink:String='' ):void
		{

			//Output a cell
			var k:Number = this.k;

			if( this.y + pHeight > this.pageBreakTrigger && !this.inFooter && this.acceptPageBreak() )
			{
				//Automatic page break
				x=this.x;
				ws=this.ws;
				if(ws>0)
				{
					this.ws=0;
					this.write('0 Tw');
				}
				this.addPage(this.currentOrientation, this.defaultUnit, this.defaultFormat ,currentPage.rotation);
				this.x = x ;
				if(ws>0)
				{
					this.ws=ws;
					this.write(sprintf('%.3f Tw',ws*k));
				}
			}

			if ( currentPage.w==0 ) currentPage.w = currentPage.w-this.rMargin-this.x;
			var s:String = new String;
			var op:String;

			if( pFill == 1 || pBorder == 1 )
			{

				if (pFill == 1 ) op = ( pBorder == 1 ) ? 'B' : 'f';
				else op = 'S';
				s=sprintf('%.2f %.2f %.2f %.2f re %s ',this.x*k,(currentPage.h-this.y)*k,pWidth*k,-pHeight*k,op);

			}

			if ( pBorder is String )
			{
				x=this.x;
				y=this.y;

				var tmpBorder:String = pBorder as String;

				if( tmpBorder.indexOf('L') != -1 ) s+=sprintf('%.2f %.2f m %.2f %.2f l S ',x*k,(currentPage.h-y)*k,x*k,(currentPage.h-(y+pHeight))*k);
				if( tmpBorder.indexOf ('T') != -1) s+=sprintf('%.2f %.2f m %.2f %.2f l S ',x*k,(currentPage.h-y)*k,(x+pWidth)*k,(currentPage.h-y)*k);
				if( tmpBorder.indexOf ('R') != -1) s+=sprintf('%.2f %.2f m %.2f %.2f l S ',(x+pWidth)*k,(currentPage.h-y)*k,(x+pWidth)*k,(currentPage.h-(y+pHeight))*k);
				if( tmpBorder.indexOf ('B') != -1 ) s+=sprintf('%.2f %.2f m %.2f %.2f l S ',x*k,(currentPage.h-(y+pHeight))*k,(x+pWidth)*k,(currentPage.h-(y+pHeight))*k);

			}

			if( pText !== '' )
			{
				var dx:Number;
				if ( pAlign=='R' ) dx = pWidth-this.cMargin-this.GetStringWidth(pText);
				else if( pAlign=='C' ) dx = (pWidth-this.GetStringWidth(pText))/2;
				else dx = this.cMargin;
				if(this.colorFlag) s+='q '+this.addTextColor+' ';
				var txt2:String = str_replace(')','\\)',str_replace('(','\\(',str_replace('\\','\\\\',pText)));
				s+=sprintf('BT %.2f %.2f Td (%s) Tj ET',(this.x+dx)*k,(currentPage.h-(this.y+.5*pHeight+.3*this.fontSize))*k,txt2);
				if(this.underline) s+=' '+_dounderline(this.x+dx,this.y+.5*pHeight+.3*this.fontSize,pText);
				if(this.colorFlag) s+=' Q';
				if( pLink ) this.addLink (this.x+dx,this.y+.5*pHeight-.5*this.fontSize,this.GetStringWidth(pText),this.fontSize, pLink);

			}

			if ( s ) this.write(s);

			this.lasth = currentPage.h;

			if( pLn >0)
			{
				//Go to next line
				this.y += pHeight;
				if( pLn ==1) this.x = this.lMargin;

			} else this.x += currentPage.w;
		}

		/**
		* Add a multicell with some text to the current page
		*
		* @param pWidth Cell width
		* @param pHeight Cell height
		* @param pText Text to add into the cell
		* @param pBorder Lets you specify if a border should be drawn around the cell
		* @param pAlign Lets you center or align the text into the cell, values can be L (left align), C (centered), R (right align), J (justified) default value
		* @param pFill Lets you specify if the cell is colored (1) or transparent (0)
		* @return Page
		* @example
		* This example shows how to write a table made of text cells :
		* <div class="listing">
		* <pre>
		*
		* myPDF.setFont('helvetica', 'B', 12);
		* myPDF.textStyle ( new RGBColor ( 0, 0, 0 ) );
		* myPDF.addMultiCell ( 70, 24, "A multicell :)", 1);
		* myPDF.addMultiCell ( 70, 24, "A multicell :)", 1);
		* </pre>
		* </div>
		*/
		public function addMultiCell ( pWidth:Number, pHeight:Number, pText:String, pBorder:*=0, pAlign:String='J', pFill:int=0):void
		{
			//Output text with automatic or explicit line breaks
			cw = this.currentFont.cw;

			if ( pWidth==0 ) pWidth = currentPage.w-this.rMargin - this.x;

			var wmax:Number = (pWidth-2*this.cMargin)*1000/this.fontSize;
			var s:String = str_replace ("\r",'',pText);
			var nb:int = s.length;

			if( nb > 0 && s.charAt(nb-1) == "\n" ) nb--;

			var b:* = 0;

			if( pBorder )
			{
				if( pBorder == 1 )
				{
					pBorder='LTRB';
					b='LRT';
					b2='LR';
				}
				else
				{
					b2='';
					if(pBorder.indexOf('L')!= -1) b2+='L';
					if(pBorder.indexOf('R')!= -1) b2+='R';
					b = (pBorder.indexOf('T')!= -1) ? b2+'T' : b2;
				}
			}

			var sep:int = -1;
			var i:int = 0;
			var j:int = 0;
			var l:int = 0;
			var ns:int = 0;
			var nl:int = 1;

			while(i<nb)
			{
				//Get next character
				var c:String = s.charAt(i);
				if(c=="\n")
				{
					//Explicit line break
					if(this.ws>0)
					{
						this.ws=0;
						this.write('0 Tw');
					}
					this.addCell(pWidth,pHeight,s.substr(j,i-j),b,2,pAlign,pFill);
					i++;
					sep=-1;
					j=i;
					l=0;
					ns=0;
					nl++;
					if(pBorder && nl==2) b=b2;
					continue;
				}
				if(c==' ')
				{
					sep=i;
					var ls:int = l;
					ns++;
				}

				l+=cw[c];

				if(l>wmax)
				{
					//Automatic line break
					if(sep==-1)
					{
						if(i==j) i++;
						if(this.ws>0)
						{
							this.ws=0;
							this.write('0 Tw');
						}
						this.addCell(pWidth,pHeight,s.substr(j,i-j),b,2,pAlign,pFill);
					}
					else
					{
						if(pAlign=='J')
						{
							this.ws=(ns>1) ? (wmax-ls)/1000*this.fontSize/(ns-1) : 0;
							this.write(sprintf('%.3f Tw',this.ws*this.k));
						}
						this.addCell(pWidth,pHeight,s.substr(j,sep-j),b,2,pAlign,pFill);
						i=sep+1;
					}
					sep=-1;
					j=i;
					l=0;
					ns=0;
					nl++;
					if ( pBorder && nl == 2 ) b = b2;
				}
				else i++;
			}
			//Last chunk
			if(this.ws>0)
			{
				this.ws=0;
				this.write('0 Tw');
			}

			if ( pBorder && pBorder.indexOf ('B')!= -1 ) b += 'B';
			this.addCell ( pWidth,pHeight,s.substr(j,i-j),b,2,pAlign,pFill );
			this.x = this.lMargin;
		}

		/**
		* Lets you write some text
		*
		* @param pHeight Line height, lets you specify height between each lines
		* @param pText Text to write, to put a line break just add a \n in the text string
		* @param pLink Any link, like http://www.mylink.com, will open te browser when clicked
		* @example
		* This example shows how to add some text to the current page :
		* <div class="listing">
		* <pre>
		*
		* myPDF.writeText ( 5, "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.", "http://www.google.fr");
		* </pre>
		* </div>
		* This example shows how to add some text with a clickable link :
		* <div class="listing">
		* <pre>
		*
		* myPDF.writeText ( 5, "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.", "http://www.google.fr");
		* </pre>
		* </div>
		*/
		public function writeText ( pHeight:Number, pText:String, pLink:String='' ):void
		{
			//Output text in flowing mode
			var cw:Object = this.currentFont.cw;
			var w:Number = currentPage.w-this.rMargin-this.x;
			var wmax:Number = (w-2*this.cMargin)*1000/this.fontSize;
			var s:String = str_replace ("\r",'',pText);
			//var s:String = ",,,"
			var nb:int = s.length;
			var sep:int = -1;
			var i:int = 0;
			var j:int = 0;
			var l:int = 0;
			var nl:int = 1;

			while( i<nb )
			{
				//Get next character
				var c:String = s.charAt(i);

				if(c=="\n")
				{
					//Explicit line break
					this.addCell (w,pHeight,s.substr(j,i-j),0,2,'',0,pLink);
					i++;
					sep=-1;
					j=i;
					l=0;
					if(nl==1)
					{
						this.x = this.lMargin;
						w = currentPage.w-this.rMargin-this.x;
						wmax= (w-2*this.cMargin)*1000/this.fontSize;
					}
					nl++;
					continue;
				}
				if(c==' ') sep=i;
				l+=cw[c];
				if(l>wmax)
				{
					//Automatic line break
					if(sep==-1)
					{
						if(this.x>this.lMargin)
						{
							//Move to next line
							this.x = this.lMargin;
							this.y += currentPage.h;
							w = currentPage.w-this.rMargin-this.x;
							wmax = (w-2*this.cMargin)*1000/this.fontSize;
							i++;
							nl++;
							continue;
						}
						if(i==j) i++;
						this.addCell (w,pHeight,s.substr(j,i-j),0,2,'',0,pLink);
					}
					else
					{
						this.addCell (w,pHeight,s.substr(j,sep-j),0,2,'',0,pLink);
						i=sep+1;
					}
					sep=-1;
					j=i;
					l=0;
					if(nl==1)
					{
						this.x=this.lMargin;
						w=currentPage.w-this.rMargin-this.x;
						wmax=(w-2*this.cMargin)*1000/this.fontSize;
					}
					nl++;
				}
				else i++;
			}
			//Last chunk
			if (i!=j) this.addCell (l/1000*this.fontSize,pHeight,s.substr(j),0,0,'',0,pLink);
		}
		
		/**
		* Lets you activate the auto pagination mode
		*
		* @param pActive Activate the mode
		* @example
		* This example shows how to activate the auto pagination mode :
		* <div class="listing">
		* <pre>
		*
		* myPDF.setPagination ( true );
		* </pre>
		* </div>
		*/
		public function setPagination ( pActive:Boolean ):void

		{

			if ( autoPagination != pActive ) autoPagination = pActive;

		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/*
		* AlivePDF saving API
		*
		* savePDF()
		* textStyle()
		* addCell()
		* addMultiCell()
		* writeText()
		*
		*/
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		/**
		* Lets you finalize and save the PDF document and make it available for download
		*
		* @param pMethod Can be se to Method.LOCAL, the savePDF will return the PDF ByteArray. When Method.REMOTE is passed, just specify the path to the create.php file
		* @param pURL The url of the create.php file
		* @param pDownload Lets you specify the way the PDF is going to be available. Use Download.INLINE if you want the PDF to be opened in the browser, use Download.ATTACHMENT if you want to make it available with a save-as dialog box
		* @param pName The name of the PDF, only available when Method.REMOTE is used
		* @return The ByteArray PDF when Method.LOCAL is used, otherwise the method returns null
		* @example
		* This example shows how to save the PDF with a download dialog-box :
		* <div class="listing">
		* <pre>
		*
		* var myPDFStream:ByteArray = myPDF.getPDF();
		* </pre>
		* </div>
		*/
		public function savePDF( pMethod:String, pURL:String='', pDownload:String='inline', pName:String='generated.pdf' ):*

		{

			finish();

			if ( pMethod == Method.LOCAL ) return this.buffer;

			var header:URLRequestHeader = new URLRequestHeader ("Content-type", "application/octet-stream");

			var myRequest:URLRequest = new URLRequest ( pURL+'?name='+pName+'&method='+pDownload );

			myRequest.requestHeaders.push (header);
			

			myRequest.method = URLRequestMethod.POST;
			trace(this.buffer);
			myRequest.data = savePDF( Method.LOCAL );

			navigateToURL ( myRequest, "_blank" );

			return null;

		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/*
		* AlivePDF image API
		*
		* addImage()
		* textStyle()
		* addCell()
		* addMultiCell()
		* writeText()
		*
		*/
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		/**
		* The addImage method takes an incoming DisplayObject object, take a snapshot from it in JPG and add it to the PDF document
		*
		* @param pDisplayObject Any DisplayObject
		* @param pAlpha Image transparency
		* @param pBlend Blend mode, can be Blend.DIFFERENCE, BLEND.HARDLIGHT, etc.
		* @param pMatrix A transformation matrix to apply to the picture
		* @param pResizePage Automatically resize the page so that the full picture fits in the page
		* @param pEncoding Image format, can be ImageFormat.JPG
		* @param pQuality Compression quality
		* @param pX Image X position
		* @param pY Image Y position
		* @param pWidth Image width
		* @param pHeight Image height
		* @param pLink If pLink is specified, the image is clickable and reaches the http link specified when clicked
		* @return Page
		* @example
		* This example shows how to add a 100% compression quality JPG image into the current page, and make the image fits :
		* <div class="listing">
		* <pre>
		*
		* myPDF.addImage (myDisplayObject, 1 , null, null, false, ImageFormat.JPG, 100, 160, 120, 0, 0);
		* </pre>
		* </div>
		*/
		public function addImage ( pDisplayObject:DisplayObject, pAlpha:Number=1, pBlend:String="Normal", pMatrix:Matrix=null, pResizePage:Boolean=false, pEncoding:String="JPG", pQuality:Number=100, pX:Number=0, pY:Number=0, pWidth:Number=0, pHeight:Number=0, pLink:String='' ):void
		{

			var info:Object
			var pos:int;
			
			setAlpha ( pAlpha, pBlend );
			
			if ( pMatrix == null ) pMatrix = new Matrix();

			if( images[pDisplayObject] == null )
			{

				if ( pEncoding == ImageFormat.JPG ) info = parseJPG ( pDisplayObject, false, pQuality );

				//else if( pEncoding == ImageFormat.PNG ) info = this.parsePNG ( pDisplayObject, false );

				else throw new Error ( 'Image type not supported : ' + pEncoding );

				info.i = getNumImages ( images )+1;

				this.images[pDisplayObject] = info;

			} else info = images[pDisplayObject];

			//Automatic width and height calculation if needed
			if( pWidth == 0 && pHeight == 0 )
			{
				//Put image at 72 dpi
				pWidth=info.w/k;
				pHeight=info.h/k;

			}

			if (pWidth==0) pWidth = pHeight*info.w/info.h;
			if (pHeight==0) pHeight = pWidth*info.h/info.w;

			var ratio:Number = Math.min ( currentPage.width / info.w, currentPage.height / info.h );

			if ( pResizePage )

			{

				currentPage.width = info.w;
				currentPage.height = info.h;
				currentPage.fwPt = info.w;
				currentPage.fhPt = info.h;
				currentPage.wPt = info.w;
				currentPage.hPt = info.h;
				currentPage.w = currentPage.wPt/k;
				currentPage.h = currentPage.hPt/k;

			} else if ( ratio < 1 )

			{

				pWidth *= ratio;
				pHeight *= ratio;

			}

			var a:Number = pMatrix.a;
			var b:Number = pMatrix.b;
			var c:Number = pMatrix.c;
			var d:Number = pMatrix.d;

			var scaleX:Number = pMatrix.a
			var scaleY:Number = pMatrix.d;

			this.write (sprintf('q %.2f 0 0 %.2f %.2f %.2f cm '+a+' '+b+' '+c+' '+d+' 0 0 cm '+scaleX+' 0 0 '+scaleY+' 0 0 cm/I%d Do Q', pWidth*k, pHeight*k, pX*k, (currentPage.h-(pY+pHeight))*k, info.i));

			if ( pLink ) addLink( pX, pY, pWidth, pHeight, pLink );

		}
		
		// coming soon ;)
		private function addImageStream ( pStream:ByteArray ):void 
		
		{
			
			
			
		}

		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/*
		* Private members
		*/
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		private function finish():void
		
		{

			if ( state < 3 ) close();

			dispatcher.dispatchEvent ( new Event ( Event.COMPLETE ) );

		}
		
		private function setUnit ( pUnit:String ):String
		
		{
			
			if ( pUnit == Unit.POINT ) k = 1;
			else if ( pUnit == Unit.MM ) k = 72/25.4;
			else if ( pUnit == Unit.CM ) k = 72/2.54;
			else if ( pUnit == Unit.INCHES ) k = 72;
			else throw new RangeError ('Incorrect unit: ' + pUnit);
			
			return pUnit;
			
		}
		
		private function acceptPageBreak():Boolean
		
		{
			return autoPageBreak;
			
		}

		private function curve (x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):void
		
		{

			var h:Number = currentPage.h;

			write(sprintf('%.2f %.2f %.2f %.2f %.2f %.2f c ', x1*k, (h-y1)*k, x2*k, (h-y2)*k, x3*k, (h-y3)*k));

		}

		private function GetStringWidth(s:String):Number
		
		{

			var s:String = String ( s );
			cw = currentFont.cw
			var w:Number=0;
			var l:int = s.length;
			for(var i:int=0;i<l;i++)w+=cw[s.charAt(i)];
			return w*fontSize/1000;

		}

		private function Open():void
		
		{
			
			this.state=1;
			
		}

		private function close ():void
		
		{
			if( state == 3 ) return;
			if( !arrayPages.length ) addPage();
			finishPage();
			finishDocument();
			
		}

		private function addExtGState(parms:Object):int
		
		{

			extgstates.push ( parms );
			return extgstates.length-1;

		}

		private function setExtGState( pGraphicState:int ):void
		
		{
			write(sprintf('/GS%d gs', pGraphicState));
			
		}

		private function insertExtGState():void
		
		{
			for ( var i:int = 0; i < extgstates.length; i++)
			{
				
				newObj();
				extgstates[i].n = n;
				write('<</Type /ExtGState');
				for (var k:String in extgstates[i]) write('/'+k+' '+extgstates[i][k]);
				write('>>');
				write('endobj');

			}
			
		}

		private function getChannels ( pColor:Number ):String

		{

			var r:Number = (pColor & 0xFF0000) >> 16;
			var g:Number = (pColor & 0x00FF00) >> 8;
			var b:Number = (pColor & 0x0000FF);

			return (r / 255) + " " + (g / 255) + " " + (b / 255);

		}

		private function getCurrentDate ( ):String

		{

			var myDate:Date = new Date;

			var year:Number = myDate.getFullYear();
			var month:*= myDate.getMonth() < 10 ? "0"+Number(myDate.getMonth()+1) : myDate.getMonth()+1;
			var day:Number = myDate.getDate();
			var hours:* = myDate.getHours() < 10 ? "0"+Number(myDate.getHours()) : myDate.getHours();
			var currentDate:String = myDate.getFullYear()+''+month+''+day+''+hours+''+myDate.getMinutes();

			return currentDate;

		}

		private function str_replace ( pSearch:String, pReplace:String, pString:String ):String

		{

			return pString.split ( pSearch ).join ( pReplace );

		}

		private function createPageTree():void
		
		{

			nb = arrayPages.length;

			if( aliasNbPagesMethod == null )
			{
				//Replace number of pages
				for( n = 0; n<nb; n++ ) arrayPages[n].content = str_replace (aliasNbPagesMethod, nb, arrayPages[n].content );
			}

			if( defaultOrientation == Orientation.PORTRAIT )
			{
				currentPage.wPt = currentPage.fwPt;
				currentPage.hPt = currentPage.fhPt;
			}
			else
			{
				currentPage.wPt = currentPage.fhPt;
				currentPage.hPt = currentPage.fwPt;
			}

			filter = (compress) ? '/Filter /FlateDecode ' : '';

			//create Page tree node
			offsets[1] = buffer.length;
			write('1 0 obj');
			write('<</Type /Pages');
			write('/Kids ['+Page.references+']');
			write('/Count '+nb);
			write('>>');
			write('endobj');

			for( var n:int = 1; n <= nb; n++ )
			{

				var page:Page = arrayPages[n-1];

				//Page
				newObj();
				write('<</Type /Page');
				write('/Parent 1 0 R');
				//if ( this.orientationChanges[n] != null ) this.write (sprintf('/MediaBox [0 0 %.2f %.2f]', page.height, page.width));
				write (sprintf ('/MediaBox [0 0 %.2f %.2f]', page.width, page.height) );
				write ('/Resources 2 0 R');
				// Write Annots
				if ( page.annotations != '' ) write ('/Annots [' + page.annotations + ']');
				// Write Rotate value for each page
				write ('/Rotate ' + page.rotation);
				write ('/Dur ' + 3);
				if ( page.transitions.length ) write ( page.transitions );
				write ('/Contents '+(this.n+1)+' 0 R>>');
				write ('endobj');
				//Page stream content
				if ( autoPagination ) insertPagination(arrayPages[n-1]);
				var p:String = arrayPages[n-1].content;
				newObj();
				write('<<'+filter+'/Length '+p.length+'>>');
				writeStream(p);
				write('endobj');

			}

		}

		private function writeXObjectDictionary():void
		
		{

			for each ( var image:Object in images ) write('/I'+image.i+' '+image.n+' 0 R');

		}

		private function writeResourcesDictionary():void
		
		{

			write('/ProcSet [/PDF /Text /ImageB /ImageC /ImageI]');
			write('/Font <<');
			for each( var font:* in fonts ) write('/F'+font.i+' '+font.n+' 0 R');
			write('>>');
			write('/XObject <<');
			writeXObjectDictionary();
			write('>>');
			write('/ExtGState <<');
			for (var k:String in extgstates) write('/GS'+k+' '+extgstates[k].n +' 0 R');
			write('>>');

		}

		private function insertImages ( ):void

		{

			var filter:String = (compress) ? '/Filter /FlateDecode ' : '';

			for each ( var image:Object in images )
			{

				newObj();
				image.n = n;
				write('<</Type /XObject');
				write('/Subtype /Image');
				write('/Width '+image.w);
				write('/Height '+image.h);

				if( image.cs =='Indexed' ) write ('/ColorSpace [/Indexed /DeviceRGB '+(image.pal.length/3-1)+' '+(n+1)+' 0 R]');
				else
				{
					write('/ColorSpace /'+image.cs);
					if( image.cs == 'DeviceCMYK' ) write ('/Decode [1 0 1 0 1 0 1 0]');
				}

				write ('/BitsPerComponent '+image.bpc);
				if (image.f != null ) write('/Filter /'+image.f);
				if (image.parms != null ) write(image.parms);

				if ( image.trns != null && image.trns is Array )
				{

					var trns:String ='';
					var lng:int = image.trns.length
					for(var i:int=0;i<lng;i++) trns += image.trns[i]+' '+image.trns[i]+' ';
					write('/Mask ['+trns+']');

				}

				write('/Length '+image.data.length+'>>');
				write('stream');
				buffer.writeBytes (image.data);
				buffer.writeUTFBytes ("\n");
				write("endstream");
				delete image.data;
				write('endobj');
				//Palette
				if(image.cs =='Indexed' )
				{
					newObj();
					var pal:String = compress ? image.pal : image.pal
					write('<<'+filter+'/Length '+pal.length+'>>');
					writeStream(pal);
					write('endobj');
				}

			}

		}

		private function insertFonts ():void
		
		{

			var nf:int = this.n;

			for (var diff:String in this.diffs)
			{

				this.newObj();
				this.write('<</Type /Encoding /BaseEncoding /WinAnsiEncoding /Differences ['+diff+']>>');
				this.write('endobj');

			}

			for ( var p:String in this.fonts )
			{

				var font:Object = this.fonts[p];

				font.n = this.n+1;
				var type:String = font.type;
				var name:String = font.name;

				if( type=='core' )
				{
					//Standard font
					this.newObj();
					this.write('<</Type /Font');
					this.write('/BaseFont /'+name);
					this.write('/Subtype /Type1');
					if( name != 'Symbol' && name != 'ZapfDingbats' ) this.write ('/Encoding /WinAnsiEncoding');
					this.write('>>');
					this.write('endobj');
				}
				else if(type=='Type1' || type=='TrueType')
				{

					//Additional Type1 or TrueType font
					this.newObj();
					this.write('<</Type /Font');
					this.write('/BaseFont /'+name);
					this.write('/Subtype /'+type);
					this.write('/FirstChar 32 /LastChar 255');
					this.write('/Widths '+(this.n+1)+' 0 R');
					this.write('/FontDescriptor '+(this.n+2)+' 0 R');

					if( font.enc )
					{
						if( font.diff != null ) this.write ('/Encoding '+(nf+font.diff)+' 0 R');
						else this.write ('/Encoding /WinAnsiEncoding');
					}

					this.write('>>');
					this.write('endobj');
					//Widths
					this.newObj();
					var cw:Object = font.cw;
					var s:String = '[';
					for(var i:int=32; i<=255; i++) s += cw[String.fromCharCode(i)]+' ';
					this.write(s+']');
					this.write('endobj');
					//Descriptor
					this.newObj();
					s = '<</Type /FontDescriptor /FontName /'+name;
					for (var q:String in font.desc ) s += ' /'+q+' '+font.desc[q];
					var file:Object = font.file;
					if (file) s +=' /FontFile'+(type=='Type1' ? '' : '2')+' '+this.fontFiles[file].n+' 0 R';
					this.write(s+'>>');
					this.write('endobj');
				}
				else
				{

					mtd = ("_put" + type.toLowerCase());
					if( this[mtd] == null ) throw new Error("Unsupported font type: " + type );
					this[mtd](font);

				}
			}

		}

		// TBD
		private function insertPagination ( pPage:Page ):void
		
		{

			pPage.content += lMargin*k + " " + (bMargin)*k+ " m\n";
			pPage.content += (pPage.w-rMargin)*k + " " + (bMargin)*k+ " l\n";
			pPage.content += bFilled ? "b" : "S";

		}

		private function writeResources():void
		
		{
			insertExtGState();
			insertFonts();
			insertImages();
			//Resource dictionary
			offsets[2] = buffer.length;
			write('2 0 obj');
			write('<<');
			writeResourcesDictionary();
			write('>>');
			write('endobj');
			// add outline
			insertBookmarks();

		}

		private function insertBookmarks ( ):void

		{

			var nb:int = outlines.length;
			if ( nb == 0 ) return;

			var lru:Array = new Array;
			var level:Number = 0;

			for ( var i:String in outlines )
			{

				var o:Object = outlines[i];

				if(o.l > 0)
				{
					var parent:* = lru[o.l-1];
					//Set parent and last pointers
					outlines[i].parent=parent;
					outlines[parent].last=i;
					if(o.l > level)
					{
						//Level increasing: set first pointer
						outlines[parent].first=i;
					}
				}
				else outlines[i].parent=nb;
				if(o.l<=level && int(i)>0)
				{
					//Set prev and next pointers
					var prev:int =lru[o.l];
					outlines[prev].next=i;
					outlines[i].prev=prev;
				}

				lru[o.l]=i;
				level=o.l;

			}
			//Outline items
			var n:int = n+1;
			for ( var j:String in outlines )
			{

				var p:Object = outlines[j];

				newObj();
				write('<</Title '+_textstring(p.t));
				write('/Parent '+(n+o.parent)+' 0 R');
				if(p.prev != null ) write('/Prev '+(n+p.prev)+' 0 R');
				if(p.next != null ) write('/Next '+(n+p.next)+' 0 R');
				if(p.first != null ) write('/First '+(n+p.first)+' 0 R');
				if(p.last != null ) write('/Last '+(n+p.last)+' 0 R');
				write ('/C ['+p.redMultiplier+' '+p.greenMultiplier+' '+p.blueMultiplier+']');
				write(sprintf('/Dest [%d 0 R /XYZ 0 %.2f null]',1+2*p.p,(currentPage.h-p.y)*k));
				write('/Count 0>>');
				write('endobj');

			}

			//Outline root
			newObj();
			outlineRoot = n;
			write('<</Type /Outlines /First '+n+' 0 R');
			write('/Last '+(n+lru[0])+' 0 R>>');
			write('endobj');

		}

		private function insertInfos():void
		{

			write ('/Producer '+_textstring('Alive PDF '+PDF.ALIVEPDF_VERSION));
			if ((title != null)) write('/Title '+_textstring(title));
			if ((subject != null)) write('/Subject '+_textstring(subject));
			if ((author != null)) write('/Author '+_textstring(author));
			if ((keywords != null)) write('/Keywords '+_textstring(keywords));
			if ((creator != null)) write('/Creator '+_textstring(creator));
			write('/CreationDate '+_textstring('D:'+getCurrentDate()));

		}

		private function createCatalog ():void
		{

			write('/Type /Catalog');
			write('/Pages 1 0 R');
			
			if ( zoomMode == Display.FULL_PAGE ) write('/OpenAction [3 0 R /Fit]');
			else if ( zoomMode == Display.FULL_WIDTH ) write('/OpenAction [3 0 R /FitH null]');
			else if ( zoomMode == Display.REAL ) write('/OpenAction [3 0 R /XYZ null null 1]');
			else if ( !(zoomMode is String) ) write('/OpenAction [3 0 R /XYZ null null '+(zoomMode/100)+']');
			
			write('/PageLayout /'+layoutMode);
			write ('/PageMode /'+pageMode);
			
			if ( viewerPreferences.length ) write ( viewerPreferences );

			if( outlines.length )
			{

				write('/Outlines '+outlineRoot+' 0 R');
				write('/PageMode /UseOutlines');

			}

		}

		private function createHeader():void
		
		{

			write('%PDF-'+pdfVersion);

		}

		private function createTrailer():void
		
		{

			write('/Size '+(n+1));
			write('/Root '+n+' 0 R');
			write('/Info '+(n-1)+' 0 R');

		}

		private function finishDocument():void
		
		{
			
			if ( pageMode == PageMode.USE_ATTACHMENTS ) pdfVersion = "1.6";
			else if ( layoutMode == Layout.TWO_PAGE_LEFT || layoutMode == Layout.TWO_PAGE_RIGHT ) pdfVersion = "1.5";
			else if ( extgstates.length && pdfVersion < "1.4" ) pdfVersion = "1.4";
			else if ( outlines.length ) pdfVersion = "1.4";
			
			createHeader();
			createPageTree();
			writeResources();
			//Info
			newObj();
			write('<<');
			insertInfos();
			write('>>');
			write('endobj');
			//Catalog
			newObj();
			write('<<');
			createCatalog();
			write('>>');
			write('endobj');
			//Cross-ref
			var o:int = buffer.length;
			write('xref');
			write('0 '+(n+1));
			write('0000000000 65535 f ');
			for(var i:int=1;i<=n;i++) write(sprintf('%010d 00000 n ',offsets[i]));
			//Trailer
			write('trailer');
			write('<<');
			createTrailer();
			write('>>');
			write('startxref');
			write(o);
			write('%%EOF');
			state = 3;

		}

		private function startPage ( pOrientation:String ):void
		
		{

			page = arrayPages.length;
			state = 2;
			x = lMargin;
			y = tMargin;
			fontFamily = '';

			currentPage = arrayPages[page-1];

			//Page orientation
			if( pOrientation == '' ) pOrientation = defaultOrientation;
			else
			{
				if ( pOrientation != defaultOrientation ) orientationChanges[page]=true;
			}
		
			if ( pOrientation == Orientation.PORTRAIT )
			{

				currentPage.wPt = currentPage.fwPt;
				currentPage.hPt = currentPage.fhPt;
				currentPage.w = currentPage.fw;
				currentPage.h = currentPage.fh;
			}
			else
			{
					
				currentPage.wPt = currentPage.fhPt;
				currentPage.hPt = currentPage.fwPt;
				currentPage.w = currentPage.fh;
				currentPage.h = currentPage.fw;

			}
			
			pageBreakTrigger = currentPage.h-bMargin;
			currentOrientation = pOrientation;

		}

		private function finishPage():void
		{

			if( angle != 0 )
			{
				angle=0;
				write('Q');
			}

			this.state=1;
			
		}

		private function newObj():void
		{

			n++;
			offsets[n] = buffer.length;
			write (n+' 0 obj');

		}

		private function _dounderline( pX:Number, pY:Number, pTxt:String ):String
		{

			//Underline text
			up = currentFont.up
			ut = currentFont.ut
			currentPage.w = GetStringWidth(pTxt)+ws*substr_count(pTxt,' ');
			return sprintf('%.2f %.2f %.2f %.2f re f',pX*k,(currentPage.h-(pY-up/1000*fontSize))*k,currentPage.w*k,-ut/1000*fontSizePt);

		}

	   private function substr_count ( pChaine:String, pSearch:String ):int

		{

			return pChaine.split (pSearch).length;

		}

		private function getNumImages ( pObject:Object ):int

		{

			var num:int = 0;

			for (var p:String in pObject ) num++;

			return num;

		}

		private function parseJPG (pDisplayObject:DisplayObject, pKeepTransformation:Boolean, pQuality:int):Object
		{

			var nWidth:Number = pDisplayObject.width;
			var nHeight:Number = pDisplayObject.height;

			var myBitmapSource:BitmapData = new BitmapData ( nWidth, nHeight );

			// render the displayobject as a bitmapdata
			myBitmapSource.draw ( pDisplayObject, pKeepTransformation ? pDisplayObject.transform.matrix : null );

			// create the encoder with the appropriate quality
			var myEncoder:JPEGEncoder = new JPEGEncoder( pQuality );

			// generate a JPG binary stream to have a preview
			var myCapStream:ByteArray = myEncoder.encode ( myBitmapSource );

			return { w : nWidth, h : nHeight, cs : 'DeviceRGB', bpc : 8, f : 'DCTDecode', data : myCapStream };

		}

		// TBD
		private function parsePNG (pDisplayObject:DisplayObject, pKeepTransformation:Boolean):Object
		{

			var nWidth:Number = pDisplayObject.width;
			var nHeight:Number = pDisplayObject.height;

			var myBitmapSource:BitmapData = new BitmapData ( nWidth, nHeight );

			// render the displayobject as a bitmapdata
			myBitmapSource.draw ( pDisplayObject, pKeepTransformation ? pDisplayObject.transform.matrix : null );

			var myCapStream:ByteArray = PNGEnc.encode( myBitmapSource );

			// parse PNG to get infos
			var myParser:PNGParser = new PNGParser ( myCapStream );

			return { w : myParser.width, h : myParser.height, cs : myParser.colspace, bpc : myParser.bpc, f : 'FlateDecode', pal : myParser.pal, parms : myParser.parms, data : myCapStream };

		}

		private function _textstring(s:String):String
		{

			//Format a text string
			return '('+_escape(s)+')';

		}

		private function _escape(s:String):String
		{

			//Add \ before \, ( and )
			return str_replace(')','\\)',str_replace('(','\\(',str_replace('\\','\\\\',s)));

		}

		private function writeStream(s:String):void
		{

			write('stream');
			write(s);
			write('endstream');

		}

		private function write(s:*):void
		{

			if ( state == 2 ) currentPage.content += s+"\n";

			else mapUTFBytes (s+"\n");

		}

		private function mapUTFBytes ( pContent:String ):void

		{

			var lng:int = pContent.length;

			for (var i:int = 0; i<lng; i++ ) buffer.writeByte( pContent.charCodeAt ( i ) );

		}

		//--
		//-- IEventDispatcher
		//--

		public function addEventListener( type: String, listener: Function, useCapture: Boolean = false, priority: int = 0, useWeakReference: Boolean = false ): void
		{
			dispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}

		public function dispatchEvent( event: Event ): Boolean
		{
			return dispatcher.dispatchEvent( event );
		}

		public function hasEventListener( type: String ): Boolean
		{
			return dispatcher.hasEventListener( type );
		}

		public function removeEventListener( type: String, listener: Function, useCapture: Boolean = false ): void
		{
			dispatcher.removeEventListener( type, listener, useCapture );
		}

		public function willTrigger( type: String ): Boolean
		{
			return dispatcher.willTrigger( type );
		}

	}

}

class Page

{

	public var width:Number;
	public var height:Number;
	public var fwPt:Number;
	public var fhPt:Number;
	public var wPt:Number;
	public var hPt:Number;
	public var fw:Number;
	public var fh:Number;
	public var w:Number;
	public var h:Number;
	public var rotation:Number;
	public var reference:String;
	public var page:int;
	public var content:String;
	
	private var annots:String;
	private var pageTransition:String;

	public static var totalPages:Number = 0;
	public static var references:String = new String;

	public function Page ( pWidth:Number, pHeight:Number, pRotation:Number, pFwpt:Number, pFhpt:Number, pWpt:Number, pHpt:Number, pW:Number, pH:Number )

	{

		width = pWidth;
		height = pHeight;
		fwPt = pFwpt;
		fhPt = pFhpt;
		w = pW;
		h = pH;
		fw = pW;
		fh = pH;
		wPt = pWpt;
		hPt = pHpt;
		rotation = pRotation;

		// page reference
		reference = (3+(Page.totalPages++ << 1))+' 0 R';
		
		// concatenate reference for the page tree node kids array
		references += reference+'\n';

		page = Page.totalPages;

		annots = new String();

		content = new String();

		transitions = new String();

	}

	public function rotate ( pRotation:Number ):void
	{

		if ( pRotation % 90 ) throw new RangeError ("Rotation must be a multiple of 90");

		rotation = pRotation;

	}

	public function addTransition ( pStyle:String='R', pDuration:Number=1, pDimension:String='H', pMotionDirection:String='I', pTransitionDirection:int=0 ):void

	{

		transitions = '/Trans << /Type /Trans /D '+pDuration+' /S /'+pStyle+' /Dm /'+pDimension+' /M /'+pMotionDirection+' /Di /'+pTransitionDirection+' >>';

	}
	
	public function get transitions ( ):String 
	
	{
		
		return pageTransition;
		
	}
	
	public function set transitions ( pTransition:String ):void 

	{
		
		pageTransition = pTransition;
		
	}
	
	public function get annotations ( ):String 

	{
		
		return annots;
		
	}
	
	public function set annotations ( pAnnotation:String ):void 

	{
		
		annots = pAnnotation;
		
	}
	

}
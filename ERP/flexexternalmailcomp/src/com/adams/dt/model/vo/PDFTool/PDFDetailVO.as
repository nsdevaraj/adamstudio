package com.adams.dt.model.vo.PDFTool
{
	import com.adams.dt.model.vo.Tasks;
	import com.adobe.cairngorm.vo.ValueObject;
	
	import flash.display.BitmapData;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	[Bindable]
	public class PDFDetailVO implements ValueObject
	{
		
		public static const DETAIL_LOADING_STATUS_PENDING : Number = 0;
		public static const DETAIL_LOADING_STATUS_COMPLETED : Number = 1;
		public static const IMAGE_LOADING_STATUS_COMPLETED : Number = 2;
		
		public static const COMPARE_MODE : Boolean = true;
		public static const READER_MODE : Boolean = false;
		
		
		public function PDFDetailVO()
		{
			// PDF Detail VO Constructor 
			this.detailLoadedStatus = PDFDetailVO.DETAIL_LOADING_STATUS_PENDING;
			this.PDFToolMode = COMPARE_MODE;
		}
		
		private var _pdfFileURL1:String;
		public function set pdfFileURL1 (value:String):void
		{
			_pdfFileURL1 = value;
		}

		public function get pdfFileURL1 ():String
		{
			return _pdfFileURL1;
		}


		
		private var _pdfFileURL2:String;
		public function set pdfFileURL2 (value:String):void
		{
			_pdfFileURL2 = value;
		}

		public function get pdfFileURL2 ():String
		{
			return _pdfFileURL2;
		}


		
		
		private var _pdfFileBitmapData1:BitmapData;
		public function set pdfFileBitmapData1 (value:BitmapData):void
		{
			_pdfFileBitmapData1 = value;
		}

		public function get pdfFileBitmapData1 ():BitmapData
		{
			return _pdfFileBitmapData1;
		}


		
		private var _pdfFileBitmapData2:BitmapData;
		public function set pdfFileBitmapData2 (value:BitmapData):void
		{
			_pdfFileBitmapData2 = value;
		}

		public function get pdfFileBitmapData2 ():BitmapData
		{
			return _pdfFileBitmapData2;
		}


		
		
		private var _pdfWidth:Number;
		public function set pdfWidth (value:Number):void
		{
			_pdfWidth = value;
		}

		public function get pdfWidth ():Number
		{
			return _pdfWidth;
		}


		
		private var _pdfHeight:Number;
		public function set pdfHeight (value:Number):void
		{
			_pdfHeight = value;
		}

		public function get pdfHeight ():Number
		{
			return _pdfHeight;
		}


		
		
		private var _detailLoadedStatus:Number;
		public function set detailLoadedStatus (value:Number):void
		{
			_detailLoadedStatus = value;
		}

		public function get detailLoadedStatus ():Number
		{
			return _detailLoadedStatus;
		}


		
		
		private var _ImgBitmapLoad:Number;
		public function set ImgBitmapLoad (value:Number):void
		{
			_ImgBitmapLoad = value;
		}

		public function get ImgBitmapLoad ():Number
		{
			return _ImgBitmapLoad;
		}


		
		
		private var _commentColor:uint;
		public function set commentColor (value:uint):void
		{
			_commentColor = value;
		}

		public function get commentColor ():uint
		{
			return _commentColor;
		}


		
		private var _PDFToolMode:Boolean;
		public function set PDFToolMode (value:Boolean):void
		{
			_PDFToolMode = value;
		}

		public function get PDFToolMode ():Boolean
		{
			return _PDFToolMode;
		}


		
		
		private var _strokeColor:uint;
		public function set strokeColor (value:uint):void
		{
			_strokeColor = value;
		}

		public function get strokeColor ():uint
		{
			return _strokeColor;
		}


		
		private var _fillColor:uint;
		public function set fillColor (value:uint):void
		{
			_fillColor = value;
		}

		public function get fillColor ():uint
		{
			return _fillColor;
		}


		
		private var _highlightColor:uint;
		public function set highlightColor (value:uint):void
		{
			_highlightColor = value;
		}

		public function get highlightColor ():uint
		{
			return _highlightColor;
		}


		
		
		private var _profile:String;
		public function set profile (value:String):void
		{
			_profile = value;
		}

		public function get profile ():String
		{
			return _profile;
		}
		
		public var commentListArrayCollection : ArrayCollection = new ArrayCollection();
		//  Tools List - Variable(s)
		public var brushToolEnable:Boolean=false;
		public var lineToolEnable:Boolean=false;
		public var rectangleToolEnable:Boolean=false;
		public var ovalToolEnable:Boolean=false;
		public var highlighterToolEnable:Boolean=false;
		public var eraseToolEnable:Boolean=false;
		public var clearToolEnable:Boolean=false;
		public var strokeColorEnable:Boolean=false;
		public var fillColorEnable:Boolean=false;
		public var rotateClockwiseToolEnable:Boolean=false;
		public var rotateCounterClockwiseToolEnable:Boolean=false;
		public var undoToolEnable:Boolean=false;
		public var redoToolEnable:Boolean=false; 
		public var saveToolEnable:Boolean=false;
		public var lineNoteToolEnable:Boolean=false;
		public var rectangleNoteToolEnable:Boolean=false; 
		public var notePanelToolEnable:Boolean=true;
		public var compareEnable:Boolean=false ;
		public var panToolEnable:Boolean=true ;
		public var fillColorBtnEnable:Boolean=false;		
		
		//  Tools List - Variable(s) 
		
		public function update(pdffile1:Tasks, pdffile2:Tasks, profile:String):void{
			
			pdfFileURL1=pdffile1.taskFilesPath;
			pdfFileURL2=pdffile2.taskFilesPath;
			
			if(pdfFileURL2){
				PDFToolMode = PDFDetailVO.COMPARE_MODE;
			}else{
				pdfFileURL2 = ''
				PDFToolMode = PDFDetailVO.READER_MODE;
			} 
			
			this.profile = profile;
			detailLoadedStatus=PDFDetailVO.DETAIL_LOADING_STATUS_COMPLETED;
			
		}

	}
	
}
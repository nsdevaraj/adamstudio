package com.rubenswieringa.book
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextSnapshot;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.SWFLoader;
	import mx.core.UIComponent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	
	[Event (name="pageUpdateComplete", type="flash.events.Event")]
	
	public class BookLite extends Group
	{
		private var book:Book = new Book();
		
		[Embed(source="assets/images/Preloader.swf")]
		[Bindable]
		public var preLoaderClass:Class;
		
		[Embed(source="assets/images/sfrLogo.png")]
		[Bindable]
		public var sfrImageClass:Class;
		
		private var bookXMLhtmlService:HTTPService= new HTTPService();
		
		[Bindable]
		public  var totalPages:int = 0;
		[Bindable]
		public var startIndex:int = 0;
		
		private const MAX_PAGE:int = 8;
		
		public var pageLength:int = 0;
		
		private var beginOfBook:Boolean = true;
		private var endOfBook:Boolean = false;
		
		private var isExitMaxPageSize:Boolean = false;
		
		private var bookXMLList:XMLList = new XMLList();
		
		private var _regionsize:Number;
		
		public var _bookXMLURL:String = "";
		
		public function get regionsize():Number
		{
			return _regionsize;
		}
		public function set regionsize(value:Number):void
		{
			_regionsize = value;
			book.regionSize = _regionsize;
		}
		
		private var _shape:String;
		
		public function get shape():String
		{
			return _shape;
		}
		
		public function set shape(value:String):void
		{
			_shape = value;
		}
		
		public static const PAGE_UPDATE_COMPLETE:String = "pageUpdateComplete";
		
		private var _bookXML:XML = new XML();
		
		public function get bookXML():XML
		{
			return _bookXML;
		}
		[Bindable]
		public function set bookXML(value:XML):void
		{
			_bookXML = value;
			setPages()
		}
		
		
		public function get bookXMLURL():String
		{
			return _bookXMLURL;
		}
		
		public function set bookXMLURL(value:String):void
		{
			_bookXMLURL = value;
			if(_bookXMLURL!=""){
				httpCall();
			}
		}
		
		public function BookLite()
		{
			super();
			book.hover = false;
			book.hardCover = false;
			book.sideFlip = true;
			book.flipOnClick = true;
			book.autoFlipDuration = 300;
			book.easing = 0.4;
			book.regionSize =150;
			book.liveBitmapping = true;
			book.snap = false;
			book.liveBitmapping = true;
			
		}
		
		private function httpCall():void
		{
			
		}
		
		private function setPages():void
		{
			((bookXML.page.length()%2)!=0)?bookXML.appendChild(XML("<page url='blank'/>")):'';
			bookXMLList = bookXML.page;
			totalPages = bookXMLList.length();
			this.width = book.width = Number(bookXML.@width)*2;
			this.height = book.height = Number(bookXML.@height);
			var pageContainerValue:Number = (Number(bookXML.@width)>Number(bookXML.@height))?500:600;
			var bookValue:Number = (Number(bookXML.@width)>Number(bookXML.@height))?Number(bookXML.@width):Number(bookXML.@height);
			bookXML.@width = String((pageContainerValue/bookValue)*Number(bookXML.@width));
			bookXML.@height = String((pageContainerValue/bookValue)*Number(bookXML.@height));
			book.regionSize = (book.width>book.height)?(book.height/8)*3:(book.width/8)*3;
			isExitMaxPageSize = (totalPages>MAX_PAGE);
			addPage();
		}
		
		private function invalidateBookComp():void
		{
			this.invalidateProperties();
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		public function removeEndFlip( ) :void
		{
			book.removePageListener();
		
		}
		private function faultHandler(event:FaultEvent):void
		{
			trace(event.message);	
		}
		private function addPage():void
		{
			var i:int;
			pageLength = (isExitMaxPageSize)?MAX_PAGE:totalPages;
			for(i=0;i<pageLength;i++)
			{
				var page:Page = new Page();
				var img:Image = new Image();
				var swfHolder:SWFLoader= new SWFLoader();
				swfHolder.width = Number(bookXML.@width);
				swfHolder.height = Number(bookXML.@height);
				if(bookXMLList[i].@url=="blank"){
					img.source= sfrImageClass;
					img.width = 47;
					img.height = 47;
					page.addChild(img);
					img.verticalCenter = 0;
					img.horizontalCenter = 0;
				}else{
					img.source= preLoaderClass;
					page.addChild(img);
					img.verticalCenter = 0;
					img.horizontalCenter = 0;
				}
				
				var label:Label = new Label();
				label.text = bookXMLList[i].@pageNum; 
				label.x = Number(bookXML.@width)-100;
				label.y = Number( bookXML.@height )- 100;
				label.visible = false;
				
				page.addChild(swfHolder);
				page.addChild( label );
				page.setStyle("backgroundColor","#ffffff");
				book.addChild(page);
				
				
			}
			updatePage(startIndex,true);
			book.hover = true;
			invalidateBookComp();
			book.addEventListener(BookEvent.PAGE_TURNED, pageTurnedHandler);
			// Book adding 
			addElement(book);
			dispatchEvent(new Event(PAGE_UPDATE_COMPLETE));
		}
		
		private function pageTurnedHandler(event:BookEvent):void
		{
			if(book.lastFlippedSide == Page.RIGHT){
				if(book.currentPage == 5 && !endOfBook)
				{
					book.gotoPageWithoutFlip(3);
					book.swapChildren(book.pages[3],book.pages[5]);
					book.swapChildren(book.pages[4],book.pages[6]);
					updatePage((startIndex+=2));
				}
			}
			if(book.lastFlippedSide == Page.LEFT){
				if(book.currentPage == 1 && !beginOfBook)
				{
					book.gotoPageWithoutFlip(3);
					book.swapChildren(book.pages[3],book.pages[1]);
					book.swapChildren(book.pages[4],book.pages[2]);
					updatePage((startIndex-=2));
				}
			}
			dispatchEvent(new Event(PAGE_UPDATE_COMPLETE));
		}
		public var nwPages:Number;
		public function gotoPageNum(pagenum:Number):void{
			var totPages:Number = totalPages-1;
			if(pagenum<0){
				startIndex = 0;
				updatePage(startIndex,true);
				book.gotoPageWithoutFlip(1);
			}
			if(pagenum<5)
			{
				var pnum:Number = pagenum-1;
				totPages = totalPages;
				startIndex = 0;
				updatePage(startIndex,true);
				book.gotoPageWithoutFlip(pnum);
			}else
			{
				if(pagenum % 2 == 0){
					nwPages = pagenum+4;
					if(nwPages>=totPages){
						IndexChange()
					}
					else{
						startIndex = nwPages - pageLength;
						updatePage(startIndex,true)
						book.gotoPageWithoutFlip(3);
					}
				}else
				{
					nwPages = pagenum+3;
					if(nwPages>=totPages){
						IndexChange()
					}else
					{
						startIndex = nwPages - pageLength;
						updatePage(startIndex,true)
						book.gotoPageWithoutFlip(3);
					}
				}
			}
		}
		
		private function IndexChange():void{
			startIndex = totalPages-pageLength;
			updatePage(startIndex,true);
			if((nwPages-totalPages) == 2){
				book.gotoPageWithoutFlip(5)
			}else if((nwPages-totalPages)>2)
			{
				book.gotoPageWithoutFlip(7)
			}else
			{
				book.gotoPageWithoutFlip(3);
			}
		}
		
		public function nextPage():void{
			book.nextPage();
		}
		
		public function previousPage():void{
			book.prevPage();
		}
		
		public function get currentPage():int{
			
			return book.currentPage;
		}
		
		public function getLastPage():Boolean
		{
			return book.isLastPage(book.currentPage);
		}
		public function getFirstPage():Boolean
		{
			return book.isFirstPage( book.currentPage ) ;
		}
		public function get pages():ArrayCollection {
			return book.pages;
		}
		public function currentPageId():String{
			
			var pageId:String
			if(!getLastPage())
			{
				pageId = Label(UIComponent(book.pages[currentPage+1]).getChildAt(2)).text;
			}else{
				pageId = totalPages.toString();
			}
			return pageId;
		}
		
		private function updatePage(sIndex:int,isFirstTime:Boolean=false):void
		{
			var i:int;
			var pageLevel:int = 0;
			if((startIndex+pageLength)>=totalPages)
			{
				startIndex = (totalPages-pageLength);
				endOfBook = true;
			}
			else{
				endOfBook = false;
			}
			if(startIndex<=0)
			{
				startIndex = 0;
				beginOfBook = true;
			}else{
				beginOfBook = false;
			}
			for(i=sIndex;i<sIndex+pageLength;i++)
			{
				if(isFirstTime || (pageLevel!=3 && pageLevel!=4) ){
					SWFLoader(UIComponent(book.pages[pageLevel]).getChildAt(1)).source = (bookXMLList[i].@url!='blank')?bookXMLList[i].@url:'';
				}
				pageLevel++;
			}
			
		}
	}
}
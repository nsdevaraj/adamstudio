// ActionScript file
import com.bookmarks;
import com.notes;

import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import mx.controls.Label;
import mx.controls.TextInput;
import mx.core.UIComponent;
import mx.effects.*;
import mx.events.ResizeEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

include "importer.as"

[Bindable]public var zoomValueXMLList:XMLList; 
[Bindable]public var referTabPanelMoveControl:Move=new Move();
[Bindable]public var referTabPanelOCStatus:Boolean=false; 
[Bindable]public var zoomPanelOCStatus:Boolean=false; 
[Embed(source='assets/swf/interfaceAssets.swf#TabBookmark')] 
[Bindable]private var TabBookmark:Class;
[Embed(source='assets/swf/interfaceAssets.swf#TabNotes')] 
[Bindable]private var TabNotes:Class;
[Embed(source='assets/swf/interfaceAssets.swf#TabTOC')] 
[Bindable]private var TabTOC:Class;
private var menu:Menu;
[Bindable]private var bookmarkBtnClick:Boolean=false;
[Bindable]private var searchResultBoxOpen:Boolean=false;
public var tempTextInput:TextInput=new TextInput();
private function init():void{
	//Alert.show("Welcome to India"+myBook.pages.length+" >> "+myBook.currentPage);
	pageNav.labels=[0,myBook.pages.length];
	//myBook.currentPage=22;
	//pageNav.maximum=myBook.pages.length;
	pageNav.minimum=0;
	pageNav.maximum=myBook.pages.length;
	pageNav.tickInterval=1;
	gotoTxt.text="0 of "+myBook.pages.length;
	gotoTxt.addEventListener(KeyboardEvent.KEY_DOWN, gotoKeyHandler);
	searchTxt.addEventListener(FocusEvent.FOCUS_IN, searchKeyHandler);
	/* referTabPanel.y=userControlBar.y+75; */
	zoomSliderVBox.y=userControlBar.y+75;
	this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownAction);
	addEventListener(MouseEvent.MOUSE_DOWN,textCreateMouseDown);
	addEventListener(MouseEvent.MOUSE_UP,textCreateMouseDown);
	addEventListener(MouseEvent.MOUSE_MOVE,textCreateMouseDown); 
	addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelAction);
	/* trace(zoomBtn.x); */
	//myBookVBox myBookTool
	tempTextInput.visible=false;
 	/* seqBookTool.addChild(moveBookTool); */ 
		myBookVBox.x=(myBookTool.width-myBookVBox.width)/2;
		myBookVBox.y=(myBookTool.height-myBookVBox.height)/2;
		  /* tocPopupBtn.popUp= new referenceTabPanel();
		trace(tocPopupBtn.popUp);  */ 
		/* trace(tocPopupBtn.popUp.stage.getChildByName("referTabPanel"));
		trace(tocPopupBtn.popUp.owner.getChildByName("referTabPanel")); */
		//tocPopupBtn.popUp.canvasBtn.click();
	//tocPopupBtn.open();
	/* tocPopupBtn.tocTree.dataProvider=tocXML; */
	/* CursorManager.setCursor(panIconOpen); */
	zoomNav.value=1.0;
	httpServiceBookmark.url="assets/localXML/bookmark.xml";
	httpServiceBookmark.send();
	httpServiceNotes.url="assets/localXML/note.xml";
	httpServiceNotes.send();
	xmldata.send();
	searchResultBox.y=userControlBar.y+pageNavBox.height+20;
	this.addEventListener(ResizeEvent.RESIZE,appResize);
	noteSmallBox.visible=false;
	this.tabChildren=false; 
}
private function mouseWheelAction(evt:MouseEvent):void{
	trace(evt.delta);
	if(evt.delta>0) zoomInBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false))
	else zoomOutBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false))
}
public function ObjToXmlList(e:ResultEvent):void { 	
	var statesXML:XMLList = e.result.page;  
	trace(e.result.page);
	for each(var XMLNodeObj:XML in statesXML) {  
		itData.push(XMLNodeObj) 
	}    
	filterData.data = itData;
}
private function bookmarkLoadFault(evt:FaultEvent):void{
	Alert.show("Error Bookmark Failed");
}
private function bookmarkLoadResult(evt:ResultEvent):void{
	var myXML:XML = XML(evt.result);
	 var myArray:Array = new Array();
	  for each( var node:XML in myXML.elements() ) { 
	  	  //  myArray.push( node.@src.toString() );
	  	  //notesAddFunc((myBook.currentPage+1),'---notes----')
	  	  bookmarkAddFunc(node.@page); 
      }
}
private function noteLoadFault(evt:FaultEvent):void{
	Alert.show("Error Notes Failed");
}
private function appResize(event:ResizeEvent):void{
	trace(event);
	//searchResultBox.y=userControlBar.y+pageNavBox.height+20;
	
}
private function noteLoadResult(evt:ResultEvent):void{
	var myXML:XML = XML(evt.result);
	 var myArray:Array = new Array();
	  for each( var node:XML in myXML.elements() ) { 
	  	  //  myArray.push( node.@src.toString() );
	  	 notesAddFunc(node.@page,node)
	  	  //bookmarkAddFunc(node.@page); 
      }
}
/* private function appKeyDown(event:KeyboardEvent):void{
	trace(event.type);
	CursorManager.setCursor(panIconOpen);
}
private function appKeyUp(event:KeyboardEvent):void{
	trace(event.type);
	CursorManager.removeAllCursors();

} */
private function gotoKeyHandler(event:KeyboardEvent):void{
	trace(event);
	if(event.keyCode==13){
		if(Number(gotoTxt.text)>-1 && Number(gotoTxt.text)<=myBook.pages.length){
			myBook.gotoPageWOF(Number(gotoTxt.text)-1);
			pageNav.value=myBook.currentPage;
		}else{
			gotoTxt.text=(myBook.currentPage+1)+" of "+myBook.pages.length;
			zoomCombo.setFocus();
			Alert.show("Page No. not Found", "Invalid Page No.");
		}
		gotoTxt.text=(myBook.currentPage+1)+" of "+myBook.pages.length;
		zoomCombo.setFocus();
	}
}
private function searchKeyHandler(event:FocusEvent):void{
	trace(event);
	/* if(event.keyCode==13){ */
	if(!searchResultBoxOpen){
		searchResultBoxFunc();
	 	zoomCombo.setFocus();
	}
	/* }  */
}
private function itemClickHandler(event:MenuEvent):void {
    var label:String = event.item.label;
    //Alert.show(event.item.groupName);        
     //zoomCombo.label = Number(event.item.data)*100+"%";
    zoomCombo.close(); 
    menu.selectedIndex = event.index;
    zoomNav.value=Number(event.item.data);
	zoomTool(Number(event.item.data));
}
private function pageNavChange():void{
	myBook.gotoPageWOF(pageNav.value-1);
	gotoTxt.text=(myBook.currentPage+1)+" of "+myBook.pages.length;
}
private function pageNavSliderTooltip(val:String):String{
	return "Page "+val;
}
private function zoomNavSliderTooltip(val:String):String{

	return (Number(val)*100)+"%";
}
private function pageNavTextFocus(event:FocusEvent):void{
	
	if(event.type=="focusIn"){
		gotoTxt.text="";	
	}else{
		gotoTxt.text=(myBook.currentPage+1)+" of "+myBook.pages.length;
	}
	
}
private function pageMove(moveDirection:Number):void{
	// 0 - Previous Pgae ===== 1 - Next Page
	//prevPageBtn.enabled=false;
	//nextPageBtn.enabled=false;
	(moveDirection)?myBook.nextPage():myBook.prevPage();
	gotoTxt.text=(myBook.currentPage+1)+' of '+myBook.pages.length;
}
private function popUpButton_initialize():void {
    menu = new Menu();
	var xml:Object = [{label: "25%",data: 0.25}, {label: "50%",data: 0.50}, {label: "100%",data: 1.00}, {label: "125%",data: 1.25}, {label: "150%",data: 1.50},{label: "175%",data: 1.75}, {label: "200%",data: 2.00}, {label: "300%",data: 3.00},{type: "separator"},{label: "Fit Page",data: 1.00, groupName: "labelSelction"}, {label: "Fit Width",data: 1.75, groupName: "labelSelction"}, {label: "Fit Height",data: 1.00, groupName: "labelSelction"}, {label: "Actual Size",data: 1.75, groupName: "labelSelction"}];
    menu.dataProvider = xml;
    menu.addEventListener("itemClick", itemClickHandler);
    zoomCombo.label="25%";
    zoomCombo.popUp = menu; 

}
private function pageflipFinishedEvent(event:Event):void{
	gotoTxt.text=(myBook.currentPage+1)+' of '+myBook.pages.length;
	pageNav.value=myBook.currentPage+1;
	if(noteSmallBox.visible){
		noteSmallBox.saveBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false))
	}
	//prevPageBtn.enabled=true;
	//nextPageBtn.enabled=true;
}
private function pageflipEnterFrameEvent(evt:Event):void{
	if(notesBtn.selected){
		myBook.regionSize=0;
		myBook.sideFlip=false;
	}else{
		myBook.sideFlip=true;
		myBook.regionSize=150;
	}
	
}
private function noteIconButtonClick(evt:Event):void{
	trace("Button Click : "+evt+"}}}}}}}}}}}}}}}"+evt.target.name+"OOOOOOOOO"+evt.target.parent);
	//var temp_mc:*=evt.target.parent;
	//var temp_parent_mc:*=evt.target.parent.parent;
	//temp_parent_mc.removeChild(temp_mc);
	 //noteSmallBox.visible=false;
	noteSmallBox.action("exist",evt.target.parent,Application.application.mouseX,Application.application.mouseY);
	//noteSmallBox.x=Application.application.mouseX;
	//noteSmallBox.y=Application.application.mouseY;
}
private var moX:Number;
private var moY:Number;
private var temp_mc:*
private function textCreateMouseDown(evt:MouseEvent):void{
	//trace(evt.buttonDown);
	 if(notesBtn.selected){ 
	 	if(String(evt.target).indexOf("Page")!=-1){
		if(evt.type=="mouseDown"){
			
			trace(moX+">>>>>>"+moY);
			trace(evt.target+">>>>>>");
			temp_mc=evt.target;
			while(String(temp_mc.name).indexOf("Page")==-1){
				temp_mc=temp_mc.parent;
			}
			trace(String(temp_mc.name).substr(4)+">>>>>"+temp_mc.name+"GG>>>>>>>>>>>"+temp_mc.side);
			
			moX=temp_mc.mouseX;
			moY=temp_mc.mouseY; 
			 /* if((event.target.name!="tocBtn" && event.target.name!="bookmarkBtn" && event.target.name!="notesBtn") && referTabPanelOCStatus){ */ 
			if((evt.target.name==this.name || evt.target.name=="userControlBar" || evt.target.name=="myBookVBox" || evt.target.name=="menuBar" ) && referTabPanelOCStatus){ 	
				referTabPanelOpenClose(evt);
			}
		
			if((evt.target.name==this.name || evt.target.name=="userControlBar" || evt.target.name=="myBookVBox" || evt.target.name=="menuBar" ) && zoomPanelOCStatus){ 	
				zoomPanelOpenClose(evt);
			}
		}else if(evt.type=="mouseUp"){

			trace(temp_mc);
			var tempmoX:Number=moX;
			var tempmoY:Number=moY;
			moX=temp_mc.mouseX;
			moY=temp_mc.mouseY;
			if(tempmoX!=moX && tempmoY!=moY){
				var virtual_box:UIComponent=new UIComponent();
				var temp_canvas:Canvas=new Canvas();
				var squareSize:uint = 100;
				var square:Shape = new Shape();
				square.graphics.beginFill(0xFFFF00, 0.5);
				square.graphics.lineStyle(1,0x000000,0.2);
				square.graphics.drawRect(0, 0, (Math.abs(tempmoX-moX)>30)?Math.abs(tempmoX-moX):30, (Math.abs(tempmoY-moY)>30)?Math.abs(tempmoY-moY):30);
				square.graphics.endFill();
	            var temo_box:*=virtual_box.addChild(square);
				temp_canvas.addChild(virtual_box);
				
	            var but:Button=new Button();
	            var dumpLabel:Label=new Label();
	            var dump_label:*=temp_canvas.addChild(dumpLabel);
				var temp_but:*=temp_canvas.addChild(but);
	
				temp_but.styleName="noteSkin";
				temp_but.addEventListener(MouseEvent.CLICK,noteIconButtonClick);
				temp_but.buttonMode=true;
				temp_but.useHandCursor=true;
				//temp_but.x=(temp_mc.side)?temo_box.width-10:-10;
				temp_but.x=(temp_mc.side)?0:temo_box.width-10;
				temp_but.y=temo_box.height-10;
				dump_label.x=Math.abs(tempmoX-moX);
				dump_label.y=temo_box.height;
	            var temp_ui:*=temp_mc.addChild(temp_canvas);
				temp_ui.x=(moX>tempmoX)?tempmoX:moX;
				temp_ui.y=(moY>tempmoY)?tempmoY:moY;
				noteSmallBox.action("new",temp_ui,Application.application.mouseX,(Math.abs(tempmoX-moX)>30)?Application.application.mouseY:30+Application.application.mouseY);
				trace(moX+">>>>>>"+moY+"|||||||||||||||||||"+tempmoX+">>>>>>>>>>>>"+tempmoY);
				//virtual_box.width=200;
			
				//temp_but.x=((moX<tempmoX)?tempmoX:moX)-10;
				//temp_but.x=(temp_mc.side)?((moX<tempmoX)?tempmoX:moX)-10:((moX>tempmoX)?tempmoX:moX)-10;
				//temp_but.y=((moY<tempmoY)?tempmoY:moY)-10;
				
				
				notesBtn.selected=false; 
			}
		}else{
			
		}
	 	}
	 } 
}
private function mouseDownAction(event:MouseEvent):void{
	trace(event.target.name+">>>>>>");
	//trace(event);
	 /* if((event.target.name!="tocBtn" && event.target.name!="bookmarkBtn" && event.target.name!="notesBtn") && referTabPanelOCStatus){ */ 
	if((event.target.name==this.name || event.target.name=="userControlBar" || event.target.name=="myBookVBox" || event.target.name=="menuBar" ) && referTabPanelOCStatus){ 	
		referTabPanelOpenClose(event);
	}
	if((event.target.name==this.name || event.target.name=="userControlBar" || event.target.name=="myBookVBox" || event.target.name=="menuBar" ) && zoomPanelOCStatus){ 	
		zoomPanelOpenClose(event);
	}
}
private function tabBtnActivities(event:Event):void{
	if(!referTabPanelOCStatus) referTabPanelOpenClose(event);
	 /* referTabPanel.selectedIndex=(event.target.name=="tocBtn")?0:((event.target.name=="bookmarkBtn")?1:2);  */
}
private function tocTreeClick(event:Event):void{
	//trace(event.target.page);
	var selectedNode:XML;
	selectedNode=Tree(event.target).selectedItem as XML;
	//trace(selectedNode.@page);
	myBook.gotoPageWOF(Number(selectedNode.@page));
}
private function zoomPanelBtn(event:Event):void{
	//trace(event.target.name);
		//Alert.show(event.target.name);
		if(event.target.name=="zoomInBtn"){
			zoomNav.value=((zoomNav.value+0.25)<=zoomNav.maximum)?(zoomNav.value+0.25):zoomNav.maximum;
		}else{
			zoomNav.value=((zoomNav.value-0.25)>=zoomNav.minimum)?(zoomNav.value-0.25):zoomNav.minimum;
		}

	zoomTool(zoomNav.value);
}
private function referTabPanelOpenClose(event:Event):void{
	trace(event.target.name);
	referTabPanelMoveControl.yTo=(referTabPanelOCStatus)?userControlBar.y+75:200;
	referTabPanelMoveControl.easingFunction=Back.easeInOut;
	referTabPanelMoveControl.duration=1000;
	/* referTabPanelMoveControl.play([referTabPanel]); */
	referTabPanelOCStatus=!referTabPanelOCStatus;
}
private function zoomPanelOpenClose(event:Event):void{
	trace(event.target.name);
	referTabPanelMoveControl.yTo=(zoomPanelOCStatus)?userControlBar.y+75:((userControlBar.y+50)-(zoomSliderVBox.height-20));
	referTabPanelMoveControl.easingFunction=Back.easeInOut;
	referTabPanelMoveControl.duration=1000;
	referTabPanelMoveControl.play([zoomSliderVBox]);
	zoomPanelOCStatus=!zoomPanelOCStatus;
}
private function zoomTool(val:Number):void{
	zoomCombo.label=Number(val)*100+"%";
	myBookVBox.scaleX=val;
	myBookVBox.scaleY=val;

	  myBookVBox.setStyle("left", (myBookTool.width<=(myBookVBox.width*val)) ? 0 : undefined);
	   myBookVBox.setStyle("top",  (myBookTool.width<=(myBookVBox.width*val)) ? 0 : undefined);
	   myBookVBox.setStyle("horizontalCenter", (myBookTool.width<=(myBookVBox.width*val)) ? undefined : 0);
	   myBookVBox.setStyle("verticalCenter", (myBookTool.width<=(myBookVBox.width*val)) ? undefined : 0);
	
	/* if(myBookTool.width<=myBookVBox.width)myBookTool.horizontalScrollPosition=myBookTool.horizontalScrollBar.maxScrollPosition/2;
	if(myBookTool.height<=myBookVBox.height)myBookTool.verticalScrollPosition=myBookTool.verticalScrollBar.maxScrollPosition/2; */

	  
}

//-------------Notes......Save------------------------
public var notesAvoidStatus:Boolean;
public function notesAddFunc(pageNo:Number,msg:String,hObject:*=null):void{
	notesAvoidStatus=false;
	notesContainer.getChildren().forEach(toAvoidDuplicationNotes);
	//if(!notesAvoidStatus){
		var note:notes = new notes();
		note.checkboxPageNo ="Page "+pageNo.toString();
		note.messageTxt=msg;
		note.pageNo=pageNo;
		note.highlightObject=hObject;
		notesContainer.addChild(note);
	//}else{
		//Alert.show("Sorry, Note is already exist!","Duplication");
	//}
}
private function toAvoidDuplicationNotes(element:*, index:int, arr:Array):void {
	if(element.checkboxPageNo=="Page "+(myBook.currentPage+1)) notesAvoidStatus=true;
}
private function checkAllNotes(element:*, index:int, arr:Array):void {
	element.notesCheck.selected=notesCheckBoxForAll.selected;
	//element.pageNo ="KING";
	//Alert.show(element.toString()); 
}
private function checkAllNotesDetails():void{
	notesContainer.getChildren().forEach(checkAllNotes);
}
private function removeSelectedNotes(element:*, index:int, arr:Array):void {
	if(element.notesCheck.selected){ 
		var temp:*=element.highlightObject.parent;
		temp.removeChild(element.highlightObject);
		notesContainer.removeChild(element);
		
	}
}    
private function removeCheckNotes():void{
	notesCheckBoxForAll.selected=false;
	notesContainer.getChildren().forEach(removeSelectedNotes);
}
private function checkAllMessageTxt(element:*, index:int, arr:Array):void {
	element.message_txt.enabled=false;
	element.editBTN.selected=false;
}
/* notesContainer.getChildren().forEach(checkAllMessageTxt); */
public function checkAllMessageTxtDetails():void{
	notesContainer.getChildren().forEach(checkAllMessageTxt);
}
//=================================================
public var bookmarkAvoidStatus:Boolean;
private function bookmarkAddFunc(pageNo:Number):void{
	bookmarkAvoidStatus=false;
	bookmarkContainer.getChildren().forEach(toAvoidDuplicationBookmark);
	if(!bookmarkAvoidStatus){
		var bookmark:bookmarks = new bookmarks();
		bookmark.checkboxPageNo ="Page "+(pageNo);
		bookmark.pageNo=pageNo;
		bookmarkContainer.addChild(bookmark);
		if(bookmarkBtnClick){
			bookmarkBtnClick=false;
			Alert.show("Bookmark is added!","Added");
		}
	}else{
		Alert.show("Sorry, Bookmark is already exist!","Duplication");
	}
}
private function toAvoidDuplicationBookmark(element:*, index:int, arr:Array):void {
	if(element.checkboxPageNo=="Page "+(myBook.currentPage+1)) bookmarkAvoidStatus=true;
}
private function checkAllBookmark(element:*, index:int, arr:Array):void {
	element.bookmarkCheck.selected=bookmarkCheckBoxForAll.selected;
	//element.pageNo ="KING";
	//Alert.show(element.toString()); 
}
private function checkAllBookmarkDetails():void{
	bookmarkContainer.getChildren().forEach(checkAllBookmark);
}
private function removeSelectedBookmark(element:*, index:int, arr:Array):void {
	if(element.bookmarkCheck.selected) bookmarkContainer.removeChild(element);
}
private function removeCheckBookmark():void{
	bookmarkCheckBoxForAll.selected=false;
	bookmarkContainer.getChildren().forEach(removeSelectedBookmark);
}
[Bindable]private var moveSearchRes:Move=new Move();
private function searchResultBoxFunc():void{
	//searchResultBox.y=userControlBar.y+pageNavBox.height 
		/* searchTxt.enabled=searchResultBoxOpen;
		searchBtn.enabled=searchResultBoxOpen; */
		moveSearchRes.yTo=(searchResultBoxOpen)?userControlBar.y+pageNavBox.height+20:((userControlBar.y+pageNavBox.height)-searchResultBox.height);
		/* if(searchResMinMax.selected){
			searchResMinMax.selected=false;
			searchResMin=false;
		} */
		moveSearchRes.easingFunction=(searchResultBoxOpen)?Circular.easeIn:Circular.easeOut;
		moveSearchRes.duration=1000;
		moveSearchRes.play([searchResultBox]);
		searchResultBoxOpen=!searchResultBoxOpen;
}
[Bindable]private var searchResMin:Boolean=false;
private function searchResultMinMax():void{
	//searchResultBox.y=userControlBar.y+pageNavBox.height
		moveSearchRes.yTo=(searchResMin)?((userControlBar.y+pageNavBox.height)-searchResultBox.height):(userControlBar.y+pageNavBox.height)-36;
		
		moveSearchRes.easingFunction=(searchResMin)?Circular.easeIn:Circular.easeOut;
		moveSearchRes.duration=500;
		moveSearchRes.play([searchResultBox]);
		searchResMin=!searchResMin;
}
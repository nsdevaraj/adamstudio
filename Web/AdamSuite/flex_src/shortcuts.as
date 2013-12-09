//initialize shortcuts
private function initShortCuts():void{
	addEventListener(KeyboardEvent.KEY_UP, keyHandler);
	addEventListener(MouseEvent.MOUSE_DOWN, startHandler);
	addEventListener(MouseEvent.MOUSE_UP, stopHandler);
}
//keyboard shortcuts
private function keyHandler(e:KeyboardEvent):void{
	 switch(e.keyCode){ 
	 	//pageup
	 	case Keyboard.PAGE_UP:
	  		if(!firstInCollection) navigate('back');
	 	break; 
	 	// pagedown
	 	case Keyboard.PAGE_DOWN:
	 	 	if(!lastInCollection) navigate('next');
	 	break;
	 	// home
	 	case Keyboard.HOME:
	 	 	if(!lastInCollection) navigate('first');
	 	break;
	 	// end
	 	case Keyboard.END:
	 	 	if(!lastInCollection) navigate('last');
	 	break;
	 } 
}	
//on mouse down, start recording mouseX
private function startHandler(e:MouseEvent):void{ 
	mousePos = mouseX;
}	
//on mouse up, find difference to read gesture 
private function stopHandler(e:MouseEvent):void{ 
	mousePos = mouseX-mousePos;
	if(mousePos>20 || mousePos<-20){
		if(mousePos>0){
			if(!lastInCollection) navigate('next');
		}else{
		 	if(!firstInCollection) navigate('back');	
		}
	}
} 	   
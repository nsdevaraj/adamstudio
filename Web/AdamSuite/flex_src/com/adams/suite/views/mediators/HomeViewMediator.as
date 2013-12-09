package com.adams.suite.views.mediators
{
	import com.adams.suite.models.vo.*;
	import com.adams.suite.utils.ArrayUtil;
	import com.adams.suite.utils.Cursor;
	import com.adams.suite.utils.RandomList;
	import com.adams.suite.utils.SMTPUtil;
	import com.adams.suite.utils.Utils;
	import com.adams.suite.views.HomeSkinView;
	import com.adams.suite.views.Question;
	import com.adams.suite.views.components.DataComp;
	import com.adams.suite.views.components.NativeButton;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.collections.XMLListCollection;
	import mx.controls.Alert;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.controls.Tree;
	import mx.controls.treeClasses.TreeListData;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.events.ItemClickEvent;
	import mx.events.ListEvent;
	import mx.events.TreeEvent;
	import mx.graphics.shaderClasses.ColorBurnShader;
	
	import org.osmf.events.TimeEvent;
	
	import spark.components.List;
	import spark.events.IndexChangeEvent;
	import spark.events.TextOperationEvent;
	import spark.skins.spark.DefaultItemRenderer;
	
	
	public class HomeViewMediator extends AbstractViewMediator
	{ 		 
		
		[Inject]
		public var currentInstance:CurrentInstance;  
		
		[Bindable ]
		[Embed("assets/images/pdf.png")]
		public var notAttenIcon:Class;
		
		[Bindable]
		[Embed("assets/images/doc.png")]
		public var attenIcon:Class;
		
		[Bindable]
		[Embed("assets/images/flag_icon.png")]
		public var flagIcon:Class;
		
		
		private var minuteTimer:Timer = new Timer(1000,0);
		
		private var tH:int;
		private var tM:int;
		private var tS:int;
		
		public var _mainViewStackIndex:int
		public function get mainViewStackIndex():int {
			return _mainViewStackIndex;
		}
		public function set mainViewStackIndex( value:int ):void {
			_mainViewStackIndex = value;
		} 
		
		/**
		 * Constructor.
		 */
		public function HomeViewMediator( viewType:Class=null )
		{
			super( HomeSkinView ); 
		}
		
		/**
		 * Since the AbstractViewMediator sets the view via Autowiring in Swiz,
		 * we need to create a local getter to access the underlying, expected view
		 * class type.
		 */
		public function get view():HomeSkinView 	{
			return _view as HomeSkinView;
		}
		
		[MediateView( "HomeSkinView" )]
		override public function setView( value:Object ):void { 
			super.setView(value);	
		}
		
		// cursor for navigation
		private var cursor:Cursor;
		/**
		 * The <code>init()</code> method is fired off automatically by the 
		 * AbstractViewMediator when the creation complete event fires for the
		 * corresponding ViewMediator's view. This allows us to listen for events
		 * and set data bindings on the view with the confidence that our view
		 * and all of it's child views have been created and live on the stage.
		 */
		override protected function init():void {
			super.init();  
			tH = Utils.ttH
			tM = Utils.ttM
			tS = Utils.ttS
				
			viewIndex = Utils.HOME_INDEX;
			pickRandomQuestions();
			wrapCurrentSetofQuestions();
			initCursor();
			generateTOC();
			//initShortCuts();
			view.question.flagreviewBtn.visible = false;
			view.question.gotoTxt.text = '1'; 
			view.question.gotoTxt.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
			view.tocList.openItems = Utils.treeData..node.(@qid == 'ch1'); 
			view.chapterSelection.dataProvider = new ArrayList(['All',Utils.CHAP1,Utils.CHAP2,Utils.CHAP3,Utils.CHAP4,Utils.CHAP5])
		}
		private function resetQuestions(ev:MouseEvent = null):void{
			//empty all old status of questions.
			for(var i:int =1; i<=Utils.chapQsArr.length; i++){
				currentInstance[Utils.CHAPTER+String(i)+Utils.ARRSTR] = []; 
			}
			init();
			if(currentInstance.isLearnMode){
				minuteTimer.stop();
				view.timerLbl.visible=false
			}else{
				resetTime();
				view.timerLbl.visible=true
			}
			//initShortCuts(); 
		}
		private function resetTime():void{
			minuteTimer.reset()
			tH = Utils.ttH
			tM = Utils.ttM
			tS = Utils.ttS
			minuteTimer.start();
		}
		// Pick random Questions
		private function pickRandomQuestions():void{
			/*var wholeList:XMLList = currentInstance.xml..item.question;
			for( var j:int=0; j< wholeList.length(); j++){
				var cat:String = String(wholeList[j].@category)
				if( cat!= "UI"&&cat!= "Architecture and Design"&&cat!="Programming Actionscript"&&cat!= "Data Source and Servers"&&cat!="AIR"){
					trace(cat + ' here')
				}   
			}
			view.qlist.dataProvider=wholeList*/ 
			for(var i:int =0; i<Utils.chapQsArr.length; i++){
				var chapterTitle:String = Utils[Utils.CHAPTITLE+int(i+1)]
				var chList:XMLList = currentInstance.xml..item.question.(@category==chapterTitle);
				var rList:XMLList = RandomList.RandomizeList(chList,Utils.chapQsArr[i]);
				trace(chList.length())
				currentInstance[Utils.CHAPTER+int(i+1)] = rList;
			}   
		
		}
		private function wrapCurrentSetofQuestions():void{
			currentInstance.questions = currentInstance._chapter1 +  currentInstance._chapter2 + currentInstance._chapter3 + currentInstance._chapter4 + currentInstance._chapter5;
			//label for numbering of quiz1
			for( var j:int=0; j< currentInstance.questions.length(); j++){
				currentInstance.questions[j].@label= String(j+1);
				currentInstance.questions[j].@flag =''
			} 
		}
		
		//initialize cursor
		private function initCursor():void{
			currentInstance.myXMLC = new XMLListCollection(currentInstance.questions); 
			cursor = new Cursor(currentInstance.myXMLC); 
			var sort:Sort = new Sort();  
			sort.fields = [new SortField(Utils.SORTQUESTION,true,false,true)];
			// sort based on id to avail seek
			currentInstance.myXMLC.sort=sort;
			currentInstance.myXMLC.refresh();
		}
		//Tree xml generation	 		
		private function generateTOC():void{
			Utils.treeData = new XML(<root><node qid='ch1'/><node qid='ch2'/><node qid='ch3'/><node qid='ch4'/><node qid='ch5'/></root>);
			for(var k:int =0; k<Utils.chapQsArr.length; k++){
				Utils.treeData.node[k].@label=Utils[Utils.CHAPTITLE+int(k+1)];  
				Utils.treeData.node[k].appendChild(genNodes(currentInstance[Utils.CHAPTER+int(k+1)],Utils.CHAPTER+int(k+1)+Utils.ARRSTR));
			} 
			view.tocList.dataProvider=Utils.treeData.node; 
		}
		//goto the selected index of collection
		private function gotoSelection(qNo:int):void{ 
			if(qNo>=0 && qNo<= currentInstance.questions.length()-1){ 
				if (cursor.myCursor.findAny(XML("<item id='" + currentInstance.myXMLC[qNo].@id + "'></item>"))) {
					navigate(Cursor.SEEK);
				}
			}else{
				view.question.gotoTxt.text = '';
			}    
		}  
		// navigate using cursor class
		private function navigate(caseStr:String = Cursor.FIRST):void {
			cursor.navigate(caseStr);	
			loadQuestion(currentInstance.myXMLC.getItemIndex(cursor.myCursor.current));   
			enableDisableButtons(); 
			
		}  
		// view.firstBtn object of Question
		private var firstBtnInCollection:Boolean;
		// view.lastBtn object of Question
		private var lastBtnInCollection:Boolean;
		// enable/ disable buttons accordingly
		private function enableDisableButtons():void {			
			firstBtnInCollection = currentInstance.myXMLC.getItemAt(0) == cursor.myCursor.current; 
			view.backBtn.enabled = view.firstBtn.enabled  = !firstBtnInCollection;
			lastBtnInCollection =currentInstance.myXMLC.getItemAt(currentInstance.myXMLC.length - 1) == cursor.myCursor.current; 
			view.nextBtn.enabled = view.lastBtn.enabled = !lastBtnInCollection;			
		}
		// XML of current Question Item   
		[Bindable] 
		private var currItem:XML = new XML();
		// load the selected question from XML
		private function loadQuestion(qNo:int):void{
			var chapArr:Array = [];
			currItem = XML(currentInstance.questions[qNo]);
			for( var i:int=0; i<currItem.answer.length(); i++){
				currItem.answer[i].@label = String.fromCharCode(i+65);
			} 
			var currChapXML:XMLList = Utils.treeData..node.(@qid ==currItem.@id);
			var statArr:String = currChapXML.@arrayName;
			var chapterIndex:int = int(statArr.substr(8,1));
			// chapter array name to derive current question status from
			chapArr = currentInstance[statArr];
			// for Questions / report/ learn
			DataComp.curqStat = chapArr[int(currChapXML.@index)];
			view.question.questionXML = currItem;
			tocSelection(Utils.treeData,chapterIndex,currChapXML); 
			view.question.gotoTxt.text = currentInstance.questions[qNo].@label;
			if(view.LearnTestToggle.selectedIndex==1){
				view.question.flagreviewBtn.visible=true;
			}else if(view.LearnTestToggle.selectedIndex==0){
				view.question.flagreviewBtn.visible=false;
			}
			if(currItem.@flag=="flagged") {
				view.question.flagreviewBtn.toolTip = 'Remove Flag'
				view.question.flagreviewBtn.selected = true;
			} else {
				view.question.flagreviewBtn.selected = false;
				view.question.flagreviewBtn.toolTip = 'Flag for review'
			}
		}
		// make the Tree element selected accordingly as per current question
		private function tocSelection(dataXML:XML,chapterIndex:int,currChapXML:XMLList):void{
			//close all Folder Trees 
			for(var i:int=0; i<Utils.chapQsArr.length; i++){
				view.tocList.expandItem(dataXML.node[i],false,false);
			} 
			//expand current chapter
			view.tocList.expandItem(dataXML.node[chapterIndex-1],true,false);
			//select the current element
			view.tocList.selectedIndex = int(currChapXML.@index)+chapterIndex;
		}
		private function chapterListener(event:IndexChangeEvent):void{
			for(var i:int =1; i<=Utils.chapQsArr.length; i++){
				Utils.chapQsArr[i-1] = Utils.finalChapQsArr[i-1];
				if(i!=event.newIndex && event.newIndex!=0) Utils.chapQsArr[i-1] = 0;
			}
			resetQuestions();
		}	
		// on selection of Tree Element 
		private function tocTreeListener(event:ListEvent):void{
			if(view.tocList.selectedItem==""){
				// navigate to the selected question
				gotoSelection(int(currentInstance.questions.(@id==view.tocList.selectedItem.@qid).@label)-1); 
				toggleVisibility()
			}else{
				//if Folder node selected, expand or close
				view.tocList.expandItem(view.tocList.selectedItem,!view.tocList.isItemOpen(view.tocList.selectedItem),true);
			}
		}
		// generate nodes for Tree for multipurpose,
		// to be used from the question Module for foreign key reference
		// for the case of storing the status and qid (the primary key) 
		private function genNodes(chapters:XMLList,arrStr:String):XMLList {
			var tempXML:XMLList = new XMLList();
			for(var i:int=1; i<=chapters.length(); i++) {
				var insert:XML = <node />;
				insert.@label = "qNo: "+i; 
				insert.@qid = chapters[i-1].@id;
				insert.@index = i-1;
				insert.@arrayName = arrStr;
				tempXML+= insert;
			}
			return tempXML;
		} 	 
		private function navigateBtn(ev:MouseEvent):void{
			switch(ev.target){
				case view.firstBtn:
					navigate(Cursor.FIRST);
					view.question.feedBack.text='';
					view.question.broswer.location='about:blank';
					break;
				case view.backBtn:
					navigate(Cursor.BACK);
					view.question.feedBack.text='';
					view.question.broswer.location='about:blank';
					break;
				case view.nextBtn:
					navigate(Cursor.NEXT);
					view.question.feedBack.text='';
					view.question.broswer.location='about:blank';
					break;
				case view.lastBtn:
					navigate(Cursor.LAST);
					view.question.feedBack.text='';
					view.question.broswer.location='about:blank';
					break;
				case view.finishBtn:
					testValidation();
					break; 		
			}
			toggleVisibility()
			if(ev.currentTarget == view.finishBtn){
				view.question.flagreviewBtn.visible=false;
				currentInstance.isResultReviewMode = false;
			}
			if(currentInstance.isFinishMode){
				view.question.flagreviewBtn.visible=false;
				currentInstance.isResultReviewMode = false;
				view.question.feedBack.visible = true;
				view.question.feedBack.text="Solution: "+"\r"+view.question.questionXML.question.@feedback;
				view.question.broswer.visible = true;
				view.question.broswer.location=view.question.questionXML.question.@link;
			}
			if(ev.currentTarget == view.finishBtn){
				view.question.flagreviewBtn.visible=false;
			}
		}
		private function txtChangedListener(textev:TextOperationEvent):void{
			gotoSelection(int(view.question.gotoTxt.text)-1);
			toggleVisibility();
		}
		private function initShortCuts():void{
			view.question.qgroup.addEventListener(MouseEvent.MOUSE_DOWN, startHandler);
			view.question.qgroup.addEventListener(MouseEvent.MOUSE_UP, stopHandler);
		} 
		//on mouse down, start recording mouseX
		private var mousePos:int;
		private function startHandler(e:MouseEvent):void{ 
			mousePos = mouseX;
		}
		//on mouse up, find difference to read gesture 
		private function stopHandler(e:MouseEvent):void{ 
			mousePos = mouseX-mousePos;
			if(mousePos>20 || mousePos<-20){
				if(mousePos>0){
					if(!lastBtnInCollection) navigate('next');
					view.question.feedBack.text="Solution: "+"\r"+view.question.questionXML.question.@feedback;
				}else{
					if(!firstBtnInCollection) navigate('back');	
					view.question.feedBack.text="Solution: "+"\r"+view.question.questionXML.question.@feedback;
				}
				toggleVisibility();
			}
		}  
		private function toggleVisibility():void{
			if(currentInstance.isLearnMode){
				view.question.feedBack.text='';
				view.question.feedBack.visible = true;
				view.question.broswer.visible = false;
				view.question.broswer.location='about:blank';
			}
			if(currentInstance.isFinishMode){
				view.question.flagreviewBtn.visible=false;
				currentInstance.isResultReviewMode = false;
				view.question.feedBack.visible = true;
				view.question.feedBack.text="Solution: "+"\r"+view.question.questionXML.question.@feedback;
				view.question.broswer.visible = true;
				view.question.broswer.location=view.question.questionXML.question.@link;
			}
			if(!currentInstance.isResultReviewMode){
				view.question.flagreviewBtn.visible=false;
				view.question.feedBack.text="Solution: "+"\r"+view.question.questionXML.question.@feedback;
				view.question.broswer.visible = true;
				view.question.broswer.location=view.question.questionXML.question.@link;
			} 
		}
		private var result:XML;
		// generate results
		public function genResult(generate:Boolean):void{
			// Tree dataprovider for result and generation of  result xml
			result = <root><node/><node/><node/><node/><node/></root>; 
			//generate reports for all chapters
			for(var i:int =0; i<Utils.chapQsArr.length; i++){
				genReport(currentInstance[Utils.CHAPTER+int(i+1)+Utils.ARRSTR],currentInstance[Utils.CHAPTER+int(i+1)],i);
			} 
			// not Attempted questions list
			currentInstance.notAttList = result..node.(@stat=='null');
			missedQs= currentInstance.notAttList.length();
			//all questions were attempted or user selection or timer complete
			if(generate ){
				showResult();
			} 
		}
		private var missedQs:int 
		private var ch1Per:int
		private var ch2Per:int
		private var ch3Per:int
		private var ch4Per:int
		private var ch5Per:int
		//result compilation
		private function showResult():void{	
			// list of questions answered correctly
			var totList:XMLList = result..node.(@stat=='true');
			// chapters organized seperately for percentage calculation
			for(var j:int =0; j<Utils.chapQsArr.length; j++){
				this["ch"+String(j+1)+"Per"] = int(totList.(@chap==Utils[Utils.CHAPTITLE+String(j+1)]).length()/ Utils.chapQsArr[j]*100);
			} 
			var totPer:int = int(totList.length()/ (currentInstance.questions.length() -1)*100);
			// feedback string 
			var resultStr:String = '';
			resultStr += "Questions not attempted: " +currentInstance.notAttList.length() + '\n';
			for(var i:int =1; i<=Utils.chapQsArr.length; i++){
				resultStr += "Chapter "+i+" Percentage " +this["ch"+String(i)+"Per"] + '% \n';
			}
			resultStr += "Overall Percentage " +totPer+ '% \n'; 
			totPer>Utils.PASSPERCENTAGE ?resultStr += "Congratulation.! You have Passed" + "\r"+"Verfiy your Wrong Answers" : resultStr += "You have Failed" + "\r" + "Please Check the answers"; 
			Alert.show(resultStr,"Result",0,this,alertClickHandler);  
			view.finishBtn.enabled =false;
			view.tocList.dataProvider =result.node;
			view.tocList.labelField="@label"; 
		}
		private function alertClickHandler(event:CloseEvent):void {
			if (event.detail==Alert.OK){
				view.timerLbl.visible=false;
					view.LearnTestToggle.selectedIndex=1;
					//view.LearnTestToggle.selected = true;
				    view.tocList.expandChildrenOf(view.tocList.firstVisibleItem,true)
					view.question.gotoTxt.text = "1"; 
					view.question.gotoTxt.dispatchEvent(new TextOperationEvent(TextOperationEvent.CHANGE));
					view.question.feedBack.visible = true;
					view.question.feedBack.text="Solution: "+"\r"+view.question.questionXML.question.@feedback;
			}
		}
		// generate report for a chapter by composing a XML
		private function genReport(chapter:Array, chList:XMLList, chInd:int):void{
			var missed:int = 0;
			var tempXML:XMLList = new XMLList();
			for( var i:int=0; i<chList.length(); i++){
				var insert:XML = <node />;
				insert.@qid = chList[i].@id;
				insert.@label = "qNo: "+int(i+1);
				insert.@chap = Utils[Utils.CHAPTITLE+int(chInd+1)];	
				if(chapter[i]!=null){
					if(!chapter[i][0]){
						insert.@fb = chList[i].question.@feedback;
						insert.@stat = 'false'; 
						missed++;						
					}else{
						insert.@fb = 'Correctly answered';
						insert.@stat = 'true';
					}
					insert.@urllink = chList[i].question.@link;		 
				}else{
					missed++;
					insert.@fb = 'Not Attempted';
					insert.@stat = 'null';
					if(view.question.questionXML.@flag == "flagged"){
						view.tocList.setItemIcon(view.tocList.selectedItem, flagIcon, flagIcon);
					}else{
						view.tocList.setItemIcon(view.tocList.selectedItem, attenIcon, attenIcon);
					}
					
				}
				tempXML+= insert;
			}   
			result.node[chInd].@label = Utils[Utils.CHAPTITLE+int(chInd+1)];
			result.node[chInd].@qid = 'ch';
			result.node[chInd].@missed = missed;
			result.node[chInd].@stat = 'ch';
			result.node[chInd].appendChild(tempXML);
		} 
		/**
		 * Create listeners for all of the view's children that dispatch events
		 * that we want to handle in this mediator.
		 */
		override protected function setViewListeners():void {
			super.setViewListeners(); 
			view.chapterSelection.addEventListener(IndexChangeEvent.CHANGE,chapterListener,false,0,true);
			view.tocList.addEventListener(ListEvent.ITEM_CLICK,tocTreeListener,false,0,true);
			view.question.gotoTxt.addEventListener(TextOperationEvent.CHANGE,txtChangedListener,false,0,true);
			view.firstBtn.clicked.add(navigateBtn);
			view.backBtn.clicked.add(navigateBtn);
			view.nextBtn.clicked.add(navigateBtn);
			view.lastBtn.clicked.add(navigateBtn);
			view.finishBtn.clicked.add(navigateBtn);
			view.LearnTestToggle.addEventListener(IndexChangeEvent.CHANGE,setCurrentTestMode)
			view.question.flagreviewBtn.addEventListener(MouseEvent.CLICK,flagReview);
			minuteTimer.addEventListener(TimerEvent.TIMER, timeCalculation);
			view.feedbackbtn.clicked.add(feedBackForm);
			view.subFeedBack.clicked.add(submitForm);
			view.canFeedBack.clicked.add(cancelFeedBackForm);
		}
		private function setCurrentTestMode(ev:IndexChangeEvent):void{
			if(view.LearnTestToggle.selectedIndex==1){
				// Test Mode
				//view.LearnTestToggle.label="LearnMode";
				view.modeChange.text="TestMode";
				view.question.feedBack.visible=false;
				view.question.broswer.visible=false;
				view.finishBtn.visible=true;
				view.finishBtn.enabled=true;
				currentInstance.isLearnMode = false;
				view.finishBtn.includeInLayout=true; 
				resetQuestions();
			}else if(view.LearnTestToggle.selectedIndex==0){
				if(currentInstance.isResultReviewMode== true){
					view.finishBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				}else{
					// Learn Mode
					view.modeChange.text="LearnMode";
					view.question.feedBack.visible=true;
					view.question.feedBack.text='';
					view.question.broswer.visible=false; 
					view.finishBtn.visible=false;
					currentInstance.isResultReviewMode=true;
					currentInstance.isLearnMode = true;
					view.finishBtn.includeInLayout=false;
					view.question.flagreviewBtn.visible=false;
					resetQuestions();
				}
			}
		}
		private function testValidation():void{
			if(currentInstance.questions.(@flag == "flagged").length() == 0){
				var resData:String='Do you want to Quit the Exam';
				Alert.show(resData,'Information',3,this,testAlertHandler);
				minuteTimer.stop()
			}else{
				resData='Do you want to Quit the Exam'+"\r"+'Flagged Questions '+currentInstance.questions.(@flag=='flagged').length();
				Alert.show(resData,'Information',3,this,testAlertHandler);
				minuteTimer.stop()
			}
			
		}
		private function testAlertHandler(event:CloseEvent):void{
			if (event.detail==Alert.YES ){
				genResult(true);
			}else{
				minuteTimer.start();
				view.question.flagreviewBtn.visible=true;
				if(currItem.@flag=="flagged") {
					view.question.flagreviewBtn.toolTip = 'Remove Flag'
					view.question.flagreviewBtn.selected = true;
				} else {
					view.question.flagreviewBtn.selected = false;
					view.question.flagreviewBtn.toolTip = 'Flag for review'
				}
				currentInstance.isResultReviewMode = true;
				view.question.feedBack.visible = false;
				view.question.broswer.visible = false;
				minuteTimer.start();
		}
			view.LearnTestToggle.selectedIndex = 1;
		}
		private function timeCalculation(event:TimerEvent):void{
			tS = tS - 1;
			if(tS==0) {
				tM = tM - 1;
				tS=60;
				if(tM==0) {
					tH = tH - 1;
					tM=60;
				}
			}
			view.timerLbl.text = tH+":"+tM+":"+tS;
			if(tH ==0 && tM==0 && tS ==1){
				minuteTimer.stop();
				view.timerLbl.text = 0+":"+0+":"+0;
				genResult(true);
				Alert.show("Time Up");
			}
		}
		private function flagReview(ev:MouseEvent):void
		{	
			if(!view.tocList.selectedItem){
				view.tocList.selectedIndex = 1;
			}
			if(view.question.flagreviewBtn.selected){
				view.question.flagreviewBtn.label = 'Remove Flag';
				view.question.flagreviewBtn.toolTip = "Remove Flag";
				view.question.questionXML.@flag ="flagged";
				view.tocList.setItemIcon(view.tocList.selectedItem,flagIcon,flagIcon);
			}
			else{
				view.question.flagreviewBtn.label = 'Flag for review';
				view.question.flagreviewBtn.toolTip = "Flag for Review";
				view.question.questionXML.@flag ="notFlagged";
				view.tocList.setItemIcon(view.tocList.selectedItem, attenIcon,attenIcon);
			}
		}
		private function feedBackForm(ev:MouseEvent):void
		{
			view.mainView.filters = [new BlurFilter(5,5,1)];
			view.feedBackForm.visible = true;
			view.nameInput.text = "";
			view.mailId.text = "";
			view.feedback.text = "";
			minuteTimer.stop();
		}
		private function submitForm(ev:MouseEvent):void
		{
			if(currentInstance.isLearnMode){
				view.timerLbl.visible=false
			}
			view.mainView.filters = [];
			view.feedBackForm.visible = false;
			var formList:XMLList = new XMLList();
			minuteTimer.start();
			var smtpmail:SMTPUtil = new SMTPUtil()
			var mail_to:String = "nsdevaraj@gmail.com";
			var commonComments:String ="<b>Name:</b>"+view.nameInput.text+"<br/>"+ "<b>MailId:</b>"+view.mailId.text+"<br/>"+ "<b>Comments:</b>" +view.feedback.text;
			SMTPUtil.mail(mail_to,"FeedBack",commonComments);
			
		}
		private function cancelFeedBackForm(ev:MouseEvent):void
		{
			if(currentInstance.isLearnMode){
				view.timerLbl.visible=false
			}
			view.mainView.filters = [];
			view.feedBackForm.visible = false;
			minuteTimer.start();
			
		}
		/**
		 * Remove any listeners we've created.
		 */
		override protected function cleanup( event:Event ):void {
			super.cleanup( event ); 		
			view.tocList.removeEventListener(ListEvent.ITEM_CLICK,tocTreeListener);
			view.question.gotoTxt.removeEventListener(TextOperationEvent.CHANGE,txtChangedListener);
			view.firstBtn.clicked.removeAll();
			view.backBtn.clicked.removeAll();
			view.nextBtn.clicked.removeAll();
			view.lastBtn.clicked.removeAll();
			view.finishBtn.clicked.removeAll();
			view.LearnTestToggle.addEventListener(MouseEvent.CLICK,setCurrentTestMode);
			minuteTimer.removeEventListener(TimerEvent.TIMER,timeCalculation);
			view.question.flagreviewBtn.removeEventListener(MouseEvent.CLICK,flagReview);
			view.feedbackbtn.clicked.removeAll();
			view.subFeedBack.clicked.removeAll();
		}
		/**
		 * initiates cleanup view, of this view. manages stage resize, minimize or maximize event 
		 * as removed from stage event should not be called on these system events
		 */		
		override protected function gcCleanup( event:Event ):void {
			if( viewIndex != Utils.HOME_INDEX ) {
				cleanup( event );	
			}
		}
	}
}
package com.adams.dt.business.util
{
	import com.adams.dt.model.ModelLocator;
	import com.adams.dt.model.managers.SharedObjectManager;
	
	import flash.desktop.NativeApplication;
	import flash.geom.Point;
	import flash.system.Capabilities;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;  
	public class Register
	{ 
		private var SoM:SharedObjectManager = SharedObjectManager.instance;
		private var point1:Point = new Point();
		[Bindable]
		private var model : ModelLocator = ModelLocator.getInstance();
		
		public var validKey:Boolean;
		private var alertDisplayed:Boolean;	  
		// check registration
		public function checkRegistration():void {
			//SoM.sharedObject.clear();
			if(SoM.data.systemId==undefined) getSystemId();
			if(SoM.data.installedTime==undefined) getInstalledTime();
			if(SoM.data.productId==undefined) getProductID();
			if(SoM.data.userName==undefined) getUserName();
			if(SoM.data.timePeriod==undefined) getTimePeriod();
			if(SoM.data.licensed==undefined) SoM.data.licensed = false;
			
			//trace(SoM.data.userName+"NAME"+SoM.data.productId+"ID"+SoM.data.installedTime+"TIME"+SoM.data.systemId+"SYTEMID")
			
			model.systemID = SoM.data.systemId;
			model.registeredUser = SoM.data.userName;
			model.evalMinutes = SoM.data.timePeriod;
			model.licensedVersion = SoM.data.licensed;
			
			var out:MD53 = new MD53(SoM.data.userName,SoM.data.systemId);
			var currentTime:Date = model.currentTime;
		  	model.tillTime = (currentTime.valueOf()- SoM.data.installedTime)/60000;
		  	
		  	//trace(model.tillTime+"++++++++tillTime"+model.evalMinutes+"+++++++model.evalMinutes"+model.licensedVersion+"__model.licensedVersion");
		
		  		// check with unique productid
		  		if(!model.licensedVersion){
		  				if(model.tillTime>model.evalMinutes){
								Alert.okLabel = "Close";
								Alert.yesLabel= "Register";
								Alert.buttonWidth = 80;
								if(!alertDisplayed){
									alertDisplayed = true;
									Alert.show("Contact Brennus","Trial Expired",Alert.YES|Alert.OK,model.mainClass,alertCloseHandler);	
								}
							}
					}   	
		  		}
		// store provided product id with userid
		public function saveProductId(productId:String,user:String):void {
			validKey = matchSearialKey(productId,user);
			if(validKey){
				if(user=="deployment" && SoM.data.productId!=productId){
					SoM.data.userName = user;
					SoM.data.productId = productId;
					SoM.data.timePeriod = 43200;					
					var currentTime:Date = model.currentTime;
					SoM.data.installedTime = currentTime.valueOf();
					 
					model.registeredUser = user;
					model.tillTime = 0;
					checkRegistration();
				}else{
					SoM.data.userName = user;
					SoM.data.licensed = true;
					checkRegistration();
				}	
			} 
		}
		private function matchSearialKey(productId:String,user:String):Boolean{
			var out:MD53 = new MD53(user,SoM.data.systemId);
			if(productId == out.output){
				return true;
			}
			return false;
		}
		private function getProductID():void{
			SoM.data.productId = "";
		}
		private function getUserName():void{
			SoM.data.userName = "trial";
		}
		// store the system id automatically for the first time installation
		private function getSystemId():void {
			SoM.data.systemId = UIDUtil.createUID();
		}
		
		private function getTimePeriod():void {
			SoM.data.timePeriod = model.evalMinutes;
		}
		
		private function getInstalledTime():void{
			var installTime:Date = new Date();
			SoM.data.installedTime =installTime.valueOf();
		}
		// close the dt
		private function alertCloseHandler(event:CloseEvent):void {
			//exit
			alertDisplayed = false;
			if (event.detail == Alert.OK) {
				SoM.data.filesToBeUpload = model.bgUploadFile.fileToUpload;
				SoM.data.filesToBeDownload = model.bgDownloadFile.fileToDownload;
				SoM.data.fileDetailsArrays = model.fileDetailsArray; 
				NativeApplication.nativeApplication.exit();
			}//registration form
			else if (event.detail == Alert.YES) {
				showWindow();
			}
		}
 
        public function showWindow():void {
            var register:Registration =Registration(PopUpManager.createPopUp( model.mainClass, Registration ,true));
            point1.x=Capabilities.screenResolutionX/2;
            point1.y=Capabilities.screenResolutionY/2;                
            register.x=point1.x-register.width/2;
            register.y=point1.y-register.height/2;
        }
	}
}
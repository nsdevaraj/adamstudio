package com.adams.dt.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.vo.IValueObject;

    
    public class OpenToDoListScreenEvent extends CairngormEvent 
    {
        public var vo:IValueObject;
        public static const EVENT_OPEN_ORDERSCREEN:String='P1T01A';
        public static const EVENT_OPEN_ORDERSCREENWITHCORRECTION:String='P1T01B';
        public static const EVENT_OPEN_ORDERRECEPTIONSCREEN:String='P1T02A';
        public static const EVENT_OPEN_ORDERRECEPTIONSCREENCORRECTION:String='P1T02B';
        public static const EVENT_OPEN_TECHNICALPREPARATIONSCREEN:String='P1T03A';
        public static const EVENT_OPEN_TECHNICALPREPARATIONSCREENCORRECTION:String='P1T03B';
        public static const EVENT_OPEN_PROCESSVALIDATIONSCREEN:String='P2T01A';
        public static const EVENT_OPEN_PROCESSVALIDATIONSCREENCORRECTION:String='P2T01B';
        public static const EVENT_OPEN_PREPARATIONTECHNIQUESCREEN:String='P3T01A';
        public static const EVENT_OPEN_PREPARATIONTECHNIQUESCREENCORRECTION:String='P3T01B';
        public static const EVENT_OPEN_REALISATIONSCREEN:String='P3T02A';
        public static const EVENT_OPEN_REALISATIONSCREENCORRECTION:String='P3T02B';
        public static const EVENT_OPEN_CONTOLSCREEN:String='P3T03A';
        public static const EVENT_OPEN_RELECTURESCREEN:String='P4T01A';
        public static const EVENT_OPEN_RELECTURESCREENCORRECTION:String='P4T01B';
        public static const EVENT_OPEN_LANCEMENTCORRECTIONSCREEN:String='P4T02A';
        public static const EVENT_OPEN_LANCEMENTCORRECTIONSCREENCORRECTION:String='P4T02B';
        public static const EVENT_OPEN_REALISATIONCORRECTIONSCREEN:String='P4T03A'; 
        public static const EVENT_OPEN_REALISATIONCORRECTIONINCOMPLETESCREEN:String='P4T03B';    
        public static const EVENT_OPEN_CONTROLCORRECTIONSCREEN:String='P4T04A';
        public static const EVENT_OPEN_RELECTURECORRECTIONSCREEN:String='P4T05A';
        public static const EVENT_OPEN_RELECTURECORRECTIONINCOMPLETESCREEN:String='P4T05B';
        public static const EVENT_OPEN_LANCEMENTLIVRAISONSCREEN:String='P5T01A';
        public static const EVENT_OPEN_DEPARTLIVRAISONSCREEN:String='P5T02A';
        public static const EVENT_OPEN_CLOSEPROJECTSCREEN:String='P5T03A';
        public static const EVENT_OPEN_VIEWMESSAGSCREEN:String='M01';
        
        
          
        
        //P4T03A   
        public function OpenToDoListScreenEvent(ptype:String,vo:IValueObject=null) 
        {
            super(ptype);
            vo = vo;
        }
    }    
}
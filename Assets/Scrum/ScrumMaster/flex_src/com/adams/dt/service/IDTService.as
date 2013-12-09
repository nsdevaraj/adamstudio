package com.adams.dt.service
{
	import com.adams.dt.model.vo.IValueObject;
	
	import mx.collections.IList;
	public interface IDTService
	{
		 function produceMessage(destn:String,desc:Object,msg:String,sentTo:Array):void
		 function configServer():void
		 function get baseURL():String
		 function set baseURL(value:String):void
		 function create( destination:String,desc:Object, vo:IValueObject ):void  
		 function update( destination:String,desc:Object, vo:IValueObject ):void  
		 function read( destination:String,desc:Object, id:int ):void  
		 function deleteById( destination:String,desc:Object, vo:IValueObject ):void 		
		 function count(destination:String,desc:Object):void  
		 function getList(destination:String,desc:Object):void  
		 function bulkUpdate(destination:String,desc:Object, list:IList ):void  
		 function deleteAll(destination:String,desc:Object):void
		 function login (user:String,pwd:String):void
		 function dbQuery(destination:String, desc:Object, ...args):void
		 function findByNameId(destination:String, desc:Object,name:String,id:int ):void 
		 function findById(destination:String, desc:Object,subnum:int ):void
		 function findByName(destination:String, desc:Object,name:String ):void
		 function findByIdName(destination:String, desc:Object,id:int,name:String ):void 
		 function findByTaskId(destination:String, desc:Object,id:int):void
		 function findAll(destination:String, desc:Object):void
		 function createSubDir( destination:String, desc:Object, parentFolder:String, folderName:String ):void 
	}
}
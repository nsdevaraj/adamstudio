package com.adams.dt.business
{
	import com.adobe.cairngorm.vo.IValueObject;
	
	import mx.collections.ArrayCollection;
	
	/**
	 * Defines a business delegate.
	 * extends IResponderAware class
	 */
	public interface IDAODelegate extends IResponderAware
	{	 
		/**
	     * Method Name create.
	     * Create new value insert
		 * @param common value Object pass 
		 * return type void
	     */	
		function create(vo:IValueObject): void
		
		/**
	     * Method Name update.
	     * previous value modify and update
		 * @param common value Object pass 
		 * return type void
	     */	
		function update(vo:IValueObject): void
		
		/**
	     * Method Name select.
		 * @param common value Object pass 
		 * return type void
	     */
		function select(vo: IValueObject) : void
		
		/**
	     * Method Name deleteVO.
	     * delete corresponding data
		 * @param common value Object pass  
		 * return type void
	     */
		function deleteVO(vo:IValueObject): void 
		
		/**
	     * Method Name findAll.
		 * retrieve the value Object
		 * return type void
	     */
		function findAll(): void
		
		/**
	     * Method Name findById.
		 * @param unique primarykey value pass	   
		 * return type void
	     */
		function findById(no:int): void
		
		/**
	     * Method Name bulkUpdate.
		 * @param Object arraycollection value pass	   
		 * return type void
	     */
		function bulkUpdate(arrayCollection : ArrayCollection) : void
		
		/**
	     * Method Name getQueryResult.
		 * @param string value pass	   
		 * return type void
	     */
		 function getQueryResult(query : String) : void
		 
		 /**
	     * Method Name deleteQuery.
		 * @param string value pass	   
		 * return type void
	     */
		 function deleteQuery(query : String) : void
		 
		 /**
	     * Method Name queryPagination.
		 * @param string value pass
		 * @param starting value pass
		 * @param ending value pass	   
		 * return type void
	     */
		 function queryPagination(query : String, start:int, end:int) : void
		 
		 /**
	     * Method Name namedQuery.
		 * @param string value pass
		 * @param starting value pass
		 * @param ending value pass	   
		 * return type void
	     */
		 function namedQuery(query : String, start:int, end:int) : void
		 
		 /**
	     * Method Name namedQueryId.
		 * @param string value pass
		 * @param primarykey value pass
		 * @param starting value pass
		 * @param ending value pass	   
		 * return type void
	     */
		 function namedQueryId(query : String,id1:int, start:int, end:int) : void
		 
		 /**
	     * Method Name namedQueryIdId.
		 * @param string value pass
		 * @param primarykey value pass
		 * @param foreignkey value pass
		 * @param starting value pass
		 * @param ending value pass	   
		 * return type void
	     */
		 function namedQueryIdId(query : String, id1:int,id2:int,start:int, end:int) : void
		 
		 /**
	     * Method Name namedQueryIdIdId.
		 * @param string value pass
		 * @param primarykey value pass
		 * @param foreignkey value pass
		 * @param foreignkey value pass
		 * @param starting value pass
		 * @param ending value pass	   
		 * return type void
	     */
		 function namedQueryIdIdId(query : String, id1:int,id2:int,id3:int,start:int, end:int) : void
		 
		 /**
	     * Method Name namedQueryIdStr.
		 * @param string value pass
		 * @param primarykey value pass
		 * @param String value pass
		 * @param starting value pass
		 * @param ending value pass	   
		 * return type void
	     */
		 function namedQueryIdStr(query : String, id1:int,str:String,start:int, end:int) : void
		 
		 /**
	     * Method Name namedQueryIdDtDt.
		 * @param string value pass
		 * @param primarykey value pass
		 * @param Date dt1 value pass
		 * @param Date dt2 value pass
		 * @param starting value pass
		 * @param ending value pass	   
		 * return type void
	     */
		 function namedQueryIdDtDt(query : String, id1:int,dt1:Date,dt2:Date,start:int, end:int) : void
		 
		 /**
	     * Method Name namedQueryStr.
		 * @param string value pass
		 * @param string value pass
		 * @param starting value pass
		 * @param ending value pass	   
		 * return type void
	     */
		 function namedQueryStr(query : String,str:String, start:int, end:int) : void
		 
		 /**
	     * Method Name namedQueryStrStr.
		 * @param string value pass
		 * @param string str1 value pass
		 * @param string str2 value pass
		 * @param starting value pass
		 * @param ending value pass	   
		 * return type void
	     */
		 function namedQueryStrStr(query : String,str1:String, str2:String, start:int, end:int) : void
		 
		 /**
	     * Method Name namedQueryStrStrDtDt.
		 * @param string value pass
		 * @param string str1 value pass
		 * @param string str2 value pass
		 * @param Date dt1 value pass
		 * @param Date dt2 value pass
		 * @param starting value pass
		 * @param ending value pass	   
		 * return type void
	     */
		 function namedQueryStrStrDtDt(query : String, str1:String,str2:String,dt1:Date,dt2:Date,start:int, end:int) : void
		 /**
	     * Method Name namedQueryList.
		 * @param string value pass		 	   
		 * return type void
	     */
		 function namedQueryList(query : String) : void 
	}
}

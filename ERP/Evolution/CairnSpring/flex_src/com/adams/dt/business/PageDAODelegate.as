package com.adams.dt.business
{
	import mx.rpc.IResponder;
	
	/**
	 * final PageDAODelegate class
	 * extends AbstractDelegate class
	 * implements IDAODelegate class
	 */
	public final class PageDAODelegate extends AbstractDelegate implements IDAODelegate
	{ 
		/**
		 * PageDAODelegate class constructor
		 * @param IResponder value pass
		 * @param Services name pass
		 */
		public function PageDAODelegate(handlers:IResponder = null, service:String='')
		{		
			super(handlers, Services.PAGE_SERVICE ); 
		} 
		
		/**
	     * Method Name getQueryResult.
	     * @param String query value pass 
	     * serverside method call getQueryResult        
		 * return type void
	     */	
		override public function getQueryResult(query : String) : void
		{
			invoke("getQueryResult",query);
		}
		
		/**
	     * Method Name deleteQuery.
	     * @param String query value pass 
	     * serverside method call deleteByForeignKey        
		 * return type void
	     */	
		override public function deleteQuery(query : String) : void
		{
			invoke("deleteByForeignKey",query);
		}
		
		/**
	     * Method Name queryPagination.
	     * @param String query value pass
	     * @param starting value pass
		 * @param ending value pass	  
	     * serverside method call queryPagination        
		 * return type void
	     */
		override public function queryPagination(query : String, start:int, end:int) : void
		{
			invoke("queryPagination",query,start,end);
		}
		
		/**
	     * Method Name namedQueryList.
		 * @param query value pass 		 
		 * serverside invoke java method queryListView
		 * return type void
	     */
		override public function namedQueryList(query : String) : void
		{
			invoke("queryListView",query);
		}
		
		/**
	     * Method Name namedQuery.
		 * @param query value pass  
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListView
		 * return type void
	     */
		override public function namedQuery(query : String, start:int, end:int) : void
		{
			invoke("paginationListView",query,start,end);
		}
		
		/**
	     * Method Name namedQueryId.
		 * @param query value pass 
		 * @param unique id value pass 
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewId
		 * return type void
	     */
 		override public function namedQueryId(query : String,id1:int, start:int, end:int) : void
		{
			invoke("paginationListViewId",query,id1,start,end);
		}
		
		/**
	     * Method Name namedQueryIdId.
		 * @param query value pass 
		 * @param unique id1 value pass 
		 * @param unique id2 value pass 
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewIdId
		 * return type void
	     */
		override public function namedQueryIdId(query : String, id1:int,id2:int,start:int, end:int) : void
		{
			invoke("paginationListViewIdId",query,id1,id2,start,end);
		}
		
		/**
	     * Method Name namedQueryIdIdId.
		 * @param query value pass 
		 * @param unique id1 value pass 
		 * @param unique id2 value pass 
		 * @param unique id3 value pass 
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewIdIdId
		 * return type void
	     */
		override public function namedQueryIdIdId(query : String, id1:int,id2:int,id3:int,start:int, end:int) : void
		{
			invoke("paginationListViewIdIdId",query,id1,id2,id3,start,end);
		}
		
		/**
	     * Method Name namedQueryIdStr.
		 * @param query value pass 
		 * @param unique id1 value pass 
		 * @param str value pass
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewIdStr
		 * return type void
	     */
		override public function namedQueryIdStr(query : String, id1:int,str:String,start:int, end:int) : void
		{
			invoke("paginationListViewIdStr",query,id1,str,start,end);
		}
		
		/**
	     * Method Name namedQueryIdDtDt.
		 * @param query value pass 
		 * @param unique id1 value pass 
		 * @param Date dt1 value pass
		 * @param Date dt2 value pass
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewIdDtDt
		 * return type void
	     */
		override public function namedQueryIdDtDt(query : String, id1:int,dt1:Date,dt2:Date,start:int, end:int) : void
		{
			invoke("paginationListViewIdDtDt",query,id1,dt1,dt2,start,end);
		}
		
		/**
	     * Method Name namedQueryStr.
		 * @param query value pass 
		 * @param String value pass 
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewStr
		 * return type void
	     */
		override public function namedQueryStr(query : String,str:String, start:int, end:int) : void
		{
			invoke("paginationListViewStr",query,str,start,end);
		}
		
		/**
	     * Method Name namedQueryStrStr.
		 * @param query value pass 
		 * @param String str1 value pass 
		 * @param String str2 value pass
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewStrStr
		 * return type void
	     */
		override public function namedQueryStrStr(query : String,str1:String, str2:String, start:int, end:int) : void
		{
			invoke("paginationListViewStrStr",query,str1,str2,start,end);
		}
		
		/**
	     * Method Name namedQueryStrStrDtDt.
		 * @param query value pass 
		 * @param String str1 value pass 
		 * @param String str2 value pass
		 * @param Date dt1 value pass
		 * @param Date dt2 value pass
		 * @param start value pass  pagination using start value
		 * @param end value pass   pagination using end value
		 * serverside invoke java method paginationListViewStrStrDtDt
		 * return type void
	     */		
		override public function namedQueryStrStrDtDt(query : String, str1:String,str2:String,dt1:Date,dt2:Date,start:int, end:int) : void
		{
			invoke("paginationListViewStrStrDtDt",query,str1,str2,dt1,dt2,start,end);
		}
	}
}

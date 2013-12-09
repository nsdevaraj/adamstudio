/*
 * Copyright 2010 @nsdevaraj
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License. You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package com.adams.scrum.response
{
	import com.adams.scrum.dao.AbstractDAO;
	import com.adams.scrum.models.collections.ICollection;
	import com.adams.scrum.models.processor.IVOProcessor;
	import com.adams.scrum.models.vo.CurrentInstance;
	import com.adams.scrum.models.vo.Domains;
	import com.adams.scrum.models.vo.IValueObject;
	import com.adams.scrum.models.vo.Products;
	import com.adams.scrum.models.vo.SignalVO;
	import com.adams.scrum.models.vo.Sprints;
	import com.adams.scrum.signals.AbstractSignal;
	import com.adams.scrum.signals.PushRefreshSignal;
	import com.adams.scrum.signals.ResultSignal;
	import com.adams.scrum.utils.Action;
	import com.adams.scrum.utils.GetVOUtil;
	import com.adams.scrum.utils.Utils;
	import com.adams.scrum.views.renderers.SprintStoryRenderer;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.swizframework.controller.AbstractController;
	import org.swizframework.utils.services.ServiceHelper;
	
	public class AbstractResult extends AbstractController
	{
		
		[Inject]
		public var service:ServiceHelper;
		
		[Inject]
		public var serviceSignal:AbstractSignal;
		
		[Inject]
		public var resultSignal:ResultSignal;
		
		[Inject]
		public var pushRefreshSignal:PushRefreshSignal;
		
		[Inject]
		public var signalSeq:SignalSequence;
		
		[Inject("domainDAO")]
		public var domainDAO:AbstractDAO;	
		
		[Inject("productDAO")]
		public var productDAO:AbstractDAO;	
		
		[Inject("sprintDAO")]
		public var sprintDAO:AbstractDAO;	
		
		[Inject("storyDAO")]
		public var storyDAO:AbstractDAO;
		
		[Inject]
		public var currentInstance:CurrentInstance; 
		
		public function AbstractResult()
		{
		} 
		
		private var _token:AsyncToken = new AsyncToken();
		public function get token():AsyncToken {
			return _token;
		}
		/** <p>
		 * delegate for global service response assigned with Global result and fault handler
		 * </p>
 		 */
		public function set token( value:AsyncToken ):void {
			_token = value; 
			service.executeServiceCall( _token, resultHandler, faultHandler, [ serviceSignal ] );
		} 
		
		/** The resultSignal is dispatched to intimate about the Server process is complete.
		 * So, further View updates can take place. Also, local parent set mappings of persistent object
		 * can be done to map with Backend
		 * <p>
		 * Handler function, globally manage the server responses.
		 * the SignalSequence is invoked onSignalDone(), to proceed with next queued signals.
		 * </p>
 		 */
		private function resultHandler( rpcevt:ResultEvent, prevSignal:AbstractSignal = null ):void {
			var resultObj:Object = rpcevt.result;
			var currentVO:IValueObject;
			
			if( resultObj is ArrayCollection ) {
				if( ArrayCollection( resultObj ).length != 0 ) {
					currentVO = ArrayCollection( resultObj ).getItemAt( 0 ) as IValueObject;	
				}
			}
			else {
				currentVO = resultObj as IValueObject;
			}
			
		//	if( Object( currentVO ).hasOwnProperty( prevSignal.currentCollection.sortString ) || ( !currentVO ) ) {
			var outCollection:ICollection = updateCollection( prevSignal.currentCollection, prevSignal.currentSignal, resultObj );
			if( prevSignal.currentProcessor ) {
				processVO( prevSignal.currentProcessor, outCollection );
			} 
			resultSignal.dispatch( resultObj, prevSignal.currentSignal );
			
			//on push added new product
			if(prevSignal.currentSignal.destination == productDAO.destination){
				//from Sprint Signal
				if(prevSignal.currentSignal.action ==  Action.FINDBY_ID){
					addPushedProduct( resultObj, prevSignal.currentSignal );
				}
				if(prevSignal.currentSignal.action ==  Action.FINDPUSH_ID){
					modifyPushedProduct( resultObj, prevSignal.currentSignal );
				}
			} 
			
			// on push
			if(prevSignal.currentSignal.action == Action.FINDPUSH_ID){ 
				//on sprint push
				if( prevSignal.currentSignal.daoName == Utils.SPRINTDAO ) {		
					updateSprint(prevSignal.currentSignal);
				}
				pushRefreshSignal.dispatch( prevSignal.currentSignal );
			}
			signalSeq.onSignalDone();
		} 
		
		/** <p>
		 * if Processor exists, for every VO the processor will be used to do the server mappings
		 * in client side. The mappings like one-one, one-many, many-one and many-many
		 * </p>
		 */
		private function processVO( process:IVOProcessor, collection:ICollection ):void {
			process.processCollection( collection.items );
		}
		
		/** <p>
		 * modifies the particular VO's Persistent Collection Object with the received server response.
		 * </p>
 		 */
		private function updateCollection( collection:ICollection, currentSignal:SignalVO, resultObj:Object ):ICollection {
			switch( currentSignal.action ) {
				case Action.CREATE:
					collection.addItem( resultObj );
				break;
				case Action.UPDATE:
					collection.updateItem( currentSignal.valueObject, resultObj );
				break;
				case Action.READ: 
				case Action.FINDBY_NAME: 
				case Action.FIND_ID: 
				case Action.FINDBY_ID:  
				case Action.FINDPUSH_ID:
					collection.modifyItems( resultObj as ArrayCollection );
					break;
				case Action.DELETE:
					ArrayCollection( collection.items ).refresh();
					collection.removeItem( currentSignal.valueObject );
				break;
				case Action.GET_COUNT:
					//collection.length = resultObj as int;
				break;
				case Action.GET_LIST:
					collection.updateItems( resultObj as ArrayCollection );
				break;
				case Action.BULK_UPDATE:
					collection.modifyItems( resultObj as ArrayCollection );
				break;
				case Action.DELETE_ALL:
					collection.removeAll();
				break;
				default:
				break;	
			}
			return collection;
		}
		private function updateSprint(signal:SignalVO):void{
			var pushSprint:Sprints = GetVOUtil.getVOObject( signal.description as int, signal.collection.items, sprintDAO.destination, Sprints ) as Sprints;
			//if product is newer to this instance
			if( !productDAO.collection.findItem( pushSprint.productFk ) ) {
				var productSignal:SignalVO = new SignalVO( null, productDAO, Action.FINDBY_ID ); 
				productSignal.id = pushSprint.productFk;
				productSignal.valueObject = pushSprint;
				signalSeq.addSignal( productSignal );
			}  
			if(currentInstance.currentSprint.sprintId == signal.description as int){
				currentInstance.currentSprint = pushSprint;	
				SprintStoryRenderer.currentSprint = currentInstance.currentSprint;
			}				
			//query the product's storycollection once again
			var storySignal:SignalVO = new SignalVO( null, storyDAO, Action.FIND_ID ); 
			storySignal.id = pushSprint.productFk; 
			signalSeq.addSignal( storySignal );	
		}
		
		public function addPushedProduct( obj:Object, signal:SignalVO ):void {
			var addedProduct:Products = ( obj as ArrayCollection ).getItemAt( 0 ) as Products;
			addedProduct = GetVOUtil.getVOObject( addedProduct.productId, productDAO.collection.items, productDAO.destination, Products ) as Products;
			Utils.addArrcStrictItem( addedProduct, addedProduct.domainObject.productSet, productDAO.destination );
			
			// if current product is received with update through push
			if( currentInstance.currentProducts.productId == Sprints( signal.valueObject ).productFk ) {
				currentInstance.currentProducts = addedProduct;
			}
		}
		
		public function modifyPushedProduct( obj:Object, signal:SignalVO ):void {
			var modifiedProduct:Products = ( obj as ArrayCollection ).getItemAt( 0 ) as Products;
			modifiedProduct = GetVOUtil.getVOObject( modifiedProduct.productId, productDAO.collection.items, productDAO.destination, Products ) as Products;
			var oldDomain:Domains = modifiedProduct.domainObject;
			var oldProduct:Products = Utils.findObject(modifiedProduct,modifiedProduct.domainObject.productSet,productDAO.destination) as Products;
			modifiedProduct.sprintCollection = oldProduct.sprintCollection;
			modifiedProduct.storyCollection = oldProduct.storyCollection;
			Utils.addArrcStrictItem(modifiedProduct,modifiedProduct.domainObject.productSet,productDAO.destination,true);
			domainDAO.collection.updateItem(oldDomain, modifiedProduct.domainObject); 
		}
		/** <p>
		 * Global fault handler for server response.
		 * </p>
 		 */
		private function faultHandler( event:FaultEvent ):void {
			trace( serviceSignal.currentSignal.action + ' ' + serviceSignal.currentSignal.destination + ' failed ' + event );
			signalSeq.onSignalDone();
		}
	}
}
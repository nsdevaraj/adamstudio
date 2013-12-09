package com.adobe.cairngorm.model
{
   /**
    * Marker interface used to mark the custom ModelLocator.
    * 
    * <p>IModelLocator is the marker interface used by Cairngorm applications
    * to implement the model in an Model-View-Controller architecture.</p>
    * <p>The model locator in an application is a singleton that the application
    * uses to store the client side model. An example implementation might be:</p>
    * <pre>
    * [Bindable]
    * public class ShopModelLocator implements IModelLocator
    * {
    *    private static var instance : ShopModelLocator;
    * 
    *    public function ShopModelLocator() 
    *    {   
    *       if ( instance != null )
    *       {
    *          throw new CairngormError(
    *             CairngormMessageCodes.SINGLETON_EXCEPTION, "ShopModelLocator" );
    *       }
    *        
    *       instance = this;
    *    }
    *    
    *    public static function getInstance() : ShopModelLocator 
    *    {
    *       if ( instance == null )
    *           instance = new ShopModelLocator();
    *           
    *       return instance;
    *    }
    *  
    *    public var products : ICollectionView;
    * }
    * </pre>
    * 
    * <p>Throughout the rest of the application, the developer can then access
    * the products from the model, as follows:</p>
    * <pre>
    *   var products : ICollectionView = ShopModelLocator.getInstance().products;
    * </pre>
    */
   public interface IModelLocator
   {
   }
}
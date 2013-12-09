package com.adobe.cairngorm.vo
{
   import com.adobe.cairngorm.vo.IValueObject;
   
   /**
    * <p><strong>Deprecated as of Cairngorm 2.1, replaced by com.adobe.cairngorm.vo.IValueObject</strong></p>
    * 
    * The ValueObject interface is a marker interface that improves
    * readability of code by identifying the classes within a Cairngorm
    * application that are to be used as value objects for passing data
    * between tiers of an application.
    * 
    * <p>
    * Currently, this interface does not require the implementation of any
    * methods; the developer is free to extend this interface according to
    * their preferred ValueObject implementation.
    * </p>
    * 
    * @see com.adobe.cairngorm.vo.IValueObject
    */ 
   public interface ValueObject extends IValueObject
   {
   }
}
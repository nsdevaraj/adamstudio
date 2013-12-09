package com
{

import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.ui.Keyboard;

import mx.controls.Button;
import mx.core.FlexVersion;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.core.UIComponentGlobals;
import mx.core.mx_internal;
import mx.effects.Tween;
import mx.events.DropdownEvent;
import mx.events.FlexMouseEvent;
import mx.managers.IFocusManagerComponent;
import mx.managers.PopUpManager;
import mx.styles.ISimpleStyleClient;

use namespace mx_internal;

//--------------------------------------
//  Events
//-------------------------------------- 

/**
 *  Dispatched when the specified UIComponent closes. 
 *
 *  @eventType mx.events.DropdownEvent.CLOSE
 */
[Event(name="close", type="mx.events.DropdownEvent")]

/**
 *  Dispatched when the specified UIComponent opens.
 *
 *  @eventType mx.events.DropdownEvent.OPEN
 */
[Event(name="open", type="mx.events.DropdownEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Length of a close transition, in milliseconds.
 *  The default value is 250.
 */
[Style(name="closeDuration", type="Number", format="Time", inherit="no")]

/**
 *  Easing function to control component closing tween.
 */
[Style(name="closeEasingFunction", type="Function", inherit="no")]

/**
 *  The default icon class for the main button.
 *
 *  @default null
 */
[Style(name="icon", type="Class", inherit="no", states="up, over, down, disabled")]

/**
 *  Length of an open transition, in milliseconds.
 *  The default value is 250.
 */
[Style(name="openDuration", type="Number", format="Time", inherit="no")]

/**
 *  Easing function to control component opening tween.
 */
[Style(name="openEasingFunction", type="Function", inherit="no")]

/**
 *  The name of a CSS style declaration used by the control.  
 *  This style allows you to control the appearance of the 
 *  UIComponent object popped up by this control. 
 *
 *  @default undefined
 */
[Style(name="popUpStyleName", type="String", inherit="no")]

/**
 *  Number of vertical pixels between the PopUpButton and the
 *  specified popup UIComponent.
 *  The default value is 0.
 */
[Style(name="popUpGap", type="Number", format="Length", inherit="no")]


public class PopUpButtonPositioned extends Button 
{

    /**
     *  Constructor.
     */
    public function PopUpButtonPositioned()
    {
        super();
                        
        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    public static const POPUP_POSITION_BOTTOM:String = "bottom";
    public static const POPUP_POSITION_TOP:String = "top";
    public static const POPUP_POSITION_LEFT:String = "left";
    public static const POPUP_POSITION_RIGHT:String = "right";

    /**
     *  @private
     */
    private var inTween:Boolean = false;

    /**
     *  @private
     *  Is the popUp list currently shown?
     */
    private var showingPopUp:Boolean = false;

    /**
     *  @private
     *  The tween used for showing/hiding the popUp.
     */
    private var tween:Tween = null;
    
    /**
     *  @private
     */
    private var popUpChanged:Boolean = false;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  showInAutomationHierarchy
    //----------------------------------

    /**
     *  @private
     */
    override public function set showInAutomationHierarchy(value:Boolean):void
    {
        //do not allow value changes
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
	private var _popUpPosition:String = POPUP_POSITION_BOTTOM;
	
	[Bindable]
	[Inspectable(category="General", defaultValue="bottom",  type="String", enumeration="bottom,top,left,right")]
	public function get popUpPosition():String{
		return _popUpPosition;
	}
	
	public function set popUpPosition(value:String):void{
		if(_popUpPosition == value)
			return;
		
		_popUpPosition = value;
		
	}
    
    //----------------------------------
    //  popUp
    //----------------------------------
    
    /**
     *  @private
     *  Storage for popUp property.
     */    
    private var _popUp:IUIComponent = null;
    
    [Bindable(event='popUpChanged')]
    [Inspectable(category="General", defaultValue="null")]
    
    /**
     *  Specifies the UIComponent object, or object defined by a subclass 
     *  of UIComponent, to pop up. 
     *  For example, you can specify a Menu, TileList, or Tree control. 
     *
     *  @default null 
     */    
    public function get popUp():IUIComponent
    {
        return _popUp;
    }
    
    /**
     *  @private
     */  
    public function set popUp(value:IUIComponent):void
    {
        _popUp = value;
        popUpChanged = true;

        invalidateProperties();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */    
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (popUpChanged)
        {
            PopUpManager.addPopUp(_popUp, this, false);
            PopUpManager.bringToFront(_popUp);
            
            if (_popUp is IFocusManagerComponent)
                IFocusManagerComponent(_popUp).focusEnabled = false;
                
            _popUp.cacheAsBitmap = true;
            _popUp.scrollRect = new Rectangle();        
            
            _popUp.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE,
                                    popMouseDownOutsideHandler);
            
            _popUp.addEventListener(FlexMouseEvent.MOUSE_WHEEL_OUTSIDE,
                                    popMouseDownOutsideHandler);
                
            _popUp.owner = this;
            
            if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0 && _popUp is ISimpleStyleClient)
                ISimpleStyleClient(_popUp).styleName = getStyle("popUpStyleName");
            
            popUpChanged = false;
        }
    }

    
    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        // PopUpIcon style prop has changed, dump skins
        if (styleProp == null ||
            styleProp == "styleName")
        {
            changeSkins();
        }
        if (styleProp == "popUpStyleName" && _popUp 
                && FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0
                && _popUp is ISimpleStyleClient)
            ISimpleStyleClient(_popUp).styleName = getStyle("popUpStyleName");
            
        super.styleChanged(styleProp);
    }
    

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    
    /**
     *  Opens the UIComponent object specified by the <code>popUp</code> property.
     */  
    public function open():void
    {
        openWithEvent(null);
    }
    
    /**
     *  @private
     */
    private function openWithEvent(trigger:Event = null):void
    {
        if (!showingPopUp && enabled && !inTween)
        {
            displayPopUp(true);

            var cbde:DropdownEvent = new DropdownEvent(DropdownEvent.OPEN);
            cbde.triggerEvent = trigger;
            dispatchEvent(cbde);
        }
    }
    
    /**
     *  Closes the UIComponent object opened by the PopUpButton control.
     */  
    public function close():void
    {
        closeWithEvent(null);
    }

    /**
     *  @private
     */
    private function closeWithEvent(trigger:Event = null):void
    {
        if (showingPopUp && enabled && !inTween)
        {
            displayPopUp(false);

            var cbde:DropdownEvent = new DropdownEvent(DropdownEvent.CLOSE);
            cbde.triggerEvent = trigger;
            dispatchEvent(cbde);
        }
    }

    /**
     *  @private
     */
    private function displayPopUp(show:Boolean):void
    {
        if (!initialized || !_popUp || (show == showingPopUp))
            return;
        
        var popUpGap:Number = getStyle("popUpGap");
        if(isNaN(popUpGap))
        	popUpGap = 0;
        
        /* var shadowDistance:Number = (_popUp as Container).getStyle("shadowDistance");
        if(isNaN(shadowDistance))
        	shadowDistance = 0; */
        	
        // bounds of this button.
        var bounds:Rectangle = this.getBounds(stage);
        
        // x & y of the popup.
        var point:Point;
        
        var initTween:Number;
        var endTween:Number;
        var easingFunction:Function;
        var duration:Number;
        
        // calculate the x & y of the popup according to the button's bounds.
        if(_popUpPosition == POPUP_POSITION_BOTTOM){
        	point = new Point(bounds.x, bounds.y + bounds.height + popUpGap);
        }
        else if(_popUpPosition == POPUP_POSITION_TOP){
        	point = new Point(bounds.x, bounds.y - _popUp.height - popUpGap);
        }
        else if(_popUpPosition == POPUP_POSITION_LEFT){
        	point = new Point(bounds.x - _popUp.width - popUpGap, bounds.y);
        }
        else if(_popUpPosition == POPUP_POSITION_RIGHT){
        	point = new Point(bounds.x + bounds.width + popUpGap, bounds.y);
        }
          
        if (show)// show
        {
			if(_popUpPosition == POPUP_POSITION_BOTTOM || _popUpPosition == POPUP_POSITION_TOP){
	            initTween = -_popUp.height;
	            if (point.y + _popUp.height > screen.height)
	            { 
	                // PopUp will go below the bottom of the stage
	                // and be clipped. Instead, have it grow up.
	                point = new Point(bounds.x, bounds.y - _popUp.height - popUpGap);
	            }
	            else if(point.y < 0)
	            {
	                // PopUp will go above the top of the stage
	                // and be clipped. Instead, have it grow down.
	            	point = new Point(bounds.x, bounds.y + bounds.height + popUpGap);
	            }
	            else
	            {
	            	initTween = _popUp.height;
	            }
	
	            point.x = Math.min( point.x, screen.width - _popUp.getExplicitOrMeasuredWidth() - 2);
	            point.x = Math.max( point.x, 2);
            }
            else if(_popUpPosition == POPUP_POSITION_LEFT || _popUpPosition == POPUP_POSITION_RIGHT){
            	initTween = -_popUp.width;
            	if (point.x + _popUp.width > screen.width)
	            { 
	                // PopUp will go out of the right of the stage
	                // and be clipped. Instead, have it grow left.
	                point = new Point(bounds.x - _popUp.width - popUpGap, bounds.y);
	            }
	            else if(point.x < 0)
	            {
	            	// PopUp will go out of the left of the stage
	                // and be clipped. Instead, have it grow right.
	            	point = new Point(bounds.x + bounds.width + popUpGap, bounds.y);
	            }
	            else
	            {
	            	initTween = _popUp.width;
	            }
	            
	            point.y = Math.min( point.y, screen.height - _popUp.getExplicitOrMeasuredHeight() - 2);
	            point.y = Math.max( point.y, 2);
            }
            
            if (_popUp.x != point.x || _popUp.y != point.y)
                _popUp.move(point.x, point.y);

            _popUp.scrollRect = new Rectangle();
            
            if (!_popUp.visible)
                _popUp.visible = true;
            
            endTween = 0;
            duration = getStyle("openDuration");
            easingFunction = getStyle("openEasingFunction") as Function;
        }
        else// hide
        {
            if(_popUpPosition == POPUP_POSITION_BOTTOM || _popUpPosition == POPUP_POSITION_TOP){
	            if (point.y + _popUp.height > screen.height || point.y < 0)
	            	endTween = -_popUp.height;
	            else
	            	endTween = _popUp.height;
            }
            else if(_popUpPosition == POPUP_POSITION_LEFT || _popUpPosition == POPUP_POSITION_RIGHT){
	            if (point.x + _popUp.width > screen.width || point.x < 0)
	            	endTween = -_popUp.width;
	            else
	            	endTween = _popUp.width;
            }
            
            initTween = 0;
	        duration = getStyle("closeDuration");
	        easingFunction = getStyle("closeEasingFunction") as Function;
        }
        
        showingPopUp = show;
        inTween = true;
        UIComponentGlobals.layoutManager.validateNow();
        
        // Block all layout, responses from web service, and other background
        // processing until the tween finishes executing.
        UIComponent.suspendBackgroundProcessing();
        
        if(_popUpPosition == POPUP_POSITION_BOTTOM || _popUpPosition == POPUP_POSITION_RIGHT){
        	tween = new Tween(this, initTween, endTween, duration, -1, onTweenUpdate ,onTweenEnd);
        }
        else if(_popUpPosition == POPUP_POSITION_TOP || _popUpPosition == POPUP_POSITION_LEFT){
        	tween = new Tween(this, -initTween, -endTween, duration, -1, onTweenUpdate ,onTweenEnd);
        }
        
        if (easingFunction != null)
            tween.easingFunction = easingFunction;
    }
    

    private function onTweenUpdate(value:Number):void
    {
        var rectWidth:Number = _popUp.width;
        var rectHeight:Number = _popUp.height;
        
        /* var popUpPixelBounds:Rectangle = _popUp.transform.pixelBounds;
        if(popUpPixelBounds.width > rectWidth)
        	rectWidth = popUpPixelBounds.width + (popUpPixelBounds.width - _popUp.width);
        if(popUpPixelBounds.height > rectHeight)
        	rectHeight = popUpPixelBounds.height; */
        
        if(_popUpPosition == POPUP_POSITION_BOTTOM || _popUpPosition == POPUP_POSITION_TOP){
        	_popUp.scrollRect = new Rectangle(0, value, rectWidth, rectHeight);
        }
        else if(_popUpPosition == POPUP_POSITION_LEFT || _popUpPosition == POPUP_POSITION_RIGHT){
        	_popUp.scrollRect = new Rectangle(value, 0, rectWidth, rectHeight);
        }
    }

    private function onTweenEnd(value:Number):void
    {
        var rectWidth:Number = _popUp.width;
        var rectHeight:Number = _popUp.height;
        
		/* var popUpPixelBounds:Rectangle = _popUp.transform.pixelBounds;
        if(popUpPixelBounds.width > rectWidth)
        	rectWidth = popUpPixelBounds.width;
        if(popUpPixelBounds.height > rectHeight)
        	rectHeight = popUpPixelBounds.height; */
        
         if(_popUpPosition == POPUP_POSITION_BOTTOM || _popUpPosition == POPUP_POSITION_TOP){
	        _popUp.scrollRect = new Rectangle(0, value, rectWidth, rectHeight);
         }
		 else if(_popUpPosition == POPUP_POSITION_LEFT || _popUpPosition == POPUP_POSITION_RIGHT){
	        _popUp.scrollRect = new Rectangle(value, 0, rectWidth, rectHeight);
		 }
		 
        inTween = false;
        UIComponent.resumeBackgroundProcessing();

        if (!showingPopUp)
        {
            _popUp.visible = false;
            _popUp.scrollRect = null;
        }
    }
        
    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function keyDownHandler(event:KeyboardEvent):void
    {
        super.keyDownHandler(event);
        
        if (event.ctrlKey && event.keyCode == Keyboard.DOWN)
        {
            openWithEvent(event);
            event.stopPropagation();
        }
        else if ((event.ctrlKey && event.keyCode == Keyboard.UP) ||
                 (event.keyCode == Keyboard.ESCAPE))
        {
            closeWithEvent(event);
            event.stopPropagation();
        }
        else if (event.keyCode == Keyboard.ENTER && showingPopUp)
        {
            // Redispatch the event to the popup
            // and let its keyDownHandler() handle it.
            _popUp.dispatchEvent(event);
            closeWithEvent(event);                      
            event.stopPropagation();
        }       
        else if (showingPopUp &&
                 (event.keyCode == Keyboard.UP ||
                  event.keyCode == Keyboard.DOWN ||
                  event.keyCode == Keyboard.LEFT ||
                  event.keyCode == Keyboard.RIGHT ||
                  event.keyCode == Keyboard.PAGE_UP ||
                  event.keyCode == Keyboard.PAGE_DOWN))
        {
            // Redispatch the event to the popup
            // and let its keyDownHandler() handle it.
            _popUp.dispatchEvent(event);
            event.stopPropagation();
        }
    }

    /**
     *  @private
     */
    override protected function focusOutHandler(event:FocusEvent):void
    {
        // If the dropdown is open...
        if (showingPopUp && _popUp)
        {
            // If focus is moving outside the popUp...
            if (!event.relatedObject)
            {
                close();
            }
            else if (_popUp is DisplayObjectContainer && !DisplayObjectContainer(_popUp).contains(event.relatedObject))
            {
                close();
            }
        }

        super.focusOutHandler(event);
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers: Button
    //
    //--------------------------------------------------------------------------

    

     override protected function rollOverHandler(event:MouseEvent):void{
		super.rollOverHandler(event);
		if(inTween)
			return;
			
		openWithEvent(event);       
    } 
    /* override protected function clickHandler(event:MouseEvent):void{
		super.rollOverHandler(event);
		if(inTween)
			return;
			
		openWithEvent(event);       
    } */

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    
    /**
     *  @private
     */    
    private function popMouseDownOutsideHandler(event:MouseEvent):void
    {
        var p:Point = event.target.localToGlobal(new Point(event.localX, event.localY));
        if (hitTestPoint(p.x, p.y, true))
        {
            // do nothing
        }
        else
        {
        	close();
        }
    }    
    
    /**
     *  @private
     */
    private function removedFromStageHandler(event:Event):void
    {
        // Ensure we've unregistered ourselves from PopupManager, else
        // we'll be leaked.
        if (_popUp) {
            PopUpManager.removePopUp(_popUp);
            _popUp = null;
        }
    }

}//class

}//package

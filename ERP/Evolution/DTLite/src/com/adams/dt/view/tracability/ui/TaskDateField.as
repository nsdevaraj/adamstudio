/**       
*          Tool                       : DateChooser with the Filled Colors    
*          Class                      : Custom DateField with editable options         
*          Developed by          : P.Chandra Deepan
*          Developed for         : Adam's Studio India Pvt., Ltd., Chennai.
*          email id                 : chandradeepan@gmail.com 
*          Last Modified Date : 23/03/2009
*/
package com.adams.dt.view.tracability.ui
{
	import com.adams.dt.event.tracability.DateSelectEvent;
	import com.adams.dt.event.tracability.DrawingEvent;
	import com.adams.dt.event.tracability.PeriodChangeEvent;
	import com.adams.dt.model.ModelLocator;
	
	import flash.events.*;
	import flash.text.TextField;
	
	import mx.controls.DateField;
	import mx.controls.Label;
	import mx.controls.TextInput;
	import mx.core.IUITextField;
	import mx.core.UITextField;
	import mx.core.mx_internal;
	import mx.events.DropdownEvent;
	import mx.events.FlexEvent;
	import mx.formatters.DateFormatter;
	[Event(name = "periodChanged" , type = "com.adams.dt.event.tracability.PeriodChangeEvent")]
	[Event(name = "selectedDateSet" , type = "com.adams.dt.event.tracability.DrawingEvent")]
	[Event(name = "dateSelected" , type = "com.adams.dt.event.tracability.DateSelectEvent")]
	public final class TaskDateField extends DateField
	{
		use namespace mx_internal;
		private static const millisecondsPerDay : int = 1000 * 60 * 60 * 24;
		private var myDate : Date;
		private var dateFiller : Boolean = false;
		private var _focusOutValue : Date;
		private var _dateFormatter : DateFormatter = new DateFormatter();
		[Bindable]
		public var onChangeText : String;
		[Bindable]
		private var model:ModelLocator = ModelLocator.getInstance();
		private var _differencePeriod : Number;
		private var _selectValue : Boolean;
		private var _tempFlexEvent : FlexEvent;
		private var _textField : TextField = new TextField();
		public var daysLabel:Label;
		
		
		/**
		* Difference Period between the adjacent DateFields. 
		**/
		public function get differencePeriod() : Number
		{
			return _differencePeriod;
		}

		public function set differencePeriod( value : Number ) : void
		{
			_differencePeriod = value;
		}

		/**
		* Constructor Function. 
		**/
		public function TaskDateField()
		{
			super();
			_dateFormatter.formatString = "DD/MM/YYYY";
			this.monthNames = model.monthNames;
			addEventListener(DropdownEvent.CLOSE , onClose , false , 0 , true);
			addEventListener(MouseEvent.MOUSE_DOWN , onMouseDown , false , 0 , true);
		}

		/**
		* Function which sets the Date value in the TextInput on the creation complete Event. 
		**/
		public function onCreationComplete( ) : void
		{
			onChangeText = _dateFormatter.format( selectedDate.toDateString() );
			textInput.text = onChangeText;
			_textField = textFieldFinding( textInput as TextInput );
			textInput.maxChars = 2;
		}

		/**
		* Overriding the set method of selected date property so that the TextInput value
		* does not change unless until the dateField component looses its focus. 
		**/
		override public function set selectedDate( value : Date ) : void
		{
			super.selectedDate = value;
			dateFiller = true;
		}

		override public function set enabled(value : Boolean) : void
		{
			super.enabled = value;
			if( !value )
			{
				if( hasEventListener( MouseEvent.MOUSE_DOWN ) )
				{
					removeEventListener( MouseEvent.MOUSE_DOWN , onMouseDown , false );
				}
				this.styleName = "textAreaReader";
			}
		}

		/**
		* Commit properties override to avoid TextInput Value change on every selected date change.
		**/
		override protected function commitProperties() : void
		{
			super.commitProperties();
			textInput.restrict = '0-9';
			if( dateFiller )
			{
				dateFiller = false;
				if( daysLabel ) {
					if( onChangeText != String( differencePeriod ) )	daysLabel.visible = false;
				}	
				textInput.text = onChangeText;
			}

			if( _selectValue )
			{
				textInput.text = String( differencePeriod );
				_selectValue = false
			}
		}

		override protected function updateDisplayList(unscaledWidth : Number , unscaledHeight : Number) : void
		{
			super.updateDisplayList(unscaledWidth , unscaledHeight);
		}

		/**
		* Overriding the change event listener of the TextInput in order to draw the 
		* sprite according to the days increment.
		**/
		override protected function textInput_changeHandler(event : Event) : void
		{
			if( textInput.text.charAt(0) != '')
			{
				onChangeText = textInput.text;
				if( textInput.text.indexOf(" ") != - 1 ) {
					differencePeriod = Number( textInput.text.slice( 0 , textInput.text.indexOf(" ") ) );
				}	
				else
					differencePeriod = Number( textInput.text );
				if( !isNaN( differencePeriod ) )	
					dispatchEvent( new PeriodChangeEvent( PeriodChangeEvent.PERIOD_CHANGE ) );
			}
		}
		
		/**
		* Overriding the FocusIn handler so that the users will be allowed to type the no "Days"
		* string by using tab key in the keyboard.
		**/
		override protected function focusInHandler( event:FocusEvent ):void {
			relativeOperation();
		}
		
		/**
		* Overriding the focus out handler to set the TextInput to its selected date value
		* and make its editable property to false.
		**/
		override protected function focusOutHandler( event : FocusEvent ) : void
		{
			editable = false;
			if( daysLabel )	daysLabel.visible = false;
			if( selectedDate )
			{
				text = _dateFormatter.format( selectedDate );
			}else
			{
				text = _dateFormatter.format( _focusOutValue );
				selectedDate = _focusOutValue;
			}
			onChangeText = text;
		}
		
		override protected function keyDownHandler( event:KeyboardEvent ):void {
			
		}
		
		/**
		* Overriding close method which is called when the user selects the date through the dateChooser.
		**/		
		override public function close() : void
		{
			super.close();
		}

		/**
		* Function which sets the dateChooser's visble property to false on every
		* click on the TextInput control. 
		**/
		private function onLaterCall() : void
		{
			super.dropdown.visible = false;
		}

		/**
		* Close event handler in turn dispatches the data selected event to update the sprite and the 
		* focus out handler.
		**/
		private function onClose( event : DropdownEvent ) : void
		{
			dispatchEvent( new FocusEvent( FocusEvent.FOCUS_OUT ) );
			dispatchEvent( new DateSelectEvent( DateSelectEvent.DATE_SELECTED ) );
		}

		/**
		* Mouse down handler to identify wheather the mouse down happens in TextInput(if so make it as editable)
		* or in the DateChooser.
		**/ 
		private function onMouseDown( event : MouseEvent ) : void
		{
			if( event.target is UITextField )
			{
				callLater( onLaterCall );
			}
			relativeOperation();
		}
		
		/**
		* Mouse down handler to identify wheather the mouse down happens in TextInput(if so make it as editable)
		* or in the DateChooser.
		**/
		private function relativeOperation():void {
			editable = true;
			_selectValue = true;
			textInput.text = String( differencePeriod );
			if( selectedDate )
			{
				_focusOutValue = selectedDate;
			}
			if( !textInput.focusEnabled ) {
				textInput.setFocus();
			}
			if( daysLabel )	daysLabel.visible = true;
		}
		
		/**
		* Function which gets the TextField component of the TextInput to avoid the delete functionalities
		* called during the creation complete event.
		**/
		private function textFieldFinding( container : mx.controls.TextInput ) : UITextField
		{
			var tf : UITextField;
			var container_Len:int=container.numChildren - 1;
			for(var i : int = 0;i <= container_Len;i++)
			{
				var temptf : *= container.getChildAt(i);
				if(temptf is IUITextField)
					tf = UITextField(temptf);
			}

			return tf;
		}
	}
}

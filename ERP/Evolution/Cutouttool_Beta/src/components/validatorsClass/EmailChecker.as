package components.validatorsClass
{
	import mx.validators.EmailValidator;

	/**
	* The FileExtensionValidator class validates a file's extension
	* against an array of valid extensions. 
	*  
	* @see mx.validators.Validator
	*/
	public class EmailChecker extends EmailValidator
	{
		/**
		* Indicates the error code. 
		*/ 
		private const ERROR_BAD_SYNTAX:String = "BadName"; 
		
		/**
		* Array stores the return value of doValidation(). 
		*/
		private var _results:Array;
			
		/**
		* Class constructor.
		*/ 
		public function EmailChecker()
		{
			// Call the base class' constructor.
			super();
		}

		private var _errorMessage:String;

		/**
		* Provides a custom error message.
		*/ 
		public function get errorMessage():String {
			return _errorMessage;
		}

		/** 
		* @private
		*/ 
		public function set errorMessage(value:String):void {
			_errorMessage = value;
		}
		
		/**
		* Overrides the superclass' doValidation() method and defines 
		* a custom implementation.
		*
		 * @param value Object to validate.
		 * @return Array containing a ValidationResult object for each error.
		*/ 
		override protected function doValidation(value:Object):Array {
				_results = super.doValidation(value);
				return _results;
		}
	}
}

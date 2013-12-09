package com.adams.dam.model
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;
 
	
	public class EncryptUtil
	{
		private var type:String = 'simple-aes-ecb';
        private var key:ByteArray;
                
		public function EncryptUtil()
		{
			init();
		}
		
		private function init():void {
                key = Hex.toArray( Hex.fromString( 'SRETBT23234SDFTR' ) );
        }
 
        public function encrypt( txt:String = '' ):String {
            var data:ByteArray = Hex.toArray( Hex.fromString( txt ) );
            var mode:ICipher = Crypto.getCipher( type, key, null );
            mode.encrypt( data );
            return Base64.encodeByteArray( data );
        }
		
        public function decrypt( txt:String = '' ):String {
            var data:ByteArray = Base64.decodeToByteArray( txt );
            var pad:IPad = new PKCS5;
            var mode:ICipher = Crypto.getCipher( type, key, pad );
            pad.setBlockSize( mode.getBlockSize() );
            mode.decrypt( data );
            return Hex.toString( Hex.fromArray( data ) );
        }
	}
}
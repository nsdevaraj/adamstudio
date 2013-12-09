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
package com.adams.swizdao.util
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
		private static var type:String='simple-aes-ecb';
		private static var key:ByteArray = Hex.toArray(Hex.fromString('SRETBT23234SDFTR'));
		public static function encrypt(txt:String = ''):String
		{
			var data:ByteArray = Hex.toArray(Hex.fromString(txt));
			var mode:ICipher = Crypto.getCipher(type, key, null);
			mode.encrypt(data);
			return Base64.encodeByteArray(data);
		}
		public static function decrypt(txt:String = ''):String
		{
			var data:ByteArray = Base64.decodeToByteArray(txt);
			var pad:IPad = new PKCS5;
			var mode:ICipher = Crypto.getCipher(type, key, pad);
			pad.setBlockSize(mode.getBlockSize());
			mode.decrypt(data);
			return Hex.toString(Hex.fromArray(data));
		}
	}
}
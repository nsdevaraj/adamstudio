package com.adams.dt.business.util{
	public class MD53 {
		public var str:String;
		public var hex_chr:String; // private key
		public var output:String;
		/*Take a string and return the hex representation of its MD5.*/
		public function MD53(str:String, sysId:String):void {
			hex_chr = sysId+"ZXCVBNM,.ASDFGHJKL;'QWERTYUIOP[]"
			var xx:Array = str2blks_MD5(str);
			var a:int = 1732584193;
			var b:int = -271733879;
			var c:int = -1732584194;
			var d:int = 271733878;

			for (var i:int=0; i<xx.length; i += 16) {
				var olda:int = a;
				var oldb:int = b;
				var oldc:int = c;
				var oldd:int = d;

				a = ff(a, b, c, d, xx[i+0], 7, -680876936);
				d = ff(d, a, b, c, xx[i+1], 12, -389564586);
				c = ff(c, d, a, b, xx[i+2], 17, 606105819);
				b = ff(b, c, d, a, xx[i+3], 22, -1044525330);
				a = ff(a, b, c, d, xx[i+4], 7, -176418897);
				d = ff(d, a, b, c, xx[i+5], 12, 1200080426);
				c = ff(c, d, a, b, xx[i+6], 17, -1473231341);
				b = ff(b, c, d, a, xx[i+7], 22, -45705983);
				a = ff(a, b, c, d, xx[i+8], 7, 1770035416);
				d = ff(d, a, b, c, xx[i+9], 12, -1958414417);
				c = ff(c, d, a, b, xx[i+10], 17, -42063);
				b = ff(b, c, d, a, xx[i+11], 22, -1990404162);
				a = ff(a, b, c, d, xx[i+12], 7, 1804603682);
				d = ff(d, a, b, c, xx[i+13], 12, -40341101);
				c = ff(c, d, a, b, xx[i+14], 17, -1502002290);
				b = ff(b, c, d, a, xx[i+15], 22, 1236535329);

				a = gg(a, b, c, d, xx[i+1], 5, -165796510);
				d = gg(d, a, b, c, xx[i+6], 9, -1069501632);
				c = gg(c, d, a, b, xx[i+11], 14, 643717713);
				b = gg(b, c, d, a, xx[i+0], 20, -373897302);
				a = gg(a, b, c, d, xx[i+5], 5, -701558691);
				d = gg(d, a, b, c, xx[i+10], 9, 38016083);
				c = gg(c, d, a, b, xx[i+15], 14, -660478335);
				b = gg(b, c, d, a, xx[i+4], 20, -405537848);
				a = gg(a, b, c, d, xx[i+9], 5, 568446438);
				d = gg(d, a, b, c, xx[i+14], 9, -1019803690);
				c = gg(c, d, a, b, xx[i+3], 14, -187363961);
				b = gg(b, c, d, a, xx[i+8], 20, 1163531501);
				a = gg(a, b, c, d, xx[i+13], 5, -1444681467);
				d = gg(d, a, b, c, xx[i+2], 9, -51403784);
				c = gg(c, d, a, b, xx[i+7], 14, 1735328473);
				b = gg(b, c, d, a, xx[i+12], 20, -1926607734);

				a = hh(a, b, c, d, xx[i+5], 4, -378558);
				d = hh(d, a, b, c, xx[i+8], 11, -2022574463);
				c = hh(c, d, a, b, xx[i+11], 16, 1839030562);
				b = hh(b, c, d, a, xx[i+14], 23, -35309556);
				a = hh(a, b, c, d, xx[i+1], 4, -1530992060);
				d = hh(d, a, b, c, xx[i+4], 11, 1272893353);
				c = hh(c, d, a, b, xx[i+7], 16, -155497632);
				b = hh(b, c, d, a, xx[i+10], 23, -1094730640);
				a = hh(a, b, c, d, xx[i+13], 4, 681279174);
				d = hh(d, a, b, c, xx[i+0], 11, -358537222);
				c = hh(c, d, a, b, xx[i+3], 16, -722521979);
				b = hh(b, c, d, a, xx[i+6], 23, 76029189);
				a = hh(a, b, c, d, xx[i+9], 4, -640364487);
				d = hh(d, a, b, c, xx[i+12], 11, -421815835);
				c = hh(c, d, a, b, xx[i+15], 16, 530742520);
				b = hh(b, c, d, a, xx[i+2], 23, -995338651);

				a = ii(a, b, c, d, xx[i+0], 6, -198630844);
				d = ii(d, a, b, c, xx[i+7], 10, 1126891415);
				c = ii(c, d, a, b, xx[i+14], 15, -1416354905);
				b = ii(b, c, d, a, xx[i+5], 21, -57434055);
				a = ii(a, b, c, d, xx[i+12], 6, 1700485571);
				d = ii(d, a, b, c, xx[i+3], 10, -1894986606);
				c = ii(c, d, a, b, xx[i+10], 15, -1051523);
				b = ii(b, c, d, a, xx[i+1], 21, -2054922799);
				a = ii(a, b, c, d, xx[i+8], 6, 1873313359);
				d = ii(d, a, b, c, xx[i+15], 10, -30611744);
				c = ii(c, d, a, b, xx[i+6], 15, -1560198380);
				b = ii(b, c, d, a, xx[i+13], 21, 1309151649);
				a = ii(a, b, c, d, xx[i+4], 6, -145523070);
				d = ii(d, a, b, c, xx[i+11], 10, -1120210379);
				c = ii(c, d, a, b, xx[i+2], 15, 718787259);
				b = ii(b, c, d, a, xx[i+9], 21, -343485551);

				a = addme(a, olda);
				b = addme(b, oldb);
				c = addme(c, oldc);
				d = addme(d, oldd);
			}
			output = rhex(a) + rhex(b) + rhex(c) + rhex(d);
		}
		/* Convert a 32-bit number to a hex string with ls-byte first */
		private function rhex(num:int):String {
			var str:String = "";
			for (var j:int=0; j<=3; j++) {
				var tempAnd1:int = bitAND((num >> (j*8+4)), 0x0F);
				var tempAnd2:int = bitAND((num >> (j*8)), 0x0F);
				str += hex_chr.charAt(tempAnd1)+hex_chr.charAt(tempAnd2);
			}
			return str;
		}

		/*Convert a string to a sequence of 16-word blocks, stored as an array.
		 * Append padding bits and the length, as described in the MD5 standard.*/
		private function str2blks_MD5(str:String):Array {
			var nblk:int = ((str.length+8) >> 6)+1;
			var blks:Array = new Array(nblk*16);
			for (var ii:int=0; ii<nblk*16; ii++) {
				blks[ii] = 0;
			}
			for (var i:int=0; i<str.length; i++) {
				blks[i >> 2] |= str.charCodeAt(i) << ((i%4)*8);
				blks[i >> 2] |= 0x80 << ((i%4)*8);
				blks[nblk*16-2] = str.length*8;
			}
			return blks;
		}
		/*Add integers, wrapping at 2^32. This uses 16-bit operations internally 
		 * to work around bugs in some JS interpreters.*/
		private function addme(x:int, y:int):int {
			var tempAnd3:int = bitAND(x, 0xFFFF);
			var tempAnd4:int = bitAND(y, 0xFFFF);
			var lsw:int = tempAnd3+tempAnd4;
			var msw:int = (x >> 16)+(y >> 16)+(lsw >> 16);
			var tempAnd9:int = bitAND(lsw, 0xFFFF);
			return msw << 16 | tempAnd9;
		}
		/*Bitwise rotate a 32-bit number to the left */
		private function rol(num:int, cnt:int):int {
			return num << cnt | num >>> 32 - cnt;
		}
		/*These functions implement the basic operation for each round of the algorithm.*/
		private function cmn(q:int,a:int, b:int,x:int,s:int, t:int):int {
			return addme(rol(addme(addme(a,q),addme(x,t)),s),b);
		}
		private function ff(a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
			var tempAnd5:int = bitAND(b, c);
			var tempAnd6:int = bitAND(~b, d);
			return cmn(tempAnd5 | tempAnd6,a,b,x,s,t);
		}
		private function gg(a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
			var tempAnd7:int = bitAND(b, d);
			var tempAnd8:int = bitAND(c, ~d);
			return cmn(tempAnd7 | tempAnd8,a,b,x,s,t);
		}
		private function hh(a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
			return cmn(b ^ c ^ d,a,b,x,s,t);
		}
		private function ii(a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
			return cmn(c ^ b | ~ d,a,b,x,s,t);
		}
		/*BitAND operator*/
		private function bitAND(a:int, b:int):int {
			if (a<0 && b<0) {
				var lsb:int = (a & 0x1) & (b & 0x1);
				var msb31:int = (a >>> 1) & (b >>> 1);
				return msb31 << 1 | lsb;
			} else {
				return (a & b);
			}
		}
	}
}
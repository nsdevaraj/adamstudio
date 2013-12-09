﻿package com.alivepdf.fonts
{	
	/**
	 * This class serves as a font metrics dictionary. ALl font metrics resides here.
	 * @author Thibault Imbert
	 * 
	 */	
	public final class FontMetrics 
	{
		private static var lookupTables:Array = new Array();
		private static var lookupFontName:String;
		
		public static const DEFAULT_WIDTH:uint = 580;
		
		private static var HelveticaBold:Object = {' ':278,'!':333,'"':474,'#':556,'$':556,'%':889,'&':722,'\'':238,'(':333,')':333,'*':389,'+':584,
		',':278,'-':333,'.':278,'/':278,'0':556,'1':556,'2':556,'3':556,'4':556,'5':556,'6':556,'7':556,'8':556,'9':556,':':333,';':333,'<':584,'=':584,'>':584,'?':611,'@':975,'A':722,
		'B':722,'C':722,'D':722,'E':667,'F':611,'G':778,'H':722,'I':278,'J':556,'K':722,'L':611,'M':833,'N':722,'O':778,'P':667,'Q':778,'R':722,'S':667,'T':611,'U':722,'V':667,'W':944,
		'X':667,'Y':667,'Z':611,'[':333,'\\':278,']':333,'^':584,'_':556,'`':333,'a':556,'b':611,'c':556,'d':611,'e':556,'f':333,'g':611,'h':611,'i':278,'j':278,'k':556,'l':278,'m':889,
		'n':611,'o':611,'p':611,'q':611,'r':389,'s':556,'t':333,'u':611,'v':556,'w':778,'x':556,'y':556,'z':500,'{':389,'|':280,'}':389,'~':584 };
		
		private static var Helvetica:Object = {' ':278,'!':278,'"':355,'#':556,'$':556,'%':889,'&':667,'\'':191,'(':333,')':333,'*':389,'+':584,
		',':278,'-':333,'.':278,'/':278,'0':556,'1':556,'2':556,'3':556,'4':556,'5':556,'6':556,'7':556,'8':556,'9':556,':':278,';':278,'<':584,'=':584,'>':584,'?':556,'@':1015,'A':667,
		'B':667,'C':722,'D':722,'E':667,'F':611,'G':778,'H':722,'I':278,'J':500,'K':667,'L':556,'M':833,'N':722,'O':778,'P':667,'Q':778,'R':722,'S':667,'T':611,'U':722,'V':667,'W':944,
		'X':667,'Y':667,'Z':611,'[':278,'\\':278,']':278,'^':469,'_':556,'`':333,'a':556,'b':556,'c':500,'d':556,'e':556,'f':278,'g':556,'h':556,'i':222,'j':222,'k':500,'l':222,'m':833,
		'n':556,'o':556,'p':556,'q':556,'r':333,'s':500,'t':278,'u':556,'v':500,'w':722,'x':500,'y':500,'z':500,'{':334,'|':260,'}':334,'~':584 };
		
		private static var HelveticaOblique:Object = { ' ':278,'!':278,'"':355,'#':556,'$':556,'%':889,'&':667,'\'':191,'(':333,')':333,'*':389,'+':584,
		',':278,'-':333,'.':278,'/':278,'0':556,'1':556,'2':556,'3':556,'4':556,'5':556,'6':556,'7':556,'8':556,'9':556,':':278,';':278,'<':584,'=':584,'>':584,'?':556,'@':1015,'A':667,
		'B':667,'C':722,'D':722,'E':667,'F':611,'G':778,'H':722,'I':278,'J':500,'K':667,'L':556,'M':833,'N':722,'O':778,'P':667,'Q':778,'R':722,'S':667,'T':611,'U':722,'V':667,'W':944,
		'X':667,'Y':667,'Z':611,'[':278,'\\':278,']':278,'^':469,'_':556,'`':333,'a':556,'b':556,'c':500,'d':556,'e':556,'f':278,'g':556,'h':556,'i':222,'j':222,'k':500,'l':222,'m':833,
		'n':556,'o':556,'p':556,'q':556,'r':333,'s':500,'t':278,'u':556,'v':500,'w':722,'x':500,'y':500,'z':500,'{':334,'|':260,'}':334,'~':584 };
		
		private static var HelveticaBoldOblique:Object = { ' ':278,'!':333,'"':474,'#':556,'$':556,'%':889,'&':722,'\'':238,'(':333,')':333,'*':389,'+':584,
		',':278,'-':333,'.':278,'/':278,'0':556,'1':556,'2':556,'3':556,'4':556,'5':556,'6':556,'7':556,'8':556,'9':556,':':333,';':333,'<':584,'=':584,'>':584,'?':611,'@':975,'A':722,
		'B':722,'C':722,'D':722,'E':667,'F':611,'G':778,'H':722,'I':278,'J':556,'K':722,'L':611,'M':833,'N':722,'O':778,'P':667,'Q':778,'R':722,'S':667,'T':611,'U':722,'V':667,'W':944,
		'X':667,'Y':667,'Z':611,'[':333,'\\':278,']':333,'^':584,'_':556,'`':333,'a':556,'b':611,'c':556,'d':611,'e':556,'f':333,'g':611,'h':611,'i':278,'j':278,'k':556,'l':278,'m':889,
		'n':611,'o':611,'p':611,'q':611,'r':389,'s':556,'t':333,'u':611,'v':556,'w':778,'x':556,'y':556,'z':500,'{':389,'|':280,'}':389,'~':584 };
		
		private static var Times:Object =  { ' ':250,'!':333,'"':408,'#':500,'$':500,'%':833,'&':778,'\'':180,'(':333,')':333,'*':500,'+':564,
		',':250,'-':333,'.':250,'/':278,'0':500,'1':500,'2':500,'3':500,'4':500,'5':500,'6':500,'7':500,'8':500,'9':500,':':278,';':278,'<':564,'=':564,'>':564,'?':444,'@':921,'A':722,
		'B':667,'C':667,'D':722,'E':611,'F':556,'G':722,'H':722,'I':333,'J':389,'K':722,'L':611,'M':889,'N':722,'O':722,'P':556,'Q':722,'R':667,'S':556,'T':611,'U':722,'V':722,'W':944,
		'X':722,'Y':722,'Z':611,'[':333,'\\':278,']':333,'^':469,'_':500,'`':333,'a':444,'b':500,'c':444,'d':500,'e':444,'f':333,'g':500,'h':500,'i':278,'j':278,'k':500,'l':278,'m':778,
			'n':500,'o':500,'p':500,'q':500,'r':333,'s':389,'t':278,'u':500,'v':500,'w':722,'x':500,'y':500,'z':444,'{':480,'|':200,'}':480,'~':541 };
		
		private static var TimesBold:Object = { ' ':250,'!':333,'"':555,'#':500,'$':500,'%':1000,'&':833,'\'':278,'(':333,')':333,'*':500,'+':570,
		',':250,'-':333,'.':250,'/':278,'0':500,'1':500,'2':500,'3':500,'4':500,'5':500,'6':500,'7':500,'8':500,'9':500,':':333,';':333,'<':570,'=':570,'>':570,'?':500,'@':930,'A':722,
		'B':667,'C':722,'D':722,'E':667,'F':611,'G':778,'H':778,'I':389,'J':500,'K':778,'L':667,'M':944,'N':722,'O':778,'P':611,'Q':778,'R':722,'S':556,'T':667,'U':722,'V':722,'W':1000,
		'X':722,'Y':722,'Z':667,'[':333,'\\':278,']':333,'^':581,'_':500,'`':333,'a':500,'b':556,'c':444,'d':556,'e':444,'f':333,'g':500,'h':556,'i':278,'j':333,'k':556,'l':278,'m':833,
		'n':556,'o':500,'p':556,'q':556,'r':444,'s':389,'t':333,'u':556,'v':500,'w':722,'x':500,'y':500,'z':444,'{':394,'|':220,'}':394,'~':520 };
		
		private static var TimesBoldItalic:Object =  {' ':250,'!':389,'"':555,'#':500,'$':500,'%':833,'&':778,'\'':278,'(':333,')':333,'*':500,'+':570,
		',':250,'-':333,'.':250,'/':278,'0':500,'1':500,'2':500,'3':500,'4':500,'5':500,'6':500,'7':500,'8':500,'9':500,':':333,';':333,'<':570,'=':570,'>':570,'?':500,'@':832,'A':667,
		'B':667,'C':667,'D':722,'E':667,'F':667,'G':722,'H':778,'I':389,'J':500,'K':667,'L':611,'M':889,'N':722,'O':722,'P':611,'Q':722,'R':667,'S':556,'T':611,'U':722,'V':667,'W':889,
		'X':667,'Y':611,'Z':611,'[':333,'\\':278,']':333,'^':570,'_':500,'`':333,'a':500,'b':500,'c':444,'d':500,'e':444,'f':333,'g':500,'h':556,'i':278,'j':278,'k':500,'l':278,'m':778,
			'n':556,'o':500,'p':500,'q':500,'r':389,'s':389,'t':278,'u':556,'v':444,'w':667,'x':500,'y':444,'z':389,'{':348,'|':220,'}':348,'~':570 };
		
		private static var TimesItalic:Object =  { ' ':250,'!':333,'"':420,'#':500,'$':500,'%':833,'&':778,'\'':214,'(':333,')':333,'*':500,'+':675,
		',':250,'-':333,'.':250,'/':278,'0':500,'1':500,'2':500,'3':500,'4':500,'5':500,'6':500,'7':500,'8':500,'9':500,':':333,';':333,'<':675,'=':675,'>':675,'?':500,'@':920,'A':611,
		'B':611,'C':667,'D':722,'E':611,'F':611,'G':722,'H':722,'I':333,'J':444,'K':667,'L':556,'M':833,'N':667,'O':722,'P':611,'Q':722,'R':611,'S':500,'T':556,'U':722,'V':611,'W':833,
		'X':611,'Y':556,'Z':556,'[':389,'\\':278,']':389,'^':422,'_':500,'`':333,'a':500,'b':500,'c':444,'d':500,'e':444,'f':278,'g':500,'h':500,'i':278,'j':278,'k':444,'l':278,'m':722,
		'n':500,'o':500,'p':500,'q':500,'r':389,'s':389,'t':278,'u':500,'v':444,'w':667,'x':444,'y':444,'z':389,'{':400,'|':275,'}':400,'~':541 };
		
		private static var Symbol:Object = { ' ':250,'!':333,'"':713,'#':500,'$':549,'%':833,'&':778,'\'':439,'(':333,')':333,'*':500,'+':549,
		',':250,'-':549,'.':250,'/':278,'0':500,'1':500,'2':500,'3':500,'4':500,'5':500,'6':500,'7':500,'8':500,'9':500,':':278,';':278,'<':549,'=':549,'>':549,'?':444,'@':549,'A':722,
		'B':667,'C':722,'D':612,'E':611,'F':763,'G':603,'H':722,'I':333,'J':631,'K':722,'L':686,'M':889,'N':722,'O':722,'P':768,'Q':741,'R':556,'S':592,'T':611,'U':690,'V':439,'W':768,
		'X':645,'Y':795,'Z':611,'[':333,'\\':863,']':333,'^':658,'_':500,'`':500,'a':631,'b':549,'c':549,'d':494,'e':439,'f':521,'g':411,'h':603,'i':329,'j':603,'k':549,'l':549,'m':576,
		'n':521,'o':549,'p':549,'q':521,'r':549,'s':603,'t':439,'u':576,'v':713,'w':686,'x':493,'y':686,'z':494,'{':480,'|':200,'}':480,'~':549};
				
		private static var ZapfDingbats:Object = {' ':278,'!':974,'"':961,'#':974,'$':980,'%':719,'&':789,'\'':790,'(':791,')':690,'*':960,'+':939,
		',':549,'-':855,'.':911,'/':933,'0':911,'1':945,'2':974,'3':755,'4':846,'5':762,'6':761,'7':571,'8':677,'9':763,':':760,';':759,'<':754,'=':494,'>':552,'?':537,'@':577,'A':692,
		'B':786,'C':788,'D':788,'E':790,'F':793,'G':794,'H':816,'I':823,'J':789,'K':841,'L':823,'M':833,'N':816,'O':831,'P':923,'Q':744,'R':723,'S':749,'T':790,'U':792,'V':695,'W':776,
		'X':768,'Y':792,'Z':759,'[':707,'\\':708,']':682,'^':701,'_':826,'`':815,'a':789,'b':789,'c':707,'d':687,'e':696,'f':689,'g':786,'h':787,'i':713,'j':791,'k':785,'l':791,'m':873,
				'n':761,'o':762,'p':762,'q':759,'r':759,'s':892,'t':892,'u':788,'v':784,'w':438,'x':138,'y':277,'z':415,'{':392,'|':392,'}':668,'~':668};
		
		private static var Courier:Object = FontMetrics.generate();
		private static var CourierBold:Object = FontMetrics.Courier;
		private static var CourierOblique:Object = FontMetrics.Courier;
		private static var CourierBoldOblique:Object = FontMetrics.Courier;
		
		public function FontMetrics ()
		{
			FontMetrics.lookupTables.push ( { alias : FontFamily.HELVETICA, metrics : FontMetrics.Helvetica },
												{ alias : FontFamily.HELVETICA_BOLD, metrics : FontMetrics.HelveticaBold },
												{ alias : FontFamily.HELVETICA_OBLIQUE, metrics : FontMetrics.HelveticaOblique },
												{ alias : FontFamily.HELVETICA_BOLDOBLIQUE, metrics : FontMetrics.HelveticaBoldOblique },
												{ alias : FontFamily.COURIER, metrics : FontMetrics.Courier },
												{ alias : FontFamily.COURIER_BOLD, metrics : FontMetrics.CourierBold },
												{ alias : FontFamily.COURIER_OBLIQUE, metrics : FontMetrics.CourierOblique },
												{ alias : FontFamily.COURIER_BOLDOBLIQUE, metrics : FontMetrics.CourierBoldOblique },
												{ alias : FontFamily.TIMES, metrics : FontMetrics.Times },
												{ alias : FontFamily.TIMES_BOLD, metrics : FontMetrics.TimesBold },
												{ alias : FontFamily.TIMES_ITALIC, metrics : FontMetrics.TimesItalic },
												{ alias : FontFamily.TIMES_BOLDITALIC, metrics : FontMetrics.TimesBoldItalic },
												{ alias : FontFamily.SYMBOL, metrics : FontMetrics.Symbol },
												{ alias : FontFamily.ZAPFDINGBATS, metrics : FontMetrics.ZapfDingbats } );
		}
	
		private static function generate ():Object
		{
			var obj:Object = new Object();
			for(var i:int=0; i<=0xFF; i++) 
				obj[String.fromCharCode(i)] = 600;
			return obj;	
		}
				
		private static function filter ( element:*, index:int, arr:Array ):Boolean
		{	
			return element.alias == FontMetrics.lookupFontName;	
		}
		
		public static function add ( fontName:String, metrics:Object ):void
		{	
			FontMetrics.lookupFontName = fontName;
			var result:Array = FontMetrics.lookupTables.filter(filter);
			if ( result.length == 0 ) 
				FontMetrics.lookupTables.push ( { alias : fontName, metrics : metrics } );
		}
		
		public static function lookUp ( fontName:String ):Object
		{	
			FontMetrics.lookupFontName = fontName;
			var result:Array = FontMetrics.lookupTables.filter(filter);
			if ( result.length > 0 ) 
				return result[0].metrics;
			else throw new Error ("Font not available.");	
		}		
	}
}
@SET SWFTOOLS_INSTALL=C:\temp

@SET convopts=-f -T10 -t
@SET convthumbopts=--flatten -s bitmap -s zoom=10 -s jpegquality=50 -s subpixels=1
@SET combopts=

@echo OK:[ > "%TEMP%\pdf2swf.fil"
@"%SWFTOOLS_INSTALL%/pdf2swf" -I "%*".pdf > "%TEMP%\pdf2swf.cnt"
@set /A LINES=0
@for /f "delims==" %%I in (%TEMP%\pdf2swf.cnt) do @( set /A LINES+=1 )

@for /L %%C in (1,1,%LINES%) do @( "%SWFTOOLS_INSTALL%\pdf2swf" %convopts% -p%%C "%*".pdf "%*-%%C.swf" >> "%TEMP%\pdf2swf.log" )
@for /L %%C in (1,1,%LINES%) do @( "%SWFTOOLS_INSTALL%\pdf2swf" %convthumbopts% -p%%C "%*".pdf "%*-%%C_thumb.swf" >> "%TEMP%\pdf2swf.log" )
@for /L %%C in (1,1,%LINES%) do @( IF EXIST "%*-%%C.swf" echo %*-%%C.swf, >> "%TEMP%\pdf2swf.fil" ) 

@echo ] >> "%TEMP%\pdf2swf.fil"
@type "%TEMP%\pdf2swf.fil"

@del "%TEMP%\pdf2swf.fil"
@del "%TEMP%\pdf2swf.cnt"
@del "%TEMP%\pdf2swf.log"

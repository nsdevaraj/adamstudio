package fr.brennus.specifics.SF {
  import flash.events.Event;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.utils.Dictionary;
  
  import mx.rpc.AsyncToken;
  import mx.rpc.events.FaultEvent;
  import mx.rpc.events.ResultEvent;
  import mx.rpc.http.HTTPService;

  public class dataCatch {
    private var _config:XML;
    private var _language:String;
    private var _loading:String = "";
    private var _requestedRefs:Array = new Array();
    // private const _URLROOT:String = "http://boutique.stade.fr";
    //private const _IMGROOT:String = _URLROOT + "/boutique/images_produits";
    private const _URLROOT:String = "http://212.43.199.78/StadeRelay/get?url=";
    private const _IMGROOT:String = "http://212.43.199.78/StadeRelay/get?url=boutique%2Fimages_produits";
    private const _URLHILITE:String = "liste_produits.cfm?type={htype}&code_lg={lg}";
    private const _URLCATALOG:String = "recherche_resultats.cfm?marque_nav=0&rayon_nav=-1&gamme_nav=0&prix_min=&prix_max=&mot=%25&classement=&code_lg={lg}&ordre=&triage=0&pag={pg}";
    private const _URLDETAILS:String = "fiche_produit.cfm?ref={ref}&code_lg={lg}";
    private var _asyncToken:AsyncToken;
    private var _dataHilite:Dictionary;
    private var _dataCatalog:Dictionary;
    private var _dataTypes:Dictionary;

    public function dataCatch( cLang:String = "fr" ):void {
      var ldr:URLLoader = new URLLoader();
      var file:URLRequest = new URLRequest( "config.xml" );

      ldr.addEventListener( Event.COMPLETE, configComplete );
      ldr.load( file );
      _language = cLang;
      _dataHilite = new Dictionary();
      _dataHilite["fr"] = new XML( "<HILITE lang=\"fr\" complete=\"0\" />" );
      _dataHilite["en"] = new XML( "<HILITE lang=\"en\" complete=\"0\" />" );
      _dataCatalog = new Dictionary();
      _dataCatalog["fr"] = new XML( "<CATALOG lang=\"fr\" complete=\"0\" />" );
      _dataCatalog["en"] = new XML( "<CATALOG lang=\"en\" complete=\"0\" />" );
      _dataTypes = new Dictionary();
      _dataTypes["fr"] = new Dictionary();
      _dataTypes["en"] = new Dictionary();
    }    // End of dataCatch() constructor

    private function configComplete( pEvt:Event ):void {
      _config = new XML( pEvt.target.data );
      // Initiate the catch of default hilite list
      _loading = "HILITE";
      startCatch( alterUrl( _URLHILITE ) );
    }    // End of function configComplete()

    private function parseHilite( pData:String, pLanguage:String ):void {
      const cSTARTMARK:String = "<a href=\"fiche_produit.cfm?ref=";
      const cENDMARK:String = "</a>";
      const cSTARTIMG:String = "<img src=\"images_produits/";
      const cENDIMG:String = "\"";
      const cSTARTTITLE:String = " alt=\"";
      const cENDTITLE:String = "\"";
      var cStart:int;
      var cEnd:int;
      var cRefEnd:int;
      var cSlice:String;
      var cReference:String;
      var cLastRef:String = "__none__";
      var cImgStart:int;
      var cImgEnd:int;
      var cImgRef:String;
      var cTitleStart:int;
      var cTitleEnd:int;
      var cTitleRef:String;
      var cNewNode:String;

      // Slice the input
      cStart = pData.indexOf( cSTARTMARK, 0 );
      while( cStart != -1 ) {
        cEnd = pData.indexOf( cENDMARK, cStart );
        if( cEnd == -1 ) {
          trace( "Malformed HTML stream for Hilite: no slice end found after position " + cStart );
          cSlice = pData.substring( cStart );
        }
        else {
          cSlice = pData.substring( cStart, cEnd );
        }

        // Parse the reference out
        cRefEnd = cSlice.indexOf( "&amp;", cSTARTMARK.length );
        if( cRefEnd == -1 ) {
          trace( "Malformed HTML stream for Hilite: no ref end found after position " + cStart + cSTARTMARK.length );
          trace( "..." + cSlice.substring( 0, 200 ) );
        }
        else {
          cReference = cSlice.substring( cSTARTMARK.length, cRefEnd );
          if( cReference != cLastRef ) {
            // Parse the other fields
            cImgStart = cSlice.indexOf( cSTARTIMG );
            if( cImgStart == -1 ) {
              trace( "Malformed HTML stream for Hilite: no image start found " );
              trace( "..." + cSlice.substring( 0, 200 ) );
              cImgEnd = 0;
              cImgRef = "not_found";
            }
            else {
              cImgEnd = cSlice.indexOf( cENDIMG, cImgStart+cSTARTIMG.length );
              cImgRef = cSlice.substring( cImgStart+cSTARTIMG.length, cImgEnd );
            }
            cSlice = cSlice.substring( cImgEnd );
            cTitleStart = cSlice.indexOf( cSTARTTITLE );
            cTitleEnd = cSlice.indexOf( cENDTITLE, cTitleStart+cSTARTTITLE.length );
            if( cTitleStart == -1 ) {
              trace( "Malformed HTML stream for Hilite: no image start found " );
              trace( "..." + cSlice.substring( 0, 200 ) );
              cTitleRef = "not_found";
            }
            else {
              cTitleRef = cSlice.substring( cTitleStart+cSTARTTITLE.length, cTitleEnd );
            }

            // Add an XML child
            cNewNode = "<ITEM ref=\"" + cReference + "\">"
                     + "<TITLE>" + cTitleRef + "</TITLE>"
                     + "<PICTURE>" + _IMGROOT + "/" + cImgRef.substring( 1 ) + "</PICTURE>"
                     + "<THUMBNAIL>" + _IMGROOT + "/" + cImgRef + "</THUMBNAIL>"
                     + "</ITEM>";
            _dataHilite[pLanguage].appendChild( new XML( cNewNode ) );
            cLastRef = cReference;
          }
        }

        cStart = pData.indexOf( cSTARTMARK, cEnd );
      }    // End of while( {parse-the-input} )
      _dataHilite[pLanguage].@complete = "2";    // 2 = load completed
    }    // End of function parseHilite()

    private function parseTypes( pData:String, pLanguage:String ):void {
      const cSTARTMARK:RegExp = /id="menu_acces_rapide"/i;
      const cSTARTMARKLEN:int = 22;
      const cENDMARK:RegExp = /<\/select>/i;
      const cOPTIONSTART:RegExp = /<option value="/i;
      const cOPTIONSTARTLEN:int = 15;
      const cOPTIONEND:RegExp = /<\/option>/i;
      var cStart:int, cEnd:int;
      var cOptionStart:int, cOptionEnd:int, cValEnd:int;
      var cKey:String;
      var cType:String;

      cStart = pData.search( cSTARTMARK );
      if( cStart != -1 ) {
        pData = pData.substring( cStart + cSTARTMARKLEN );
        cEnd = pData.search( cENDMARK );
        if( cEnd != -1 ) {
          pData = pData.substring( 0, cEnd );
          for( var key:Object in _dataTypes[ pLanguage ] ) delete _dataTypes[ pLanguage ][key];
          cOptionStart = pData.search( cOPTIONSTART );
          while( cOptionStart != -1 ) {
            pData = pData.substring( cOptionStart + cOPTIONSTARTLEN );
            cOptionStart = -1;
            cValEnd = pData.indexOf( "\"", 1 );
            if( cValEnd != -1 ) {
              cKey = pData.substring( 0, cValEnd );
              cOptionStart = pData.indexOf( ">" );
              cOptionEnd = pData.indexOf( "<", cOptionStart );
              if( cKey != "0" && cOptionStart != -1 && cOptionEnd != -1 ) {
                cType = pData.substring( cOptionStart+1, cOptionEnd )
                _dataTypes[ pLanguage ][ cKey ] = cType.replace( /[\n\r]/g, "" );
                pData = pData.substring( cOptionEnd );
                cOptionStart = pData.search( cOPTIONSTART );
              }
            }
          }    // End of while( cOptionStart )
        }    // End of if( cEnd )
      }    // End of if( cStart )
    }    // End of function parseTypes()

    private function parseCatalog( pData:String, pLanguage:String ):int {
      const cSTARTMARK:String = "<form method=\"post\" action=\"com_act.cfm?ref=";
      const cTYPEMARK:RegExp = /[&?]type=/i;
      const cTYPEMARKLEN:int = 6;
      const cENDMARK:String = "</form>";
      const cFIELDNAMES:Array = new Array( "TITLE",
                                           "PRICE",
                                           "THUMBNAIL",
                                           "WEIGHT",
                                           "TAXRATE",
                                           "PROMO" );
      const cFIELDMARKS:Array = new Array( "<INPUT TYPE=\"HIDDEN\" NAME=\"titre\" VALUE=\"",
                                           "<INPUT TYPE=\"HIDDEN\" NAME=\"prix\" VALUE=\"",
                                           "<INPUT TYPE=\"HIDDEN\" NAME=\"ima\" VALUE=\"",
                                           "<INPUT TYPE=\"HIDDEN\" NAME=\"poids\" VALUE=\"",
                                           "<INPUT TYPE=\"HIDDEN\" NAME=\"taxe\" VALUE=\"",
                                           "<INPUT TYPE=\"HIDDEN\" NAME=\"promo\" VALUE=\"" );
      const cELEMNAMES:Array = new Array( "BRAND",
                                          "DESCRIPTION",
                                          "CANCELLEDPRICE",
                                          "ACTUALPRICE",
                                          "AVAILABLE" );
      const cELEMMARKS:Array = new Array(  "id=\"titre_nom_marque_recherche_resultats\"",
                                           "<span class=\"texte_catalogue\"",
                                           "id=\"prix_devise_barre_recherche_resultats\"",
                                           "id=\"prix_devise_gras_recherche_resultats\"",
                                           "lien_selectionnez_recherche_resultats\"" );
      var cNbItems:int = 0;
      var cStart:int;
      var cEnd:int;
      var cSlice:String;
      var cValStart:int;
      var cValEnd:int;
      var cReference:String;
      var cTypeKey:String;
      var cType:String;
      var cIx:int;
      var cValues:Dictionary = new Dictionary();
      var cNewNode:String;

      // Get the dictionary of types if needed
      var cNbTypes:int = 0;
      for( var ckey:Object in _dataTypes[ pLanguage ] ) cNbTypes++;
      if( cNbTypes == 0 )
        parseTypes( pData, pLanguage );

      // Slice the input
      cStart = pData.indexOf( cSTARTMARK, 0 );
      while( cStart != -1 ) {
        cEnd = pData.indexOf( cENDMARK, cStart );
        if( cEnd == -1 ) {
          trace( "Malformed HTML stream for Catalog: no slice end found after position " + cStart );
          cSlice = pData.substring( cStart + cSTARTMARK.length );
        }
        else {
          cSlice = pData.substring( cStart + cSTARTMARK.length, cEnd );
        }

        // Parse the reference out
        cValEnd = cSlice.indexOf( "&" );
        if( cValEnd == -1 )
          cReference = "";
        else
          cReference = cSlice.substring( 0, cValEnd );

        // Parse the type out
        cValStart = cSlice.search( cTYPEMARK );
        cValEnd = cSlice.indexOf( "&", cValStart + cTYPEMARKLEN );
        cType = "";
        if( cValEnd != -1 ) {
          cTypeKey = cSlice.substring( cValStart + cTYPEMARKLEN, cValEnd );
          if( _dataTypes[ pLanguage ][ cTypeKey ] != undefined )
            cType = _dataTypes[ pLanguage ][ cTypeKey ];
        }

        // Parse fields out of HIDDEN elements
        for( cIx=0; cIx<cFIELDNAMES.length; cIx++ ) {
          cValStart = cSlice.indexOf( cFIELDMARKS[cIx] );
          if( cValStart == -1 ) {
            cValues[cFIELDNAMES[cIx]] = "";
          }
          else {
            cValStart += cFIELDMARKS[cIx].length;
            cValEnd = cSlice.indexOf( "\"", cValStart );
            if( cValEnd == -1 ) {
              cValues[cFIELDNAMES[cIx]] = cSlice.substring( cValStart );
            }
            else {
              cValues[cFIELDNAMES[cIx]] = cSlice.substring( cValStart, cValEnd );
            }
            cValues[cFIELDNAMES[cIx]] = cValues[cFIELDNAMES[cIx]].replace( /\n/g, "" ).replace( /\r/g, "" ).replace( /<BR>/gi, "\n" ).replace( /^[\n\t ]*/, "").replace( /[\n\t ]*$/, "").replace( /<[^>]*>/g, "");
          }
        }    // End of for( fields )

        // Parse fields out of elements contents
        for( cIx=0; cIx<cELEMNAMES.length; cIx++ ) {
          cValStart = cSlice.indexOf( cELEMMARKS[cIx], cSTARTMARK.length );
          if( cValStart == -1 ) {
            cValues[cELEMNAMES[cIx]] = "";
          }
          else {
            cValStart += cELEMMARKS[cIx].length;
            cValStart = cSlice.indexOf( ">", cValStart );
            cValEnd = cSlice.substring(cValStart+1).search( /<\/SPAN>/i );
            if( cValStart == -1 || cValEnd == -1 ) {
              cValues[cELEMNAMES[cIx]] = cSlice.substring( cValStart+1 );
            }
            else {
              // Caution: use substr because cValEnd is the position relative to cValStart+1
              cValues[cELEMNAMES[cIx]] = cSlice.substr( cValStart+1, cValEnd );
            }
            cValues[cELEMNAMES[cIx]] = cValues[cELEMNAMES[cIx]].replace( /\n/g, "" ).replace( /\r/g, "" ).replace( /<BR>/gi, "\n" ).replace( /^[\n\t ]*/, "").replace( /[\n\t ]*$/, "").replace( /<[^>]*>/g, "");
          }
        }    // End of for( elements )

        // Output the data
        if( cReference != "" ) {
          cNbItems++;
          if( cValues["AVAILABLE"] == "" ) cValues["AVAILABLE"] = "0";
          else cValues["AVAILABLE"] = "1";
          if( cValues["CANCELLEDPRICE"] == "" ) {
            cValues["_PRICE"] = cValues["ACTUALPRICE"].replace( /[^0-9\.]/g, "" );
            cValues["_SPECIAL"] = "";
          }
          else {
            cValues["_PRICE"] = cValues["CANCELLEDPRICE"].replace( /[^0-9\.]/g, "" );
            cValues["_SPECIAL"] = cValues["ACTUALPRICE"].replace( /[^0-9\.]/g, "" );
          }
          // Add an XML child
          cNewNode = "<ITEM ref=\"" + cReference + "\" complete=\"1\">"
                   + "<TITLE>" + cValues["TITLE"] + "</TITLE>"
                   + "<BRAND>" + cValues["BRAND"] + "</BRAND>"
                   + "<TYPE>" + cType + "</TYPE>"
                   + "<PRICE>" + cValues["_PRICE"] + "</PRICE>"
                   + "<SPECIAL>" + cValues["_SPECIAL"] + "</SPECIAL>"
                   + "<PROMO>" + cValues["PROMO"] + "</PROMO>"
                   + "<TAXRATE>" + cValues["TAXRATE"] + "</TAXRATE>"
                   + "<PICTURE>" + _IMGROOT + "/" + cValues["THUMBNAIL"].substr(1) + "</PICTURE>"
                   + "<THUMBNAIL>" + _IMGROOT + "/" + cValues["THUMBNAIL"] + "</THUMBNAIL>"
                   + "<WEIGHT>" + cValues["WEIGHT"] + "</WEIGHT>"
                   + "<AVAILABLE>" + cValues["AVAILABLE"] + "</AVAILABLE>"
                   + "<DESCRIPTION>" + cValues["DESCRIPTION"] + "</DESCRIPTION>"
                   + "</ITEM>";
          _dataCatalog[pLanguage].appendChild( new XML( cNewNode ) );
        }

        // Prepare next item slice
        cStart = pData.indexOf( cSTARTMARK, cEnd );
        cReference = undefined;
        for( var key:Object in cValues ) delete cValues[key];
      }    // End of while( slice the input )

      return cNbItems;
    }    // End of function parseCatalog()

    private function parseDetails( pData:String, pLanguage:String ):void {
      const cREFSTART:String = "<INPUT TYPE=\"HIDDEN\" NAME=\"ref\" VALUE=\"";
      const cIMGSTART:String = "<img src=\"images_produits/";
      const cDESCSTART:String = "id=\"texte_description_fiche_produit\"";
      const cSIZESTART:String = "menu_option_fiche_produit";
      var cStart:int;
      var cEnd:int;
      var cOptStart:int;
      var cOptEnd:int;
      var cReference:String;
      var cFullDesc:String;
      var cOptCount:int = 0;
      var cOptions:String;
      var cOptValue:String;
      var cOptLabel:String;
      var cNewNode:String;
      var cCatEntry:XMLList;

      // Search for the product reference
      cStart = pData.indexOf( cREFSTART );
      if( cStart == -1 ) {
        trace( "Error: cannot find reference start marker" );
        return;
      }
      cEnd = pData.indexOf( "\"", cStart + cREFSTART.length );
      if( cEnd == -1 ) {
        trace( "Malformed reference element" );
        return;
      }
      cReference = pData.substring( cStart + cREFSTART.length, cEnd );

      // Search for the reference in the catalog
      cCatEntry = _dataCatalog[pLanguage].ITEM.(@ref==cReference)
      if( cCatEntry.length == 0 || cCatEntry[0] == null ) {
        trace( "Details reference not found in catalog: " + cReference );
        return;
      }

      // Search for the full resolution image
      cStart = pData.indexOf( cIMGSTART );
      if( cStart != -1 ) {
        cEnd = pData.indexOf( "\"", cStart + cIMGSTART.length );
        if( cEnd == -1 ) {
          trace( "Malformed image element for product reference: " + cReference );
        }
        else {
          cCatEntry[0].PICTURE = _IMGROOT + "/" + pData.substring( cStart + cIMGSTART.length, cEnd );
        }
      }

      // Search for the full description
      cStart = pData.indexOf( cDESCSTART );
      if( cStart != -1 ) {
        cStart = pData.indexOf( ">", cStart + cDESCSTART.length );
        cEnd = pData.indexOf( "</div>", cStart );
        if( cEnd == -1 ) {
          trace( "Malformed description element for product reference: " + cReference );
        }
        else {
          cFullDesc = pData.substring( cStart + 1, cEnd );
          cCatEntry[0].DESCRIPTION = cFullDesc.replace( /\n/g, "" ).replace( /\r/g, "" ).replace( /<BR>/gi, "\n" ).replace( /^[\n\t ]*/, "").replace( /[\n\t ]*$/, "").replace( /<[^>]*>/g, "");
        }
      }

      // Search for the list of product options (sizes)
      cStart = pData.indexOf( cSIZESTART );
      if( cStart != -1 ) {
        cStart = pData.indexOf( ">", cStart + cSIZESTART.length );
        cEnd = pData.indexOf( "</select>", cStart );
        if( cEnd == -1 ) {
          trace( "Malformed options element for product reference: " + cReference );
        }
        else {
          cOptions = pData.substring( cStart + 1, cEnd );
          cOptStart = cOptions.indexOf( "<option value='" );
          while( cOptStart != -1 ) {
            cOptCount++;
            cOptEnd = cOptions.indexOf( "'", cOptStart + 15 );
            if( cOptEnd != -1 ) {
              cOptValue = cOptions.substring( cOptStart + 15, cOptEnd );
              cOptStart = cOptions.indexOf( ">", cOptEnd + 1 );
              if( cOptStart != -1 ) {
                cOptEnd = cOptions.indexOf( "<", cOptStart );
                if( cOptEnd != -1 ) {
                  cOptLabel = cOptions.substring( cOptStart + 1, cOptEnd );
                  cNewNode = "<SIZE ord=\"" + cOptCount + "\"><LBL>" + cOptLabel + "</LBL><REF>"
                           + cOptValue + "</REF></SIZE>";
                  cCatEntry[0].appendChild( new XML( cNewNode ) );
                }
              }
            }
            if( cOptEnd != -1 )
              cOptStart = cOptions.indexOf( "<option value='", cOptEnd );
            else
              cOptStart = -1;
          }    // End of while( cOptStart != -1 )
        }
      }

      cCatEntry[0].@complete = "2";    // 2 = details info completed
    }    // End of parseDetails()

    private function handleFault( cEvent:FaultEvent ):void {
      trace( cEvent.fault.message );
      _loading = "";
    }    // End of handleFault()

    private function handleResult( cEvent:ResultEvent, pLanguage:String ):void {
      var cLngChanged:Boolean = false;
      var cPageNum:String;
      var cPageDelimiter:int;
      var cNbItems:int;
      var cComplete:Boolean;
      var cDummy:XML;
      var cToDo:XMLList;

      if( _language != pLanguage ) cLngChanged = true;

      if( _loading == "HILITE" ) {
        // It is a result for Hilite search
        parseHilite( cEvent.result.toString(), pLanguage );
        _loading = "";
        // Launch the loading of catalog
        if( ! cLngChanged )
          cDummy = getCatalog();
      }    // end of if( HILITE )

      else if( _loading == "DETAILS" ) {
        // It is a result for Details search
        parseDetails( cEvent.result.toString(), pLanguage );
        _loading = "";

        // Search next item to complete
        if( ! cLngChanged ) {
          if( _requestedRefs.length == 0 ) {
            cComplete = true;
            for each( var xItem:XML in _dataCatalog[pLanguage].ITEM ) {
              if( xItem.@complete == "1" ) {
                _requestedRefs.push( xItem.@ref );
                cComplete = false;
                break;
              }
            }
            if( cComplete ) _dataCatalog[pLanguage].@complete = "2";
          }
          // Launch the loading of next details
          // (details will be searched ondemand only)
          // (uncomment the following line to autoload all details)
          // searchDetails();
        }    // end of if( ! cLngChanged )
      }    // end of if( DETAILS )

      else {
        // It is a result for Catalog:{pg} search
        cPageDelimiter = _loading.search( /:/ );
        cNbItems = parseCatalog( cEvent.result.toString(), pLanguage );
        if( cNbItems > 0 ) {
          if( cLngChanged ) {
            // Purge catalog: will have to be retrieved if switching back to this lng
            _dataCatalog[pLanguage].@complete = "0";
            delete _dataCatalog[pLanguage].* ; //for each( var yItem:XML in _dataCatalog[pLanguage].children() ) delete yItem;
            _loading = "";
          }
          else {
            cPageNum = String( int( _loading.substr( cPageDelimiter + 1 ) ) + 1 );
            _loading = "CATALOG:" + cPageNum;
            startCatch( alterUrl( _URLCATALOG.replace( /{pg}/, cPageNum ) ) );
          }
        }
        else {
          _loading = "";
          _dataCatalog[pLanguage].@complete = "1";    // 1 = basic info completed
          // Launch details retrieval for 1st item
          if( ! cLngChanged ) {
            cToDo = _dataCatalog[pLanguage].*;
            if( cToDo.length() > 0 ) {
              _requestedRefs.push( cToDo[0].@ref );
              searchDetails();
            }
          }
        }
      }    // end of if( CATALOG )
    }    // End of handleResult()

    private function handleResultFr( cEvent:ResultEvent ):void {
      handleResult( cEvent, "fr" );
    }

    private function handleResultEn( cEvent:ResultEvent ):void {
      handleResult( cEvent, "en" );
    }

    private function startCatch( pFullUrl:String ):void {
      var cHttpService:HTTPService = new HTTPService();
      cHttpService.useProxy = false;
      cHttpService.url = pFullUrl;
      cHttpService.method = "GET";
      cHttpService.resultFormat = "text";
      cHttpService.addEventListener( mx.rpc.events.FaultEvent.FAULT, handleFault );
      if( _language == "fr" ) {
        cHttpService.addEventListener( mx.rpc.events.ResultEvent.RESULT, handleResultFr );
      }
      else {
        cHttpService.addEventListener( mx.rpc.events.ResultEvent.RESULT, handleResultEn );
      }
      _asyncToken = cHttpService.send();
    }    // End of startCatch()

    private function alterUrl( pBaseUrl:String ):String {
      // if( _language == "fr" ) {
      //   return _URLROOT + "/boutique/"
      //                   + pBaseUrl.replace( /\{lg\}/g, "lg_fr" ).replace( /\{htype\}/g, _config..hilitepagetype );
      // } else {
      //   return _URLROOT + "/boutique_us/" 
      //                   + pBaseUrl.replace( /\{lg\}/g, "lg_us" ).replace( /\{htype\}/g, _config..hilitepagetype );
      // }
      var cFullUrl:String;
      if( _language == "fr" ) {
        cFullUrl = "boutique/" + pBaseUrl.replace( /\{lg\}/g, "lg_fr" ).replace( /\{htype\}/g, _config..hilitepagetype );
      } else {
        cFullUrl = "boutique_us/" + pBaseUrl.replace( /\{lg\}/g, "lg_us" ).replace( /\{htype\}/g, _config..hilitepagetype );
      }
      return _URLROOT + cFullUrl.replace( /\//g, "%2F" ).replace( /?/g, "%3F" ).replace( /=/g, "%3D" ).replace( /&/g, "%26" );
    }    // End of alterUrl()

    private function searchDetails():void {
      if( _loading == "" && _requestedRefs.length > 0 ) {
        _loading = "DETAILS";
        startCatch( alterUrl( _URLDETAILS.replace( /{ref}/, _requestedRefs.shift() ) ) );
      }
    }    // End of searchDetails()

    public function getHilite( lang:String = "" ):XML {
      // Keep / Switch current language
      if( lang != "" && lang != _language) {
        while( _requestedRefs.length > 0 ) _requestedRefs.shift();
        _language = lang;
      }

      if( _dataHilite[_language].@complete == "2" ) {
        return _dataHilite[_language];
      }
      else if( _loading == "" ) {
        _loading = "HILITE";
        startCatch( alterUrl( _URLHILITE ) );
      }
      return null;      // Meaning "retry later"
    }    // End of getHilite()

    public function getCatalog( lang:String = "" ):XML {
      // Keep / Switch current language
      if( lang != "" && lang != _language) {
        while( _requestedRefs.length > 0 ) _requestedRefs.shift();
        _language = lang;
      }

      if( _dataCatalog[_language].@complete != "0" ) {
        return _dataCatalog[_language];
      }
      else if( _loading == "" ) {
        _loading = "CATALOG:1";
        startCatch( alterUrl( _URLCATALOG.replace( /{pg}/, "1" ) ) );
      }
      return null;      // Meaning "retry later"
    }    // End of getCatalog()

    public function getDetails( pRef:String, lang:String = "" ):XML {
      var cItem:XMLList;

      // Keep / Switch current language
      if( lang != "" && lang != _language) {
        while( _requestedRefs.length > 0 ) _requestedRefs.shift();
        _language = lang;
      }

      // Search the element
      cItem = _dataCatalog[_language].*.( @ref == pRef );
      if( cItem.length == 0 || cItem[0] == undefined ) {
        getCatalog();
        return null;
      }
      if( cItem[0].@complete != "2" ) {
        if( _requestedRefs.indexOf(pRef) == -1 ) {
          _requestedRefs.push( pRef );
          searchDetails();
          return null;
        }
      }
      return cItem[0];
    }    // End of getDetails()

  }    // End of class dataCatch

}    // End of package fr.brennus.specifics.SF

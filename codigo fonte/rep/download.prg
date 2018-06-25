function Main()

* desenvolvido em Harbour versão 3.0.0.
* compilado em Harbour Make (hbmk2) versão 3.0.0.
* download.prg - 28/01/2018 - versão 1.2. Updated:04/04/2018
* argumento in: Analisa se os arquivos solicitados estão disponíveis para download. Se sim, envia quais estão disponíveis
* para serem baixados pelo programa BaixaDBFx. Se não, preenche as chaves do arquivo "download.ini" com zeros.
* argumento out: Identifica nomes de arquivos semelhantes entre o arquivo "download.ini" e o arquivo "totalsol.dbf". Se
* encontrar, altera no arquivo "totalsol.dbf", o valor do campo "download" de "N" para "S".

* Declarações da linguagem e diretivas de pré-processador.
#include "common.ch"
#include "fileio.ch"
#define BLOKSIZE 128
#define CR CHR(13)
#define LF CHR(10)
#define CRLF ( CR + LF )
#define INIEXT ".INI"
#define NULSECT "**NUL SECTION**"

* Variáveis públicas auxiliares.
PUBLIC cPosit := ""
PUBLIC cFile := ""
PUBLIC cDownloaded := ""
PUBLIC cPosit2 := ""
PUBLIC cFile2 := ""
PUBLIC cDownloaded2 := ""
PUBLIC cRegistro := ""
PUBLIC cStatus := ""

* Verifica se os argumentos são válidos. 
if HB_ArgV( 1 ) <> "in" .and. HB_ArgV( 1 ) <> "out" .and. HB_ArgV( 1 ) <> "verify"
? "Esses parametros não são válidos."
__Quit()
endif

if HB_ArgV( 1 ) = "in" // instruções para o argumento de valor "in".
* Procura no diretório o arquivo "download.ini".
if FILE("C:\SinanFTP\auxx\download.ini") = .F. // se não encontrar, cria o arquivo.
       aMyIni := IniIni()
       IniPut( aMyIni, "DADOS", "filename", "" )
	   IniPut( aMyIni, "DADOS", "position", "" )
	   IniPut( aMyIni, "DADOS", "registros", "" )
	   IniPut( aMyIni, "DADOS", "status", "" )
	   IniPut( aMyIni, "DADOS", "modo", "" )
	   IniPut( aMyIni, "DADOS", "downloaded?", "" )
	   IniPut( aMyIni, "DADOS", "falhou?", "" )
	   IniSave( aMyIni, "C:\SinanFTP\auxx\download.ini" )
endif
* Procura no arquivo "totalsol.dbf"	se existem solicitações que estejam disponíveis para download.
use "C:\SinanFTP\auxx\totalsol.dbf"
goto top
locate for alltrim(link) = "Baixar arquivo DBF" .and. alltrim(download) = "N" .and. empty (alltrim(tipo)) = .F.
* Se sim, envia um arquivo que mostra qual arquivo está disponível para download e sua posição na tela.
if found() = .T. 
goto recno()
cPosit = alltrim(str(recno()))
cFile = alltrim(filename)
cRegistro = alltrim(registros)
cStatus = alltrim(status)

* substitui valores das chaves contidas no arquivo download.ini.
	   aMyIni2 := IniLoad("C:\SinanFTP\auxx\download.ini")
       IniPut( aMyIni2, "DADOS", "filename", cFile )
	   IniPut( aMyIni2, "DADOS", "position", cPosit )
	   IniPut( aMyIni2, "DADOS", "registros", cRegistro )
	   IniPut( aMyIni2, "DADOS", "status", cStatus )
	   IniSave( aMyIni2, "C:\SinanFTP\auxx\download.ini" )
else
* substitui valores das chaves contidas no arquivo download.ini.
	   aMyIni2 := IniLoad("C:\SinanFTP\auxx\download.ini")
       IniPut( aMyIni2, "DADOS", "filename", "000000" )
	   IniPut( aMyIni2, "DADOS", "position", "000000" )
	   IniSave( aMyIni2, "C:\SinanFTP\auxx\download.ini" )
endif

endif

if HB_ArgV( 1 ) = "out" // instruções para o argumento de valor "out".
  aMyIni3   := IniLoad( "C:\SinanFTP\auxx\download.ini" )
      cFile2 := IniGet( aMyIni3, "DADOS", "filename" )
      ? cFile2
* procura em download.ini e totalsol.dbf, nomes de arquivos semelhantes.
use "C:\SinanFTP\auxx\totalsol.dbf"
goto top
locate for alltrim(filename) = alltrim(cFile2)
if found() = .T. 
goto recno()
replace download with "S"	
close  
endif

endif

if HB_ArgV( 1 ) = "verify" // instruções para o argumento de valor "verify".
* Procura no diretório o arquivo "download.ini".
if FILE("C:\SinanFTP\auxx\download.ini") = .F. // se não encontrar, cria o arquivo.
       aMyIni := IniIni()
       IniPut( aMyIni, "DADOS", "filename", "" )
	   IniPut( aMyIni, "DADOS", "position", "" )
	   IniPut( aMyIni, "DADOS", "registros", "" )
	   IniPut( aMyIni, "DADOS", "status", "" )
	   IniPut( aMyIni, "DADOS", "modo", "" )
	   IniPut( aMyIni, "DADOS", "downloaded?", "" )
	   IniPut( aMyIni, "DADOS", "falhou?", "" )
	   IniSave( aMyIni, "C:\SinanFTP\auxx\download.ini" )
endif
* Procura no arquivo "totalsol.dbf"	se existem solicitações que ainda estão sendo processadas.
use "C:\SinanFTP\auxx\totalsol.dbf"
goto top
locate for alltrim(status) = "Em processamento" .or. alltrim(status) = "Agendada"
* Se sim, envia um arquivo que mostra essa condição para o programa principal.
if found() = .T. 
* substitui valores das chaves contidas no arquivo download.ini.
	   aMyIni2 := IniLoad("C:\SinanFTP\auxx\download.ini")
       IniPut( aMyIni2, "DADOS", "filename", "processando..." )
	   IniPut( aMyIni2, "DADOS", "position", "processando..." )
	   IniSave( aMyIni2, "C:\SinanFTP\auxx\download.ini" )
	   
else
* substitui valores das chaves contidas no arquivo download.ini.
	   aMyIni2 := IniLoad("C:\SinanFTP\auxx\download.ini")
       IniPut( aMyIni2, "DADOS", "filename", "" )
	   IniPut( aMyIni2, "DADOS", "position", "" )
	   IniSave( aMyIni2, "C:\SinanFTP\auxx\download.ini" )
endif
endif

* Funções de manipulação de arquivos ini
* File.....: inifile.prg
* Author...: Peter Townsend
* CIS ID...:
* e-mail...: cephas@tpgi.com.au
* version..: 1.3
* This is an original work by Peter Townsend and is hereby placed in the public domain.
* ===========================================================================================================
FUNCTION IniSave( aIni, cFile )
    LOCAL nCntr, nOutLen, nInCntr, nInLen, lSuccess
    DEFAULT cFile TO "APPLIC"
    IF ! ( "." $ cFile )
        cFile += INIEXT
    ENDIF
    lSuccess := .F.
    hIniFile := FCREATE( cFile, FC_NORMAL )
    IF hIniFile > -1
        nOutCntr := 1
        nOutLen  := LEN( aIni )
        DO WHILE nOutCntr <= nOutLen
            IF aIni[ nOutCntr, 1 ] != NULSECT
                FWRITE( hIniFile, "[" + aIni[ nOutCntr, 1 ] + "]" + CRLF )
            ENDIF
            nInLen  := LEN( aIni[ nOutCntr, 2 ] )
            nInCntr := 1
            DO WHILE nInCntr <= nInLen
                cItem  := aIni[ nOutCntr, 2, nInCntr, 1 ]
                DO CASE
                    CASE EMPTY( cItem )
                        FWRITE( hIniFile, CRLF )
                    CASE LEFT( cItem , 1 ) == ";"
                        FWRITE( hIniFile, cItem + CRLF )
                    OTHERWISE
                        cValue := aIni[ nOutCntr, 2, nInCntr, 2 ]
                        FWRITE( hIniFile, cItem + "=" + cValue + CRLF )
                ENDCASE
                nInCntr++
            ENDDO
            nOutCntr++
        ENDDO
        FCLOSE( hIniFile )
        lSuccess := .T.
    ENDIF
RETURN( lSuccess )
* ===========================================================================================================
FUNCTION IniPut( aIni, xSection, xItem, cValue )
    LOCAL aSub, nOutPos, nInPos, lSuccess, lFinished
    lSuccess  := .T.
    lFinished := .F.
    IF VALTYPE( xSection ) == "N"
        IF xSection >= 1 .AND. xSection < LEN( aIni )
            nOutPos := xSection + 1
        ELSE
            nOutPos   := 0
            lFinished := .T.
        ENDIF
    ELSE
        nOutPos  := ASCAN( aIni, {|x| UPPER(x[1]) == UPPER(xSection) } )
    ENDIF
    IF lFinished
        lSuccess := .F.
    ELSE
        IF nOutPos == 0
            AADD( aIni, { xSection, {} } )
            nOutPos := LEN( aIni )
        ENDIF
        IF VALTYPE( xItem ) == "N"
            nInPos := NthItemPos( aIni, nOutPos, xItem )
            IF nInPos != xItem
                lFinished := .T.
                lSuccess  := .F.
            ENDIF
        ELSE
            nInPos := ASCAN( aIni[ nOutPos, 2 ], {|x| UPPER(x[1]) == UPPER(xItem) } )
        ENDIF
        IF ! lFinished
            IF nInPos == 0
                AADD( aIni[ nOutPos, 2 ], { xItem, cValue } )
            ELSE
                aIni[ nOutPos, 2, nInPos, 2 ] := cValue
            ENDIF
        ENDIF
    ENDIF
RETURN( lSuccess )
* ===========================================================================================================
FUNCTION IniIni()
RETURN( {} )
* ===========================================================================================================
FUNCTION IniLoad( cFile )
    LOCAL lSuccess, nFileEnd, nCurrent, hIniFile, cLine, aIni
    LOCAL cItem,    cValue,   nEquPos
    DEFAULT cFile TO "APPLIC"
    IF ! ( "." $ cFile )
        cFile += INIEXT
    ENDIF
    aIni := {}                                  // Initialise array
    hIniFile  := FOPEN( cFile, FO_READ + FO_DENYWRITE )
    IF FERROR() == 0
        IF EMPTY( aIni )
            AADD( aIni, { NULSECT, {} } )
        ENDIF
        nFileEnd := FSEEK( hIniFile, 0, FS_END )     // Find end of file
        FSEEK( hIniFile, 0, FS_SET)                  // Reposition at top
        DO WHILE FSEEK( hIniFile, 0, FS_RELATIVE ) < nFileEnd
            cLine := FReadLyn( hIniFile )
            DO CASE
                CASE EMPTY( cLine )
                    AADD( aIni[ LEN( aIni ), 2 ], { "", "" } )
                CASE LEFT( cLine , 1 ) == ";"
                    AADD( aIni[ LEN( aIni ), 2 ], { cLine, "" } )
                CASE LEFT( cLine, 1 ) == "[" .AND. RIGHT( cLine, 1 ) == "]"
                    cSection := SUBSTR( cLine, 2 )
                    cSection := LEFT( cSection, LEN( cSection ) - 1 )
                    AADD( aIni, { cSection, {} } )
                CASE (nEquPos := AT( "=", cLine )) > 0
                    cItem   := LEFT( cLine , nEquPos - 1)
                    cValue  := SUBSTR( cLine, nEquPos + 1)
                    AADD( aIni[ LEN( aIni ), 2 ], { cItem, cValue } )
                OTHERWISE
                    * Do nothing - it has the wrong structure
            ENDCASE
        ENDDO
        FCLOSE( hIniFile )
    ENDIF
RETURN( aIni )
* ===========================================================================================================
FUNCTION IniGet( aIni, xSection, xItem, lGetName )
    LOCAL aSub, nOutPos, nInPos, cValue
    DEFAULT lGetName TO .F.
    nOutPos := 0
    IF VALTYPE( xSection ) == "N"
        IF ( xSection >= 1 ) .AND. ( xSection < LEN( aIni ) )
            nOutPos   := xSection + 1
        ENDIF
    ELSE
        nOutPos  := ASCAN( aIni, {|x| UPPER(x[1]) == UPPER(xSection) } )
    ENDIF
    IF nOutPos > 0
        IF xItem == NIL
            cValue := aIni[ nOutPos, 1 ]
        ELSE
            nInPos := 0
            IF VALTYPE( xItem ) == "N"
                nInPos := NthItemPos( aIni, nOutPos, xItem )
            ELSE
                nInPos := ASCAN( aIni[ nOutPos, 2 ], {|x| UPPER(x[1]) == UPPER(xItem) } )
            ENDIF
            IF nInPos > 0
                IF lGetName
                    cValue := aIni[ nOutPos, 2, nInPos, 1 ]
                ELSE
                    cValue := aIni[ nOutPos, 2, nInPos, 2 ]
                ENDIF
            ENDIF
        ENDIF
    ENDIF
RETURN( cValue )
* ===========================================================================================================
STATIC FUNCTION FReadLyn( hReadFile )
    LOCAL cReadBuf, cPostBuf, nFilePos, nCharPos, lReadMor, nReadAmt
    lFileEnd := .F.
    nFilePos := FSEEK( hReadFile, 0, FS_RELATIVE )
    cReadBuf := SPACE( BLOKSIZE )
    cPostBuf := ""
    lReadMor := .T.
    DO WHILE lReadMor
        nReadAmt := FREAD( hReadFile, @cReadBuf, BLOKSIZE )
        lReadMor := (! ( CR $ cReadBuf )) .AND. ( nReadAmt == BLOKSIZE )
        IF lReadMor
            cPostBuf += cReadBuf
            cReadBuf := SPACE( BLOKSIZE )
        ELSE
            IF CR $ cReadBuf
                nCharPos := AT( CR, cReadBuf ) - 1
            ELSE
                nCharPos := nReadAmt
            ENDIF
            cPostBuf += LEFT( cReadBuf, nCharPos )
            FSEEK( hReadFile, nFilePos + LEN( cPostBuf ) + 1, FS_SET )
        ENDIF
    ENDDO
    IF LEFT( cPostBuf, 1 ) == LF
        cPostBuf := SUBSTR( cPostBuf, 2 )
    ENDIF
RETURN( cPostBuf )
* ======================================================================== *
* Is the item being tested a key (as opposed to a blank line or a comment. *
STATIC FUNCTION IsAKey( cItem )
    LOCAL lRetVal
    lRetVal := ( LEFT( cItem, 1 ) != ";" )
    lRetVal := lRetVal .AND. (! EMPTY( cItem ) )
RETURN( lRetVal )
* ======================================================================== *
* Determine the actual position in the array of the nth item               *
STATIC FUNCTION NthItemPos( aIni, nOutPos, nItem )
    LOCAL nInPos, nInCntr
    nInCntr := 0
    nInPos  := 1
    DO WHILE ( nInCntr < nItem ) .AND. nInPos <= LEN( aIni[ nOutPos, 2 ] )
        IF IsAKey( aIni[ nOutPos, 2, nInPos, 1 ] )
            nInCntr++
        ENDIF
        IF nInCntr < nItem
            nInPos++
        ENDIF
    ENDDO
    IF nInCntr != nItem
        nInCntr := 0
    ENDIF
RETURN( nInPos )

return nil
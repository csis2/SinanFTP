#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; unzipping versão 1.0 - CSIS Software - 30/04/2018.
; Descompacta arquivos enfileirados na pasta c:\SinanFTP\tmp\deng ou c:\SinanFTP\tmp\chik.

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Iniciando o script unzipping. `r`n"
file.Write(TestString)
file.Close()

GLOBAL argui2 := 0 ; armazena o argumento escolhido pelo usuário.
GLOBAL nFiles := 0 ; armazena a quantidade de arquivos gerados após a descompactacao.

; Testa se o script está rodando com argumento.
if 0 < 1  
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------O script unzipping está rodando sem argumentos. Finalizando script... `r`n"
file.Write(TestString)
file.Close()
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000
ExitApp ; se o argumento não foi encontrado, finaliza o script.
}

loop
{
	switch := %a_index%
	if switch =
	{
	file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
	FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
	TestString := TimeString "-------O script unzipping está rodando com argumento invalido. Finalizando script... `r`n"
	file.Write(TestString)
	file.Close()
	Sleep 3000
	RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
	Sleep 3000
	ExitApp ; se o argumento não foi encontrado, finaliza o script.
	}
	If switch = deng
	{
     	argui2 = 1 ; atribui o valor 1 se o argumento passado for deng.
		FileDelete, c:\SinanFTP\tmp\deng\*.dbf
		Sleep, 3000
		break
		}
	If switch = chik
	{
		argui2 = 2 ; atribui o valor 2 se o argumento passado for chik.
		FileDelete, c:\SinanFTP\tmp\chik\*.dbf
		Sleep, 3000
		break
	}
}

if (argui2 == 1 and !FileExist("c:\sinanftp\tmp\deng\*.zip")) ; procura por arquivos compactados na subpasta 'deng' do SinanFTP.
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Nao foram encontrados arquivos zip na pasta 'deng' para descompactar. `r`n"
file.Write(TestString)
file.Close()
Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000
ExitApp ; 
}

if (argui2 == 2 and !FileExist("c:\sinanftp\tmp\chik\*.zip")) ; procura por arquivos compactados na subpasta 'chik' do SinanFTP.
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Nao foram encontrados arquivos zip na pasta 'chik' para descompactar. `r`n"
file.Write(TestString)
file.Close()
Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000
ExitApp ; 
}

FileList := []

if (argui2 == 1) ; nesse argumento, coloca no array FileList os arquivos na pasta c:\SinanFTP\tmp\deng.
{
Loop, Files, c:\sinanftp\tmp\deng\*.zip
{
FileList.Insert(A_LoopFileFullPath)
}
}
if (argui2 == 2) ; nesse argumento, coloca no array FileList os arquivos na pasta c:\SinanFTP\tmp\chik.
{
Loop, Files, c:\sinanftp\tmp\chik\*.zip
FileList.Insert(A_LoopFileFullPath)
}

FileList.MaxIndex()

if (argui2 == 1) ; nesse argumento, os arquivos serão descompactados na pasta c:\SinanFTP\tmp\deng.
Output_Path := "c:\sinanftp\tmp\deng\"
if (argui2 == 2) ; nesse argumento, os arquivos serão descompactados na pasta c:\SinanFTP\tmp\chik.
Output_Path := "c:\sinanftp\tmp\chik\"

For index, value in FileList
{
Compressed_File := % FileList[A_Index]

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Descompactando " Compressed_File ".`r`n"
file.Write(TestString)
file.Close()
Sleep 2000

RunWait %comspec% /c c:\sinanftp\exe\7za e %Compressed_File% -o%Output_Path% -y
}

Sleep 2000

if (argui2 == 1) ; nesse argumento, identifica quantos arquivos dbf estão presentes na pasta 'deng' após o processo.
{
Loop, c:\sinanftp\tmp\deng\*.dbf, 1, 1
{
numerator += 1
}
numerator +=0
nFiles = %numerator%
if (nFiles<>0)
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Foram encontrados " nFiles " arquivos dbf na pasta 'deng' apos a descompactacao. `r`n"
file.Write(TestString)
file.Close()
Sleep 3000
}
}

if (argui2 == 2) ; nesse argumento, identifica quantos arquivos dbf estão presentes na pasta 'chik' após o processo.
{
Loop, c:\sinanftp\tmp\chik\*.dbf, 1, 1
{
numerator += 1
}
numerator +=0
nFiles = %numerator%
if (nFiles<>0)
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Foram encontrados " nFiles " arquivos dbf na pasta 'chik' apos a descompactacao. `r`n"
file.Write(TestString)
file.Close()
Sleep 3000
}
}

if (argui2 == 1 and !FileExist("c:\sinanftp\tmp\deng\*.dbf")) ; procura por arquivos descompactados na subpasta 'deng' do SinanFTP.
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Nao foram encontrados arquivos dbf na pasta 'deng' apos a descompactacao. `r`n"
file.Write(TestString)
file.Close()
Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000
ExitApp ; 
}

if (argui2 == 2 and !FileExist("c:\sinanftp\tmp\chik\*.dbf")) ; procura por arquivos descompactados na subpasta 'chik' do SinanFTP.
{
file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Nao foram encontrados arquivos dbf na pasta 'chik' apos a descompactacao. `r`n"
file.Write(TestString)
file.Close()
Sleep 3000
RunWait, autotask.exe, c:\SinanFTP\exe, max ; como o processo falhou, agenda uma nova tarefa.
Sleep 3000
RunWait, log_close.bat, c:\SinanFTP\bat, max ; finaliza e renomeia o log.
Sleep 3000
ExitApp ; 
}

file := FileOpen("c:\SinanFTP\log\SinanFTP.log", "a")
FormatTime, TimeString, dd/MM/yyyy hh:mm:ss tt
TestString := TimeString "-------Fim do script unzipping. `r`n"
file.Write(TestString)
file.Close()
Sleep 3000
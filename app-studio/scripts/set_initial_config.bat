@echo off
set originalpath=%cd%
set rootpath=%~dp0
cd %rootpath%

@REM ----------------------------------------------------------------------------
@REM Getting Fusion connection details
@REM ----------------------------------------------------------------------------

cd "..\src\main\resources\conf\services\api\"

set /p HOST="What is your Fusion host? (e.g. localhost, 111.222.333.444 or fusion.example.com -- do not include protocol or port) "

if "%HOST%" == "" (
    echo "No Input"
) else (
    PowerShell -Command "(gc fusion.conf) -replace '^host: .*', 'host: %HOST%' | Set-Content -Encoding UTF8 fusion.conf"
)


set /p PORT="If you know your Fusion port, enter it here: (typically 6764 for Fusion 5, or 8764 for Fusion 4 and earlier) "

if "%PORT%" == "" (
    echo "No Input"
) else (
    PowerShell -Command "(gc fusion.conf) -replace '^port: .*', 'port: %PORT%' | Set-Content -Encoding UTF8 fusion.conf"
)


set /p PROTOCOL="If you know your Fusion protocol (http or https), enter it here: "

if "%PROTOCOL%" == "" (
    echo "No Input"
) else (
    PowerShell -Command "(gc fusion.conf) -replace '^protocol: .*', 'protocol: %PROTOCOL%' | Set-Content -Encoding UTF8 fusion.conf"
)


@REM set /p USERNAME="Please enter your Fusion username here: "
@REM set /p PASSWORD="Please enter your Fusion password here: "

@REM ----------------------------------------------------------------------------
@REM Getting App Name
@REM ----------------------------------------------------------------------------

cd "..\..\platforms\fusion\"

set /p APP="What is the name of your Fusion App? "

if "%APP%" == "" (
    echo "No Input"
) else (
    PowerShell -Command "(gc social.conf) -replace '^collection: .*', 'collection: %APP%_user_prefs' | Set-Content -Encoding UTF8 social.conf"
)

@REM ----------------------------------------------------------------------------
@REM Getting Query Profiles from Fusion
@REM ----------------------------------------------------------------------------

cd "..\..\message\service\"


set /p QPNAME="What is the name of the primary Fusion query profile that you would like to target? "

if "%QPNAME%" == "" (
    echo "No Input"
) else (
    PowerShell -Command "(gc fusion.conf) -replace '^query-profile: .*', 'query-profile: %QPNAME%' | Set-Content -Encoding UTF8 fusion.conf"
)

cd "..\..\platforms\fusion\"


if "%QPNAME%" == "" (
    echo "No Input"
) else (
    PowerShell -Command "(gc data.conf) -replace '^query-profile: .*', 'query-profile: %QPNAME%' | Set-Content -Encoding UTF8 data.conf"
)

cd %rootpath%
cd "..\src\main\webapp\views\"


@REM ----------------------------------------------------------------------------
@REM Update the search.html view
@REM ----------------------------------------------------------------------------

set /p FACETS="Enter the names of any facets you'd like to display (in the format: facet1,facet2,facet3) "

if "%FACETS%" == "" (
    echo "No Input"
) else (
    PowerShell -Command "(gc search.html) -replace '(<search:query.*var=""""query"""".*facets="""").*("""".*></search:query>)','$1%FACETS%$2' | Set-Content -Encoding UTF8 search.html"
)

set /p TITLE="Enter the name of your title field: "

if "%TITLE%" == "" (
    echo "No Input"
) else (
    PowerShell -Command "(gc search.html) -replace '(<search:field.*name="""").*("""".*styling=""""title"""".*)','$1%TITLE%$2' | Set-Content -Encoding UTF8 search.html"
    PowerShell -Command "(gc search.html) -replace '(title=.*field:'').*(''.*)','$1%TITLE%$2' | Set-Content -Encoding UTF8 search.html"
)


set /p URL="Enter the name of your URL field: "

if "%URL%" == "" (
    echo "No Input"
) else (
    PowerShell -Command "(gc search.html) -replace '(<search:field.*styling=""""title"""".*urlfield="""").*("""".*)','$1%URL%$2' | Set-Content -Encoding UTF8 search.html"
)


set /p BODY="Enter the name of your description or body field: "

if "%BODY%" == "" (
    echo "No Input"
) else (
    PowerShell -Command "(gc search.html) -replace '(<search:field.*name="""").*("""".*styling=""""description"""".*)','$1%BODY%$2' | Set-Content -Encoding UTF8 search.html"
)


set /p DATE="Enter the name of your date field: "

if "%DATE%" == "" (
    echo "No Input"
) else (
    PowerShell -Command "(gc search.html) -replace '(<search:field.*name="""").*("""".*label=""""Date Indexed"""".*)','$1%DATE%$2' | Set-Content -Encoding UTF8 search.html"
)

cd %originalpath%
echo "Great! We've updated your project to use these settings. Now run the command 'app-studio.bat start -f' in the project root directory to run the app on your local machine. Your credentials will be the same as your Fusion credentials. For further reference, please go to https://doc.lucidworks.com/app-studio/latest/index.html"
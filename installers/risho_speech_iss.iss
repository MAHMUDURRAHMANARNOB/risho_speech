; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Risho Speech"
#define MyAppVersion "1.0"
#define MyAppPublisher "Shonod"
#define MyAppURL "https://www.rishospeech.com/"
#define MyAppExeName "risho_speech.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{13EC4EDA-3D8E-4324-BE55-7A9449CA3DE7}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
; Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=E:\Flutter Projects\risho_speech\installers
OutputBaseFilename=risho_speech
SetupIconFile=C:\Users\Shonod\Desktop\risho_speech_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "E:\Flutter Projects\risho_speech\build\windows\x64\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "E:\Flutter Projects\risho_speech\build\windows\x64\runner\Release\audioplayers_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "E:\Flutter Projects\risho_speech\build\windows\x64\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "E:\Flutter Projects\risho_speech\build\windows\x64\runner\Release\permission_handler_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "E:\Flutter Projects\risho_speech\build\windows\x64\runner\Release\record_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "E:\Flutter Projects\risho_speech\build\windows\x64\runner\Release\url_launcher_windows_plugin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "E:\Flutter Projects\risho_speech\build\windows\x64\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "E:\Flutter Projects\risho_speech\build\windows\x64\runner\Release\fmedia\*"; DestDir: "{app}\fmedia"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\Windows\System32\msvcp140.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Windows\System32\vcruntime140.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Shonod\Downloads\vcruntime140_1.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Shonod\Downloads\api-ms-win-core-heap-l2-1-0.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Windows\System32\concrt140.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Windows\System32\msvcp140_1.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Windows\System32\msvcp140_2.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Shonod\Downloads\VC_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Code]
function IsVC2015RuntimeInstalled(): Boolean;
var
  Installed: Cardinal;
begin
  Result := RegQueryDWordValue(HKLM, 'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64', 'Installed', Installed) and (Installed = 1);
end;


[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
Filename: "{tmp}\VC_redist.x64.exe"; Parameters: "/install /quiet /norestart"; Flags: waituntilterminated; Check: not IsVC2015RuntimeInstalled


program RADServerDockerDeploy;

{$APPTYPE CONSOLE}

{$R *.res}
{$R *.dres}

uses
  System.Classes,
  System.Types,
  System.SysUtils,
  {$IF DEFINED(POSIX)}
  Posix.Stdlib,
  {$ENDIF POSIX}
  System.IniFiles;

const
  SERVER_PACKAGES = 'Server.Packages';
  TARGET_MODULE_PATH = '/etc/ems/module.so';
  TARGET_SETTINGS_PATH = '/etc/ems/emsserver.ini';

var
  ResStream: TResourceStream;
  IniFile: TMemIniFile;
{$IF DEFINED(POSIX)}
  LCommand: String;
{$ENDIF}
begin
  try
    // Add your RAD Server resource module .so file via Project|Resources and Images...|Add...
    // Be sure to set Identifier to Module and Type should be set to RCDATA
    ResStream := TResourceStream.Create(HInstance, 'Module', RT_RCDATA);
    try
      ResStream.Position := 0;
      ResStream.SaveToFile(TARGET_MODULE_PATH);
    finally
      ResStream.Free;
    end;

    IniFile := TMemIniFile.Create(TARGET_SETTINGS_PATH);

    IniFile.EraseSection(SERVER_PACKAGES);
    IniFile.WriteString(SERVER_PACKAGES,TARGET_MODULE_PATH,ExtractFileName(TARGET_MODULE_PATH));

    IniFile.UpdateFile;
    IniFile.Free;

    {$IF DEFINED(POSIX)}
    LCommand := 'service apache2 restart';
    _system(PAnsiChar(AnsiString(LCommand)));
    {$ENDIF POSIX}

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

unit CFunctions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, dynlibs;

type
  TSDKInit = procedure(); cdecl;
  TSDKYeet = procedure(); cdecl;
  TSDKUpdate = procedure(); cdecl;
  TSDKPlatformWindowScreenResize = procedure(width, height: Integer); cdecl;

var
  sdk_init : TSDKInit;
  sdk_yeet : TSDKYeet;
  sdk_update : TSDKUpdate;
  sdk_platform_window_screen_resize : TSDKPlatformWindowScreenResize;

procedure SDKLoadLibs(const DLLPath: string);

implementation

var
  DLLHandle: TLibHandle = NilHandle;

procedure SDKLoadLibs(const DLLPath: string);
function LoadFunc(const funcName: string): Pointer;
  begin
    Result := GetProcedureAddress(DLLHandle, funcName);
    if Result = nil then
      raise Exception.CreateFmt(
        'Could not find "%s" in "%s"', [funcName, DLLPath]);
  end;
begin
  DLLHandle := LoadLibrary(DLLPath);
  if DLLHandle = NilHandle then
    raise Exception.CreateFmt(
      'Failed to load "%s" with error "%s"',
      [DLLPath, SysErrorMessage(GetLastOSError)]);

  sdk_init := TSDKInit(LoadFunc('tramsdk_init'));
  sdk_yeet := TSDKYeet(LoadFunc('tramsdk_yeet'));
  sdk_update := TSDKUpdate(LoadFunc('tramsdk_update'));
  sdk_platform_window_screen_resize := TSDKPlatformWindowScreenResize(LoadFunc('tramsdk_platform_window_screen_resize'));
end;

end.


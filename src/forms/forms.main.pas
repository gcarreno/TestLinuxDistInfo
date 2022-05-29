unit Forms.Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ActnList,
  StdActns, ExtCtrls, StdCtrls, ComCtrls, DefaultTranslator;

const
  cApplicationTitle = 'Test Linux Distribution Info';
  cVersionMajor    = 0;
  cVersionMinor    = 1;
  cVersionRevision = 1;

  cIssueIndex      = 0;
  cIssueNetIndex   = 1;
  cOsReleaseIndex  = 2;
  cLsbReleaseIndex = 3;

  cFileSeparator     = '---- ✂️ ----------------------------------------------';
  cFileIssue         = '/etc/issue';
  cFileIssueNet      = '/etc/issue.net';
  cFileOsRelease     = '/etc/os-release';
  cFileLsbRelease    = '/etc/lsb-release';
  cCommandLsbRelease = 'lsb_release';

resourcestring
  rsLookingForFile = 'Looking for %s';
  rsFoundFile      = 'Found %s';
  rsDidNotFindFile = 'Did NOT find %s';
  rsContentsOfFile = 'Contents of %s:';
  rsValuesFrom     = 'Some values from %s:';

  rsOsReleaseName             = 'Name: %s';
  rsOsReleaseVersionID        = 'Version ID: %s';
  rsOsReleaseVersionCodename  = 'Version Codename: %s';

  rsLsbReleseDistributionID       = 'Distribution ID: %s';
  rsLsbReleseDistributionRelease  = 'Distribution Release: %s';
  rsLsbReleseDistributionCodename = 'Distribution Codename: %s';


type

{ TfrmMain }
  TfrmMain = class(TForm)
    actInfoQuery: TAction;
    actInfoIssue: TAction;
    actInfoIssueNet: TAction;
    actInfoOsRelease: TAction;
    actInfoLsbRelease: TAction;
    alMain: TActionList;
    actFileExit: TFileExit;
    btnInfoLsbRelease: TButton;
    btnInfoQuery: TButton;
    btnInfoIssueNet: TButton;
    btnInfoIssue: TButton;
    btnInfoOsRelease: TButton;
    cgAvaiilableMethods: TCheckGroup;
    memLog: TMemo;
    mnuInfoIssue: TMenuItem;
    mnuInfoIssueNet: TMenuItem;
    mnuInfoOsRelease: TMenuItem;
    mnuInfoLsbRelease: TMenuItem;
    mnuFile: TMenuItem;
    mnuFileExit: TMenuItem;
    mnuInfo: TMenuItem;
    mnuInfoQuery: TMenuItem;
    mnuInfoSep1: TMenuItem;
    mmMain: TMainMenu;
    panButtons: TPanel;
    sbMain: TStatusBar;
    procedure actInfoIssueExecute(Sender: TObject);
    procedure actInfoIssueNetExecute(Sender: TObject);
    procedure actInfoLsbReleaseExecute(Sender: TObject);
    procedure actInfoOsReleaseExecute(Sender: TObject);
    procedure actInfoQueryExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure InitShortcuts;
    procedure DisplayHint(Sender: TObject);
  public

  end;

var
  frmMain: TfrmMain;

implementation

uses
  LCLType
, FileUtil
, process
;

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.InitShortcuts;
begin
{$IFDEF UNIX}
  actFileExit.ShortCut := KeyToShortCut(VK_Q, [ssCtrl]);
{$ENDIF}
{$IFDEF WINDOWS}
  actFileExit.ShortCut := KeyToShortCut(VK_X, [ssAlt]);
{$ENDIF}
end;

procedure TfrmMain.DisplayHint(Sender: TObject);
begin
  sbMain.SimpleText:= Application.Hint;
end;

procedure TfrmMain.actInfoQueryExecute(Sender: TObject);
begin
  actInfoQuery.Enabled:= False;
  Application.ProcessMessages;

  memLog.Append(Format(rsLookingForFile, [cFileIssue]));
  if FileExists(cFileIssue) then
  begin
    memLog.Append(Format(rsFoundFile, [cFileIssue]));
    cgAvaiilableMethods.Checked[cIssueIndex]:= True;
    actInfoIssue.Visible:= True;
  end
  else
  begin
    memLog.Append(Format(rsDidNotFindFile, [cFileIssue]));
    cgAvaiilableMethods.Checked[cIssueIndex]:= False;
    actInfoIssue.Visible:= False;
  end;
  Application.ProcessMessages;

  memLog.Append(Format(rsLookingForFile, [cFileIssueNet]));
  if FileExists(cFileIssueNet) then
  begin
    memLog.Append(Format(rsFoundFile, [cFileIssueNet]));
    cgAvaiilableMethods.Checked[cIssueNetIndex]:= True;
    actInfoIssueNet.Visible:= True;
  end
  else
  begin
    memLog.Append(Format(rsDidNotFindFile, [cFileIssueNet]));
    cgAvaiilableMethods.Checked[cIssueNetIndex]:= False;
    actInfoIssueNet.Visible:= False;
  end;
  Application.ProcessMessages;

  memLog.Append(Format(rsLookingForFile, [cFileOsRelease]));
  if FileExists(cFileOsRelease) then
  begin
    memLog.Append(Format(rsFoundFile, [cFileOsRelease]));
    cgAvaiilableMethods.Checked[cOsReleaseIndex]:= True;
    actInfoOsRelease.Visible:= True;
  end
  else
  begin
    memLog.Append(Format(rsDidNotFindFile, [cFileOsRelease]));
    cgAvaiilableMethods.Checked[cOsReleaseIndex]:= False;
    actInfoOsRelease.Visible:= False;
  end;
  Application.ProcessMessages;

  memLog.Append(Format(rsLookingForFile, [cFileLsbRelease]));
  if FileExists(cFileLsbRelease) then
  begin
    memLog.Append(Format(rsFoundFile, [cFileLsbRelease]));
    cgAvaiilableMethods.Checked[cLsbReleaseIndex]:= True;
    actInfoLsbRelease.Visible:= True;
  end
  else
  begin
    memLog.Append(Format(rsDidNotFindFile, [cFileLsbRelease]));
    cgAvaiilableMethods.Checked[cLsbReleaseIndex]:= False;
    actInfoLsbRelease.Visible:= False;
  end;
  Application.ProcessMessages;

  Application.ProcessMessages;
  actInfoQuery.Enabled:= True;
end;

procedure TfrmMain.actInfoIssueExecute(Sender: TObject);
begin
  actInfoIssue.Enabled:= False;
  Application.ProcessMessages;

  memLog.Append(Format(rsContentsOfFile, [cFileIssue]));
  memLog.Append(cFileSeparator);
  memLog.Append(ReadFileToString(cFileIssue));
  memLog.Append(cFileSeparator);

  Application.ProcessMessages;
  actInfoIssue.Enabled:= True;
end;

procedure TfrmMain.actInfoIssueNetExecute(Sender: TObject);
begin
  actInfoIssueNet.Enabled:= False;
  Application.ProcessMessages;

  memLog.Append(Format(rsContentsOfFile, [cFileIssueNet]));
  memLog.Append(cFileSeparator);
  memLog.Append(ReadFileToString(cFileIssueNet));
  memLog.Append(cFileSeparator);

  Application.ProcessMessages;
  actInfoIssueNet.Enabled:= True;
end;

procedure TfrmMain.actInfoOsReleaseExecute(Sender: TObject);
var
  osReleaseFile: TStringList;
begin
  actInfoOsRelease.Enabled:= False;
  Application.ProcessMessages;

  osReleaseFile:= TStringList.Create;
  try
    osReleaseFile.LoadFromFile(cFileOsRelease);
    memLog.Append(Format(rsValuesFrom, [cFileOsRelease]));
    memLog.Append(Format(
      rsOsReleaseName,[
        StringReplace(
          osReleaseFile.Values['NAME'],
          '"',
          '',
          [rfReplaceAll]
        )
      ]
    ));
    memLog.Append(Format(
      rsOsReleaseVersionID,[
        StringReplace(
          osReleaseFile.Values['VERSION_ID'],
          '"',
          '',
          [rfReplaceAll]
        )
      ]
    ));
    memLog.Append(Format(
      rsOsReleaseVersionCodename,[
        osReleaseFile.Values['VERSION_CODENAME']
      ]
    ));

    memLog.Append(Format(rsContentsOfFile, [cFileOsRelease]));
    memLog.Append(cFileSeparator);
    memLog.Append(osReleaseFile.Text);
    memLog.Append(cFileSeparator);
  finally
    osReleaseFile.Free;
  end;


  Application.ProcessMessages;
  actInfoOsRelease.Enabled:= True;
end;

procedure TfrmMain.actInfoLsbReleaseExecute(Sender: TObject);
var
  lsbReleaseFile: TStringList;
begin
  actInfoLsbRelease.Enabled:= False;
  Application.ProcessMessages;

  lsbReleaseFile:= TStringList.Create;
  try
    lsbReleaseFile.LoadFromFile(cFileLsbRelease);
    memLog.Append(Format(rsValuesFrom, [cFileLsbRelease]));
    memLog.Append(Format(
      rsLsbReleseDistributionID,
        [lsbReleaseFile.Values['DISTRIB_ID']
      ]
    ));
    memLog.Append(Format(
      rsLsbReleseDistributionRelease,[
        lsbReleaseFile.Values['DISTRIB_RELEASE']
      ]
    ));
    memLog.Append(Format(
      rsLsbReleseDistributionCodename,[
        lsbReleaseFile.Values['DISTRIB_CODENAME']
      ]
    ));

    memLog.Append(Format(rsContentsOfFile, [cFileLsbRelease]));
    memLog.Append(cFileSeparator);
    memLog.Append(lsbReleaseFile.Text);
    memLog.Append(cFileSeparator);
  finally
    lsbReleaseFile.Free;
  end;


  Application.ProcessMessages;
  actInfoLsbRelease.Enabled:= True;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption:= Format('%s v%d.%d.%d', [
    cApplicationTitle,
    cVersionMajor,
    cVersionMinor,
    cVersionRevision
  ]);
  InitShortcuts;
  Application.OnHint:=@DisplayHint;
end;

end.


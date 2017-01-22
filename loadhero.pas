unit loadhero;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, IniFiles,Monstr_Kill;

type

  { TfLoadHero }

  TfLoadHero = class(TForm)
    Button1: TButton;
    Button2: TButton;
    edtName: TEdit;
    edtPass: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLoadHero: TfLoadHero;

implementation

{$R *.lfm}

{ TfLoadHero }

procedure TfLoadHero.Button2Click(Sender: TObject);
var
  pass:string;
  iniFile:TiniFile;
  flag:Boolean;
begin
  flag:=False;
  iniFile:=TiniFile.Create('listh.ini');
  flag:=iniFile.SectionExists(edtName.Text);
  pass:= iniFile.ReadString(edtName.Text,'pass','null');
  iniFile.free();

  if flag
  then begin
       if(pass = edtPass.Text)
       then begin
            loadDataH:=1;
            Close();
            end
       else ShowMessage('Неверный пароль!');
       end
   else ShowMessage('Героя с таким именем не существует.');
end;

end.


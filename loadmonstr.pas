unit loadmonstr;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, IniFiles,Monstr_Kill, LCLType;

type

  { TFormLoadMonstr }

  TFormLoadMonstr = class(TForm)
    ComboBox1: TComboBox;
    Ok: TButton;
    Cancel: TButton;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);




  private
    { private declarations }
   // procedure FormShow(Sender: TObject);
  public
    { public declarations }
  end;

var
  FormLoadMonstr: TFormLoadMonstr;

implementation

{$R *.lfm}
{ TFormLoadMonstr }

procedure TFormLoadMonstr.FormShow(Sender: TObject);
var f:TiniFile;
begin
  //
    ComboBox1.Clear;
    f:=TiniFile.Create('kletka/kletka.ini');
    f.ReadSections(ComboBox1.Items);
    f.Free;
    ComboBox1.ItemIndex:=0;
    loadDataM:=1;
  //
end;



end.


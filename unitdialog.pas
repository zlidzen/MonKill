unit unitDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TDialogForm }

  TDialogForm = class(TForm)
    btnOk: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  DialogForm: TDialogForm;

implementation

{$R *.lfm}

{ TDialogForm }



procedure TDialogForm.FormShow(Sender: TObject);
var
  s:string;
  f:TextFile;
begin
  //
    Memo1.Lines.Clear;
    assignfile(f,'terms.txt');
    reset(f);

    while not EOF(f) do
          begin
           readLn(f,s);
           Memo1.Lines.AddText(s);
          end;

    closefile(f);
  //
end;

end.


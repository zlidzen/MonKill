program Monster_Kill;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Monstr_Kill, unitDialog, loadmonstr, unitlvlup, create_hero, loadhero;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDialogForm, DialogForm);
  Application.CreateForm(TFormLoadMonstr, FormLoadMonstr);
  Application.CreateForm(TFormLvlUp, FormLvlUp);
  Application.CreateForm(TNewHero, NewHero);
  Application.CreateForm(TfLoadHero, fLoadHero);
  Application.Run;
end.


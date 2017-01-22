unit create_hero;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, inifiles;

type

  { TNewHero }

  TNewHero = class(TForm)
    Button1: TButton;
    btnCreateHero: TButton;
    Button3: TButton;
    cmbbClass: TComboBox;
    edtNameHero: TEdit;
    edtPass: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    lblHelhH: TLabel;
    lblPowerH: TLabel;
    lblArmorH: TLabel;
    lblAttackH: TLabel;
    lblBlkH: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure btnCreateHeroClick(Sender: TObject);
    procedure cmbbClassChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  NewHero: TNewHero;

implementation

{$R *.lfm}

{ TNewHero }


// Запись данных о новом герое
procedure TNewHero.btnCreateHeroClick(Sender: TObject);
var
  iniFile:Tinifile;
begin
  iniFile:=TiniFile.Create('listh.ini');
        // редактир
   if(not iniFile.SectionExists(edtNameHero.Text))
        then begin
             iniFile.WriteString(edtNameHero.Text, 'pass', edtPass.Text);
             iniFile.WriteString(edtNameHero.Text, 'lvl', '1');
             iniFile.WriteString(edtNameHero.Text, 'op', '0');
            // iniFile.WriteString(edtNameHero.Text, 'klass', cmbbClass.SelText);
             iniFile.WriteString(edtNameHero.Text, 'helch', lblHelhH.Caption);
             iniFile.WriteString(edtNameHero.Text, 'power', lblPowerH.Caption);
             iniFile.WriteString(edtNameHero.Text, 'armor', lblArmorH.Caption);
             iniFile.WriteString(edtNameHero.Text, 'attackB', '1');
             iniFile.WriteString(edtNameHero.Text, 'blockB', '1');
             // зависимость от класса!!
             if (cmbbClass.SelText = 'DD')
                  then begin
                  iniFile.WriteString(edtNameHero.Text, 'klass', 'DD');
                  iniFile.WriteString(edtNameHero.Text, 'attackG', '6');
                  iniFile.WriteString(edtNameHero.Text, 'blockG', '5');
                  end

              else begin
              iniFile.WriteString(edtNameHero.Text, 'klass', 'T');
              iniFile.WriteString(edtNameHero.Text, 'attackG', '5');
              iniFile.WriteString(edtNameHero.Text, 'blockG', '6');
              end;

              ShowMessage('Герой создан успешно!');
             Close();
             end

        else ShowMessage('Герой с таким именем существует!');

    iniFile.free;
end;

// изменение типа героя
procedure TNewHero.cmbbClassChange(Sender: TObject);
begin
   // DD
   if (cmbbClass.ItemIndex = 0)
        then begin
             lblHelhH.Caption:='25';
             lblPowerH.Caption:='3';
             lblArmorH.Caption:='2';
             lblAttackH.Caption:='6d1';
             lblBlkH.Caption:='5d1';
        end;
   //T
   if (cmbbClass.ItemIndex = 1)
           then begin
                lblHelhH.Caption:='30';
                lblPowerH.Caption:='2';
                lblArmorH.Caption:='3';
                lblAttackH.Caption:='5d1';
                lblBlkH.Caption:='6d1';
                end;
end;

end.


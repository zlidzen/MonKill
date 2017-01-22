unit unitlvlup;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls,Monstr_Kill,inifiles;

type

  { TFormLvlUp }

  TFormLvlUp = class(TForm)
    Button1: TButton;
    Button2: TButton;
    btnSkip: TButton;
    EditUpHp: TEdit;
    EditUpPow: TEdit;
    EditUpArm: TEdit;
    EditUpBAtk: TEdit;
    EditUpBBlk: TEdit;
    EditUpXAtk: TEdit;
    EditUpXBlk: TEdit;
    ImageHero: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lblXAttackHero: TLabel;
    lblXBlockHero: TLabel;
    lblFreeBalls: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblArmorHero: TLabel;
    lblBAttackHero: TLabel;
    lblAttackHero1: TLabel;
    lbBlBlockHero: TLabel;
    lblExp: TLabel;
    lblExp1: TLabel;
    lblHpHero: TLabel;
    lblLvlHero: TLabel;
    lblNameHero: TLabel;
    lblStrongHero: TLabel;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    UpDown4: TUpDown;
    UpDown5: TUpDown;
    UpDown6: TUpDown;
    UpDown7: TUpDown;

    procedure btnSkipClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown3Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown4Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown5Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown6Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown7Click(Sender: TObject; Button: TUDBtnType);


  private
    { private declarations }
   function LockUp(ball:integer):integer;

  public
    { public declarations }
  end;

var
  FormLvlUp: TFormLvlUp;
  giBalls:integer;

implementation

{$R *.lfm}

{ TFormLvlUp }

// формирование стартовых данных
procedure TFormLvlUp.FormShow(Sender: TObject);
begin
  // реальные данные
  lblNameHero.Caption:=hero.name;
  lblLvlHero.Caption:=IntToStr(hero.lvl);
  lblHpHero.Caption:=IntToStr(hero.helsh);
  lblStrongHero.Caption:=IntToStr(hero.power);
  lblArmorHero.Caption:=IntToStr(hero.armor);
  lblBAttackHero.Caption:=IntToStr(hero.dCA);
  lblXAttackHero.Caption:=IntToStr(hero.xDA);
  lbBlBlockHero.Caption:=IntToStr(hero.dCB);
  lblXBlockHero.Caption:=IntToStr(hero.xDB);
  lblExp.Caption:=IntToStr(hero.totExp);

  giBalls:=2;

  // бонусный уровень
  case hero.lvl of
      5,8,11,14:giBalls:=giBalls+4;
  end;

  lblFreeBalls.Caption:=IntToStr(giBalls);

end;

procedure TFormLvlUp.btnSkipClick(Sender: TObject);
begin
  EditUpHp.Text := '0';
  EditUpPow.Text := '0';
  EditUpArm.Text := '0';
  EditUpBAtk.Text := '0';
  EditUpXAtk.Text := '0';
  EditUpBBlk.Text := '0';
  EditUpXBlk.Text := '0';

  UpDown1.Enabled:=True;
  UpDown3.Enabled:=True;
  UpDown2.Enabled:=True;
  UpDown4.Enabled:=True;
  UpDown6.Enabled:=True;
  UpDown5.Enabled:=True;
  UpDown7.Enabled:=True;

  lblFreeBalls.Caption:=IntToStr(giBalls);

end;

// запись изменений
procedure TFormLvlUp.Button1Click(Sender: TObject);
 var
   iniFile:Tinifile;
 begin
   iniFile:=TiniFile.Create('listh.ini');
         // редактир
    if(iniFile.SectionExists(hero.name))
         then begin
              iniFile.WriteString(hero.name, 'op', lblExp.Caption);

              hero.helsh:=hero.helsh+StrToInt(EditUpHp.Text);
              iniFile.WriteString(hero.name, 'helch', IntToStr(hero.helsh));

              hero.power:=hero.power+StrToInt(EditUpPow.Text);
              iniFile.WriteString(hero.name, 'power', IntToStr(hero.power));

              hero.armor:=hero.armor+StrToInt(EditUpArm.Text);
              iniFile.WriteString(hero.name, 'armor', IntToStr(hero.armor));

              hero.dCA:=hero.dCA+StrToInt(EditUpBAtk.Text);
              iniFile.WriteString(hero.name, 'attackB', IntToStr(hero.dCA));

              hero.xDA:=hero.xDA+StrToInt(EditUpXAtk.Text);
              iniFile.WriteString(hero.name, 'attackG', IntToStr(hero.xDA));

              hero.dCB:=hero.dCB+StrToInt(EditUpBBlk.Text);
              iniFile.WriteString(hero.name, 'blockB', IntToStr(hero.dCB));

              hero.xDB:=hero.xDB+StrToInt(EditUpXBlk.Text);
              iniFile.WriteString(hero.name, 'blockG', IntToStr(hero.xDB));
              end;
     iniFile.free;
 end;

// увеличение жизней
procedure TFormLvlUp.UpDown1Click(Sender: TObject; Button: TUDBtnType);
Var
  i:integer;
begin

  i:=StrToInt(EditUpHp.Text);

  If (Button = TUDBtnType.btNext)
  Then EditUpHp.Text:=IntToStr(i+LockUp(1)*10)

  Else if (i>0)
       then EditUpHp.Text:=IntToStr(i-LockUp(-1)*10);

  UpDown1.Enabled:=True;

end;

// Увеличение брони
procedure TFormLvlUp.UpDown2Click(Sender: TObject; Button: TUDBtnType);
Var
  i:integer;
begin
  i:=StrToInt(EditUpArm.Text);

  If (Button = TUDBtnType.btNext)
  Then EditUpArm.Text:=IntToStr(i+LockUp(1)*2)

  Else if (i>0)
       then EditUpArm.Text:=IntToStr(i-LockUp(-1)*2);

  UpDown2.Enabled:=True;

end;

// Увеличение Силы
procedure TFormLvlUp.UpDown3Click(Sender: TObject; Button: TUDBtnType);
 Var
  i:integer;
begin
  i:=StrToInt(EditUpPow.Text);

  If (Button = TUDBtnType.btNext)
  Then EditUpPow.Text:=IntToStr(i+LockUp(1)*2)

  Else if (i>0)
       then EditUpPow.Text:=IntToStr(i-LockUp(-1)*2);

  UpDown3.Enabled:=True;

end;

// Увеличение броска атаки
procedure TFormLvlUp.UpDown4Click(Sender: TObject; Button: TUDBtnType);
 Var
  i:integer;
begin
  i:=StrToInt(EditUpBAtk.Text);

  If (Button = TUDBtnType.btNext)
  Then EditUpBAtk.Text:=IntToStr(i+LockUp(2)*1)

  Else if (i>0)
       then EditUpBAtk.Text:=IntToStr(i-LockUp(-2)*1);

  UpDown4.Enabled:=True;

end;

// увеличение броска защиты
procedure TFormLvlUp.UpDown5Click(Sender: TObject; Button: TUDBtnType);
 Var
    i:integer;
  begin
    i:=StrToInt(EditUpBBlk.Text);

    If (Button = TUDBtnType.btNext)
    Then EditUpBBlk.Text:=IntToStr(i+LockUp(2)*1)

    Else if (i>0)
         then EditUpBBlk.Text:=IntToStr(i-LockUp(-2)*1);

    UpDown5.Enabled:=True;

  end;

// увеличение значения атаки
procedure TFormLvlUp.UpDown6Click(Sender: TObject; Button: TUDBtnType);
 Var
   i:integer;
 begin
   i:=StrToInt(EditUpXAtk.Text);

   If (Button = TUDBtnType.btNext)
   Then EditUpXAtk.Text:=IntToStr(i+LockUp(1)*1)

   Else if (i>0)
        then EditUpXAtk.Text:=IntToStr(i-LockUp(-1)*1);

  UpDown6.Enabled:=True;

 end;

// увеличение значения защиты
procedure TFormLvlUp.UpDown7Click(Sender: TObject; Button: TUDBtnType);
 Var
    i:integer;
  begin
    i:=StrToInt(EditUpXBlk.Text);

    If (Button = TUDBtnType.btNext)
    Then EditUpXBlk.Text:=IntToStr(i+LockUp(1)*1)

    Else if (i>0)
         then EditUpXBlk.Text:=IntToStr(i-LockUp(-1)*1);

    UpDown7.Enabled:=True;

  end;

// преключение клавиш и свободных очков
function TFormLvlUp.LockUp(ball:integer):integer;
var j:integer;
begin
  j:=StrToInt(lblFreeBalls.Caption);

  j:=j-ball;

  if (j>0) and (j<=giBalls)
  then begin
       lblFreeBalls.Caption:=IntToStr(j);

       UpDown1.Enabled:=True;
       UpDown3.Enabled:=True;
       UpDown2.Enabled:=True;
       UpDown4.Enabled:=True;
       UpDown6.Enabled:=True;
       UpDown5.Enabled:=True;
       UpDown7.Enabled:=True;

       Result:=1;
       end
   else if (j = 0)
        then begin

             UpDown1.Enabled:=False;
             UpDown3.Enabled:=False;
             UpDown2.Enabled:=False;
             UpDown4.Enabled:=False;
             UpDown6.Enabled:=False;
             UpDown5.Enabled:=False;
             UpDown7.Enabled:=False;

             //if (StrToInt(EditUpHp.Text) = 0) then UpDown1.Enabled:=False;
             //if (StrToInt(EditUpPow.Text) = 0) then UpDown3.Enabled:=False;
             //if (StrToInt(EditUpArm.Text) = 0) then UpDown2.Enabled:=False;
             //if (StrToInt(EditUpBAtk.Text) = 0) then UpDown4.Enabled:=False;
             //if (StrToInt(EditUpXAtk.Text) = 0) then UpDown6.Enabled:=False;
             //if (StrToInt(EditUpBBlk.Text) = 0) then UpDown5.Enabled:=False;
             //if (StrToInt(EditUpXBlk.Text) = 0) then UpDown7.Enabled:=False;

             lblFreeBalls.Caption:=IntToStr(j);
             Result:=1;
             end
        else Result:=0;

end;

end.


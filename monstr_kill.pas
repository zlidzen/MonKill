unit Monstr_Kill;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, Menus, inifiles;

type

  { TMainForm }

  TMainForm = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    btnAction: TButton;
    chbHead: TCheckBox;
    chbArms: TCheckBox;
    chbBody: TCheckBox;
    chbFut: TCheckBox;
    ImageHero: TImage;
    ImageMon: TImage;
    Label1: TLabel;
    lblBlockMonstr: TLabel;
    lblAction: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    lblBlockHero: TLabel;
    lblAttakMon: TLabel;
    lblExp: TLabel;
    lblExp1: TLabel;
    lblAttackHero: TLabel;
    lblAttackHero1: TLabel;
    lblLvlMonstr: TLabel;
    lblLv: TLabel;
    lblLvlHero: TLabel;
    lblArmorMonstr: TLabel;
    lblStrongMonstr: TLabel;
    lblHpMonstr: TLabel;
    lblNameMonstr: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblArmorHero: TLabel;
    lblStrongHero: TLabel;
    lblHpHero: TLabel;
    lblNameHero: TLabel;
    MainMenu: TMainMenu;
    memOutAction: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItemFile1: TMenuItem;
    MenuItemFile5: TMenuItem;
    MenuItemHelp: TMenuItem;
    MenuItemAbout: TMenuItem;
    MenuItemFile: TMenuItem;
    pBarResult: TProgressBar;
    ProgressBar1: TProgressBar;

    procedure btnActionClick(Sender: TObject);
    procedure chbArmsChange(Sender: TObject);
    procedure chbBodyChange(Sender: TObject);
    procedure chbFutChange(Sender: TObject);
    procedure chbHeadChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure MenuItemAboutClick(Sender: TObject);
    procedure MenuItemFile1Click(Sender: TObject);
    procedure MenuItemFile5Click(Sender: TObject);
    procedure MenuItemHelpClick(Sender: TObject);

  private
    { private declarations }

  public
    { public declarations }
    procedure checkedDotBlk(cDot:integer);
    procedure checkedDotAt(cDot:integer);
    procedure LoadHero(pNameHero:string);
    procedure UpdateForm();
    procedure LoadMonstr();
    procedure SaveHero();
    procedure UpLvLHero();
     function MonstrBlock (iDotHAt:integer; iCHAt:integer; iCMBl:integer):integer;
     function HeroBlock (iCMAt:integer; iCHBl:integer):integer;
  end;

  type man = record
    name:string;
    lvl:integer;
    helsh:integer;
    power:integer;
    armor:integer;
    xDA:integer;
    dCA:integer;
    xDB:integer;
    dCB:integer;
    totExp:integer;
    end;

  type mon = record
    name:string;
    lvl:integer;
    helsh:integer;
    power:integer;
    armor:integer;
    xDA:integer;
    dCA:integer;
    xDB:integer;
    dCB:integer;
    end;

var
  MainForm: TMainForm;
  myFileText:textfile;
  hero:man;
  monstr:mon;
  iNumMon:string;
  iGlobStart, iGlobDotAt, iMaxCDot, iSaveDot1, iSaveDot2, loadDataH,loadDataM:integer;


implementation
//!!!!!!!!!!!!!!!!!!!!!
uses unitDialog,loadmonstr,unitlvlup,create_hero,loadhero;

{$R *.lfm}

{ TMainForm }

// функция броска кубика
function kubik (xDot:integer; dCount: integer):integer;

var
rez,i:integer;
begin
    rez:=0;
    for i:=0 to dCount - 1 do
    begin
    Randomize();
    rez:= rez + Random(xDot) + 1;
    end;
    Result:=rez;
end;

// ф-я подбора части тела
function pice(i:integer):string;
begin
  case i of
      0:Result:='голову';
      1:Result:='руки';
      2:Result:='туловище';
      3:Result:='ноги';
    end;
end;

// Функция действий монстра
function TMainForm.MonstrBlock (iDotHAt:integer; iCHAt:integer; iCMBl:integer):integer;
var
iDotBl1, iDotBl2:Integer;

begin
    Randomize();
    iDotBl1 := Random(4);

    repeat
      begin
            sleep(15);
            Randomize();
            iDotBl2 := Random(4);
      end;
    until (iDotBl2 <> iDotBl1);


    if ((iDotBl1 = iDotHAt)or(iDotBl2 = iDotHAt))
    then Result := iCHAt - iCMBl
    else Result := iCHAt;

    memOutAction.Lines.Add('Монстр защищает: '+pice(iDotBl1)+' и '+pice(iDotBl2));
    memOutAction.Lines.Add('Герой атакует: '+pice(iDotHAt));
 end;

// пробитие брони
function TMainForm.HeroBlock (iCMAt:integer; iCHBl:integer):integer;
var iDotMAt:integer;
begin
    Randomize();
    sleep(15);
    iDotMAt := Random(4);

    if ((iSaveDot1 = iDotMAt)or(iSaveDot2 = iDotMAt))
    then Result := iCMAt - iCHBl
    else Result := iCMAt;

    //memOutAction.Lines.Add('Защита героя: '+IntToStr(iSaveDot1)+' '+IntToStr(iSaveDot2));
    memOutAction.Lines.Add('Герой защитил: '+pice(iSaveDot1)+' и '+pice(iSaveDot2));
    memOutAction.Lines.Add('Монстр атаковал: '+pice(iDotMAt));

end;

// процедура загрузки данных героя
procedure TMainForm.LoadHero(pNameHero:string);
var
   iniFile:Tinifile;
   s:string;
begin
    //
    iniFile:=TiniFile.Create('listh.ini');

    hero.name:=pNameHero;    // имя

    s:=iniFile.ReadString(pNameHero,'lvl','null');
    hero.lvl:=StrToInt(s);   // LvL

    s:=iniFile.ReadString(pNameHero,'helch','null');
    hero.helsh:=StrToInt(s); // здоровье

    s:=iniFile.ReadString(pNameHero,'power','null');
    hero.power:=StrToInt(s); // сила

    s:=iniFile.ReadString(pNameHero,'armor','null');
    hero.armor:=StrToInt(s); // броня

    s:=iniFile.ReadString(pNameHero,'attackG','null');
    hero.xDA:=StrToInt(s);   // кол-во граней Атаки

    s:=iniFile.ReadString(pNameHero,'attackB','null');
    hero.dCA:=StrToInt(s);   // кол-во броскв Атаки

    s:=iniFile.ReadString(pNameHero,'blockG','null');
    hero.xDB:=StrToInt(s);   // кол-во граней Защиты

    s:=iniFile.ReadString(pNameHero,'blockB','null');
    hero.dCB:=StrToInt(s);   // кол-во броскв Защиты

    s:=iniFile.ReadString(pNameHero,'op','null');
    hero.totExp:=StrToInt(s); // экспа

    iniFile.free;
end;

// ОБНОВЛЕНИЕ формы
procedure TMainForm.UpdateForm();
begin
    lblLvlHero.Caption:=IntToStr(hero.lvl);   // LvL
    lblHpHero.Caption:=IntToStr(hero.helsh); // здоровье
    lblStrongHero.Caption:=IntToStr(hero.power); // сила
    lblArmorHero.Caption:=IntToStr(hero.armor); // броня

    lblExp.Caption:=IntToStr(hero.totExp)+' .K';  // опыт
    lblAttackHero.Caption:=IntToStr(hero.dCA)+'d'+IntToStr(hero.xDA);
    lblBlockHero.Caption:=IntToStr(hero.dCB)+'d'+IntToStr(hero.xDB);;

    lblNameHero.caption:=hero.name;
    ProgressBar1.Max:=hero.helsh;

    ImageHero.Picture.LoadFromFile('koala.jpg');
end;

// процедура увеличения уровня
procedure TMainForm.UpLvLHero();
var
expBuff:Double;
lvlBuff:integer;
begin
    expBuff:=0;
    lvlBuff:= hero.lvl;

    if(hero.lvl > monstr.lvl)
    then expBuff := 10 + (monstr.lvl - hero.lvl) //Frac(monstr.lvl / hero.lvl) * 10
    else expBuff := (monstr.lvl div hero.lvl) * 10;

    hero.totExp:=hero.totExp + Trunc(expBuff);

    ShowMessage('Монстр побежден! Вы получили '+FloatToStr(expBuff)+' K экспириенcа');

    case hero.totExp of
      30..70:hero.lvl:=2;
      71..110:hero.lvl:=3;
      111..150:hero.lvl:=4;
      151..190:hero.lvl:=5;
      191..230:hero.lvl:=6;
      231..270:hero.lvl:=7;
      271..310:hero.lvl:=8;
      311..350:hero.lvl:=9;
      351..390:hero.lvl:=10;
      391..410:hero.lvl:=11;
      411..450:hero.lvl:=12;
      451..490:hero.lvl:=13;
      491..540:hero.lvl:=14;
      541..590:hero.lvl:=15;
    end;

    if (lvlBuff<>hero.lvl)
    then begin

         if FormLvlUp.ShowModal = mrOK
         then ShowMessage('Уровень повышен!');

         end;
end;

// процедура сохранения данных героя
procedure TMainForm.SaveHero();
var
   iniFile:Tinifile;
begin

    iniFile:=TiniFile.Create('listh.ini');

    iniFile.WriteString(hero.name, 'lvl', IntToStr(hero.lvl));     // LvL
    iniFile.WriteString(hero.name, 'helch', IntToStr(hero.helsh)); // здоровье
    iniFile.WriteString(hero.name, 'power', IntToStr(hero.power)); // сила
    iniFile.WriteString(hero.name, 'armor', IntToStr(hero.armor)); // броня
    iniFile.WriteString(hero.name, 'attackG', IntToStr(hero.xDA)); // кол-во граней Атаки
    iniFile.WriteString(hero.name, 'attackB', IntToStr(hero.dCA)); // кол-во броскв Атаки
    iniFile.WriteString(hero.name, 'blockG', IntToStr(hero.xDB));  // кол-во граней Защиты
    iniFile.WriteString(hero.name, 'blockB', IntToStr(hero.dCB));  // кол-во броскв Защиты
    iniFile.WriteString(hero.name, 'op', IntToStr(hero.totExp));   // кол-во опыта

    iniFile.free;

end;

// процедура загрузки данных монстра
procedure TMainForm.LoadMonstr();
var s:string;
    f:TiniFile;
begin
    f:=TiniFile.Create('kletka/kletka.ini');
     //
    monstr.name:=iNumMon;    // имя

    s:=f.ReadString(iNumMon,'lvl','null');         // ЛвЛ
    lblLvlMonstr.Caption:=s;
    monstr.lvl:=StrToInt(s);

    s:=f.ReadString(iNumMon,'helch','null');   // здоровье
    lblHpMonstr.Caption:=s;
    monstr.helsh:=StrToInt(s);

    s:=f.ReadString(iNumMon,'power','null');  // сила
    lblStrongMonstr.Caption:=s;
    monstr.power:=StrToInt(s);

    s:=f.ReadString(iNumMon,'armor','null');  // броня
    lblArmorMonstr.Caption:=s;
    monstr.armor:=StrToInt(s);

    s:=f.ReadString(iNumMon,'attackG','null'); // кол-во граней Атаки
    monstr.xDA:=StrToInt(s);

    s:=f.ReadString(iNumMon,'attackB','null'); // кол-во броскв Атаки
    monstr.dCA:=StrToInt(s);

    s:=f.ReadString(iNumMon,'blockG','null'); // кол-во граней Защиты
    monstr.xDB:=StrToInt(s);

    s:=f.ReadString(iNumMon,'blockB','null'); // кол-во броскв Защиты
    monstr.dCB:=StrToInt(s);

    s:=f.ReadString(iNumMon,'scr','null'); // JPG
    ImageMon.Picture.LoadFromFile('kletka\'+s+'.jpg');

    f.Free;

    lblAttakMon.Caption:=IntToStr(monstr.dCA)+'d'+IntToStr(monstr.xDA);
    lblBlockMonstr.Caption:=IntToStr(monstr.dCB)+'d'+IntToStr(monstr.xDB);

    lblNameMonstr.caption:=monstr.name;
    pBarResult.Max:=monstr.helsh;
end;

// процедура выбора точки атаки
procedure TMainForm.checkedDotAt(cDot:integer);
begin
    case cDot of
       0:begin
              //chbHead.Checked
              chbArms.Checked := False;
              chbBody.Checked :=False;
              chbFut.Checked :=False;
              end;

       1:begin
              chbHead.Checked := False;
              //chbArms.Checked := False;
              chbBody.Checked :=False;
              chbFut.Checked :=False;
              end;

       2:begin
              chbHead.Checked := False;
              chbArms.Checked := False;
              //chbBody.Checked :=False;
              chbFut.Checked :=False;
              end;

       3:begin
              chbHead.Checked := False;
              chbArms.Checked := False;
              chbBody.Checked :=False;
              //chbFut.Checked :=False;
              end;
       end;//case
       iSaveDot1:=cDot;
end;

// процедура выбора точек защиты
procedure TMainForm.checkedDotBlk(cDot:integer);
var
bl: array[0..3] of integer;
i,S:integer;
begin
    s:=0;
    for i:=0 to 3 do bl[i]:=0;

    if (chbHead.Checked)
    then bl[0]:=1;

    if (chbArms.Checked)
    then bl[1]:=1;

    if (chbBody.Checked)
    then bl[2]:=1;

    if (chbFut.Checked)
    then bl[3]:=1;

    for i:=0 to 3 do S:=S+bl[i];

    case S of
         1: begin
            iSaveDot1:=cDot;
            end;

         2: begin
            iSaveDot2:=cDot;
            end;

         3: begin
            case iSaveDot2 of
                  0:chbHead.Checked:=False;
                  1:chbArms.Checked:=False;
                  2:chbBody.Checked:=False;
                  3:chbFut.Checked:=False;
                 end;

             case cDot of
                  0:chbHead.Checked:=True;
                  1:chbArms.Checked:=True;
                  2:chbBody.Checked:=True;
                  3:chbFut.Checked:=True;
                 end;

            iSaveDot2:=cDot;
            end;//3

    end;//case
end;

// кнопка действий
procedure TMainForm.btnActionClick(Sender: TObject);
var
cMonstrAt,cMonstrBl,cHeroAt,cHeroBl,iDamage:Integer;

begin
   if (iGlobStart = 1)  // 1 = Attack; 2 = Block
   then begin
        cHeroAt:=kubik(hero.xDA,hero.dCA) + hero.power;
        sleep(15);
        cMonstrBl:=kubik(monstr.xDB,monstr.dCB) + monstr.armor;

        iDamage := MonstrBlock(iSaveDot1, cHeroAt, cMonstrBl);

        if (iDamage > 0)
        then begin
             pBarResult.Position := pBarResult.Position - iDamage;
             lblHpMonstr.Caption := IntToStr(pBarResult.Position);
             end
        else iDamage:=0;

        memOutAction.Lines.Add('Вы атака: '+IntToStr(cHeroAt)+' --> Монстр защита: '+IntToStr(cMonstrBl));
        memOutAction.Lines.Add('Урон: '+IntToStr(iDamage));

        if (pBarResult.Position <= 0)
        then begin
             btnAction.Enabled:=False;
             UpLvLHero();
             SaveHero();
             end

        else begin
             iGlobStart := 2;
             lblAction.Caption:='Защита!';
             btnAction.Caption:='Защита!';
             end;
         end //then

   else begin
        cHeroBl:=kubik(hero.xDB,hero.dCB) + hero.armor;
        sleep(15);
        cMonstrAt:=kubik(monstr.xDA,monstr.dCA) + monstr.power;

        iDamage := HeroBlock(cMonstrAt, cHeroBl);
        if (iDamage > 0)
        then begin
             ProgressBar1.Position := ProgressBar1.Position - iDamage;
             lblHpHero.Caption:=IntToStr(ProgressBar1.Position);
             end
        else iDamage:=0;

        memOutAction.Lines.Add('Вы защита: '+IntToStr(cHeroBl)+' <-- Монстр атака: '+IntToStr(cMonstrAt));
        memOutAction.Lines.Add('Урон: '+IntToStr(iDamage));

        if (ProgressBar1.Position <= 0)
        then begin
             ShowMessage('Вас побили!');
             memOutAction.Lines.Add('Вас побили!');
             memOutAction.Lines.Add('Для продолжения - Файл/В бой!');
             btnAction.Enabled:=False;
             end

        else begin
             iGlobStart := 1;
             lblAction.Caption:='Атака!';
             btnAction.Caption:='Атака!';
             end;

        //memOutAction.Lines.Add('HP: '+IntToStr(ProgressBar1.Position));
   end; //else
   iSaveDot1:=-1;
   iSaveDot2:=-1;
   chbHead.Checked := False;
   chbArms.Checked := False;
   chbBody.Checked :=False;
   chbFut.Checked :=False;
end;

 // chb1
procedure TMainForm.chbArmsChange(Sender: TObject);
begin
  if (chbArms.Checked)
  then begin
       if (iGlobStart = 1)
          then checkedDotAt(1)
          else checkedDotBlk(1);
          end;
end;
 // chb2
procedure TMainForm.chbBodyChange(Sender: TObject);
begin
    if (chbBody.Checked)
       then begin
            if (iGlobStart = 1)
                then checkedDotAt(2)
                else checkedDotBlk(2);
                end;
end;
 // chb3
procedure TMainForm.chbFutChange(Sender: TObject);
begin
  if (chbFut.Checked)
  then begin
       if(iGlobStart = 1)
       then checkedDotAt(3)
       else checkedDotBlk(3);
       end;
end;
 // chb0
procedure TMainForm.chbHeadChange(Sender: TObject);
begin
  if (chbHead.Checked)
  then begin
       if(iGlobStart = 1)
       then checkedDotAt(0)
       else checkedDotBlk(0);
       end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
 loadDataH:=0;
 loadDataM:=0;
end;


// Создать Героя
procedure TMainForm.MenuItem3Click(Sender: TObject);
var
  iniFile:Tinifile;
  str:string;
begin

  if NewHero.ShowModal = mrOK
  then begin
       iniFile:=TiniFile.Create('listh.ini');
       str:=iniFile.ReadString(NewHero.edtNameHero.Text,'pass','null');
       iniFile.free;
       ShowMessage('Герой создан! '+ str);
       end;
end;

// загрузить героя
procedure TMainForm.MenuItem4Click(Sender: TObject);
begin
 // окно загрузить героя
  fLoadHero.ShowModal();
   if (loadDataH = 1)
   then begin
         LoadHero(fLoadHero.edtName.Text);
         MenuItem9.Enabled:=True;
         UpdateForm();
        end;
end;

// п_меню загрузить монстра
procedure TMainForm.MenuItem7Click(Sender: TObject);
begin
 iNumMon :='';
  if FormLoadMonstr.ShowModal = mrOK
  then iNumMon := FormLoadMonstr.ComboBox1.Items[FormLoadMonstr.ComboBox1.ItemIndex];

  ShowMessage('Выбран монстр ' + iNumMon);
  LoadMonstr();
end;


// сохранить героя
procedure TMainForm.MenuItem9Click(Sender: TObject);
begin
  MenuItem9.Enabled:=False;
  SaveHero();
end;

// о программе
procedure TMainForm.MenuItemAboutClick(Sender: TObject);
begin
  ShowMessage('Программа MonstrKill v.2.953'+#13+'Все права защищены! (c) GiT_Labs'+#13+'2016 г.'
  +#13+'gitlab.by');
end;

// процедура стартовой кнопки
procedure TMainForm.MenuItemFile1Click(Sender: TObject);
begin

    if (loadDataH = 0)// if_general
    then ShowMessage('Герой не загружен!')
    else if (loadDataM = 0)
         then ShowMessage('Монстр не выбран!')
         else begin // if_general
              UpdateForm();
              LoadMonstr();

              Randomize();
              iGlobStart:=Random(2)+1; // 1 = Attack; 2 = Block
              iSaveDot1:=-1;
              iSaveDot2:=-1;

              if (iGlobStart = 1)
              then begin
                   lblAction.Caption:='Атака!';
                   btnAction.Caption:='Атака!';
                   end
              else begin
                   lblAction.Caption:='Защита!';
                   btnAction.Caption:='Защита!';
                   end;

              iMaxCDot:=1;

              pBarResult.Position := pBarResult.Max;
              ProgressBar1.Position := ProgressBar1.Max;

              memOutAction.Lines.Clear;
              memOutAction.Lines.Add('Покатила!');
              btnAction.Enabled:=True;
              end; // if_general
end;

// Close
procedure TMainForm.MenuItemFile5Click(Sender: TObject);
begin
  Close();
end;

// Справка
procedure TMainForm.MenuItemHelpClick(Sender: TObject);
begin
  if DialogForm.ShowModal = mrOK
  then lblNameMonstr.Caption:='Прочитано';
end;

end.


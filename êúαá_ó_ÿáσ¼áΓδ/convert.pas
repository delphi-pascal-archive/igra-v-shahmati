unit convert;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm5 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}
uses deplacements,fonctions,variables;
procedure TForm5.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm5.Button2Click(Sender: TObject);
var i,k       :integer;
    s,s1,laligne      :string;
    La_couleur:boolean;

var    qui:Integer;
       ColDou,liDou:Char;
       ou,dou:T_str2;
       PRise:Boolean;
       dep:integer;
Function finalise:boolean;
var j,ar:integer;
begin
  finalise:=false;
  Coups_Possibles.Nb_pos:=0;
  generer_liste_coup(la_couleur);
  ar:=enchiffre(ou);
  if (ar<0) or (ar>63) then exit;
  For j:=1 to  Coups_Possibles.Nb_pos do
  begin
    dep:=Coups_Possibles.position[j,1];
    dou:=cartesien(dep);
    if ar=Coups_Possibles.position[j,2] then
    if (qui=posit.Cases[dep]) then
    if  (coldou='n') or (coldou=dou[1]) then
    if  (Lidou='n')  or  (lidou=dou[2])  then
    if (prise=false) or  (posit.Cases[ar]*posit.Cases[dep]<0) then
    begin
      Laligne:=Laligne+dou+ou;
      finalise:=true;
      jouer(dep,ar,dep);
      exit;
    end;
  end;

end;
function traite(lecoups:string):boolean;
begin
   traite:=false;
   While lecoups[length(lecoups)]=' ' do delete(lecoups,length(lecoups),1);
   If pos('+',lecoups)<>0 then delete(lecoups,pos('+',lecoups),1);
   If length(lecoups)<2 then exit;
   If la_couleur=false then
   begin
     If lecoups='O-O' then
     begin
       laligne:=laligne+'e1g1';traite:=true;exit;
     end;
     If lecoups='O-O-O' then
     begin
      laligne:=laligne+'e1c1';traite:=true;exit;
     end;
   end else
   begin
     If lecoups='O-O' then
     begin
       laligne:=laligne+'e8g8';traite:=true;exit;
     end;
     If lecoups='O-O-O' then
     begin
      laligne:=laligne+'e8c8';traite:=true;exit;
     end;
   end;
   {ou:='';}ou:=ou+lecoups[length(lecoups)-1]+lecoups[length(lecoups)];
   If length(lecoups)=2 then lecoups:='' else Delete(lecoups,length(lecoups)-1,2);

   Qui:=6;
   If pos('K',lecoups)<>0 then begin qui:=1;delete(lecoups,pos('K',lecoups),1);end;
   If pos('Q',lecoups)<>0 then begin qui:=2;delete(lecoups,pos('Q',lecoups),1);end;
   If pos('B',lecoups)<>0 then begin qui:=3;delete(lecoups,pos('B',lecoups),1);end;
   If pos('N',lecoups)<>0 then begin qui:=4;delete(lecoups,pos('N',lecoups),1);end;
   If pos('R',lecoups)<>0 then begin qui:=5;delete(lecoups,pos('R',lecoups),1);end;
   If la_Couleur then qui:=-qui;
   If pos('x',lecoups)<>0 then
   begin
     Prise:=true;
     delete(lecoups,pos('x',lecoups),1);
   end else prise:=false;
   ColDou:='n';LiDou:='n';
   if length(lecoups)<>0 then If pos(lecoups[1],'abcdefgh')<>0 then ColDou:=lecoups[1];
   if length(lecoups)<>0 then If pos(lecoups[1],'12345678')<>0 then LiDou:=lecoups[1];
   if not finalise then exit;
   If length(lecoups)<>0 then If pos(lecoups[1],'abcdefgh12345678')=0 then
   begin
     showmessage('Reste : '+lecoups);
     exit;
   end;
   traite:=true;
end;

begin
  s1:='';
  For i:=0 to Form5.memo1.lines.count do
  begin
    s:=Form5.memo1.lines[i];
    k:=pos('}',s);
    If k=0 then s:='' else  delete(s,1,k);
    if pos('1.',s)<> 0 then delete(s,pos('1.',s),2);
    if pos('2.',s)<> 0 then delete(s,pos('2.',s),2);
    if pos('3.',s)<> 0 then delete(s,pos('3.',s),2);
    if pos('4.',s)<> 0 then delete(s,pos('4.',s),2);
    if pos('5.',s)<> 0 then delete(s,pos('5.',s),2);
    if pos('6.',s)<> 0 then delete(s,pos('6.',s),2);
    if pos('7.',s)<> 0 then delete(s,pos('7.',s),200);
    if pos('8.',s)<> 0 then delete(s,pos('8.',s),200);
    initialisation;
    La_couleur:=False;
    laligne:='';
    While length(s)>0 do
    begin
      while s[1]=' ' do delete(s,1,1);
      If not (s='') then
      begin
         k:=1;s1:='';
         While not ( (k>length(s)) or (s[k]=' ') ) do
         begin
           s1:=s1+s[k];
           inc(k);
         end;
         delete(s,1,k);
         if not traite(s1) then
         begin
           showmessage('erreur ligne '+strint(i) );
           exit;
         end;
         La_couleur:=not la_couleur;
      end;
    end;
    Form5.memo1.lines[i]:=laligne;
 end;
end;
end.

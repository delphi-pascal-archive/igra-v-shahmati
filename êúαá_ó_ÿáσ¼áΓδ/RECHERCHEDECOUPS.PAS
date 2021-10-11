unit recherchedecoups;
interface
procedure Affiche;
// Auteur Montero-Ribas
// Logiciel sous license GNU GPL
procedure Recherche(const color: boolean);

implementation
uses windows, SysUtils, variables, deplacements, dialogs, fonctions, evaluation, forms, echec1, math, Graphics, plateau;

procedure Tri_Nimportequoi(var li: t_liste_coup; const n: integer);
var
  s, sj, sl, sr, j, S1: LongInt; // Merci à John Fullspeed
  Code: smallint;
  Resa_Chiffre: T_Element;
  St: array[0..100, 0..1] of LongInt;
begin
  with li do
  begin
    S := 1;
    st[S, 0] := 1;
    st[S, 1] := n;
    repeat
      sl := st[S, 0];
      sr := st[S, 1];
      S := pred(S);
      repeat
        j := sl;
        sj := sr;
        S1 := (sl + sr) div 2;
        Code := -position[S1, 4];
        repeat
          while (-position[J, 4] < Code) do
            j := j + 1;
          while (Code < -position[Sj, 4]) do
            SJ := Sj - 1;
          if j <= sj then
          begin
            Resa_Chiffre := position[Sj];
            position[Sj] := position[j];
            position[j] := Resa_Chiffre;
            j := Succ(J);
            sj := Pred(sj);
          end;
        until j > sj;
        if j < sr then
        begin
          S := Succ(S);
          St[S, 0] := j;
          St[S, 1] := sr;
        end;
        sr := sj;
      until sl >= sr;
    until S < 1;
  end;
end;

function feuilletrue(const beta: integer): integer;
var j, evalupremier,evalupremierpourj, evalu, Le_Meilleur, i, arrivee,deprime: integer;
  encours: T_echiquier;
  Squize, yena: boolean;
  cbpb:integer;
begin
  yena := false;
  encours := Posit;
  Le_Meilleur := -infini;
  with coups_possibles do with posit do
    begin
      cbpb:=Cases_battues_par_blancs;
      evalupremier := evaluer(true)-cbpb;
      for j := 63 downto 0 do if cases[j] < 0 then
        begin
          Nb_Pos := 0;
          coups_Noirs(j);
          if Nb_Pos <> 0 then
          begin
            yena := true;
            for i := 1 to Nb_pos do
            begin
              arrivee := position[i, 2];
              squize := false;
              if (complexite >= 25) then
              begin
                evalupremierpourj:=evalupremier - bonus[cases[j],j];
                if (cases[arrivee] = vide) then
                begin
                  Squize := true;deprime:=cbpb;
                  case cases[j] of
                    PionNoir: if j >= 48 then Squize := false;
                    Roinoir,Tournoir:Squize:=roque_noir;
                  end ;
                end else deprime:=23+cbpb;
                if Squize then evalu := evalupremierpourj  + bonus[cases[j],arrivee]-deprime else
                begin
                  jouertrue(position[i, 1], position[i, 2], position[i, 3]);
                  evalu := evaluer(true) -deprime;
                  Posit := encours;
                end;
              end else
              begin
                 evalupremierpourj:=evalupremier - bonus_fin[cases[j],j];
                if (cases[arrivee] = vide) then
                  case cases[j] of
                    PionNoir: if j < 48 then Squize := true;
                    CavalierNoir, FouNoir, ReineNoir, RoiNoir: Squize := true;
                  end;
                if Squize then evalu := evalupremierpourj + bonus_fin[cases[j],arrivee] else
                begin
                  jouertrue(position[i, 1], position[i, 2], position[i, 3]);
                  evalu := evaluer(true);
                  Posit := encours;
                end;
              end;
              if evalu > Le_Meilleur then
              begin
                Le_Meilleur := evalu;
                if Le_Meilleur >= beta then
                begin
                  feuilletrue := Le_Meilleur;
                  exit;
                end;
              end;
            end;
          end;
        end;
      if not yena then
      begin
        if souslefeu(Position_Roi[Noir], -1, false) then feuilletrue := -infini + (profope - 1) else feuilletrue := 0;
        exit;
      end;
      feuilletrue := Le_Meilleur;
      exit;
    end;
end;

function feuillefalse(const beta: integer): integer;
var j, evalupremier,evalupremierpourj, evalu, Le_Meilleur, i, arrivee,deprime: integer;
  encours: T_echiquier;
  Squize, yena: boolean;
  cbpn:integer;
begin
  yena := false;
  encours := Posit;
  Le_Meilleur := -infini;
  with coups_possibles do with posit do
    begin
      cbpn:=Cases_battues_par_noirs;
      evalupremier := evaluer(false)-cbpn;
      for j := 0 to 63 do if cases[j] > 0 then
        begin
          evalupremierpourj:=evalupremier - bonus[cases[j],j];
          Nb_Pos := 0;
          coups_blancs(j);
          if Nb_Pos <> 0 then
          begin
            yena := true;
            for i := 1 to Nb_pos do
            begin
              arrivee := position[i, 2];
              squize := false;
              if (complexite >= 25) then
              begin
                if (cases[arrivee] = vide) then
                begin
                 Squize := true;
                 deprime:=cbpn;
                 case cases[j] of
                   Pion: if j < 16 then Squize := false;
                   Roi,Tour:Squize:=roque_blanc;
                 end;
                end else deprime:=23+cbpn;
                if Squize then evalu := evalupremierpourj  + bonus[cases[j],arrivee]-deprime else
                begin
                  jouerfalse(position[i, 1], position[i, 2], position[i, 3]);
                  evalu := evaluer(false) - deprime;
                  Posit := encours;
                end;
              end else
              begin
                evalupremierpourj:=evalupremier - bonus_fin[cases[j],j];
                if (cases[arrivee] = vide) then
                  case cases[j] of
                    Roi, Reine, Fou, Cavalier: Squize := true;
                    Pion: if j >= 16 then Squize := true;
                  end;
                if Squize then evalu := evalupremier + bonus_fin[cases[j],arrivee] else
                begin
                  jouerfalse(position[i, 1], position[i, 2], position[i, 3]);
                  evalu := evaluer(false);
                  Posit := encours;
                end;
              end;
              if evalu > Le_Meilleur then
              begin
                Le_Meilleur := evalu;
                if Le_Meilleur >= beta then
                begin
                  feuillefalse := Le_Meilleur;
                  exit;
                end;
              end;
            end;
          end;
        end;
      if not yena then
      begin
        if souslefeu(Position_Roi[Blanc], 1, false) then feuillefalse := -infini + (profope - 1) else feuillefalse := 0;
        exit;
      end;
      feuillefalse := Le_Meilleur;
      exit;
    end;
end;

procedure Affiche;
begin
  Form1.Label1.caption := strint(Nb_Eval) + ' Evaluations en : '+temps(GetTickCount - h);
end;

function AlphaBetalegere(const profondeur: integer; alpha: integer; const beta: integer; const color: boolean): integer;
var evalu, Le_Meilleur, i: integer;
  liste_coup: T_Liste_Coup;
  encours: T_echiquier;
begin
  if profondeur = 1 then if color then begin alphabetalegere := feuilletrue(beta); exit; end else begin alphabetalegere := feuillefalse(beta); exit; end;
  encours := Posit;
  Le_Meilleur := -infini;
  generer_liste_coup(color);
  liste_coup := Coups_Possibles;
  with liste_coup do
  begin
    if Nb_pos = 0 then if color then
      begin
        if souslefeu(posit.Position_Roi[Noir], -1, false) then AlphaBetalegere := -infini else AlphaBetalegere := 0;
        exit;
      end else
      begin
        if souslefeu(posit.Position_Roi[Blanc], 1, false) then AlphaBetalegere := -infini else AlphaBetalegere := 0;
        exit;
      end;
    for i := 1 to Nb_pos do
    begin
      jouer(position[i, 1], position[i, 2], position[i, 3]);
      if profondeur = 2 then
      begin
        if color then evalu := -feuillefalse(-alpha) else evalu := -feuilletrue(-alpha);
      end else evalu := -AlphaBetalegere(profondeur - 1, -beta, -alpha, not color);
      if evalu > Le_Meilleur then
      begin
        Le_Meilleur := evalu;
        if Le_Meilleur >= beta then
        begin
          AlphaBetalegere := Le_Meilleur;
          exit;
        end;
        alpha := max(alpha, le_meilleur);
      end;
      Posit := encours;
    end;
  end;
  AlphaBetalegere := Le_Meilleur;
end;

function AlphaBeta(const profondeur: integer; alpha: integer; const beta: integer; const color: boolean): integer;
var evalu, Le_Meilleur, i, j: integer;
  liste_coup: T_Liste_Coup;
  tmp: T_Element;
  encours: T_echiquier;
begin
  if profondeur = 1 then if color then begin alphabeta := feuilletrue(beta); exit; end else begin alphabeta := feuillefalse(beta); exit; end;
  encours := Posit;
  Le_Meilleur := -infini;
  generer_liste_coup(color);
  liste_coup := Coups_Possibles;
  with liste_coup do
  begin
    if Nb_pos = 0 then if color then
      begin
        if souslefeu(posit.Position_Roi[Noir], -1, false) then AlphaBeta := -infini + (profope - profondeur) else AlphaBeta := 0;
        exit;
      end else
      begin
        if souslefeu(posit.Position_Roi[Blanc], 1, false) then AlphaBeta := -infini + (profope - profondeur) else AlphaBeta := 0;
        exit;
      end;
      for i := 1 to Nb_pos do if La_Pile_1[profondeur] = position[i, 1] then if La_Pile_2[profondeur] = position[i, 2] then
        begin
          tmp := position[i];
          for j := i downto 2 do position[j] := position[j - 1];
          position[1] := tmp;
          Break;
        end;
    for i := 1 to Nb_pos do
    begin
      Application.processmessages;
      jouer(position[i, 1], position[i, 2], position[i, 3]);
      evalu := -AlphaBeta(profondeur - 1, -beta, -alpha, not color);
      if evalu > Le_Meilleur then
      begin
        Le_Meilleur := evalu;
        if Le_Meilleur >= beta then
        begin
          AlphaBeta := Le_Meilleur;
          La_Pile_1[profondeur] := position[i, 1];
          La_Pile_2[profondeur] := position[i, 2];
          exit;
        end;
        alpha := max(alpha, le_meilleur);
      end;
      Posit := encours;
    end;
  end;
  AlphaBeta := Le_Meilleur;
end;

function negascout(const profondeur: integer; alpha: integer; const beta: integer; const color: boolean): integer;
var i, j, a, b, t: integer;
  liste_coup: T_Liste_Coup;
  tmp: T_Element;
  encours: T_echiquier;
begin
  if profondeur = 3 then begin Negascout := alphabeta(profondeur, alpha, beta, color); exit; end;
  if stop then begin Negascout :=0;exit;end;
  encours := Posit;
  generer_liste_coup(color);
  liste_coup := Coups_Possibles;
  a := alpha; b := beta;
  with liste_coup do
  begin
    if Nb_pos = 0 then if color then
    begin
      if souslefeu(posit.Position_Roi[Noir], -1, false) then Negascout := -infini + (profope - profondeur) else Negascout := 0;
      exit;
    end else
    begin
      if souslefeu(posit.Position_Roi[Blanc], 1, false) then Negascout := -infini + (profope - profondeur) else Negascout := 0;
      exit;
    end;
    if (profondeur = profope-1) AND (profope<12) then
    for i := 1 to Nb_pos do
    begin
      jouer(position[i, 1], position[i, 2], position[i, 3]);
      position[i, 4] := -AlphaBeta(3, -beta, -alpha, not color);
      Posit := encours;
    end else 
    for i := 1 to Nb_pos do
    begin
      jouer(position[i, 1], position[i, 2], position[i, 3]);
      case profondeur of
              2..6:position[i, 4] := evaluer(color);
             7..15:position[i, 4] := -AlphaBetalegere(2, -beta, -alpha, not color);
      end;
      Posit := encours;
    end;
    Tri_Nimportequoi(liste_coup, Nb_pos);
    for i := 1 to Nb_pos do if La_Pile_1[profondeur] = position[i, 1] then if La_Pile_2[profondeur] = position[i, 2] then
    begin
      tmp := position[i];
      for j := i downto 2 do position[j] := position[j - 1];
      position[1] := tmp;
      Break;
    end;
    for i := 1 to Nb_pos do
    begin
      Application.processmessages;
      jouer(position[i, 1], position[i, 2], position[i, 3]);
      t := -Negascout(profondeur - 1, -b, -a, not color);
      if (t > a) and (t < beta) and (i > 1) then a := -Negascout(profondeur - 1, -beta, -t, not color);
      a := max(a, t);
      if a >= beta then
      begin
        Negascout := a;
        La_Pile_1[profondeur] := position[i, 1]; La_Pile_2[profondeur] := position[i, 2];
        exit;
      end;
      Posit := encours;
      b := a + 1;
    end;
  end;
  Negascout := a;
end;

procedure Recherche(const color: boolean);
var Le_Meilleur, i, j, alpha: integer;
  liste_coup: T_Liste_Coup;
  encours: T_echiquier;
  annule: boolean;
  a, b, t: integer;
begin
  annule := true; alpha := -infini; stop := false; a := alpha; b := infini;
  enabler(false, false, false, false);
  posit.Total := 0;
  FillChar(la_Pile_1, Sizeof(La_Pile_1), 0); FillChar(la_Pile_2, Sizeof(La_Pile_2), 0);
  encours := posit;
  Le_Meilleur := -infini - 60;
  generer_liste_coup(color);
  liste_coup := Coups_Possibles;
  if liste_coup.Nb_pos = 0 then
  begin
    if (color and souslefeu(posit.Position_Roi[Noir], -1, false)) or (not color and souslefeu(posit.Position_Roi[Blanc], 1, false)) then
    begin
      showmessage('Mat !');
      partie_en_cours := false;
    end else
    begin
      showmessage('Nulle');
      encours := posit;
      partie_en_cours := false;
    end;
    exit;
  end;
  h := GetTickCount;
  form1.Timer1.Enabled:=true;
  with liste_coup do
  begin
    for i := 1 to Nb_pos do
    begin
      jouer(position[i, 1], position[i, 2], position[i, 3]);
      position[i, 4] := -negascout(3, -infini, -alpha, not color);
      posit := encours;
    end;
    Tri_Nimportequoi(liste_coup, Nb_pos);
    alpha := -infini;
    for i := 1 to Nb_pos do
    begin
      jouer(position[i, 1], position[i, 2], position[i, 3]);
      position[i, 4] := -negascout(5, -infini, -alpha, not color);
      posit := encours;
    end;
    Tri_Nimportequoi(liste_coup, Nb_pos);
    dessine(posit_dessin);
    if Nb_pos=1 then
    begin
      best_depart := position[1, 1];
      best_arrivee := position[1, 2];
      best_efface := position[1, 3];
    end else
    for i := 1 to Nb_pos do
    begin
      Affiche;
      if form1.Effacerlesflches1.checked then dessine(posit_dessin);
      If i>1 then  fleche(best_depart, best_arrivee,clgray);
      fleche(position[i, 1], position[i, 2],clBlue);
      if stop then exit;
      jouer(position[i, 1], position[i, 2], position[i, 3]);
      t := -Negascout(profope - 1, -b, -a, not color);
      if (t > a) and (i > 1) then a := -Negascout(profope - 1, -infini, -t, not color);
      a := max(a, t);
      Nb_Repetition := 0;
      for j := 1 to Taille_Pile_Rep do if compareMem(@encours, @La_Pile_Rep[j], 64) then Inc(Nb_Repetition);
      if annule then if Nb_repetition > 2 then
        begin
          showmessage('L''ordinateur pouvait annuler en jouant : ' + cartesien(position[i, 1]) + cartesien(position[i, 2]));
          if nb_pos > 1 then a := -infini;
          nb_repetition := 0; annule := false;
        end;
      if a > Le_Meilleur then
      begin
        Le_Meilleur := a;
        best_depart := position[i, 1];
        best_arrivee := position[i, 2];
        best_efface := position[i, 3];
        if (le_meilleur > infini - 20) then begin posit := encours; break; end;
      end;
      posit := encours;
      b := a + 1;
    end;
  end;
  form1.Timer1.Enabled:=false;
  Affiche;
end;

end.


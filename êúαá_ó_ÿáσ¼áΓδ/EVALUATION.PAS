unit Evaluation;
// Auteur Montero-Ribas
// Logiciel sous license GNU GPL
interface


function evaluer(const cote: boolean): smallint;

implementation
uses SysUtils, variables, math;


function evaluer(const cote: boolean): smallint;
var Colonne, ligne, ici:integer;
    retour: smallint;

begin
  inc(Nb_Eval);
  with posit do
  begin
    retour := 0;
    if complexite < 25 then for Colonne := 0 to 7 do
      begin
        nb_pion_blanc[Colonne] := 0; nb_pion_noir[Colonne] := 0;
        ici := Colonne;
        for Ligne := 1 to 6 do
        begin
          inc(ici, 8);
          case cases[ici] of
              Pion: inc(nb_pion_blanc[Colonne]);
              PionNoir: inc(nb_pion_noir[Colonne]);
          end;
        end;
        if nb_pion_blanc[Colonne] = 2 then dec(retour, 20);
        if nb_pion_noir[Colonne] = 2 then inc(retour, 20);
      end else
    begin
      if Roque_Noir then
      begin
        case position_roi[Noir] of
          1, 2: if Cases[9] = PionNoir then if Cases[10] = PionNoir then if ((Cases[8] = PionNoir) or (Cases[16] = PionNoir)) then dec(retour, 20);
          5, 6: if Cases[14] = PionNoir then if ((Cases[15] = PionNoir) or (Cases[23] = PionNoir)) then dec(retour, 20);
        end;
        dec(retour, 40);
      end else
      begin
        if not (noir_grand_roque or noir_petit_roque) then inc(retour, 30);
      end;
      if Roque_Blanc then
      begin
        case position_roi[blanc] of
          57, 58: if ((Cases[48] = Pion) or (Cases[40] = Pion)) then if Cases[49] = Pion then if Cases[50] = Pion then inc(retour, 20);
          61, 62: if Cases[54] = Pion then if ((Cases[55] = Pion) or (Cases[47] = Pion)) then inc(retour, 20);
        end;
        inc(retour, 40);
      end else
      begin
        if not (blanc_grand_roque or blanc_petit_roque) then dec(retour, 30);
      end;
      for Colonne := 0 to 7 do
      begin
        nb_pion_blanc[Colonne] := 0; nb_pion_noir[Colonne] := 0;
        ici := Colonne;
        for Ligne := 1 to 6 do
        begin
          inc(ici, 8);
          case cases[ici] of
              Pion: begin inc(nb_pion_blanc[Colonne]);end;
              PionNoir: begin inc(nb_pion_noir[Colonne]); end;
          end ;

        end;
        case nb_pion_blanc[Colonne] of
          0: if colonne<>0 then if (colonne=1) or (nb_pion_blanc[Colonne - 2] = 0) then
                begin
                  if nb_pion_blanc[Colonne - 1] <> 0 then dec(retour, 10); {isole}
                  if nb_pion_noir[Colonne - 1] <> 0 then dec(retour, 10); {passe}
                end;

          2: dec(retour, 20); {double}
        end;
        case nb_pion_noir[Colonne] of
          0: if colonne <> 0 then if (colonne=1) or (nb_pion_noir[Colonne - 2] = 0) then
              begin
                if nb_pion_noir[Colonne - 1] <> 0 then inc(retour, 10); {isole}
                if nb_pion_blanc[Colonne - 1] <> 0 then inc(retour, 10); {passe}
              end;
          2: inc(retour, 20); {double}
        end;
      end;
      if nb_pion_blanc[6] = 0 then
      begin
        if nb_pion_blanc[7] <> 0 then dec(retour, 10); {isole}
        if nb_pion_noir[7] <> 0 then dec(retour, 10); {passe}
      end;
      if nb_pion_noir[6] = 0 then
      begin
        if nb_pion_noir[7] <> 0 then inc(retour, 10); {isole}
        if nb_pion_blanc[7] <> 0 then inc(retour, 10); {passe}
      end;
    end;
    inc(retour, total);
  end;
  if cote then result := -retour else result := retour;
end;

end.


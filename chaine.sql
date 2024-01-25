create or replace package chaine as
    function eliminerVoyelles (chaine in varchar2) return varchar2;
    function desaccentuer (chaine in varchar2) return varchar2;
    function nbVoyelles (chaine in varchar2) return varchar2;
    function nbConsonnes (chaine in varchar2) return varchar2;
    function estAlphabetiqueNumber (chaine in varchar2) return number;
    function estPalindromeNumber (chaine in varchar2) return number;
    function estPalindromeNumber2 (chaine in varchar2) return number;
    function estEquilibreNumber (chaine in varchar2) return number;
    function ontMemesLettres(chaine1 in varchar2, chaine2 in varchar2) return number;
end chaine;
/

create or replace package body chaine as
    function eliminerVoyelles (chaine in varchar2) return varchar2 as
    begin
        return replace(translate(chaine, 'aeiouyAEIOUY', 'a'), 'a');
    end eliminerVoyelles;

    function desaccentuer (chaine in varchar2) return varchar2 as
    begin
        return translate (chaine, 'יכךטאהגמןפצחס', 'eeeeaaaiioocn');
    end desaccentuer;
    
    function nbVoyelles (chaine in varchar2) return varchar2 as
    begin
        return length(chaine) - length(eliminerVoyelles(chaine));
    end nbVoyelles;
    
    function nbConsonnes (chaine in varchar2) return varchar2 as
    begin
        return length(chaine) - nbVoyelles(chaine);
    end nbConsonnes;
    
    function estAlphabetiqueNumber (chaine in varchar2) return number is
        lettre          char(1 char);
        nouvelleLettre  char(1 char);
    begin
        if chaine is null then
            return 0;
        else
            lettre := lower(substr(chaine, 1, 1));
            for i in 2..length(chaine) loop
                nouvelleLettre := lower(substr(chaine, i, 1));
                if nouvelleLettre > lettre then
                    lettre := nouvelleLettre;
                else
                    return 0;
                end if;
            end loop;
            return 1;
        end if;
    end estAlphabetiqueNumber;
    
    function estPalindromeNumber (chaine in varchar2) return number is
    mot         varchar2(150);
    lettre      char(1 char);
    begin
        for i in reverse 1..length(chaine) loop
            lettre:=substr(chaine, i, 1);
            mot:=mot||lettre;
        end loop;
        if lower(mot) = lower(chaine) then
            return 1;
        else
            return 0;
        end if;
    end estPalindromeNumber;
    
    function estPalindromeNumber2 (chaine in varchar2) return number is
    begin
        for i in 1..length(chaine)/2 loop
            if lower(substr(chaine, i, 1))!=lower(substr(chaine, length(chaine)-i+1, 1)) then
                return 0;
            end if;
        end loop;
        return 1;
    end estPalindromeNumber2;
    
    function estEquilibreNumber (chaine in varchar2) return number is
    begin
        if nbConsonnes(chaine)=nbVoyelles(chaine) then
          return 1;
        end if;
        return 0;
    end estEquilibreNumber;
    
    function ontMemesLettres(chaine1 in varchar2, chaine2 in varchar2) return number is
        chaineA varchar2(20):=lower(chaine1);
        chaineB varchar2(20):=lower(chaine2);
    begin
        for j in 1..2 loop
            for i in 1..length(chaineA) loop
                if instr(chaineB, substr(chaineA, i, 1))=0 then
                    return 0;
                end if;
            end loop;
            chaineA:=lower(chaine2);
            chaineB:=lower(chaine1);
        end loop;
        return 1;
    end ontMemesLettres;
    
end chaine;
/
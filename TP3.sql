--ex1
create or replace procedure majPrixPort(pCode in etat.code%type, pPrixPort in etat.prixport%type) as
begin
    update etat
    set prixPort = pPrixPort
    where code = pCode;
end majPrixPort;
/

--ex1b
exec majPrixPort ('LA', 42.69);

--ex1b
exec majPrixPort ('LA', 4.26);

select prixport, code
from etat
where code='LA';

--ex1c
rollback;

--ex2a
select replace(translate('Emmanuelle', 'aeiouy', 'a'), 'a') from dual;

--ex2b
select chaine.eliminerVoyelles ('Gérard') from dual;

--ex3
select chaine.desaccentuer('Fränçôïs') from dual ;

--ex4a
select chaine.nbVoyelles ('Emmanuelle') from dual;

--ex4b
select chaine.nbConsonnes ('Emmanuelle') from dual;

--ex5
select chaine.estAlphabetiqueNumber ('AbCde') from dual;

--ex5b
select libelle
from prenom
where chaine.estalphabetiquenumber(libelle) = 1
order by length(libelle) desc, libelle;

--ex7
create or replace procedure supprimerPrenom (chaine in varchar2) as
begin
    delete naissance
    where naissance.idp = (select idp
                            from prenom where initcap(chaine)=libelle);
    delete prenom
    where initcap(chaine)=libelle;
end supprimerPrenom;
/

exec supprimerPrenom ('richard');

select *
from prenom
where libelle='Richard';

rollback;

--ex8a
select chaine.estPalindromeNumber('Eve') from dual;

select chaine.estPalindromeNumber2('Eve') from dual;

--ex8b
select p.libelle
from prenom p
where chaine.estPalindromeNumber2(p.libelle) = 1
order by length(p.libelle) DESC, libelle;

--ex9a
select chaine.estEquilibreNumber('Antoniodejesus') from dual;

--ex9b
select chaine.ontMemesLettres('Abigael','Gabiela') from dual;

select p1.libelle, p2.libelle
from prenom p1, prenom p2
where p1.idp<p2.idp
and p2.idp<1000
and chaine.ontMemesLettres(p1.libelle, p2.libelle)=1
order by p1.libelle;
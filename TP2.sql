-- M2106
-- Correction du TD2

-- ex1
select *
from prenom
where libelle = initcap('&prenom') ;

-- ex2
select count(*) nbTotal, count(estCelebre) nbCelebres, count(*) - count(estCelebre) nbInconnus
from prenom ;

-- ex3
select count(*) nb
from prenom
where estCelebre is null ;

-- ex4a
select nvl(sum(nb), 0) nbEnfants
from naissance
where idP = (select idP from prenom where libelle = initcap('&prenom')) ;

-- ex4b
select nvl(sum(nb), 0) nbEnfants
from naissance n, prenom p
where p.idP = n.idP
  and libelle = initcap('&prenom') ;

-- ex5
select libelle
from prenom
where libelle like 'Z%rr%'
order by libelle ;

-- ex6
select libelle
from prenom
where length(replace(lower(libelle), 'e', '')) = length(libelle) - 4
order by libelle ;

-- ex7a
create view joursVecus as
  select sysdate - to_date('08/03/1982 14:30', 'DD/MM/YYYY HH24:MI') jours
  from dual ;

-- ex7b  
select 24 * jours heuresVecues
from joursVecus ;  

-- ex7c  
select joursDecimal, jours, heures,  mod((joursDecimal - jours) * 24 * 60, 60) minutes
from
(
  select joursDecimal, jours, trunc((joursDecimal - jours) * 24) heures,
                              trunc(mod((joursDecimal - jours) * 24, 24)) heuresBis
  from
  (
    select joursDecimal, trunc(joursDecimal) jours
    from
    (
      select sysdate - to_date('08/03/1982 14:30', 'DD/MM/YYYY HH24:MI') joursDecimal
      from dual
    )
  )
) ;  
  
-- ex8a
select libelle
from prenom
where idP not in (select idP from naissance)
order by 1 ;

-- ex8b
select libelle
from prenom p
where not exists (select 1 from naissance where idP = p.idP)
order by 1 ;

-- ex8c
select libelle
from prenom
minus
select libelle
from prenom p, naissance n
where p.idP = n.idP
order by 1 ;

-- ex8d
select libelle
from prenom p
where 0 = (select count(*) from naissance where idP = p.idP) 
order by 1 ;

-- ex8e
select distinct libelle
from prenom p, naissance n
where p.idP = n.idP (+)
  and n.idP is null
order by 1 ;

-- ex9a
select sum(nb) "Nb naissances"
from naissance ;

-- ex9b
select code "Etat", sum(nb) "Nb naissances"
from naissance
group by code
order by 2 desc ;

-- ex9c
select annee, sum(nb)
from prenom p, naissance n
where p.idP = n.idP
  and libelle = 'Barack'
group by annee
order by annee ;

-- ex10
-- v1 : déclenchement de la sous-requête pour chaque ligne (coût = 1084, tps = 5.9 s)
select libelle||' est le prénom le plus populaire' resultat
from naissance n, prenom p
where n.idP = p.idP
  and sexe = 'F' 
  and code = 'CA'
  and annee =  2012
  and nb = (select max(nb)
            from naissance
            where sexe = n.sexe
              and code = n.code
              and annee = n.annee) ;

-- v2 : beaucoup plus efficace (coût = 69, tps = 0.2 s)            
with naissanceCal2012 as
(
  select idP, nb
  from naissance
  where sexe = 'F'
    and code = 'CA'
    and annee = 2012
)
select libelle||' est le prénom le plus populaire' resultat
from naissanceCal2012 n, prenom p
where n.idP = p.idP
  and nb = (select max(nb) from naissanceCal2012) ;
  

-- ex11
-- méthode "bourrin" mais qui marche...
select libelle
from prenom
where idP in 
(
  select idP from naissance where code = 'CA'
  intersect
  select idP from naissance where code = 'CO'
  intersect
  select idP from naissance where code = 'FL'
  intersect
  select idP from naissance where code = 'LA'
  intersect
  select idP from naissance where code = 'MA'
  intersect
  select idP from naissance where code = 'TX'
  intersect
  select idP from naissance where code = 'UT'
)
order by 1 ;

-- oui, mais si on avait beaucoup plus que 7 états ? (la bonne méthode)
select libelle
from prenom p, naissance n
where p.idP = n.idP
group by p.idP, libelle
having count(distinct code) = (select count(*) from etat)
order by 1 ;


-- ex12a
select avg(length(libelle)) lgMoyenneUniforme
from prenom ;

-- ex12b
select sum(length(libelle) * sum(nb)) / sum(sum(nb)) lgMoyNonUniforme
from prenom p, naissance n
where p.idP = n.idP 
group by p.idP, libelle ; 

-- Solution alternative avec décomposition, en se basant que le fait que l'algèbre est fermée
select sum(nbPondere)/sum(nb) lgMoyNonUniforme
from
(
  select libelle, length(libelle) * sum(nb) nbPondere, sum(nb) nb
  from prenom p, naissance n
  where p.idP = n.idP
  group by p.idP, libelle
) ;

-- ex14
select count (*) nb
from prenom
where estcelebre is not null;

-- ex15
select idp, libelle, estcelebre
from prenom
where lower (libelle) like '%jesus%'
order by libelle ;

-- ex16a
select libelle
from prenom
where libelle like '__z%'
order by libelle;

-- ex16b
select libelle
from prenom
where instr(libelle, 'z', 3)=3;

-- ex17
select p.idp, p.libelle, p.estcelebre, n.idp, n.sexe, e.code, n.annee, n.nb
from prenom p, naissance n, etat e
where p.idp = n.idp
and n.code = e.code
and libelle like 'Messiah';

-- ex18
select annee, sum(nb) Nb_Elvis
from prenom p, naissance n
where p.idp = n.idp
and n.code = 'TX'
and p.libelle = 'Elvis'
group by annee
order by n.annee desc;

-- ex19
select libelle, sum(nb)
from prenom p, naissance n, etat e
where p.idp = n.idp
and e.code=n.code
and length(p.libelle) > 3
and n.sexe = 'F'
and (e.code = 'TX'or e.code='CO')
and n.annee > 1991
group by libelle
order by sum(nb) desc,libelle;

-- ex20
select annee, sum(nb)
from prenom p, naissance n
where p.idp=n.idp
and n.sexe = 'F'
and libelle='Richard'
group by annee
order by annee;

-- ex21
select *
from etat
where 42 = 42;

select *
from etat
where 42 <> 42;

select *
from etat
where null = null;

select *
from etat
where null is null;

select *
from prenom
where estcelebre = null;

select *
from prenom
where estcelebre is null;

select *
from etat
where null <> null;

select *
from etat
where null is not null;

select *
from prenom
where estcelebre <> null;

select *
from prenom
where estcelebre is not null;

-- ex22a
select libelle
from prenom
where soundex('LILITH')=soundex(libelle)
and libelle <> 'Lilith'
order by libelle;

-- ex22b
select p1.libelle,p2.libelle
from prenom p1, prenom p2
WHERE SOUNDEX(p1.libelle) = SOUNDEX(p2.libelle)
and p1.idP<p2.idP
order by p1.libelle,p2.libelle;

-- ex23a
select libelle
from prenom p
where (select count (distinct sexe)
        from naissance n
        where p.idp = n.idp)=2
order by libelle;

-- ex24a
select idP
from naissance
group by idP
having count(distinct sexe)=2
order by 1;

--ex24b
select idP
from
(
    select distinct idP from naissance where sexe = 'M'
    union all
    select distinct idP from naissance where sexe = 'F'
)
group by idP
having count(*) = 2
order by 1;

-- ex25
select p.libelle, max(n.sexe), sum(n.nb)
from prenom p, naissance n
where p.idp = n.idP
group by p.libelle
having count(distinct n.sexe)=1
order by sum(n.nb) desc;

--ex 26
create or replace view repartitionParGenre as
  select libelle, sum(nb) nbtotal, sum(case when n.sexe='M' then nb else 0 end) nbM, sum(case when n.sexe='F' then nb else 0 end) nbF
  from naissance n, prenom p
  where p.idp = n.idp
  group by libelle
  having count(distinct sexe)=2
  order by 2 desc;
  
  --exercice 27
create or replace view repartitionParGenre as 
select libelle, nbT, nbM, round(nbm/nbT, 4)  PCTM , nbF, round (nbf/ nbT, 4) PCTF
from repartitionParGenre
order by libelle;


--exercice 28 
select libelle, nBT, nbF, PCTM, PCTF
from repartitionParGenre
order by abs(pctF - pctM) desc;
--réponse : Il sors les prénoms les plus populaires et affiche le nombre de femme qui porte le prénom ansi que le pourcentage masculin et féminin de personne portant ce prénom.

--exercice 29
select p.libelle, min(n.annee) debut, max(n.annee) fin, count(distinct n.annee) nbannees, sum(n.nb) nbtot
from prenom p, naissance n
where n.idp = p.idp
and n.sexe = 'F'
group by p.idp
having max(n.annee - min(n.annee) > 2
    and min(n.annee > 1980
    and max (n.annee) < 2012
order by sum(n.nb) desc, max(n.annee) - min(n.annee);

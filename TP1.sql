-- M2106
-- Correction du TD1

-- ex1
create table etat
(
  code        char(2 char)      constraint pk_etat          primary key,
  nom         varchar2(15 char) constraint nn_etat_nom      not null,
  capitale    varchar2(15 char) constraint nn_etat_capitale not null,
  nbHab       number(8)         constraint nn_etat_nbHab    not null, 
  constraint  un_etat_nom       unique(nom),
  constraint  un_etat_capitale  unique(capitale),
  constraint  ck_etat_nbHab     check(nbHab >= 500000)
) ;

-- ex2
create table prenom
(
  idP         number                constraint pk_prenom          primary key,
  libelle     varchar2(15 char)     constraint nn_prenom_libelle  not null,
  estCelebre  char(1 char),      
  constraint  un_prenom_libelle     unique(libelle),
  constraint  ck_prenom_libelle     check(initcap(libelle) = libelle),
  constraint  ck_prenom_estCelebre  check(estCelebre in ('O', 'N'))
) ;

-- ex3
create table naissance
(
  idP         number,
  sexe        char(1 char),
  code        char(2 char),
  annee       number(4),
  nb          number              default 5 constraint nn_naissance_nb not null,
  constraint  pk_naissance        primary key(idP, sexe, code, annee),
  constraint  fk_naissance_idP    foreign key(idP) references prenom,
  constraint  fk_naissance_code   foreign key(code) references etat,
  constraint  ck_naissance_sexe   check(sexe in ('M', 'F')),
  constraint  ck_naissance_annee  check(annee between 1910 and 2012),
  constraint  ck_naissance_nb     check(nb >= 5)
) ;

-- ex4
desc etat
desc prenom
desc naissance

-- ex5
select table_name
from user_tables ;

-- ex6
select table_name, constraint_name, constraint_type, status
from user_constraints
order by table_name, constraint_name ;

-- ex7
insert into etat values('CA', 'California', 'Sacramento', 38041430) ;
insert into etat(code, nom, capitale, nbHab) values('TX', 'Texas', 'Austin', 26059203) ;
insert into etat(capitale, nbHab, code, nom) values('Tallahasee', 19317568, 'FL', 'Florida') ;
insert into etat values('MA', 'Massachussets', 'Boston', 6646144) ;
insert into etat values('CO', 'Colorado', 'Denver', 5187582) ;
insert into etat values('LA', 'Louisiana', 'Baton Rouge', 4601893) ;
insert into etat values('UT', 'Utah', 'Salt Lake City', 2855287) ;
commit ;

-- ex8
insert into prenom(idP, libelle) select idP, libelle from guillaume_cabanac.prenom ;

-- ex9
insert into naissance 
  select idP, sexe, code, annee, nb
  from guillaume_cabanac.naissance
  where code in ('CA', 'CO', 'FL', 'LA', 'MA', 'TX', 'UT') -- ou in (select code from etat)
    and annee > 1979 ;

commit ;

-- ex10
select t.*, bytes/1024/1024 MO_occupes, (max_bytes - bytes)/1024/1024 MO_dispos
from user_ts_quotas t ;

-- ex12
update prenom
    set estCelebre = 'N'
    where libelle = 'Elyn' or libelle = 'Clorissa';

-- ex13
update prenom
    set estCelebre = 'O'
    where libelle in ('Barack', 'Monica', 'Marylin','Mickael','Indiana','Hussain');

-- ex14
insert into etat values ('XA', 'California', 'Paris', 1666555);

--ex15 a)
create table naissanceVip as
    select *
    from naissance
    where idP in (select idP
                    from prenom
                    where libelle = 'Elyn' or libelle = 'Clorissa');

-- ex15 b)
select table_name, constraint_name, constraint_type, status, search_condition
from user_constraints
where lower (table_name) = lower ('NAISSANCEVIP');

select table_name, constraint_name, constraint_type, status, search_condition
from user_constraints
where lower (table_name) = lower ('NAISSANCE');

--ex15 c)
delete from naissanceVip
    where annee < 2010;

--ex15 d)
drop table naissanceVip;

--ex 16
alter table etat add
(
    prixPort float(6) default 3.14 constraint ck_etat_prixPort check(prixPort<=8.50)
);

--ex17
update etat
    set prixPort = 6.9
    where nom = 'Utah'
    or nbhab > 10000000;

--ex 18
insert into prenom (idP, libelle) values(100000, 'Captain Fantastic Faster Than Superman Spiderman Batman Wolverine Hulk And The Flash Combined');

alter table prenom modify libelle varchar(100);

--ex 19
alter table etat drop constraint ck_etat_prixPort;

ALTER TABLE etat ADD(constraint ck_etat_prixPort check(prixPort<=15));

UPDATE etat 
set prixPort =12.42
where nom='Texas';

--ex20
create table echangeTmp as
    select *
    from naissance
    where idP =666
    or idP = (select idP from prenom where libelle = 'Lilith');

delete naissance
where idP in (select idP from echangeTmp);

insert into naissance
select (select distinct idP
        from echangeTmp
        where idP <> e.idP), sexe, code, annee, nb
from echangeTmp e;

update prenom p
set libelle = (select libelle
                from prenom
                where idP in (select idP
                                from echangeTmp)
                        and idP <> p.idP)
where idP in (select idP from echangeTmp);

drop table echangeTmp;
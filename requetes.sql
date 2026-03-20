-- Nombre total d’appartements vendus au 1er semestre 2020
select count(*) as ventes
from vente v
inner join bien b on b.bien_id = v.bien_id
where v.date_mutation >= '2020-01-01' and v.date_mutation < '2020-07-01' and b.type_local = 'Appartement' -- au 1er semestre 2020
;

-- Le nombre de ventes d’appartement par région pour le 1er semestre 2020
select count(v.vente_id), r.reg_nom
from vente v
inner join bien b on b.bien_id = v.bien_id
inner join adresse a on a.adresse_id = v.adresse_id
inner join commune c on c.com_id = a.com_id
inner join departement d on d.dep_id = c.dep_id
inner join region r on r.reg_id = d.reg_id
where v.date_mutation >= '2020-01-01' and v.date_mutation < '2020-07-01' and b.type_local = 'Appartement' -- au 1er semestre 2020
group by r.reg_nom
order by count(v.vente_id) desc
;
-- Proportion des ventes d’appartements par le nombre de pièces
select count(v.vente_id) as ventes, b.nombre_pieces 
from vente v
inner join bien b on b.bien_id = v.bien_id
where b.type_local = 'Appartement'
group by b.nombre_pieces
;
-- Liste des 10 départements où le prix du mètre carré est le plus élevé
select round(max(v.valeur_fonciere / b.surface_carrez)) as prix_m2, d.dep_nom
from vente v
inner join bien b on b.bien_id = v.bien_id
inner join adresse a on a.adresse_id = v.adresse_id
inner join commune c on c.com_id = a.com_id
inner join departement d on d.dep_id = c.dep_id
group by d.dep_nom
order by prix_m2 desc
limit 10
;
-- Prix moyen du mètre carré d’une maison en Île-de-France
select round(avg(v.valeur_fonciere / b.surface_carrez)) as prix_moy_m2, r.reg_nom
from vente v
inner join bien b on b.bien_id = v.bien_id
inner join adresse a on a.adresse_id = v.adresse_id
inner join commune c on c.com_id = a.com_id
inner join departement d on d.dep_id = c.dep_id
inner join region r on r.reg_id = d.reg_id
where r.reg_id = 'R11' and b.type_local = 'Maison'
group by r.reg_id
order by prix_moy_m2 desc
;
-- Liste des 10 appartements les plus chers avec la région et le nombre de mètres carrés
select round(v.valeur_fonciere) as prix, b.surface_carrez, r.reg_nom, round(v.valeur_fonciere / b.surface_carrez) as m2
from vente v
inner join bien b on b.bien_id = v.bien_id
inner join adresse a on a.adresse_id = v.adresse_id
inner join commune c on c.com_id = a.com_id
inner join departement d on d.dep_id = c.dep_id
inner join region r on r.reg_id = d.reg_id
where b.type_local = 'Appartement'
order by prix desc
limit 10
;

-- Taux d’évolution du nombre de ventes entre le premier et le second trimestre de 2020
select max(ventes) - min (ventes) as ventes, min (ventes) as min, max(ventes) as max
from (
select count(*) as ventes
from vente v
where v.date_mutation < '2020-04-01' -- jusqu'au 1er trimestre 2020
UNION
select count(*) as ventes
from vente v
where v.date_mutation < '2020-07-01' -- jusqu'au 2eme trimestre 2020
)
;


-- Le classement des régions par rapport au prix au mètre carré des appartement de plus de 4 pièces
select round(avg(v.valeur_fonciere / b.surface_carrez)) as prix_moy_m2, r.reg_nom
from vente v
inner join bien b on b.bien_id = v.bien_id
inner join adresse a on a.adresse_id = v.adresse_id
inner join commune c on c.com_id = a.com_id
inner join departement d on d.dep_id = c.dep_id
inner join region r on r.reg_id = d.reg_id
where b.type_local = 'Appartement' and b.nombre_pieces > 4
group by r.reg_nom
order by prix_moy_m2 desc
;


-- Liste des communes ayant eu au moins 50 ventes au 1er trimestre
select c.com_id, c.com_nom, count(v.vente_id) as nb_ventes
from vente v
inner join bien b on b.bien_id = v.bien_id
inner join adresse a on a.adresse_id = v.adresse_id
inner join commune c on c.com_id = a.com_id
where v.date_mutation >= '2020-01-01' and v.date_mutation < '2020-04-01' -- au 1er trimestre 2020
group by c.com_id
having count(v.vente_id) >= 50
;

-- Différence en pourcentage du prix au mètre carré entre un appartement de 2 pièces et un appartement de 3 pièces
select abs(round(((b2.valeur - b1.valeur) / b2.valeur) * 100)) as percent, b1.valeur as moy_2_pieces, b2.valeur as moy_3_pieces
from
    (select round(avg(v.valeur_fonciere / b.surface_carrez)) as valeur from bien b join vente v on v.bien_id = b.bien_id where b.type_local = 'Appartement' and b.nombre_pieces = 2) b1, -- moyenne = 1 résultat
    (select round(avg(v.valeur_fonciere / b.surface_carrez)) as valeur from bien b join vente v on v.bien_id = b.bien_id where b.type_local = 'Appartement' and b.nombre_pieces = 3) b2  -- moyenne = 1 résultat
;
	
--  Les moyennes de valeurs foncières pour le top 3 des communes des départements 6, 13, 33, 59 et 69
select c.com_id, c.com_nom, round(avg(v.valeur_fonciere)) as valeurs_moy
from vente v
inner join bien b on b.bien_id = v.bien_id
inner join adresse a on a.adresse_id = v.adresse_id
inner join commune c on c.com_id = a.com_id
where c.com_id like 'C06%'
	or c.com_id like 'C13%'
	or c.com_id like 'C33%'
	or c.com_id like 'C59%'
	or c.com_id like 'C69%'
group by c.com_id
order by valeurs_moy desc
limit 3
;

--  Les 20 communes avec le plus de transactions pour 1000 habitants pour les communes qui dépassent les 10 000 habitants
select top.com_nom, top.com_id, top.ventes, pop.populations, ROUND((top.ventes * 1000.0) / pop.populations, 2) as ventes_par_population
from
( -- nombre de transactions par communes
select c.com_id, c.com_nom, count(v.vente_id) as ventes
from commune c
inner join adresse a on a.com_id = c.com_id
inner join vente v on v.adresse_id = a.adresse_id
group by c.com_id
) top
inner join ( -- La population par commune
select p.com_id, sum(p.PTOT) as populations
from population p
group by p.com_id
) pop on pop.com_id = top.com_id
where pop.populations > 10000 -- les communes qui dépassent les 10 000 habitants
order by ventes_par_population desc
limit 20 -- top 20
	
	
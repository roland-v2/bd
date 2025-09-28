-- 12. 5 Cereri complexe care satistac cerinta

--Afișați, pentru fiecare departament, numărul de pacienți internați în 2024 și media lungimii observațiilor medicale asociate tratamentelor din acel departament, ordonat dupa numele departamentului.
-- **********
-- subcereri sincronizate (join 3+ tabele)
-- grupare de date
-- count, avg
-- length, to_char
-- ordonare
select d.nume as departament,
    (
        select count(distinct t.id_pacient)
        from tratament t
        join pacient pac on t.id_pacient = pac.id_pacient
        join doctor doc on t.id_doctor = doc.id_doctor
        join programare p on t.id_pacient = p.id_pacient
        where doc.id_departament = d.id_departament
          and extract(year from p.data_internare) = 2024
    ) as nr_pacienti_2024,
    (
        select round(avg(length(t.observatii_medicale)), 2)
        from tratament t
        join pacient pac on t.id_pacient = pac.id_pacient
        join programare p on pac.id_pacient = p.id_pacient
        join doctor doc on t.id_doctor = doc.id_doctor
        where doc.id_departament = d.id_departament
          and extract(year from p.data_internare) = 2024
    ) as medie_lungime_observatii
from departament d
order by departament;

-- Pentru pacienții care au fost internați în saloane comune și au stat spitalizați minimum 2 zile, afișați: 
-- numele complet al pacientului,
-- ziua săptămânii și luna internării,
-- numărul total de zile spitalizate,
-- un indicator textual (weekend/weekday) în funcție de ziua internării.
-- Se va ordona rezultatul după durata internării descrescător.
-- **********
-- subcerere nesincronizata in from
-- to_char
-- case
-- ordonare
select p.Nume || ' ' || p.Prenume as Pacient,
    to_char(sub.Data_internare, 'Day') as Zi_Intrare,
    to_char(sub.Data_internare, 'Month') as Luna_Internare,
    (sub.Data_externare - sub.Data_internare) as Nr_Zile,
    case 
        when to_char(sub.Data_internare, 'D') in ('1', '7') then 'Weekend'
        else 'Weekday'
    end as Tip_Zi
from (
    select * from programare
    where ID_Salon in (select ID_Salon from salon where Tip = 'comun')
) sub
join pacient p on p.ID_Pacient = sub.ID_Pacient
where (sub.Data_externare - sub.Data_internare) >= 2
order by Nr_Zile desc;

-- Afișați saloanele în care media duratei de spitalizare a pacienților este mai mica decât media duratei de spitalizare din toate saloanele.
-- Pentru fiecare salon, afișați:
-- ID-ul salonului,
-- tipul salonului,
-- media zilelor de spitalizare pentru pacienți.
-- Rezultatele să fie ordonate descrescător după media zilelor de spitalizare.
-- **********
-- grupare de date
-- avg
-- subcerere nesincronizata in having
-- ordonare
select s.ID_Salon, s.Tip,
    round(avg(p.Data_externare - p.Data_internare), 2) as Media_Salon
from salon s
join programare p on s.ID_Salon = p.ID_Salon
group by s.ID_Salon, s.Tip
having avg(p.Data_externare - p.Data_internare) < (
    select avg(Data_externare - Data_internare) from programare
)
order by Media_Salon desc;

-- Afișați numele pacienților, istoricul medical (sau “Fara istoric” dacă e NULL), vârsta și categoria de vârstă (minor/adult/senior).
-- Ordonati dupa Categoria de varsta, si in caz de egalitate, dupa numele intreg al pacientului.
-- **********
-- nvl
-- decode
-- months_between, sysdate, trunc
-- case
-- ordonare
select p.Nume || ' ' || p.Prenume as Pacient,
    nvl(p.Istoric_medical, 'Fara istoric') as Istoric,
    trunc(months_between(sysdate, p.Data_nasterii)/12) as Varsta,
    decode(
        case 
            when months_between(sysdate, p.Data_nasterii)/12 < 18 then 'Minor'
            when months_between(sysdate, p.Data_nasterii)/12 between 18 and 65 then 'Adult'
            else 'Senior'
        end,
        'Minor', 'Minor - Sub 18 ani',
        'Adult', 'Adult - 18-65 ani',
        'Senior', 'Senior - Peste 65 ani'
    ) as Categorie
from pacient p
order by Categorie, Pacient;

-- Afișați primii 3 doctori in functie de numărul total de echipamente medicale utilizate în tratamentele lor sau, in caz de egalitate, dupa numele intreg al doctorului.
-- **********
-- bloc cerere with
-- grupare de date
-- count
-- concatenare
-- ordonare
with DoctorEchipamente as (
    select d.ID_Doctor, d.Nume || ' ' || d.Prenume as Doctor,
        count(te.ID_Echipament_m) as Nr_Echipamente
    from doctor d
    join tratament t on d.ID_Doctor = t.ID_Doctor
    join tratament_echipament te on t.ID_Tratament = te.ID_Tratament
    group by d.ID_Doctor, d.Nume, d.Prenume
)
select Doctor, Nr_Echipamente
from DoctorEchipamente
order by Nr_Echipamente desc, Doctor
fetch first 3 rows only;


-- 13. Actualizarea si suprimarea datelor folosind subcereri.ALTER
-- a. actualizare - Modifica doza medicamentului pentru tratamentele pacienților care au fost internați în “Cardiologie” si "Oncologie"
update tratament_medicament
set doza = '20mg'
where id_tratament in (
    select t.id_tratament
    from tratament t
    join pacient p on t.id_pacient = p.id_pacient
    join programare pr on p.id_pacient = pr.id_pacient
    join salon s on pr.id_salon = s.id_salon
    join departament d on s.id_departament = d.id_departament
    where d.nume in ('Cardiologie', 'Oncologie')
);

-- b. stergere - Elimina echipamentele care sunt folosite (exemplu ipotetic)
delete from echipament_medical 
where id_echipament_m in (
    select distinct id_echipament_m from tratament_echipament
);

DELETE FROM echipament_medical
WHERE id_echipament_m IN (
    SELECT id_echipament_m
    FROM tratament_echipament
)
AND id_echipament_m NOT IN (
    SELECT id_echipament_m
    FROM echipament_departament
);

-- c. actualizare - Actualizează calificarea doctorilor care tratează pacienți cu “migrene” în istoric
update doctor
set calificare = 'specialist'
where id_doctor in (
    select distinct t.id_doctor
    from tratament t
    join pacient p on t.id_pacient = p.id_pacient
    where lower(p.istoric_medical) like '%migrene%'
);

commit;


-- 14. Crearea unei vizualizari complexe si exemple de comenzi LMD
create view V_Internari_Detalii_Pacient_Departament as
select
    P.ID_Pacient,
    P.Nume as Nume_Pacient,
    P.Prenume as Prenume_Pacient,
    P.CNP,
    PR.ID_Programare,
    PR.Data_internare,
    PR.Data_externare,
    (PR.Data_externare - PR.Data_internare) as Durata_Zile_Internare,
    S.ID_Salon,
    S.Tip as Tip_Salon,
    D.ID_Departament,
    D.Nume as Nume_Departament,
    D.Etaj as Etaj_Departament
from pacient P
join programare PR on P.ID_Pacient = PR.ID_Pacient
join salon S on PR.ID_Salon = S.ID_Salon
join departament D on S.ID_Departament = D.ID_Departament;

-- Afisare vizualizare
select * from V_INTERNARI_DETALII_PACIENT_DEPARTAMENT;

-- Stergere vizualizare, daca este nevoie
drop view V_Internari_Detalii_Pacient_Departament;

-- Operație LMD permisă: Actualizarea datei de externare pentru o anumită programare.
update V_Internari_Detalii_Pacient_Departament
set Data_externare = to_date('2024-01-06', 'YYYY-MM-DD') -- Noua dată de externare
where ID_Programare = 1;

-- verificarea actualizării
select ID_Programare, Data_externare from PROGRAMARE where ID_Programare = 1;
-- Explicație:
-- Coloana Data_externare aparține direct tabelei de bază PROGRAMARE.
-- Clauza where ID_Programare = 1 identifică unic un rând în tabela PROGRAMARE (deoarece ID_Programare este cheia primară).
-- Actualizarea nu creează ambiguități cu privire la tabelele de bază afectate.


-- Operație LMD nepermisă: Încercarea de a actualiza direct coloana calculată 'Durata_Zile_Internare'.
-- Această coloană este derivată din (PR.Data_externare - PR.Data_internare) și nu există fizic ca o coloană stocată care poate fi modificată direct.
update V_Internari_Detalii_Pacient_Departament
set Durata_Zile_Internare = 10
where ID_Programare = 1;
-- Această comandă va genera o eroare (https://docs.oracle.com/error-help/db/ora-01733/01733. 00000 -  "virtual column not allowed here" *Cause:    An attempt was made to use an INSERT, UPDATE, or DELETE statement on an expression in a view.)

commit;


-- 15. outer-join, division, top-n
-- a. outer-join --
-- "Afișați ID-ul, numele și prenumele fiecărui pacient, împreună cu ID-ul programării, data internării și data externării (dacă pacientul are programări), 
-- tipul salonului asociat programării (dacă există salon valid pentru programare) și numele departamentului în care se află salonul (dacă există departament valid pentru salon). 
-- Lista trebuie să includă toți pacienții, indiferent dacă au sau nu programări înregistrate sau dacă detaliile despre salon/departament sunt completate pentru programările existente. 
-- Rezultatele vor fi ordonate după numele și prenumele pacientului, apoi după data internării."
select
    p.ID_Pacient,
    p.Nume as Nume_Pacient,
    p.Prenume as Prenume_Pacient,
    pr.ID_Programare,
    pr.Data_internare,
    pr.Data_externare,
    s.Tip as Tip_Salon,
    d.Nume as Nume_Departament
from PACIENT p
left outer join PROGRAMARE pr on p.ID_Pacient = pr.ID_Pacient
left outer join SALON s on pr.ID_Salon = s.ID_Salon
left outer join DEPARTAMENT d on s.ID_Departament = d.ID_Departament
order by p.Nume, p.Prenume, pr.Data_internare;

-- b. division --
-- "Afișați pacienții (ID, Nume, Prenume) care au primit, în cadrul tratamentelor lor, toate medicamentele distincte care au fost utilizate cel puțin o dată în tratamentele efectuate de doctorii din departamentul 'Cardiologie'."
with MedicamenteSpecificeDepartament as (
    select distinct tm.ID_Medicament
    from TRATAMENT t
    join DOCTOR doc on t.ID_Doctor = doc.ID_Doctor
    join DEPARTAMENT dep on doc.ID_Departament = dep.ID_Departament
    join TRATAMENT_MEDICAMENT tm on t.ID_Tratament = tm.ID_Tratament
    where dep.nume = 'Cardiologie'
),
NumarTotalMedicamenteSpecifice as (
    select count(*) as TotalMedicamente from MedicamenteSpecificeDepartament
)
select
    p.ID_Pacient,
    p.Nume as Nume_Pacient,
    p.Prenume as Prenume_Pacient
from PACIENT p
join TRATAMENT t on p.ID_Pacient = t.ID_Pacient
join TRATAMENT_MEDICAMENT tm on t.ID_Tratament = tm.ID_Tratament
where tm.ID_Medicament in (select ID_Medicament from MedicamenteSpecificeDepartament)
group by p.ID_Pacient, p.Nume, p.Prenume
having
    count(distinct tm.ID_Medicament) = (select TotalMedicamente from NumarTotalMedicamenteSpecifice)
    and (select TotalMedicamente from NumarTotalMedicamenteSpecifice) > 0;

-- c. top-n --
-- "Afișați numele și durata medie de spitalizare (în zile, rotunjită la două zecimale) pentru primele 3 departamente 
-- care au cea mai mare durată medie de spitalizare a pacienților în saloanele respectivelor departamente. Se vor lua în considerare doar programările finalizate (cu dată de internare și externare valide).
-- Ordonarea se va face descrescător după durata medie."
with DurataMedieSpitalizarePerDepartament as (
    select
        d.ID_Departament,
        d.Nume as Nume_Departament,
        avg(pr.Data_externare - pr.Data_internare) as Medie_Zile_Spitalizare
    from PROGRAMARE pr
    join SALON s on pr.ID_Salon = s.ID_Salon
    join DEPARTAMENT d on s.ID_Departament = d.ID_Departament
    where 
        pr.Data_externare is not null
        and pr.Data_internare is not null
        and pr.Data_externare >= pr.Data_internare
    group by d.ID_Departament, d.Nume
)
select
    Nume_Departament,
    round(Medie_Zile_Spitalizare, 2) as Medie_Zile_Spitalizare_Top
from DurataMedieSpitalizarePerDepartament
order by Medie_Zile_Spitalizare desc
fetch first 3 rows only;


-- 16. a) 
-- "Afișați numele și prenumele pacienților, împreună cu numele departamentului în care au fost internați, 
-- pentru toți pacienții care au fost internați în anul 2024 în saloane de tip 'privat'."
-- Cererea initiala - neoptimizata
select P.Nume, P.Prenume, D.Nume as Nume_Departament
from PACIENT P
join PROGRAMARE PR on P.ID_Pacient = PR.ID_Pacient
join SALON S on PR.ID_Salon = S.ID_Salon
join DEPARTAMENT D on S.ID_Departament = D.ID_Departament
where extract(year from PR.Data_internare) = 2024 and S.Tip = 'privat';


-- tabele implicate si atribute relevante
-- PACIENT (ID_Pacient, Nume, Prenume)
-- PROGRAMARE (ID_Programare, ID_Pacient, ID_Salon, Data_internare)
-- SALON (ID_Salon, ID_Departament, Tip)
-- DEPARTAMENT (ID_Departament, Nume AS Nume_Departament)


-- expresie algebrica initiala - neoptimizata
-- Folosim π pentru proiecție, σ pentru selecție, ⨝ pentru join
-- π <sub>P.Nume, P.Prenume, D.Nume_Departament</sub> ( σ <sub>extract(year from PR.Data_internare) = 2024 and S.Tip = 'privat'</sub> ( ( ( PACIENT P ⨝<sub>P.ID_Pacient = PR.ID_Pacient</sub> PROGRAMARE PR ) ⨝<sub>PR.ID_Salon = S.ID_Salon</sub> SALON S ) ⨝<sub>S.ID_Departament = D.ID_Departament</sub> DEPARTAMENT D ) )


-- arbore algebric - neoptimizat
-- Join-urile combină toate atributele tabelelor implicate.
-- Selecția filtrează rândurile.
-- Proiecția finală alege coloanele P.Nume, P.Prenume (din PACIENT) și D.Nume (din DEPARTAMENT, redenumit Nume_Departament).
--          π <sub>P.Nume, P.Prenume, D.Nume_Departament</sub>
--              |
--              | <- Atribute disponibile: toate din P, PR, S, D care satisfac condițiile de join și selecție
--              |
--              σ <sub>extract(year from PR.Data_internare) = 2024 and S.Tip = 'privat'</sub>
--                    |
--                    | <- Atribute disponibile: toate din P, PR, S, D care satisfac condițiile de join
--                    |
--                    ⨝ <sub>S.ID_Departament = D.ID_Departament</sub>
--                   /                                        \
--                  /                                          \
--                 /                                            \
--                ⨝ <sub>PR.ID_Salon = S.ID_Salon</sub>      DEPARTAMENT D (ID_Departament, Nume)
--               /                                           \
--              /                                             \
--             /                                               \
--            ⨝ <sub>P.ID_Pacient = PR.ID_Pacient</sub>  SALON S (ID_Salon, ID_Departament, Tip)
--           /                                    \
--          /                                      \
--         /                                        \
--        PACIENT P (ID_Pacient, Nume, Prenume)       PROGRAMARE PR (ID_Programare, ID_Pacient, ID_Salon, Data_internare)


-- Cererea optimizata
with Pacienti_Proiectati as (
    select ID_Pacient, Nume, Prenume
    from PACIENT
),
Programari_Filtrate_Proiectate as (
    select ID_Pacient, ID_Salon
    from PROGRAMARE
    where extract(year from Data_internare) = 2024
),
Saloane_Filtrate_Proiectate as (
    select ID_Salon, ID_Departament
    from SALON
    where Tip = 'privat'
),
Departamente_Proiectate as (
    select ID_Departament, Nume as Nume_Departament
    from DEPARTAMENT
)
select
    PP.Nume,
    PP.Prenume,
    DP.Nume_Departament
from Pacienti_Proiectati PP
join Programari_Filtrate_Proiectate PFP ON PP.ID_Pacient = PFP.ID_Pacient
join Saloane_Filtrate_Proiectate SFP ON PFP.ID_Salon = SFP.ID_Salon
join Departamente_Proiectate DP ON SFP.ID_Departament = DP.ID_Departament;


-- expresie algebrică optimizată
-- Fie:
-- PACIENT_opt = π <sub>ID_Pacient, Nume, Prenume</sub> (PACIENT P)
-- PROGRAMARE_opt = π <sub>ID_Pacient, ID_Salon</sub> ( σ <sub>EXTRACT(YEAR FROM Data_internare) = 2024</sub> (PROGRAMARE PR) )
-- SALON_opt = π <sub>ID_Salon, ID_Departament</sub> ( σ <sub>Tip = 'privat'</sub> (SALON S) ) (Notă: S.Tip nu mai este necesar în proiecția lui SALON_opt deoarece nu apare în rezultatul final, dar este necesar pentru selecția pe SALON)
-- DEPARTAMENT_opt = π <sub>ID_Departament, Nume AS Nume_Departament</sub> (DEPARTAMENT D)
-- Expresia devine: π <sub>PACIENT_opt.Nume, PACIENT_opt.Prenume, DEPARTAMENT_opt.Nume_Departament</sub> ( ( ( PACIENT_opt ⨝<sub>PACIENT_opt.ID_Pacient = PROGRAMARE_opt.ID_Pacient</sub> PROGRAMARE_opt ) ⨝<sub>PROGRAMARE_opt.ID_Salon = SALON_opt.ID_Salon</sub> SALON_opt ) ⨝<sub>SALON_opt.ID_Departament = DEPARTAMENT_opt.ID_Departament</sub> DEPARTAMENT_opt )


-- arbore algebric optimizat
--                                π <sub>P_opt.Nume, P_opt.Prenume, D_opt.Nume_Departament</sub>
--                                      |
--                                      | <- Atribute disponibile: P_opt.Nume, P_opt.Prenume, D_opt.Nume_Departament, chei de join
--                                      |
--                                      ⨝ <sub>S_opt.ID_Departament = D_opt.ID_Departament</sub>
--                                     /                                              \
--                                    /                                                \
--                                   /                                                  \
--                                  ⨝ <sub>PR_opt.ID_Salon = S_opt.ID_Salon</sub>      (D_opt) π <sub>ID_Departament, Nume AS Nume_Departament</sub>
--                                 /                                              \                                    |
--                                /                                                \                                   | <- Atribute: ID_Departament, Nume
--                               /                                                  \                               DEPARTAMENT D (ID_Departament, Nume)
--                              ⨝ <sub>P_opt.ID_Pacient = PR_opt.ID_Pacient</sub>    (S_opt) π <sub>ID_Salon, ID_Departament</sub>
--                             /                \                                        |
--                            /                  \                                       | <- Atribute: ID_Salon, ID_Departament
--                           /                    \                                      σ <sub>Tip='privat'</sub>                                     
--                          /                      \                                     | <- Atribute: ID_Salon, ID_Departament, Tip
--                         /                        \                                    SALON S (ID_Salon, ID_Departament, Tip)            
--(P_opt) π <sub>ID_Pacient, Nume, Prenume</sub>     (PR_opt) π <sub>ID_Pacient, ID_Salon</sub> 
--          |                                         |
--          | <- Atribute: ID_Pacient, Nume, Prenume  | <- Atribute: ID_Pacient, ID_Salon
--          |                                         |
--      PACIENT P                                     σ <sub>extract(year from Data_internare)=2024</sub>
--(ID_Pacient, Nume, Prenume)                         |
--                                                    | <- Atribute: ID_Programare, ID_Pacient, ID_Salon, Data_internare
--                                                    |
--                                                PROGRAMARE PR (ID_Programare, ID_Pacient, ID_Salon, Data_internare)


-- 17. b) exemplu de cerinta frecventa
-- afișarea unei liste de programări ale pacienților împreună cu numele complet al pacientului și numele departamentului unde se află salonul acestuia.
select
    PR.ID_Programare,
    PA.Nume || ' ' || PA.Prenume AS Nume_Complet_Pacient,
    D.Nume AS Nume_Departament_Salon,
    PR.Data_internare,
    PR.Data_externare
from PROGRAMARE PR
join PACIENT PA on PR.ID_Pacient = PA.ID_Pacient
join SALON S on PR.ID_Salon = S.ID_Salon
join DEPARTAMENT D on S.ID_Departament = D.ID_Departament;

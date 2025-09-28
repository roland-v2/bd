-- 1. READ UNCOMMITTED (Citire Necomisă)

-- Sesiunea 1:
-- Începe tranzacția
UPDATE DOCTOR SET Calificare = 'stagiar' WHERE ID_Doctor = 1;
-- Nu facem COMMIT incă

-- Sesiunea 2 (setată ipotetic la READ UNCOMMITTED):
-- SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED; -- Ipotetic
SELECT Calificare FROM DOCTOR WHERE ID_Doctor = 1;
-- Ar returna 'stagiar' (citire necomisă)

-- Sesiunea 1 continuă:
ROLLBACK; -- Anulează modificarea


-- 2. READ COMMITTED (Citire Comisă)
-- a. Exemplu (Non-Repeatable Read - așa cum s-a demonstrat anterior):

-- Sesiunea 1:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- Citirea inițială
SELECT Telefon FROM PACIENT WHERE ID_Pacient = 1; 
-- Se returnează '0700001111'

-- Sesiunea 2:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE PACIENT SET Telefon = '0700009999' WHERE ID_Pacient = 1;
COMMIT;

-- Sesiunea 1:
-- A doua citire
SELECT Telefon FROM PACIENT WHERE ID_Pacient = 1;
COMMIT;


-- b. Exemplu (Phantom Read - așa cum s-a demonstrat anterior):

-- Sesiunea 1:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- Numără pacienții cu numele 'Popa'
SELECT COUNT(*) FROM PACIENT WHERE Nume = 'Popa';
-- Returnează 1

-- Sesiunea 2:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
INSERT INTO PACIENT (ID_Pacient, CNP, Nume, Prenume, Telefon, Adresa, Data_nasterii, Istoric_medical) 
VALUES (seq_pacient_id.NEXTVAL, '1900101123000', 'Popa', 'Mihai', '0700008888', 'Str. Noua 1', TO_DATE('1990-01-01', 'YYYY-MM-DD'), TO_CLOB('sanatos'));
COMMIT;

-- Sesiunea 1:
-- Numără din nou pacienții cu numele 'Popa'
SELECT COUNT(*) FROM PACIENT WHERE Nume = 'Popa';
-- Va returna 2 (o fantomă a apărut).
COMMIT;


-- 3. REPEATABLE READ (Citire Repetabilă)
-- Exemplu Ipotetic (REPEATABLE READ standard - dacă ar fi suportat cu posibilitatea de scriere):

-- Sesiunea 1 - setată la REPEATABLE READ (ipotetic):
-- SET TRANSACTION ISOLATION LEVEL REPEATABLE READ; -- Ipotetic
-- Citirea 1
SELECT Calificare FROM DOCTOR WHERE ID_Doctor = 2;
-- Se returnează 'sef sectie'
-- Citirea 2 (număr de doctori în departamentul 2)
SELECT COUNT(*) FROM DOCTOR WHERE ID_Departament = 2;
-- Se returnează 1

-- Sesiunea 2 - READ COMMITTED:
UPDATE DOCTOR SET Calificare = 'profesor' WHERE ID_Doctor = 2;
INSERT INTO DOCTOR (ID_Doctor, ID_Departament, Calificare, Nume, Prenume, Telefon, Mail) 
VALUES (seq_doctor_id.NEXTVAL, 2, 'asistent univ.', 'Marinescu', 'Vlad', '0700000008', 'vlad.m@email.com');
COMMIT;

-- Sesiunea 1:
-- Citirea 3
SELECT Calificare FROM DOCTOR WHERE ID_Doctor = 2;
-- Returnează 'sef sectie' (Non-Repeatable Read prevenit)
-- Citirea 4
SELECT COUNT(*) FROM DOCTOR WHERE ID_Departament = 2;
-- Returnează 2 (Phantom Read permis, deoarece Sesiunea 2 a inserat un nou doctor în departamentul 2)
-- COMMIT;


-- 4. SERIALIZABLE (Serializabil)
-- Exemplu (Prevenirea Phantom Read și conflict la scriere - așa cum s-a demonstrat anterior):

-- Sesiunea 1:
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- Numără doctorii din departamentul 1
SELECT COUNT(*) FROM DOCTOR WHERE ID_Departament = 1;
-- Returnează 1

-- Sesiunea 2:
SET TRANSACTION ISOLATION LEVEL READ COMMITTED; -- Sau SERIALIZABLE
-- Modifică doctorul pe care Sesiunea 1 l-a citit/l-ar putea modifica
UPDATE DOCTOR SET Calificare = 'medic primar' WHERE ID_Doctor = 1;
-- Se inserează un nou doctor în departamentul 1
INSERT INTO DOCTOR (ID_Doctor, ID_Departament, Calificare, Nume, Prenume, Telefon, Mail) 
VALUES (seq_doctor_id.NEXTVAL, 1, 'specialist', 'Georgescu', 'Mihai', '0700000009', 'mihai.g@email.com');
COMMIT;

-- Sesiunea 1:
-- Se numără din nou doctorii din departamentul 1
SELECT COUNT(*) FROM DOCTOR WHERE ID_Departament = 1;
-- Va returna tot 1 (Phantom Read prevenit, Sesiunea 1 vede snapshot-ul său)

-- Încercăm să actualizăm un doctor pe care Sesiunea l-ar fi putut modifica.
UPDATE DOCTOR SET Telefon = '0711111111' WHERE ID_Doctor = 1; 
-- Dacă Sesiunea 1 a modificat și comis rândul pentru ID_Doctor = 1 între timp, acest UPDATE al Sesiunii 1 va eșua cu ORA-08177.
COMMIT; 

-- Observație: Sesiunea 1 nu va vedea noul doctor inserat de Sesiunea 2 în SELECT COUNT(*). Dacă Sesiunea 1 încearcă să facă UPDATE la ID_Doctor = 1 (pe care Sesiunea 2 l-a modificat și comis), Sesiunea 1 va primi ORA-08177, deoarece modificarea Sesiunii 2 a invalidat premisa pe care se baza tranzacția serializabilă a Sesiunii 1.
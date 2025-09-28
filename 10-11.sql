-- Drop Table si Sequence, in caz ca ca exista deja create
DROP TABLE TRATAMENT_MEDICAMENT CASCADE CONSTRAINTS;
DROP TABLE TRATAMENT_ECHIPAMENT CASCADE CONSTRAINTS;
DROP TABLE ECHIPAMENT_DEPARTAMENT CASCADE CONSTRAINTS;
DROP TABLE PROGRAMARE CASCADE CONSTRAINTS;
DROP TABLE SALON CASCADE CONSTRAINTS;
DROP TABLE DOCTOR CASCADE CONSTRAINTS;
DROP TABLE PACIENT CASCADE CONSTRAINTS;
DROP TABLE TRATAMENT CASCADE CONSTRAINTS;
DROP TABLE FACTURA CASCADE CONSTRAINTS;
DROP TABLE ECHIPAMENT_MEDICAL CASCADE CONSTRAINTS;
DROP TABLE DEPARTAMENT CASCADE CONSTRAINTS;
DROP TABLE MEDICAMENT CASCADE CONSTRAINTS;

DROP SEQUENCE seq_doctor_id;
DROP SEQUENCE seq_pacient_id;
DROP SEQUENCE seq_programare_id;
DROP SEQUENCE seq_departament_id;
DROP SEQUENCE seq_tratament_id;
DROP SEQUENCE seq_medicament_id;
DROP SEQUENCE seq_factura_id;
DROP SEQUENCE seq_salon_id;
DROP SEQUENCE seq_echipament_id;

-- 10. Secvente
CREATE SEQUENCE seq_doctor_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pacient_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_programare_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_departament_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_tratament_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_medicament_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_factura_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_salon_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_echipament_id START WITH 1 INCREMENT BY 1;
create sequence seq_specializare_id start with 1 increment by 1;

-- 11. Crearea tabelelor si inserarea datelor
CREATE TABLE DEPARTAMENT (
    ID_Departament INTEGER PRIMARY KEY,
    Nume VARCHAR(20),
    Etaj INTEGER
);

CREATE TABLE DOCTOR (
    ID_Doctor INTEGER PRIMARY KEY,
    ID_Departament INTEGER,
    Calificare VARCHAR(20),
    Nume VARCHAR(20),
    Prenume VARCHAR(20),
    Telefon VARCHAR(11),
    Mail VARCHAR(30),
    FOREIGN KEY (ID_Departament) REFERENCES DEPARTAMENT(ID_Departament)
);

CREATE TABLE PACIENT (
    ID_Pacient INTEGER PRIMARY KEY,
    CNP VARCHAR(16) UNIQUE,
    Nume VARCHAR(20),
    Prenume VARCHAR(20),
    Telefon VARCHAR(20),
    Adresa VARCHAR(50),
    Data_nasterii DATE,
    Istoric_medical CLOB
);

CREATE TABLE SALON (
    ID_Salon INTEGER PRIMARY KEY,
    ID_Departament INTEGER,
    Tip VARCHAR(10),
    FOREIGN KEY (ID_Departament) REFERENCES DEPARTAMENT(ID_Departament)
);

CREATE TABLE PROGRAMARE (
    ID_Programare INTEGER PRIMARY KEY,
    ID_Pacient INTEGER,
    ID_Salon INTEGER,
    Data_internare DATE,
    Data_externare DATE,
    FOREIGN KEY (ID_Pacient) REFERENCES PACIENT(ID_Pacient),
    FOREIGN KEY (ID_Salon) REFERENCES SALON(ID_Salon)
);

CREATE TABLE TRATAMENT (
    ID_Tratament INTEGER PRIMARY KEY,
    ID_Doctor INTEGER,
    ID_Pacient INTEGER,
    Observatii_medicale CLOB,
    FOREIGN KEY (ID_Doctor) REFERENCES Doctor(ID_Doctor),
    FOREIGN KEY (ID_Pacient) REFERENCES Pacient(ID_Pacient)
);

CREATE TABLE FACTURA (
    ID_Factura INTEGER PRIMARY KEY,
    ID_Pacient INTEGER,
    Istoric CLOB,
    FOREIGN KEY (ID_Pacient) REFERENCES PACIENT(ID_Pacient)
);

CREATE TABLE ECHIPAMENT_MEDICAL (
    ID_Echipament_m INTEGER PRIMARY KEY,
    ID_Departament INTEGER
);

CREATE TABLE MEDICAMENT (
    ID_Medicament INTEGER PRIMARY KEY,
    Administrare CLOB
);

CREATE TABLE TRATAMENT_MEDICAMENT (
    ID_Tratament INTEGER,
    ID_Medicament INTEGER,
    Doza VARCHAR(10),
    Administrare VARCHAR(50),
    PRIMARY KEY (ID_Tratament, ID_Medicament),
    FOREIGN KEY (ID_Tratament) REFERENCES Tratament(ID_Tratament),
    FOREIGN KEY (ID_Medicament) REFERENCES Medicament(ID_Medicament)
);

CREATE TABLE TRATAMENT_ECHIPAMENT (
    ID_Tratament INTEGER,
    ID_Echipament_m INTEGER,
    Frecventa_utilizare VARCHAR(10),
    Administrare VARCHAR(50),
    PRIMARY KEY (ID_Tratament, ID_Echipament_m),
    FOREIGN KEY (ID_Tratament) REFERENCES Tratament(ID_Tratament),
    FOREIGN KEY (ID_Echipament_m) REFERENCES Echipament_Medical(ID_Echipament_m)
);

CREATE TABLE ECHIPAMENT_DEPARTAMENT (
    ID_Echipament_m INTEGER,
    ID_Departament INTEGER,
    PRIMARY KEY (ID_Echipament_m, ID_Departament)
);

create table Specializare (
    ID_Specializare INTEGER PRIMARY KEY,
    Nume VARCHAR(50)
);

create table Specializare_doctor (
    ID_Specializare INTEGER,
    ID_Doctor INTEGER,
    PRIMARY KEY (ID_Specializare, ID_Doctor),
    FOREIGN KEY (ID_Specializare) REFERENCES Specializare(ID_Specializare),
    FOREIGN KEY (ID_Doctor) REFERENCES Doctor(ID_Doctor)
);

INSERT INTO DEPARTAMENT (ID_Departament, Nume, Etaj) VALUES (seq_departament_id.NEXTVAL, 'Cardiologie', 2);
INSERT INTO DEPARTAMENT (ID_Departament, Nume, Etaj) VALUES (seq_departament_id.NEXTVAL, 'Neurologie', 3);
INSERT INTO DEPARTAMENT (ID_Departament, Nume, Etaj) VALUES (seq_departament_id.NEXTVAL, 'Pediatrie', 1);
INSERT INTO DEPARTAMENT (ID_Departament, Nume, Etaj) VALUES (seq_departament_id.NEXTVAL, 'Oncologie', 4);
INSERT INTO DEPARTAMENT (ID_Departament, Nume, Etaj) VALUES (seq_departament_id.NEXTVAL, 'Radiologie', 0);

INSERT INTO DOCTOR (ID_Doctor, ID_Departament, Calificare, Nume, Prenume, Telefon, Mail) VALUES (seq_doctor_id.NEXTVAL, 1, 'rezident', 'Popescu', 'Ion', '0700000001', 'ion.popescu@email.com');
INSERT INTO DOCTOR (ID_Doctor, ID_Departament, Calificare, Nume, Prenume, Telefon, Mail) VALUES (seq_doctor_id.NEXTVAL, 2, 'sef sectie', 'Ionescu', 'Maria', '0700000002', 'maria.ionescu@email.com');
INSERT INTO DOCTOR (ID_Doctor, ID_Departament, Calificare, Nume, Prenume, Telefon, Mail) VALUES (seq_doctor_id.NEXTVAL, 3, 'asistent', 'Georgescu', 'Andrei', '0700000003', 'andrei.g@email.com');
INSERT INTO DOCTOR (ID_Doctor, ID_Departament, Calificare, Nume, Prenume, Telefon, Mail) VALUES (seq_doctor_id.NEXTVAL, 4, 'rezident', 'Ciobanu', 'Ana', '0700000004', 'ana.c@email.com');
INSERT INTO DOCTOR (ID_Doctor, ID_Departament, Calificare, Nume, Prenume, Telefon, Mail) VALUES (seq_doctor_id.NEXTVAL, 5, 'sef sectie', 'Dumitru', 'Paul', '0700000005', 'paul.d@email.com');

INSERT INTO PACIENT (ID_Pacient, CNP, Nume, Prenume, Telefon, Adresa, Data_nasterii, Istoric_medical) VALUES (seq_pacient_id.NEXTVAL, '1960101123456', 'Popa', 'Alex', '0700001111', 'Str. Libertatii 10', TO_DATE('1960-01-01', 'YYYY-MM-DD'), TO_CLOB('hipertensiune cronica'));
INSERT INTO PACIENT (ID_Pacient, CNP, Nume, Prenume, Telefon, Adresa, Data_nasterii, Istoric_medical) VALUES (seq_pacient_id.NEXTVAL, '2870202123456', 'Marin', 'Elena', '0700002222', 'Str. Primaverii 45', TO_DATE('1987-02-02', 'YYYY-MM-DD'), TO_CLOB('migrene'));
INSERT INTO PACIENT (ID_Pacient, CNP, Nume, Prenume, Telefon, Adresa, Data_nasterii, Istoric_medical) VALUES (seq_pacient_id.NEXTVAL, '5010303123456', 'Iacob', 'Dan', '0700003333', 'Str. Universitatii 3', TO_DATE('2001-03-03', 'YYYY-MM-DD'), TO_CLOB('alergii'));
INSERT INTO PACIENT (ID_Pacient, CNP, Nume, Prenume, Telefon, Adresa, Data_nasterii, Istoric_medical) VALUES (seq_pacient_id.NEXTVAL, '6840404123456', 'Grigore', 'Ioana', '0700004444', 'Str. Stadionului 12', TO_DATE('1984-04-04', 'YYYY-MM-DD'), TO_CLOB('diabet tip 2'));
INSERT INTO PACIENT (ID_Pacient, CNP, Nume, Prenume, Telefon, Adresa, Data_nasterii, Istoric_medical) VALUES (seq_pacient_id.NEXTVAL, '2770505123456', 'Radu', 'Andreea', '0700005555', 'Str. Mihai Viteazul 20', TO_DATE('1977-05-05', 'YYYY-MM-DD'), TO_CLOB('astm'));

INSERT INTO SALON (ID_Salon, ID_Departament, Tip) VALUES (seq_salon_id.NEXTVAL, 1, 'comun');
INSERT INTO SALON (ID_Salon, ID_Departament, Tip) VALUES (seq_salon_id.NEXTVAL, 2, 'privat');
INSERT INTO SALON (ID_Salon, ID_Departament, Tip) VALUES (seq_salon_id.NEXTVAL, 3, 'comun');
INSERT INTO SALON (ID_Salon, ID_Departament, Tip) VALUES (seq_salon_id.NEXTVAL, 4, 'privat');
INSERT INTO SALON (ID_Salon, ID_Departament, Tip) VALUES (seq_salon_id.NEXTVAL, 5, 'comun');

INSERT INTO PROGRAMARE (ID_Programare, ID_Pacient, ID_Salon, Data_internare, Data_externare) VALUES (seq_programare_id.NEXTVAL, 1, 1, TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-01-03', 'YYYY-MM-DD'));
INSERT INTO PROGRAMARE (ID_Programare, ID_Pacient, ID_Salon, Data_internare, Data_externare) VALUES (seq_programare_id.NEXTVAL, 2, 1, TO_DATE('2025-01-04', 'YYYY-MM-DD'), TO_DATE('2025-01-06', 'YYYY-MM-DD'));
INSERT INTO PROGRAMARE (ID_Programare, ID_Pacient, ID_Salon, Data_internare, Data_externare) VALUES (seq_programare_id.NEXTVAL, 3, 2, TO_DATE('2024-02-01', 'YYYY-MM-DD'), TO_DATE('2024-02-02', 'YYYY-MM-DD'));
INSERT INTO PROGRAMARE (ID_Programare, ID_Pacient, ID_Salon, Data_internare, Data_externare) VALUES (seq_programare_id.NEXTVAL, 4, 3, TO_DATE('2025-03-01', 'YYYY-MM-DD'), TO_DATE('2025-03-10', 'YYYY-MM-DD'));
INSERT INTO PROGRAMARE (ID_Programare, ID_Pacient, ID_Salon, Data_internare, Data_externare) VALUES (seq_programare_id.NEXTVAL, 5, 4, TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-04-04', 'YYYY-MM-DD'));

INSERT INTO TRATAMENT (ID_Tratament, ID_Doctor, ID_Pacient, Observatii_medicale) VALUES (seq_tratament_id.NEXTVAL, 1, 1, 'Hipertensiune stabilizată');
INSERT INTO TRATAMENT (ID_Tratament, ID_Doctor, ID_Pacient, Observatii_medicale) VALUES (seq_tratament_id.NEXTVAL, 2, 2, 'Tratament migrene');
INSERT INTO TRATAMENT (ID_Tratament, ID_Doctor, ID_Pacient, Observatii_medicale) VALUES (seq_tratament_id.NEXTVAL, 3, 3, 'Alergii sezoniere');
INSERT INTO TRATAMENT (ID_Tratament, ID_Doctor, ID_Pacient, Observatii_medicale) VALUES (seq_tratament_id.NEXTVAL, 4, 4, 'Insulină zilnică');
INSERT INTO TRATAMENT (ID_Tratament, ID_Doctor, ID_Pacient, Observatii_medicale) VALUES (seq_tratament_id.NEXTVAL, 5, 5, 'Terapie astm ușor');

INSERT INTO FACTURA (ID_Factura, ID_Pacient, Istoric) VALUES (seq_factura_id.NEXTVAL, 1, 'Internare cardiologie, 2 zile');
INSERT INTO FACTURA (ID_Factura, ID_Pacient, Istoric) VALUES (seq_factura_id.NEXTVAL, 2, 'Consult neurologie, 1 zi');
INSERT INTO FACTURA (ID_Factura, ID_Pacient, Istoric) VALUES (seq_factura_id.NEXTVAL, 3, 'Alergii pediatrice, tratament ambulatoriu');
INSERT INTO FACTURA (ID_Factura, ID_Pacient, Istoric) VALUES (seq_factura_id.NEXTVAL, 4, 'Internare oncologie, tratament chimioterapie');
INSERT INTO FACTURA (ID_Factura, ID_Pacient, Istoric) VALUES (seq_factura_id.NEXTVAL, 5, 'Tratament fizioterapie pulmonară');

INSERT INTO ECHIPAMENT_MEDICAL (ID_Echipament_m, ID_Departament) VALUES (seq_echipament_id.NEXTVAL, 1);
INSERT INTO ECHIPAMENT_MEDICAL (ID_Echipament_m, ID_Departament) VALUES (seq_echipament_id.NEXTVAL, 2);
INSERT INTO ECHIPAMENT_MEDICAL (ID_Echipament_m, ID_Departament) VALUES (seq_echipament_id.NEXTVAL, 3);
INSERT INTO ECHIPAMENT_MEDICAL (ID_Echipament_m, ID_Departament) VALUES (seq_echipament_id.NEXTVAL, 4);
INSERT INTO ECHIPAMENT_MEDICAL (ID_Echipament_m, ID_Departament) VALUES (seq_echipament_id.NEXTVAL, 5);

INSERT INTO MEDICAMENT (ID_Medicament, Administrare) VALUES (seq_medicament_id.NEXTVAL, 'De 3 ori pe zi');
INSERT INTO MEDICAMENT (ID_Medicament, Administrare) VALUES (seq_medicament_id.NEXTVAL, 'De 2 ori pe zi');
INSERT INTO MEDICAMENT (ID_Medicament, Administrare) VALUES (seq_medicament_id.NEXTVAL, 'Atentie! Contine alergeni');
INSERT INTO MEDICAMENT (ID_Medicament, Administrare) VALUES (seq_medicament_id.NEXTVAL, 'Variat in functie de nevoia pacientului');
INSERT INTO MEDICAMENT (ID_Medicament, Administrare) VALUES (seq_medicament_id.NEXTVAL, 'De 4 ori pe zi');

INSERT INTO TRATAMENT_MEDICAMENT VALUES
(1, 1, '10mg', '1/zi dimineata'),
(1, 2, '5mg', '2/zi'),
(2, 3, '50mg', 'la nevoie'),
(2, 4, '25mg', '1/zi seara'),
(3, 5, '15mg', '1/zi'),
(3, 1, '5mg', 'dimineata'),
(4, 2, '10mg', 'injectabil'),
(4, 3, '10mg', 'oral'),
(5, 5, '20mg', '1/zi'),
(5, 4, '30mg', '2/zi');

INSERT INTO TRATAMENT_ECHIPAMENT VALUES
(1,1,'3/zi','monitorizare tensiune'),
(1,2,'2/luna','EKG'),
(2,2,'1/luna','scanare cerebrală'),
(3,3,'1/sapt','test alergii'),
(4,4,'3/zi','chimioterapie'),
(4,5,'2/luna','radioterapie'),
(5,5,'1/zi','nebulizare'),
(5,1,'4/zi','supraveghere respiratorie'),
(3,1,'1/sapt','pulsoximetru'),
(2,1,'1/luna','EEG');

INSERT INTO ECHIPAMENT_DEPARTAMENT VALUES
(1,1), (1,2), (2,2), (2,3), (3,3), (3,4), (4,4), (4,5), (5,5), (5,1);

COMMIT;
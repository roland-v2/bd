const db = db.getSiblingDB("spitalMongoDB");

db.pacienti.drop();
db.doctori.drop();
db.departamente.drop();
db.medicamente.drop();
db.echipamente_medicale.drop();
print("Collections dropped.");

db.dropDatabase();

// a) si b) - Crearea și Popularea Colecțiilor

// DEPARTAMENTE Collection
// Structure: { id_departament, nume, etaj }
print("Inserting into 'departamente' collection...");
db.departamente.insertMany([
  { id_departament: 1, nume: "Cardiologie", etaj: 2 },
  { id_departament: 2, nume: "Neurologie", etaj: 3 },
  { id_departament: 3, nume: "Pediatrie", etaj: 1 },
  { id_departament: 4, nume: "Oncologie", etaj: 4 },
  { id_departament: 5, nume: "Radiologie", etaj: 0 }
]);
print(`Inserted ${db.departamente.countDocuments()} documents into departamente.`);

// -- MEDICAMENTE Collection --
// Structure: { id_medicament, nume_medicament, administrare_generala }
print("Inserting into 'medicamente' collection...");
db.medicamente.insertMany([
  { id_medicament: 1, nume_medicament: "Lisinopril", administrare_generala: "10mg, 1/zi" },
  { id_medicament: 2, nume_medicament: "Amlodipina", administrare_generala: "5mg, 1/zi" },
  { id_medicament: 3, nume_medicament: "Sumatriptan", administrare_generala: "50mg, la nevoie" },
  { id_medicament: 4, nume_medicament: "Metformin", administrare_generala: "500mg, 2/zi" },
  { id_medicament: 5, nume_medicament: "Salbutamol", administrare_generala: "Inhalator, la nevoie" }
]);
print(`Inserted ${db.medicamente.countDocuments()} documents into medicamente.`);

// -- ECHIPAMENTE_MEDICALE Collection --
// Structure: { id_echipament, nume_echipament, departament_principal_id }
print("Inserting into 'echipamente_medicale' collection...");
db.echipamente_medicale.insertMany([
  { id_echipament: 1, nume_echipament: "Monitor Tensiune Arteriala", departament_principal_id: 1 },
  { id_echipament: 2, nume_echipament: "Aparat EKG", departament_principal_id: 1 },
  { id_echipament: 3, nume_echipament: "Scanner Cerebral", departament_principal_id: 2 },
  { id_echipament: 4, nume_echipament: "Kit Test Alergii", departament_principal_id: 3 },
  { id_echipament: 5, nume_echipament: "Aparat Chimioterapie", departament_principal_id: 4 }
]);
print(`Inserted ${db.echipamente_medicale.countDocuments()} documents into echipamente_medicale.`);

// -- DOCTORI Collection --
// Structure: { id_doctor, departament_id, calificare, nume, prenume, telefon, mail }
print("Inserting into 'doctori' collection...");
db.doctori.insertMany([
  { id_doctor: 1, departament_id: 1, calificare: "rezident", nume: "Popescu", prenume: "Ion", telefon: "0700000001", mail: "ion.popescu@email.com" },
  { id_doctor: 2, departament_id: 2, calificare: "sef sectie", nume: "Ionescu", prenume: "Maria", telefon: "0700000002", mail: "maria.ionescu@email.com" },
  { id_doctor: 3, departament_id: 3, calificare: "asistent", nume: "Georgescu", prenume: "Andrei", telefon: "0700000003", mail: "andrei.g@email.com" },
  { id_doctor: 4, departament_id: 4, calificare: "rezident", nume: "Ciobanu", prenume: "Ana", telefon: "0700000004", mail: "ana.c@email.com" },
  { id_doctor: 5, departament_id: 5, calificare: "sef sectie", nume: "Dumitru", prenume: "Paul", telefon: "0700000005", mail: "paul.d@email.com" }
]);
print(`Inserted ${db.doctori.countDocuments()} documents into doctori.`);

// -- PACIENTI Collection --
// Structure: Incapsulare complexa: programari, tratamente, facturi.
print("Inserting into 'pacienti' collection...");
db.pacienti.insertMany([
  {
    id_pacient: 1,
    cnp: "1960101123456",
    nume: "Popa",
    prenume: "Alex",
    telefon: "0700001111",
    adresa: "Str. Libertatii 10",
    data_nasterii: new Date("1960-01-01T00:00:00Z"),
    istoric_medical_general: "hipertensiune cronica",
    programari: [
      { id_programare: 1, salon_id: 1, salon_tip: "comun", departament_salon_id: 1, data_internare: new Date("2024-01-01T00:00:00Z"), data_externare: new Date("2024-01-03T00:00:00Z") }
    ],
    tratamente: [
      {
        id_tratament: 1,
        doctor_id: 1,
        observatii_medicale: "Hipertensiune stabilizată",
        medicamente_prescrise: [
          { medicament_id: 1, doza: "10mg", administrare_specifica: "1/zi dimineata" }
        ],
        echipamente_utilizate: [
          { echipament_id: 1, frecventa_utilizare: "3/zi", scop_utilizare: "monitorizare tensiune" }
        ]
      }
    ],
    facturi: [
      { id_factura_sql: 1, istoric_detaliat_factura: "Internare cardiologie, 2 zile", data_emitere: new Date("2024-01-03T00:00:00Z") }
    ]
  },
  {
    id_pacient: 2,
    cnp: "2870202123456",
    nume: "Marin",
    prenume: "Elena",
    telefon: "0700002222",
    adresa: "Str. Primaverii 45",
    data_nasterii: new Date("1987-02-02T00:00:00Z"),
    istoric_medical_general: "migrene",
    programari: [
      { id_programare: 2, salon_id: 1, salon_tip: "comun", departament_salon_id: 1, data_internare: new Date("2025-01-04T00:00:00Z"), data_externare: new Date("2025-01-06T00:00:00Z") }
    ],
    tratamente: [
      {
        id_tratament: 2,
        doctor_id: 2,
        observatii_medicale: "Tratament migrene",
        medicamente_prescrise: [
          { medicament_id: 3, doza: "50mg", administrare_specifica: "la nevoie" }
        ]
      }
    ],
    facturi: [
      { id_factura: 2, istoric_detaliat_factura: "Consult neurologie, 1 zi", data_emitere: new Date("2025-01-06T00:00:00Z") }
    ]
  },
  // Patient for update/delete examples
  {
    id_pacient: 100,
    cnp: "1990101010101",
    nume: "Test",
    prenume: "PacientDel",
    telefon: "0712345678",
    adresa: "Str. Test 123",
    data_nasterii: new Date("1999-12-31T00:00:00Z"),
    istoric_medical_general: "pentru stergere",
    programari: [], tratamente: [], facturi: []
  }
]);
print(`Inserted ${db.pacienti.countDocuments()} documents into pacienti.`);

db.getCollectionNames();

// c) modificare și ștergere documente
// inserarea documentelor a fost realizată mai sus - insertMany
// stergerea documentelor: db.collectionName.drop();

print("\n--- Modifying Documents ---");
// Update nr de telefon pentru pacientul Popa Alex
const updateResultTel = db.pacienti.updateOne(
  { "id_pacient": 1 },
  { $set: { "telefon": "0711223344" } }
);
print(`Updated phone for pacient id_pacient: 1. Matched: ${updateResultTel.matchedCount}, Modified: ${updateResultTel.modifiedCount}`);

// Adauga programare pacientului Marin Elena
const updateResultProg = db.pacienti.updateOne(
  { "id_pacient": 2 },
  {
    $push: {
      "programari": {
        id_programare: 103,
        salon_tip: "privat",
        departament_salon_id: 2,
        data_internare: new Date("2025-09-01T00:00:00Z"),
        data_externare: new Date("2025-09-03T00:00:00Z")
      }
    }
  }
);
print(`Added programare for pacient id_pacient: 2. Matched: ${updateResultProg.matchedCount}, Modified: ${updateResultProg.modifiedCount}`);

// Modifica o observatie intr-un tratament incapsulat pentru Pacient Popa Alex
const updateResultTrat = db.pacienti.updateOne(
  { "id_pacient": 1, "tratamente.id_tratament": 1 },
  { $set: { "tratamente.$.observatii_medicale": "Hipertensiune bine controlata, monitorizare continua." } }
);
print(`Updated treatment observation for pacient id_pacient: 1. Matched: ${updateResultTrat.matchedCount}, Modified: ${updateResultTrat.modifiedCount}`);

print("\n--- Deleting Documents ---");

// Sterge pacientul test
const deleteResult = db.pacienti.deleteOne({ "cnp": "1990101010101" });
print(`Deleted patient with CNP 1990101010101. Deleted count: ${deleteResult.deletedCount}`);

// Sterge toti doctorii rezidenti
const deleteRezidentiResult = db.doctori.deleteMany({ "calificare": "rezident" });
print(`Deleted rezident doctors. Count: ${deleteRezidentiResult.deletedCount}`);

// d) exemple comenzi pentru interogarea datelor - filtrare si sortare
print("\n1. Find Pacient by CNP (Popa Alex) - Example of basic filtering:");
const pacientByCnp = db.pacienti.findOne({ "cnp": "1960101123456" });
printjson(pacientByCnp);

print("\n2. Find Pacienti with programari in January 2024 - Example of filtering on embedded array & using operators:");
const pacientiIan2024 = db.pacienti.find(
  {
    "programari.data_internare": {
      $gte: new Date("2024-01-01T00:00:00Z"),
      $lt: new Date("2024-02-01T00:00:00Z")
    }
  },
  { nume: 1, prenume: 1, "programari.$": 1, _id: 0 } 
).toArray();
printjson(pacientiIan2024);

print("\n3. Find all Pacienti, sorted by Nume (asc) then Prenume (asc) - Example of sorting:");
const pacientiSortati = db.pacienti.find(
  {},
  { nume: 1, prenume: 1, cnp: 1, _id: 0 }
).sort({ "nume": 1, "prenume": 1 }).toArray();
printjson(pacientiSortati);
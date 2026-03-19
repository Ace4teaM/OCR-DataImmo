-- Created by Redgate Data Modeler (https://datamodeler.redgate-platform.com)
-- Last modification date: 2026-03-19 14:10:44.036

-- tables
-- Table: academie
CREATE TABLE IF NOT EXISTS academie (
    aca_id character(3) NOT NULL CONSTRAINT academie_pk PRIMARY KEY,
    aca_nom varchar(50) NOT NULL,
    reg_id character(3) NOT NULL,
    CONSTRAINT FK_ACADEMIE_REGION FOREIGN KEY (reg_id)
    REFERENCES region (reg_id)
);

-- Table: adresse
CREATE TABLE IF NOT EXISTS adresse (
    adresse_id integer NOT NULL CONSTRAINT adresse_pk PRIMARY KEY AUTOINCREMENT,
    no_voie integer,
    type_voie varchar(20),
    voie varchar(50) NOT NULL,
    code_postal integer,
    code_voie varchar(4) NOT NULL,
    btq character(1),
    com_id character(6) NOT NULL,
    CONSTRAINT AK_ADRESSE_UNIQUE UNIQUE (no_voie, code_voie, com_id, btq),
    CONSTRAINT FK_COMMUNE_ADRESSE FOREIGN KEY (com_id)
    REFERENCES commune (com_id)
);

CREATE INDEX IF NOT EXISTS idx_adresse_commune
ON adresse (com_id ASC)
;

-- Table: bien
CREATE TABLE IF NOT EXISTS bien (
    bien_id integer NOT NULL CONSTRAINT bien_immobilier_pk PRIMARY KEY AUTOINCREMENT,
    type_local varchar(50),
    surface_reelle_bati integer,
    nombre_pieces integer,
    surface_terrain integer,
    surface_carrez numeric,
    nature_culture varchar(20)
);

-- Table: commune
CREATE TABLE IF NOT EXISTS commune (
    com_id character(6) NOT NULL CONSTRAINT commune_pk PRIMARY KEY,
    com_nom varchar(100) NOT NULL,
    geolocalisation varchar(50),
    dep_id varchar(3) NOT NULL,
    CONSTRAINT FK_DEPARTEMENT_COMMUNE FOREIGN KEY (dep_id)
    REFERENCES departement (dep_id)
);

CREATE INDEX IF NOT EXISTS idx_commune_departement
ON commune (dep_id ASC)
;

-- Table: departement
CREATE TABLE IF NOT EXISTS departement (
    dep_id varchar(3) NOT NULL CONSTRAINT departement_pk PRIMARY KEY,
    dep_nom varchar(50) NOT NULL,
    reg_id character(3) NOT NULL,
    CONSTRAINT FK_REGION_DEPARTEMENT FOREIGN KEY (reg_id)
    REFERENCES region (reg_id)
);

CREATE INDEX IF NOT EXISTS idx_departement_region
ON departement (reg_id ASC)
;

-- Table: population
CREATE TABLE IF NOT EXISTS population (
    id integer NOT NULL CONSTRAINT population_pk PRIMARY KEY AUTOINCREMENT,
    PMUN integer NOT NULL,
    PCAP integer NOT NULL,
    com_id character(6) NOT NULL,
    CONSTRAINT FK_COMMUNE_POPULATION FOREIGN KEY (com_id)
    REFERENCES commune (com_id)
);

CREATE INDEX IF NOT EXISTS idx_population_commune
ON population (com_id ASC)
;

-- Table: region
CREATE TABLE IF NOT EXISTS region (
    reg_id character(3) NOT NULL CONSTRAINT region_pk PRIMARY KEY,
    reg_nom varchar(50) NOT NULL,
    regrgp_nom varchar(20) NOT NULL
);

-- Table: vente
CREATE TABLE IF NOT EXISTS vente (
    vente_id integer NOT NULL CONSTRAINT vente_pk PRIMARY KEY AUTOINCREMENT,
    date_mutation date NOT NULL,
    valeur_fonciere integer NOT NULL,
    section_cadastrale varchar(10),
    no_plan integer,
    bien_id integer NOT NULL,
    adresse_id integer NOT NULL,
    CONSTRAINT AK_VENTE_MUTATION UNIQUE (date_mutation, bien_id, adresse_id),
    CONSTRAINT FK_VENTE_BIEN FOREIGN KEY (bien_id)
    REFERENCES bien (bien_id),
    CONSTRAINT FK_ADRESSE_VENTE FOREIGN KEY (adresse_id)
    REFERENCES adresse (adresse_id)
);

CREATE INDEX IF NOT EXISTS idx_transaction_date
ON vente (date_mutation ASC)
;

CREATE INDEX IF NOT EXISTS idx_transaction_bien
ON vente (bien_id ASC)
;

-- End of file.


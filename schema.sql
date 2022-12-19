/* Database schema to keep the structure of entire database. */

CREATE TABLE animals ( 
    id BIGSERIAL NOT NULL PRIMARY KEY, 
    name VARCHAR(50) NOT NULL, 
    date_of_birth DATE NOT NULL, 
    escape_attempts integer NOT NULL, 
    neutered boolean NOT NULL, 
    weight_kg decimal NOT NULL
);

ALTER TABLE animals
ADD species VARCHAR(50);

CREATE TABLE owners ( id BIGSERIAL NOT NULL PRIMARY KEY, full_name VARCHAR(150), age INT );
CREATE TABLE species ( id BIGSERIAL NOT NULL PRIMARY KEY, name VARCHAR(150) );

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals ADD COLUMN species_id INT, ADD COLUMN owner_id INT;

ALTER TABLE animals
    ADD CONSTRAINT fk_species
    FOREIGN KEY (species_id)
    REFERENCES species(id);

ALTER TABLE animals
    ADD CONSTRAINT fk_owner
    FOREIGN KEY (owner_id)
    REFERENCES owners(id);
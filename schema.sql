/* Database schema to keep the structure of entire database. */

CREATE TABLE animals ( 
    id BIGSERIAL NOT NULL, 
    name VARCHAR(50) NOT NULL, 
    date_of_birth DATE NOT NULL, 
    escape_attempts integer NOT NULL, 
    neutered boolean NOT NULL, 
    weight_kg decimal NOT NULL
);

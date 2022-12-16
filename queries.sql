/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';

SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

SELECT * FROM animals WHERE neutered =true and escape_attempts < 3;

SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

SELECT * FROM animals WHERE neutered = true;

SELECT * FROM animals WHERE name NOT LIKE 'Gabumon';

SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;

BEGIN;

  UPDATE animals
  SET species = 'unspecified';

ROLLBACK;

BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
SELECT * FROM animals;
UPDATE animals SET species = 'Pokemon' WHERE species is NULL;
COMMIT;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals; 
ROLLBACK;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT date_birth_Jan_1st_2022;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO date_birth_Jan_1st_2022;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

SELECT COUNT(*) AS "Animals that are there" FROM animals;
SELECT COUNT(*) AS "Animals that have never tried to escape" FROM animals
WHERE escape_attempts = 0;

SELECT AVG(weight_kg) AS "Average weight of animals" FROM animals;
SELECT MAX(escape_attempts), neutered FROM animals GROUP BY neutered;
SELECT Min(weight_kg), Max(weight_kg), species FROM animals GROUP BY species;

SELECT AVG(escape_attempts), species FROM animals 
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' 
GROUP BY species;
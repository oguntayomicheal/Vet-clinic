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

-- Animals that belong to Melody pond
SELECT name AS "Animal Name", full_name AS "Owner"
  FROM animals
  INNER JOIN owners
  ON animals.owner_id = owners.id
  WHERE owners.full_name = 'Melody Pond';

-- animals that are pokemon.
SELECT animals.name AS "Animal Name", species.name AS "Species"
  FROM animals
  INNER JOIN species
  ON animals.species_id = species.id
  WHERE species.name = 'Pokemon';

-- all owners and their animals
SELECT owners.full_name AS "Owner", animals.name AS "Animal Name"
  FROM owners
  LEFT JOIN animals
  ON owners.id = animals.owner_id;

-- Animals per specie

SELECT COUNT(animals.name) AS "Animals Count", species.name AS "Species"
  FROM animals
  INNER JOIN species
  ON animals.species_id = species.id
  GROUP BY species.name;

-- Digimon owned by Jennifer Orwell.
SELECT owners.full_name AS "Owner", animals.name As "Animal", species.name AS "Species"
  FROM owners
  INNER JOIN animals
  ON owners.id = animals.owner_id
  INNER JOIN species
  ON species.id = animals.species_id
  WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

-- animals owned by Dean Winchester that haven't tried to escape.
SELECT owners.full_name AS "Owner", animals.name As "Animal" , animals.escape_attempts
  FROM owners
  INNER JOIN animals
  ON owners.id = animals.owner_id
  WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

--  Who owns the most animals?
SELECT owners.full_name , COUNT(*)
  FROM owners
  INNER JOIN animals
  ON owners.id = animals.owner_id
  GROUP BY owners.full_name
  ORDER BY count DESC LIMIT 1;
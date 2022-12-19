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


-- Who was the last animal seen by William Tatcher?
SELECT vets.name AS "Vet Name", animals.name AS "Animal Name", visits.date_of_visit
  FROM vets
  INNER JOIN visits
    ON vets.id = visits.vet_id
  INNER JOIN animals
    ON visits.animal_id = animals.id
  WHERE vets.name = 'William Tatcher'
  ORDER by date_of_visit DESC LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT vets.name AS "Vet Name", COUNT(DISTINCT animals.name)
   FROM vets
   INNER JOIN visits
     ON vets.id = visits.vet_id
   INNER JOIN animals
     ON visits.animal_id = animals.id
   WHERE vets.name = 'Stephanie Mendez'
   GROUP BY vets.name;

-- List all vets and their specialties, including vets with no specialties.
SELECT vets.name AS "Vet Name", species.name AS "Species"
  FROM vets
  FULL OUTER JOIN specializations
    ON vets.id = specializations.vet_id
  FULL OUTER JOIN species
    ON species.id = specializations.species_id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name AS "Animal", visits.date_of_visit
  FROM animals
  JOIN visits
    ON animals.id = visits.animal_id
  WHERE visits.vet_id = (SELECT id FROM vets WHERE vets.name = 'Stephanie Mendez')
  AND
  visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT animals.name, COUNT(*)
  FROM animals
  JOIN visits
    ON animals.id = visits.animal_id
  GROUP BY animals.name
  ORDER BY count DESC LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT vets.name AS "Vet", animals.name AS "Animal", visits.date_of_visit
  FROM vets
  JOIN visits
    ON vets.id = visits.vet_id
  JOIN animals
    ON visits.animal_id = animals.id
  WHERE vets.name = 'Maisy Smith'
  ORDER BY date_of_visit LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT
  vets.id AS "Vet id", vets.name AS "Vet", date_of_graduation,

  visits.date_of_visit,

  animals.id AS "Animal id", animals.name AS "Animal", date_of_birth, escape_attempts, neutered, weight_kg, species_id, owner_id
  FROM vets
  JOIN visits
    ON vets.id = visits.vet_id
  JOIN animals
    ON visits.animal_id = animals.id
  ORDER BY date_of_visit DESC LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT vets.name
  FROM vets
  JOIN visits
    ON vets.id = visits.vet_id
  LEFT JOIN specializations
    ON vets.id = specializations.vet_id
  WHERE specializations.vet_id IS NULL
  GROUP BY vets.name;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name AS "species", COUNT(animals.species_id)
  FROM vets
  JOIN visits
    ON vets.id = visits.vet_id
  JOIN animals
    ON animals.id = visits.animal_id
  JOIN species
    ON species.id = animals.species_id
  WHERE vets.name = 'Maisy Smith'
  GROUP BY species.name
  ORDER BY count DESC LIMIT 1;
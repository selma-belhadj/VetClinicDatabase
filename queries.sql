/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name = 'Luna';

-- Find all animals whose name ends in "mon".
SELECT * from animals WHERE name like '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT * from animals WHERE date_of_birth between '2016-01-01' and '2019-12-31' ;

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name from animals WHERE neutered='true' and escape_attempts < 3 ;

-- List date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth from animals WHERE name='Agumon' or name='Pikachu' ;

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts from animals WHERE weight_kg > 10.5 ;

-- Find all animals that are neutered.
SELECT * from animals WHERE neutered='true' ;

-- Find all animals not named Gabumon.
SELECT * from animals WHERE name<>'Gabumon' ;

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * from animals WHERE weight_kg >= 10.4 and  weight_kg <= 17.3;

/* Count number of animals */
SELECT COUNT(*) FROM animals;

/* Count number of animals that have not attempted escape */
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

/* Avarage weight of animals */
SELECT AVG(weight_kg) FROM animals;

/* Sum escape attempts and compare between neutered and non-neutered */
SELECT neutered, SUM(escape_attempts) FROM animals GROUP BY neutered;

/* Minimum and maximum weights of each type of animal*/
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals GROUP BY species;

/* Average number of escape attempts per animal type of those born between 1990 and 2000 */
SELECT species, AVG(escape_attempts) FROM animals WHERE date_of_birth 
BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;


/* Write queries (using JOIN) */

-- What animals belong to Melody Pond?
SELECT * FROM
    animals a 
    JOIN owners o
    ON a.owner_id = o.id 
    WHERE full_name='Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT * FROM
    animals a 
    JOIN species s
    ON a.species_id = s.id 
    WHERE s.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT * FROM 
    owners o 
    LEFT JOIN animals a 
    ON a.owner_id=o.id;

-- How many animals are there per species?
SELECT s.name as species, COUNT(*) as animals FROM
    animals a 
    JOIN species s
    ON a.species_id = s.id 
    GROUP BY s.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT * FROM
    animals a 
    JOIN species s
    ON a.species_id = s.id 
    JOIN owners o
    ON a.owner_id = o.id 
    WHERE s.name='Digimon' and o.full_name='Jennifer Orwell';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT * FROM
    animals a 
    JOIN owners o
    ON a.owner_id = o.id 
    WHERE o.full_name='Dean Winchester' and a.escape_attempts<=0;

-- Who owns the most animals?
SELECT o.full_name, count (*) as animals FROM
    animals a 
    JOIN owners o
    ON a.owner_id = o.id 
    GROUP BY o.full_name 
    ORDER BY animals DESC 
    LIMIT(1);

-- Who was the last animal seen by William Tatcher?
SELECT a.name as animal_name, ve.name as vet_name, v.date_visit 
    FROM animals a
    JOIN visits v ON a.id = v.animals_id
    JOIN vets ve ON ve.id = v.vets_id
    WHERE ve.name='William Tatcher'
    ORDER BY v.date_visit DESC
    LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT DISTINCT COUNT(a.name) AS diffrent_animals_seen, ve.name AS vet_name
    FROM visits v
    JOIN vets ve ON ve.id = v.vets_id
    JOIN animals a ON a.id = v.vets_id
    WHERE  ve.name = 'Stephanie Mendez'
    GROUP BY ve.name;

-- List all vets and their specialties, including vets with no specialties.
SELECT vt.name, s.name
    FROM vets vt
    LEFT JOIN specializations sz 
    ON vt.id=sz.vets_id
    LEFT JOIN species s 
    ON s.id = sz.species_id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name as animal_name, ve.name as vet_name, v.date_visit 
    FROM animals a
    JOIN visits v ON a.id = v.animals_id
    JOIN vets ve ON ve.id = v.vets_id
    WHERE ve.name='Stephanie Mendez' 
    AND v.date_visit BETWEEN '2020-Apr-01' AND '2020-Aug-30';

-- What animal has the most visits to vets?
SELECT COUNT(a.name) as animal_visit, ve.name as vet_name, a.name as animal_name
    FROM animals a
    JOIN visits v ON a.id = v.animals_id
    JOIN vets ve ON ve.id = v.vets_id
    GROUP BY a.name,ve.name
    ORDER BY animal_visit DESC
    LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT a.name as animal_name, ve.name as vet_name, v.date_visit 
    FROM animals a
    JOIN visits v ON a.id = v.animals_id
    JOIN vets ve ON ve.id = v.vets_id
    WHERE ve.name='Maisy Smith'
    ORDER BY v.date_visit 
    LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.name as animal_name, a.date_of_birth as animal_date_of_birth, a.escape_attempts, a.neutered, a.weight_kg,
o.full_name as owner_name, s.name as animal_species, 
ve.name as vet_name, ve.age as vet_age, ve.date_of_graduation, 
v.date_visit 
    FROM animals a
    JOIN visits v ON a.id = v.animals_id
    JOIN vets ve ON ve.id = v.vets_id
    JOIN owners o ON a.owner_id=o.id
    JOIN species s ON a.species_id = s.id
    ORDER BY v.date_visit
    LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT ve.id as vets_id, ve.name as vet_name, COUNT(v.date_visit) as nb_of_visits
    from visits v
    LEFT JOIN vets ve ON ve.id = v.vets_id
    LEFT JOIN animals a ON a.id = v.animals_id
    LEFT JOIN specializations sz ON sz.vets_id = ve.id
    LEFT JOIN species s ON s.id = a.species_id 
    WHERE (a.species_id <> sz.species_id OR sz.species_id IS NULL) AND ve.name <> 'Stephanie Mendez'
    GROUP BY ve.name, ve.id;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT ve.name as vet_name, s.name as type_visit , COUNT(v.date_visit) as nb_of_visits
    from visits v
    LEFT JOIN vets ve ON ve.id = v.vets_id
    LEFT JOIN animals a ON a.id = v.animals_id
    JOIN species s ON s.id = a.species_id 
    WHERE ve.name = 'Maisy Smith'
    GROUP BY ve.name, s.name
    ORDER BY nb_of_visits DESC
    LIMIT 1;
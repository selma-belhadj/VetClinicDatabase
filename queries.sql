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


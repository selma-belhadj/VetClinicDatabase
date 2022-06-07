/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id SERIAL not null primary key,
    name  varchar(100) not null,          
    date_of_birth  date not null,           
    escape_attempts int not null,          
    neutered  boolean not null,
    weight_kg real not null
);

/* Add a column species of type string to the animals table */
ALTER TABLE animals 
ADD COLUMN species varchar(100);

--owners table
CREATE TABLE owners (
    id SERIAL PRIMARY KEY NOT NULL, 
    full_name VARCHAR(100) NOT NULL, 
    age INT NOT NULL
);

--species table
CREATE TABLE species (
    id SERIAL PRIMARY KEY NOT NULL, 
    name VARCHAR(100) NOT NULL
);

-- Remove column species
ALTER TABLE animals DROP species;

-- Add column species_id which is a foreign key referencing species table
ALTER TABLE animals 
    ADD COLUMN species_id INT,
    ADD CONSTRAINT fk_species
    FOREIGN KEY (species_id)
    REFERENCES species(id);

--Add column owner_id which is a foreign key referencing the owners table
ALTER TABLE animals 
    ADD COLUMN owner_id INT,
    ADD CONSTRAINT fk_owners
    FOREIGN KEY (owner_id)
    REFERENCES owners(id);

--vets table
CREATE TABLE vets (
    id SERIAL not null primary key,
    name varchar(100) not null,          
    age int not null,   
    date_of_graduation date,                  
);

-- specializations table: joining table
CREATE TABLE specializations (
    vets_id INT NOT NULL,
    species_id INT NOT NULL,
    CONSTRAINT fk_species FOREIGN KEY (species_id) REFERENCES species(id),
    CONSTRAINT fk_vets  FOREIGN KEY (vets_id) REFERENCES vets(id)             
);

-- visits table: joining table
CREATE TABLE visits (
    vets_id INT,
    animals_id INT,
    date_visit DATE ,
    CONSTRAINT fk_animals FOREIGN KEY (animals_id) REFERENCES animals(id),
    CONSTRAINT fk_vets  FOREIGN KEY (vets_id) REFERENCES vets(id)             
); 

-- Performance audit
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

CREATE INDEX idx_animal_id ON visits(animal_id);

CREATE INDEX idx_vet_id ON visits(vet_id);

CREATE INDEX idx_email ON owners(email);

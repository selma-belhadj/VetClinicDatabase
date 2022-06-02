/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id SERIAL not null primary key,
    name  varchar(100) not null,          
    date_of_birth  date not null,           
    escape_attempts int not null,          
    neutered  boolean not null,
    weight_kg real not null
);

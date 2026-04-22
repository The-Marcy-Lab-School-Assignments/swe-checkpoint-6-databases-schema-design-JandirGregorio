-- schema.sql
-- Checkpoint: Schema Design
--
-- Scenario: A cooking platform where chefs publish recipes.
--   - Chefs have a name, hometown, and specialty cuisine.
--   - Each chef can author many recipes.
--   - Each recipe has a title, description, and cook time in minutes.
--   - Recipes use ingredients. An ingredient has a name and a unit (e.g. 'cups', 'grams').
--   - A single recipe uses many ingredients, and the same ingredient can appear
--     in many different recipes. The association also stores the quantity used.
--
-- Your task:
--   Part 1 — Design the schema. Write DROP, CREATE, and INSERT statements below.
--   Part 2 — Write SQL queries to answer the 5 questions at the bottom of this file.
--
-- Run your file to verify it works without errors:
--   Mac:     psql -f schema.sql
--   Windows: sudo -u postgres psql -f schema.sql
--
-- Run it a second time to confirm it still works cleanly.

-- ============================================================
-- Step 1: Create the database and connect to it
-- ============================================================

DROP DATABASE IF EXISTS cooking_db;
CREATE DATABASE cooking_db;
\c cooking_db

-- ============================================================
-- Step 2: Drop tables in reverse dependency order
-- (most dependent first, so foreign key constraints aren't violated)
-- ============================================================



-- ============================================================
-- Step 3: Create tables in dependency order
-- (parent tables first, then tables that reference them)
--
-- Requirements:
--   [ ] Every table has a SERIAL PRIMARY KEY named after the table (e.g. chef_id)
--   [ ] All columns have appropriate data types
--   [ ] Foreign key columns use REFERENCES other_table(other_table_id)
--   [ ] The association table has UNIQUE (col1, col2) on its two foreign key columns
--   [ ] At least two columns across the schema have NOT NULL constraints
-- ============================================================



-- ============================================================
-- Step 4: Seed each table with at least 3 rows of realistic data
-- ============================================================



-- ============================================================
-- Step 5: Write queries to answer each question below
-- ============================================================

-- Question 1:
-- What recipes has the chef named 'Marcus Samuelsson' authored?
-- Show the recipe title and cook time in minutes.


-- Question 2:
-- What ingredients does the recipe titled 'Jollof Rice' use?
-- Show the ingredient name, unit, and quantity.


-- Question 3:
-- How many recipes has each chef authored?
-- Show the chef's name and their recipe count.
-- Order by recipe count from highest to lowest.


-- Question 4:
-- Which ingredients are used in more than 3 recipes?
-- Show the ingredient name and the number of recipes it appears in.

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
DROP TABLE IF EXISTS recipe_ingredients;
DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS ingredients;
DROP TABLE IF EXISTS chefs;


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
CREATE TABLE chefs (
  chef_id           SERIAL      PRIMARY KEY,
  name              TEXT        NOT NULL,
  hometown          TEXT        NOT NULL,
  specialty_cuisine TEXT        NOT NULL
);

CREATE TABLE recipes (
  recipe_id         SERIAL      PRIMARY KEY,
  title             TEXT        NOT NULL,
  description       TEXT        NOT NULL,
  cook_time         INT         NOT NULL,
  chef_id           INTEGER     REFERENCES chefs (chef_id) ON DELETE CASCADE
);

CREATE TABLE ingredients (
  ingredient_id      SERIAL     PRIMARY KEY,
  name               TEXT       NOT NULL,
  unit               TEXT       NOT NULL
);

CREATE TABLE recipe_ingredients (
  recipe_ingredient_id  SERIAL  PRIMARY KEY,
  quantity              INT     NOT NULL,
  recipe_id             INTEGER REFERENCES recipes (recipe_id) ON DELETE CASCADE,
  ingredient_id         INTEGER REFERENCES ingredients (ingredient_id) ON DELETE CASCADE,
  UNIQUE (recipe_id, ingredient_id)
);


-- ============================================================
-- Step 4: Seed each table with at least 3 rows of realistic data
-- ============================================================

INSERT INTO chefs (name, hometown, specialty_cuisine) VALUES
  ('Sofia Reyes',       'Mexico City, Mexico',     'Mexican'),
  ('James Park',        'Seoul, South Korea',      'Korean'),
  ('Lena Bauer',        'Munich, Germany',         'German'),
  ('Marcus Samuelsson', 'Addis Ababa, Ethiopia',   'Ethiopian');

INSERT INTO recipes (title, description, cook_time, chef_id) VALUES
  ('Garlic Pasta',    'A simple yet delicious al dente pasta tossed in garlic and olive oil.',      30,   1),
  ('Fried Rice',      'Delicious stir-fry of rice, eggs, and soy sauce.',                           12,   2),
  ('Tomato Soup',     'Soup prepared with seasonal Jersey Tomatoes, onion, and chicken broth.',     30,   3),
  ('Jollof Rice',     'Exquisite and aromatic rice made with love and more ingredients.',           35,   4),
  ('Veggie Tacos',    'Healthiest option with the best flavor of Mexican food and veggies.',        20,   1),
  ('Shakshouka', 'Eggs poaches in a savory tomatoe sauce, peppers, and onions. Simply spectacular.',  30, 4);

INSERT INTO ingredients (name, unit) VALUES
  ('pasta',         'ounces'), -- 1
  ('garlic',        'cloves'), -- 2
  ('olive oil',     'tablespoons'), -- 3
  ('soy sauce',     'tablespoons'), -- 4
  ('rice',          'cups'), -- 5
  ('eggs',          'whole'), -- 6
  ('tomatoes',      'whole'), -- 7
  ('onion',         'whole'), -- 8
  ('chicken broth', 'cups'), -- 9
  ('red bell peppers', 'whole'), --10
  ('tortillas',     'whole'); -- 11

INSERT INTO recipe_ingredients (quantity, recipe_id, ingredient_id) VALUES
  -- Garlic Pasta
  (8, 1, 1), -- pasta
  (4, 1, 2), -- garlic
  (3, 1, 3), -- olive oil

  -- Fried Rice
  (2, 2, 5), -- rice
  (2, 2, 6), -- eggs
  (2, 2, 4), -- soy sauce

  -- Tomato Soup
  (4, 3, 7), -- tomatoes
  (1, 3, 8), -- onion
  (2, 3, 9), -- chicken broth
  
  -- Jollof Rice
  (2, 4, 5), -- rice
  (4, 4, 2), -- garlic
  (4, 4, 7), -- tomatoes
  (3, 4, 10), -- red bell peppers
  (2, 4, 9), -- chicken broth

  -- Veggie Tacos
  (3, 5, 11), -- tortillas
  (1, 5, 7), -- tomatoes
  (1, 5, 10), -- red bell peppers
  (1, 5, 2), -- garlic
  (2, 5, 3), -- olive oil

  -- Shakshouka
  (4, 6, 7), -- tomatoes
  (1, 6, 10), -- red bell peppers
  (1, 6, 8), -- onion
  (4, 6, 6), -- eggs
  (2, 6, 3), -- olive oil
  (3, 6, 2); -- garlic
-- ============================================================
-- Step 5: Write queries to answer each question below
-- ============================================================

-- Question 1:
-- What recipes has the chef named 'Marcus Samuelsson' authored?
-- Show the recipe title and cook time in minutes.
SELECT recipes.title, recipes.cook_time
FROM recipes
  INNER JOIN chefs
  ON recipes.chef_id = chefs.chef_id
WHERE chefs.name = 'Marcus Samuelsson';

-- Question 2:
-- What ingredients does the recipe titled 'Jollof Rice' use?
-- Show the ingredient name, unit, and quantity.
SELECT ingredients.name, ingredients.unit, recipe_ingredients.quantity
FROM recipes
  INNER JOIN recipe_ingredients
  ON recipes.recipe_id = recipe_ingredients.recipe_id
  INNER JOIN ingredients
  ON ingredients.ingredient_id = recipe_ingredients.ingredient_id
WHERE recipes.title = 'Jollof Rice';

-- Question 3:
-- How many recipes has each chef authored?
-- Show the chef's name and their recipe count.
-- Order by recipe count from highest to lowest.
SELECT chefs.name, COUNT(recipes.recipe_id) AS recipe_count
FROM chefs
  LEFT JOIN recipes
  ON chefs.chef_id = recipes.chef_id
GROUP BY 1
ORDER BY 2 DESC;

-- Question 4:
-- Which ingredients are used in more than 3 recipes?
-- Show the ingredient name and the number of recipes it appears in.
SELECT ingredients.name, COUNT(*) AS recipe_count
FROM ingredients
  INNER JOIN recipe_ingredients
  ON ingredients.ingredient_id = recipe_ingredients.ingredient_id
GROUP BY 1
HAVING COUNT(*) > 3;
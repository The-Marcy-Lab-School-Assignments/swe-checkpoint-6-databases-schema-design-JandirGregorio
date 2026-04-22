# swe-checkpoint-6-databases-schema-design

This checkpoint assesses your ability to design a normalized multi-table database schema and write JOIN queries against it. You will work entirely in `schema.sql`.

- [Scenario](#scenario)
- [Setup](#setup)
- [Grading](#grading)
  - [Part 1: Schema Design (17 pts)](#part-1-schema-design-17-pts)
  - [Part 2: Queries (4 pts)](#part-2-queries-4-pts)

## Scenario

You are building a database for a cooking platform. Here is what you need to store:

- The platform has **chefs**. Each chef has a name, a hometown, and a specialty cuisine.
- Each chef can author many **recipes**. Each recipe belongs to exactly one chef and has a title, a short description, and a cook time in minutes.
- Recipes use **ingredients**. Each ingredient has a name and a unit (e.g. `'cups'`, `'grams'`, `'cloves'`). A single recipe uses many ingredients, and the same ingredient can appear in many different recipes. The link between a recipe and an ingredient also stores the **quantity** used.

Your schema must represent:
- A **one-to-many** relationship between chefs and recipes
- A **many-to-many** relationship between recipes and ingredients, via an association table

---

## Setup

**1. Clone this repo and navigate into it.**

**2. Make a draft branch:**

```sh
git checkout -b draft
```

**3. Work in `schema.sql`.** The file already creates `cooking_db` for you — start writing your `DROP`, `CREATE`, and `INSERT` statements in the sections provided.

When seeding your tables, feel free to use these suggestions or come up with your own:

**Chefs:**
- Sofia Reyes (Mexico City, Mexico — Mexican)
- James Park (Seoul, South Korea — Korean)
- Lena Bauer (Munich, Germany — German)

**Recipes and their ingredients:**

| Recipe       | Ingredient    | Unit        | Quantity |
| ------------ | ------------- | ----------- | -------- |
| Garlic Pasta | pasta         | ounces      | 8        |
| Garlic Pasta | garlic        | cloves      | 4        |
| Garlic Pasta | olive oil     | tablespoons | 3        |
| Fried Rice   | rice          | cups        | 2        |
| Fried Rice   | eggs          | whole       | 2        |
| Fried Rice   | soy sauce     | tablespoons | 2        |
| Tomato Soup  | tomatoes      | whole       | 4        |
| Tomato Soup  | onion         | whole       | 1        |
| Tomato Soup  | chicken broth | cups        | 2        |

**4. Run your file to verify it works end to end:**

**Mac:**
```sh
psql -f schema.sql
```

**Windows/WSL:**
```sh
sudo -u postgres psql -f schema.sql
```

**5. Run it a second time** to confirm all `DROP TABLE IF EXISTS` statements give you a clean slate on each run.

---

## Grading

### Part 1: Schema Design (17 pts)

**Setup (3 pts)**
- [ ] Tables are dropped in reverse-dependency order before they are created.
- [ ] Tables are created in dependency order.
- [ ] When running the seed file a second time, the database and tables are dropped and recreated cleanly.

**Table Structure (8 pts)**
- [ ] Every table has a primary key column with auto-incrementing integer values. The primary key column is named after the table (e.g. `table_id`)
- [ ] All columns have appropriate data types
- [ ] At least two columns across the schema have `NOT NULL` constraints
- [ ] Foreign key columns properly reference the primary key of their dependent table.

**Relationships (4 pts)**
- [ ] The one-to-many relationship (chefs → recipes) is represented with a foreign key column on the child table
- [ ] The many-to-many relationship (recipes ↔ ingredients) is represented with a dedicated association table
- [ ] The association table has a `UNIQUE (col1, col2)` constraint on its two foreign key columns
- [ ] The association table includes a `quantity` column with an appropriate numeric type

**Seed Data (2 pts)**
- [ ] At least 3 rows are inserted into each table with realistic, consistent data

### Part 2: Queries (4 pts)

Each query is worth 1 point based on correctness. Half credit (0.5 points) is awarded for queries that use the right structure but contain minor errors.

- [ ] Q1: Recipes by a specific chef — title and cook time
- [ ] Q2: Ingredients for a specific recipe — name, unit, and quantity
- [ ] Q3: Recipe count per chef, ordered by count descending
- [ ] Q4: Ingredients used in more than 3 recipes

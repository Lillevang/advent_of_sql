# Santa's Gift List Parser


Three tables are provided:

1. Children - contains 1000 kids
2. Wish Lists - contains wish lists in json
3. Toy Catalogue - contains information regarding the toys in the wish lists

## Gift Complexity

The complexity is mapped as follows:

-  Simple Gift: difficulty_to_make = 1
-  Moderate Gift: difficulty_to_make = 2
-  Complex Gift: difficulty_to_make >= 3

## Workshop Assignment

The department is determined by the toy category:

- Outdoor: Outside Workshop
- Educational: Learning Workshop
- All other categories: General Workshop

```sql
SELECT
  c.name,
  wl.wishes::jsonb->>'first_choice' AS primary_wish,
  wl.wishes::jsonb->>'second_choice' AS backup_wish,
  wl.wishes::jsonb->'colors'->>0 AS favorite_color,
  jsonb_array_length(wl.wishes::jsonb->'colors') AS color_count,
  CASE
    WHEN tc.difficulty_to_make = 1 THEN 'Simple Gift'
    WHEN tc.difficulty_to_make = 2 THEN 'Moderate Gift'
    WHEN tc.difficulty_to_make >= 3 THEN 'Complex Gift'
    ELSE NULL
  END AS gift_complexity,
  CASE
    WHEN tc.category = 'outdoor' THEN 'Outside Workshop'
    WHEN tc.category = 'educational' THEN 'Learning Workshop'
    ELSE 'General Workshop'
  END AS workshop_assignment
FROM
  children c
JOIN
  wish_lists wl ON c.child_id = wl.child_id
JOIN
  toy_catalogue tc ON tc.toy_name = wl.wishes::jsonb->>'first_choice'
ORDER BY c.name ASC
LIMIT 5;
```

## Explanation of the Query

### Step 1: Extract Data from JSONB

- Primary Wish: Extracted from wishes->>'first_choice'.
- Backup Wish: Extracted from wishes->>'second_choice'.
- Favorite Color: The first element in the colors array (wishes->'colors'->>0).
- Color Count: Calculated using jsonb_array_length(wishes->'colors').

### Step 2: Map Complexity and Workshop

- Gift Complexity: Mapped based on the difficulty_to_make field.
- Workshop Assignment: Mapped based on the category field.

### Step 3: Join Tables

- Join children with wish_lists on child_id.
- Join wish_lists with toy_catalogue on the first_choice gift name.

### Step 4: Sort and Limit

- Sort results alphabetically by child name (c.name ASC).
- Return the top 5 rows (LIMIT 5).

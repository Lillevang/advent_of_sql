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

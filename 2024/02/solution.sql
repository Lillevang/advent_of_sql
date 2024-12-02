WITH combined_letters AS (
    SELECT id, value FROM letters_a
    UNION ALL
    SELECT id, value FROM letters_b
),
filtered_letters AS (
    SELECT id, value
    FROM combined_letters
    WHERE (value BETWEEN 65 AND 90)   -- Uppercase letters
       OR (value BETWEEN 97 AND 122) -- Lowercase letters
       OR (value BETWEEN 48 AND 57)  -- Numbers
       OR value IN (32, 33, 44, 46)  -- Space, `!`, `,`, `.`
),
decoded_letters AS (
    SELECT id, chr(value) AS character
    FROM filtered_letters
)
SELECT string_agg(character, '' ORDER BY id) AS decoded_message
FROM decoded_letters;

/*
    We first investigate the data. There are a thousand entries of XML
*/

SELECT DISTINCT
    xpath('/*/@version', menu_data::xml)::TEXT AS version
FROM christmas_menus; -- We first discover that there are three different versions of this XML: 1.0, 2.0 and 3.0


-- Looking up the root element of each XML during initial analysis
SELECT id, xpath('/*', menu_data::xml)::TEXT AS root_element
FROM christmas_menus;

/*
    Here we pick out the data of the different XMLs of parties with about 78 participants. 
    Then we go through each type and fetch the number of gates from either of the three versions
    We also extract the foot_item_ids which we can then group by and order by this frequency to find the most popular food item

*/
SELECT
    id,
    unnest(xpath('/*/*', menu_data::xml))::TEXT AS child_elements
FROM christmas_menus;

WITH unified_data AS (
    SELECT
        id,
        COALESCE(
            (xpath('//guest_registry/total_count/text()', menu_data::xml))[1]::TEXT::INTEGER,
            (xpath('//attendance_record/total_guests/text()', menu_data::xml))[1]::TEXT::INTEGER,
            (xpath('//attendance_details/headcount/total_present/text()', menu_data::xml))[1]::TEXT::INTEGER
        ) AS guest.ex_count,
        unnest(
            COALESCE(
                xpath('//menu_items/food_category/food_category/dish/food_item_id/text()', menu_data::xml),
                xpath('//menu_registry/course_details/dish_entry/food_item_id/text()', menu_data::xml),
                xpath('//culinary_records/menu_analysis/item_performance/food_item_id/text()', menu_data::xml)
            )
        )::TEXT::INTEGER AS food_item_id
    FROM christmas_menus
    WHERE COALESCE(
        (xpath('//guest_registry/total_count/text()', menu_data::xml))[1]::TEXT::INTEGER,
        (xpath('//attendance_record/total_guests/text()', menu_data::xml))[1]::TEXT::INTEGER,
        (xpath('//attendance_details/headcount/total_present/text()', menu_data::xml))[1]::TEXT::INTEGER
    ) > 78
)
SELECT
    food_item_id,
    COUNT(*) AS frequency
FROM unified_data
GROUP BY food_item_id
ORDER BY frequency DESC, food_item_id ASC;

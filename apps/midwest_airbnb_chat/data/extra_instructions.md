# Extra Instructions

Rules the LLM follows when it writes SQL for `listings`.

- `price` is the nightly price in U.S. dollars. When the user asks what something costs, use `price` and round money to whole dollars in the answer.
- `host_is_superhost` is a boolean indicator where `t=true` means the host is an Airbnb Superhost and `f=false` means they are not. When filtering or discussing Superhosts, use this column.
- `availability_365` represents the number of available days out of the next 365. When analyzing property availability or utilization, use `availability_365` alongside `minimum_nights` to check booking constraints.
- `estimated_revenue_l365d` is a custom-calculated field for estimated revenue over the last 365 days. When discussing earnings or financial performance, use this column and format currency values rounded to whole dollars.

<!-- Add more rules below (Assignment 05 asks for at least three). Good candidates:
     `host_is_superhost` and `instant_bookable` are the text values 't' and 'f',
     not booleans; how to match a city name the user types; how to search `name`
     case-insensitively; and whether to ignore rows whose `review_scores_rating`
     is NULL when averaging ratings. -->

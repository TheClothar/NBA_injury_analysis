# NBA Injury Analysis: ACL & Achilles Tears

## Introduction
- Brief overview of the project and your motivation for choosing this topic.

## Questions Explored
- List of key questions you aimed to answer
- How do ACL and Achilles injuries affect players performance the first, and second year back since injury
- Are certain positions more at risk of acl/achilles injury?
-Are certain age groups more at risk of acl/achilles injury?
- are these injuries more likely in the late season and playoffs when the games are higher stakes? 
- are star players more likely to have one of these injuries?

## Project Steps
- Outline of the steps you took (e.g., data collection, cleaning, analysis, visualization).
- The fist thing i did was try to gather data. I looked for good data sets online and found nearly nothing that worked. Alot of the datasets were clearly missing alot of data.
-I found two datasets that worked, The first was a list of players put on or taken off injury leave
from 2010-11 to 2019-20
-The second was data off every single player on injury leave for every game from 2021-22 to 2023-24
- I cleaned and normalized both lists and then concatenated them. I also added the relevant missing acl/achilles injuries from 2020-2021.
-I then had a master table of all acl/achilles injuries for 2020 - 2024 with player name, date of injury, type of injury and team they played for.

-I similtnously was looking for the average season stats for every player in those years so I could compare their injuries to their stats
- I found the information i was looking for on basketball-reference.com for this. 
- I started scraping the website to get the fundamental database, I managed to download the html pages before I ran into alot of problems with the html formating of the database and how that affected the scraping.
-I decided to instead just manually copy the databases into csv files because there is a time to put learning everything aside and just get things done.

## What I Learned
- Key skills and insights gained during the project.

## Mistakes & Challenges
- Honest discussion of mistakes made and how you overcame challenges.
- Often time websites will block non human seeming visitors, so make sure to delay subseququent requests with a timer
- make sure to use a scraper that can get around cloudflare or else the scraping will fail (selenium works)
- Make sure to check that all data is imported correctly before starting normalization, I started working on data before realizing that only half the data set was actually uploaded into the table in SQL
-Make sure to save work frequently and upload to github. My computer crashed  and I lost a bunch of my work
-Make sure to work on copies of tables, do not work on the original tables in case a mistake is made.
- Often time data needs to be sanitized before uploading to a SQL GUI, 
    - One of my csv files had italic quotation marks 12000 rows in that stopped the data import
    - Another one of my csv files had such long text in a some cells that it exceeded the varchar 50 limit and would skip rows,
    - Both of these things can skew data

## Insights & Findings
- Summary of interesting results or trends discovered.

## Methodology
- How data is collected, cleaned, and analyzed.
- Tools and libraries used (e.g., Python, pandas, matplotlib).

## Data Sources
- Description of datasets used (e.g., public NBA injury reports, player stats).

## Future Work
- Planned improvements or additional analyses.

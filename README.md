# 8_weeks_SQL_Challenge
Resolution of all the use cases from the web site https://8weeksqlchallenge.com/

The 8 weeks SQL Challenge is a set of exercices involving writing SQL queries to resolves most of the use cases existing in differents business types:
- 1- Danny's Diner: https://8weeksqlchallenge.com/case-study-1/
- 2- Pizza Runner: https://8weeksqlchallenge.com/case-study-2/

## For local use:
-Clone the repository
```sh
git clone https://github.com/Henokagb/8_weeks_SQL_Challenge.git
cd 8_weeks_SQL_Challenge
```
-Enter in a weekN folder
```sh
cd week1
```
-Go in the tasks folder and click on the link in the CaseStudy.txt to access the problem statement, Entity Relationship Diagram, case study questions ...

-Import the schema and the data from the schema.sql file (I am using the postgresql syntax but you can use whatever you want: mySQL, SQLite ...)
```example postgresql
psql -U username -d database < schema.sql
````

-Write the queries to answer the questions

-Check the results in the caseN files and improve them if possible.

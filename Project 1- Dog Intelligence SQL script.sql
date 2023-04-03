CREATE TABLE akc (
	DogID INT PRIMARY KEY,
    breed varchar(50),
    height_low INT,
    height_high INT,
    weight_low INT,
    weight_high INT);

CREATE TABLE iq (
	id INT UNIQUE,
    classification VARCHAR(50),
    obey DECIMAL(3,2),
    reps_lower INT,
    reps_upper INT,
    FOREIGN KEY (id) REFERENCES akc(DogID));
    
    
-- Created a quicker view from the joined Tables
CREATE VIEW joined_table As
	SELECT *
	FROM akc
	JOIN iq
		ON iq.id = akc.DogID;


-- Pulling certain columns from the created view to look at all the top performing breeds
SELECT breed, classification, obey
FROM joined_table
WHERE classification = 'Brightest Dogs';


-- Adding the AKC size catergory to the querry and ordering from descending order to input as a view
CREATE VIEW size AS
SELECT Breed, obey, Classification, ((weight_high + weight_low)/2) AS avg_weight
	,CASE
		WHEN weight_high <= 9 THEN 'Toy'
        WHEN weight_high > 9 AND weight_high <= 35 THEN 'Small'
        WHEN weight_high > 35 AND weight_high <= 65 THEN 'Medium'
        WHEN weight_high > 65 AND weight_high <= 85 THEN 'Large'
			ELSE 'Giant'
		END AS size_group
FROM joined_table
WHERE obey IS NOT NULL 
	AND weight_low IS NOT NULL
ORDER BY size_group DESC, obey DESC;


-- Using the size view to see the count of iq classification and size_group while grouping the variables together
SELECT size_group, classification, COUNT(*)
FROM size
WHERE classification = 
GROUP BY size_group, classification
ORDER BY size_group, 3 DESC; 

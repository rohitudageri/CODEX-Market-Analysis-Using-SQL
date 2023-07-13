# a. Who prefers energy drink more? (male/female/non-binary?)
SELECT Gender,count(*) as Preference_count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Preference_percentage
FROM dim_repondents dr
INNER JOIN fact_survey_responses fs
ON fs.Respondent_ID = dr.Respondent_ID
GROUP BY Gender 
ORDER BY Preference_count DESC;

# Consume_frequency count categorization
SELECT fs.Consume_frequency, 
       Gender,
	  COUNT(*) AS Preference_count,
	  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY fs.Consume_frequency), 2) AS Preference_percentage,
      RANK() OVER (PARTITION BY fs.Consume_frequency ORDER BY COUNT(*) DESC) AS Gender_Rank
FROM dim_repondents dr
INNER JOIN fact_survey_responses fs 
ON fs.Respondent_ID = dr.Respondent_ID
GROUP BY fs.Consume_frequency,Gender
ORDER BY fs.Consume_frequency,Preference_count DESC;



# b. Which age group prefers energy drinks more?

SELECT age,count(*) as Preference_count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Preference_percentage
FROM dim_repondents dr
INNER JOIN fact_survey_responses fs
ON fs.Respondent_ID = dr.Respondent_ID
GROUP BY age
ORDER BY Preference_count DESC;

# c. Which type of marketing reaches the most Youth (15-30)?

SELECT Marketing_channels,
       COUNT(*) AS Reach_Count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Preference_percentage
FROM dim_repondents r
INNER JOIN fact_survey_responses fs 
ON r.Respondent_ID = fs.Respondent_ID
WHERE r.Age IN ("15-18" ,"19-30")
GROUP BY Marketing_channels
ORDER BY Reach_Count DESC;



--  Consumer Preferences:

# a) What are the preferred ingredients of energy drinks among respondents?
SELECT Ingredients_expected,count(*) as Preferred_count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS Preference_percentage
FROM fact_survey_responses 
GROUP BY Ingredients_expected
ORDER BY Preferred_count DESC;

# b) What packaging preferences do respondents have for energy drinks?
SELECT Packaging_preference, count(*) as Preferred_count
FROM fact_survey_responses
GROUP BY Packaging_preference
ORDER BY Preferred_count DESC;


-- Competition Analysis

# a) Who are the current market leaders?
SELECT  Current_brands AS Brand, count(*) AS Brand_Count
FROM fact_survey_responses
GROUP BY Current_brands
ORDER BY Brand_Count DESC;

# b) What are the primary reasons consumers prefer those brands over ours?
SELECT Reasons_for_choosing_brands,COUNT(*) AS Preference_Count
FROM fact_survey_responses
GROUP BY Reasons_for_choosing_brands
ORDER BY Preference_Count DESC;


-- Marketing Channels and Brand Awareness

# a) Which marketing channel can be used to reach more customers?
SELECT Marketing_channels,
       COUNT(*) AS Reach_Count
FROM fact_survey_responses  
GROUP BY Marketing_channels
ORDER BY Reach_Count DESC;


# b) How effective are different marketing strategies and channels in reaching our customers?
SELECT Marketing_channels,Current_brands, COUNT(*) AS Reach_Count
FROM fact_survey_responses
GROUP BY Marketing_channels,Current_brands
HAVING Current_brands = "Codex"
ORDER BY Reach_Count DESC;


-- Brand Penetration

# a) What do people think about our brand? (overall rating)
SELECT Current_brands,
       Brand_perception,COUNT(*) AS Perception_Count,
       COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS Percentage_Contribution
FROM fact_survey_responses
WHERE Current_brands = 'CodeX' and
Heard_before = "Yes" and Tried_before = "Yes"  -- out of 10k people , 4.4k people hear and only 2.2k tried them.
GROUP BY Brand_perception
ORDER BY Perception_Count DESC;


# b) Which cities do we need to focus more on ?
SELECT c.City,
	  COUNT(*) AS Respondent_Count,
	  SUM(CASE WHEN r.Gender = 'Male' THEN 1 ELSE 0 END) AS Male_Count,
	  SUM(CASE WHEN r.Gender = 'Female' THEN 1 ELSE 0 END) AS Female_Count,
	  SUM(CASE WHEN r.Gender = 'Non-binary' THEN 1 ELSE 0 END) AS Non_binary_Count
FROM dim_repondents r
INNER JOIN dim_cities c 
ON r.City_ID = c.City_ID
GROUP BY c.City
ORDER BY Respondent_Count ;


-- Purchase Behavior

#a) Where do respondents prefer to purchase energy drinks
SELECT Purchase_location,count(*) as Preferred_Location_count
FROM fact_survey_responses
GROUP BY Purchase_location 
ORDER BY Preferred_Location_count DESC ;

#b) What are the typical consumption situations for energy drinks among respondents?
SELECT Typical_consumption_situations,count(*) as Preferred_situation_count
FROM fact_survey_responses
GROUP BY Typical_consumption_situations
ORDER BY Preferred_situation_count DESC;

#c) What factors influence respondents' purchase decisions, such as price range and limited edition packaging?
SELECT dr.Gender,
       fs.Price_range,
       COUNT(*) AS Respondent_Count
FROM fact_survey_responses fs
INNER JOIN dim_repondents dr
ON fs.Respondent_ID = dr.Respondent_ID
GROUP BY dr.Gender, fs.Price_range
ORDER BY Respondent_Count DESC;


#Limited_edition_packaging
SELECT Limited_edition_packaging,
       COUNT(*) AS Respondent_Count
FROM fact_survey_responses
GROUP BY Limited_edition_packaging
ORDER BY Respondent_Count DESC;

#Price_range
SELECT Price_range,
       COUNT(*) AS Respondent_Count
FROM fact_survey_responses
GROUP BY Price_range
ORDER BY Respondent_Count DESC;


-- Product Development

#a) Which area of business should we focus more on our product development? (Branding/taste/availability)
SELECT Reasons_for_choosing_brands,count(*) as Respondent_count,
		COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS Percentage_Contribution
FROM fact_survey_responses 
GROUP BY Reasons_for_choosing_brands 
HAVING Reasons_for_choosing_brands IN ("Brand reputation","taste/Flavor preference","availability")
ORDER BY Respondent_count ; 

# Improvements Desired
SELECT Improvements_desired,count(*) as Respondent_count
FROM fact_survey_responses 
GROUP BY Improvements_desired 
ORDER BY Respondent_count DESC; 


SELECT Reasons_preventing_trying,count(*) as Respondent_count
FROM fact_survey_responses 
GROUP BY Reasons_preventing_trying 
ORDER BY Respondent_count DESC; 


SELECT Taste_experience,count(*) as Respondent_count
FROM fact_survey_responses 
GROUP BY Taste_experience 
ORDER BY Respondent_count DESC; 

SELECT Consume_reason,count(*) as Respondent_count
FROM fact_survey_responses 
GROUP BY Consume_reason 
ORDER BY Respondent_count DESC; 
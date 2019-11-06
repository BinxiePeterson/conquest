
# CHALLENGE 1 -------------------------------------------------------------

# 1.1. What are the values after each statement in the following?

mass <- 47.5            
# mass = ?

age  <- 122
# age = ?

mass_index <- mass/age
# mass_index = ?

mass <- mass * 2.0
# mass = ?

mass_index
# mass_index = ?


# CHALLENGE 2 -------------------------------------------------------------

# 2.1. What will happen in each of the following examples
# (hint: use class() to check data type or look at the environment)

num_char <- c(1, 2, 3, "a")


num_logical <- c(1, 2, 3, TRUE)


char_logical <- c("a", "b", "c", TRUE)


tricky <- c(1, 2, 3, "4")



# CHALLENGE 3 -------------------------------------------------------------


# 3.1. Can you figure out why "four" > "five" returns TRUE?

"four" > "five"



# CHALLENGE 4 -------------------------------------------------------------

# 4.1. Use the following vector (heights in inches) and create a new vector with NAs removed
heights <- c(63, 69, 60, 65, NA, 68, 61, 70, 61, 59, 64, 69, 63, 63, NA, 72, 65, 64, 70, 63, 65)





# 4.2. Calculate the median of the heights vector



# 4.3. How many people in the set are taller than 67 inches?







# CHALLENGE 5 -------------------------------------------------------------

## Based on output of str(surveys), answer the following:

str(surveys)

# 5.1. What is the class of the object surveys?  



# 5.2. How many rows and columns are in this object?  



# 5.3. How many species have been recorded during these surveys? 



# CHALLENGE 6 -------------------------------------------------------------

# 6.1. Notice how `nrow()` gave you the number of rows in a `data.frame`?
#      Use that number to pull out just that last row in the data frame.



# 6.2. Compare that with what you see as the last row using `tail()` 
#     to make sure it's meeting expectations.




# 6.3. Use `nrow()` to extract the row that is in the middle of the data frame.
#    Store the content of this row in an object named `surveys_middle`.



# 6.4. Combine `nrow()` with the `-` notation above to reproduce the behavior of
#   `head(surveys)` keeping just the first through 6th rows of the surveys dataset.



# CHALLENGE 7 -------------------------------------------------------------

# 7.1. Rename "F" and "M" to "female" and "male", respectively



# 7.2. Check that the levels have been renamed



# 7.3. Recreate the bar plot such that "undetermined" is last (after "male")



# CHALLENGE 8 -------------------------------------------------------------

# 8.1. Instead of creating a data frame with read.csv(), create your own using data.frame()
# The following code has a few mistakes. Fix the code. 

animal_data <- data.frame(animal = c(dog, cat, sea cucumber, sea urchin),
                          feel = c("furry", "squishy", "spiny"),
                          weight = c(45, 8 1.1, 0.8))

# 8.2. Can you predict the class for each of the columns in the following example?
     # Check your guesses using `str(country_climate)`:

country_climate <- data.frame(country=c("Canada", "Panama", "South Africa", "Australia"),
                              climate=c("cold", "hot", "temperate", "hot/temperate"),
                              temperature=c(10, 30, 18, "15"),
                              northern_hemisphere=c(TRUE, TRUE, FALSE, "FALSE"),
                              has_kangaroo=c(FALSE, FALSE, FALSE, 1))

#      8.2.1. Are they what you expected? Why? why not?
#      8.2.2. What would have been different if we had added `stringsAsFactors = FALSE`
#        to this call?
#      8.2.3. What would you need to change to ensure that each column had the
#        accurate data type?


# 8.3. How can the code be improved?



# CHALLENGE 9 -------------------------------------------------------------

# 9.1. Using pipes, subset the survey data to include individuals collected before
# 1995 and retain only columns "year", "sex", and "weight"





# CHALLENGE 10 ------------------------------------------------------------

# 10.1. Create a new data frame from the survey data with the following:
#       * only species_id column and hindfoot_half column
#       * The new column called "hindfoot_half" should contain 
#       * values that are half the hindfoot_length values, and
#       * there should be no NAs in the hindfoot_half column
#       * all values the hindfoot_half column should be less than 30





# CHALLENGE 11 ------------------------------------------------------------

# 11.1. How many individuals were caught in each "plot_type" surveyed?



# 11.2. Use group_by() and summarize() to find the mean, min, and max 
#    hindfoot_length for each species (using species_id). Also add
#    the number of observations (hint: see ?n).



# 11.3. What was the heaviest animal measured in each year?




# CHALLENGE 12 ------------------------------------------------------------

# 12.1. Spread the surveys data frame with `year` as columns, 
#    `plot_id`` as rows, and 
#    the values are the number of genera per plot. 
#    You will need to summarize before reshaping, and 
#    use the function `n_distinct` to get the number of unique types of a genera. 
#    It's a powerful function! See `?n_distinct` for more information.




# 12.2. Now take that data frame, and gather() it again, 
#    so each row is a unique `plot_id` by `year` combination




# 12.3. The `surveys` data set contains two columns of measurement - 
#    `hindfoot_length` and `weight`.  
#    This makes it difficult to do things like look at the 
#    relationship between mean values of each measurement 
#    per year in different plot types. Let's walk through 
#    a common solution for this type of problem. 

#    First, use `gather` to create a dataset where 
#    we have a key column called `measurement` and a `value` 
#    column that takes on the value of either `hindfoot_length` 
#    or `weight`. Hint: You'll need to specify which columns 
#    are being gathered.

# 12.4. With this new dataset, calculate the average 
#    of each `measurement` in each `year` for each different 
#    `plot_type`. Then `spread` them into a data set with 
#    a column for `hindfoot_length` and `weight`. 
#    Hint: Remember, you only need to specify the key and value 
#    columns for `spread`.




# CHALLENGE 13 ------------------------------------------------------------

# 13.1. Create a scatter plot of weight over species_id
# with plot types showing in different colors




# CHALLENGE 14 ------------------------------------------------------------

# 14.1. Boxplots are useful summaries, but hide the *shape* of the distribution.
# Replace the boxplot with a violin plot to see the shape; see geom_violin()





# 14.2. Change the scale of the axis to better distribute observations; see scale_y_log10()




# 14.3. Create a boxplot for distribution of hindfoot_length for each species




# 14.4. Add color to the datapoints according to the plot from which the sample was
# taken (plot_id)
# Hint: check class for plot_id - change from integer to factor




# 14.5. Why does this change how R makes the graph?




# CHALLENGE 15 ------------------------------------------------------------

# 15.1. Create a plot that depicts how the average weight of each species changes
# through the years




# CHALLENGE 16 ------------------------------------------------------------

# 16.1. Try to improve one of the plots generated in
# this exercise or make one of your own

# Some ideas:
# Change the thickness of the lines
# Change the name of the legend and the labels
# Try using a different color palette (http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/)





# THE END -----------------------------------------------------------------

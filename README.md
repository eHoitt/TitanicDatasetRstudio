# The Titanic Dataset analyzed in R Studio 

This coding task and dataset came from [Kaggle.com](https://www.kaggle.com/c/titanic/data).
I followed the following [tutorial on Youtube.](https://www.youtube.com/watch?v=Zx2TguRHrJE) 

I began by cleaning the data - all N/A values were replaced with the median value.  Using a median to replace missing data can produce inaccurate conclusions about the data. "Fare" is especially misleading because "fare" depends on other variables such as Pclass and Age. I then use a  simple least square linear regression model to predict fare and age. For example, this model predicted that passenger 1044 paid 7 dollars for fare. Applying the model to the entire dataset, I was able to fill in n/a values with the model’s output. I then implemented the same filter for age. 

This project represents my first attempt at using RStudio. 

In this exercise, we will analyze the US Oil & Gas production from June 2008 to June 2018. The dataset is [available on Kaggle](https://www.kaggle.com/djzurawski/us-oil-and-gas-production-june-2008-to-june-2018), and we already downloaded the CSVs in the exercise folder. They are located under the `data` subfolder, no need for you to download it again.

When analyzing data, we don't start with VS Code and write code, we stay in the notebook. VS Code will come later when we will do some **Data Engineering** and create a script to be run at once.  For this challenge we provide a completely blank notebook and will walk you through the proper steps to keep an organized and presentable notebook while we explore the data set.  You will go back & forth between these instructions and the Notebook where you will write the code. Have fun!

Let's start by launching jupyter notebook:

```bash
jupyter notebook
```

Click on the `oil_and_gas.ipynb` link to open the notebook. This is where you will write notes & Python code.


## Start Documenting

There should be a default code cell in your notebook, change its type to **Markdown** and copy-paste the following in it to create a header for your notebook:

```markdown
# U.S. Oil and Gas Production Analysis

Analysing the [Kaggle Dataset](https://www.kaggle.com/djzurawski/us-oil-and-gas-production-june-2008-to-june-2018) with information about Oil and Gas production in the US from June 2008 to June 2018.
```

Type `⇧ + ↩` to save and exit edit mode.

## Loading Modules

In the next code cell we want to import the libraries we'll need for our data exploration.  Copy paste the following:

```python
import numpy as np
import pandas as pd
import matplotlib
```

Type `⇧ + ↩` to **run** the code. It will be _remembered_ throughout the Jupyter Session (until you kill the `jupyter notebook` command in your terminal with `Ctrl+C`).

## Loading data from a CSV

Change the type of the next cell to Markdown and copy-paste the following in it:

```markdown
---

Let's load the Gas production:
```

Remember, a Jupyter notebook is not just about writing Python code, otherwise we would have stayed in VS Code!


Insert a cell below (code, the default) and write the two lines to load the **gas** consumption. Then visualize the `DataFrame` with the `.head()` function.

```python
file = "data/U.S._natural_gas_production.csv"
gas_df = pd.read_csv(file, decimal=",")
gas_df.head(3)
```

Type `⇧ + ↩` to **run** the code. You should see the [**`head(n)`**](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.head.html) of the DataFrame

There are some cells you might _always_ want to add just after having loaded a CSV file into a dataframe to get some insights about the **structure** and **size**, add each of the below to new cells in your notebook:

```python
# Check how many rows and columns in the dataframe
gas_df.shape
```

```python
# Display all the available column names in the dataframe
gas_df.columns
```

```python
# Display additional info about each columns such as data types and number of non-null values
gas_df.info()
```

With this last one, we can see that the column `Month` is loaded as an `object` and **not** recognized as a date! We need to help Pandas a bit and do some post-load treatment on it. Let's do that in our next section:

## Converting the `Month` column to `datetime`

Open and read the documentation on [`pd.to_datetime()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.to_datetime.html). Insert a new code cell and try to **update** the `Month` column to a proper `datetime`.

### Test your code

Add a new **markdown** cell:

```markdown
### Check your code
```
Let's see if our column was successfully converted.

For this challenge we **won't be using** `make`. Instead, we will use the testing tool `nbresult` directly in the notebook.

Copy the following into a new cell:

```python
month_type = gas_df['Month'].dtype
```

and another one which will persist your variables for the testing tool `nbresult`:

```python
from nbresult import ChallengeResult

result = ChallengeResult('date',
    month_type=month_type,
)
result.write()
```
You can now check your code with:

```python
print(result.check())
```

If you got 100% commit the change and continue with the next section.

Now that we have done that, you can treat the values inside the column `Month` as `datetime` objects, add a cell to your notebook and run the code below to see new ways we can interact with the `Month` column:

```python
gas_df['Month'].dt.year.head()
```

```python
gas_df['Month'].dt.month.tail()
```


## Grouping rows

As we are starting a new block of exploration, insert a **Markdown** cell and append the following code:

```markdown
---

## Yearly Gas production
```

Now that we have prepared the dataframe, we can try to answer a first Business-related question:

> How much gas has been produced yearly by each US state, and by the US as a whole?

To answer this question, we need to **aggregate** the rows based on the **year** of the `Month` column. Go ahead, insert a new code cell and code this aggregation.  Assign the resulting dataframe to a variable named `yearly_gas_df`.


<details><summary markdown='span'>Hint
</summary>

 Take a look at [`DataFrame.groupby()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.groupby.html) and [`DataFrame.sum()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.sum.html).

</details>

### Test your code

Add a new **markdown** cell:

```markdown
### Check your code
```
Let's see if our dataframe was successfully grouped, copy the following into a new cell:

```python
index_year = yearly_gas_df.index[0]
yearly_gas_shape = yearly_gas_df.shape
us_total = yearly_gas_df.iloc[0,0]
```

and another one which will persist your variables for the testing tool `nbresult`:

```python
from nbresult import ChallengeResult

result = ChallengeResult('full_gas',
    index_year=index_year,
    yearly_gas_shape=yearly_gas_shape,
    us_total=us_total
)
result.write()

print(result.check())
```

If you got 100% commit the change and continue with the next section.

## Plotting results

Once we have successfully aggregated this dataframe, time to **plot** the total production in the `U.S.` thanks to the [`DataFrame.filter()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.filter.html) and the [`DataFrame.plot()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.plot.html) functions.

<details><summary markdown='span'>View solution
</summary>

We will go into much more depth on plotting in future sessions, for now we can quickly plot the `U.S.` column (total production) of this aggregated dataframe with the following line:

```python
plot = yearly_gas_df.filter(items=['U.S.']).plot(kind="bar")
plot.set_xlabel("Year");
```

</details>

## Discarding rows with Boolean Indexing

In the previous section, we've seen that the production data is not complete for the year 2008 and 2018 (we only have half of the year). We'd like to continue working with full years, meaning we need to discard the first and last rows of `yearly_gas_df` based on the year.

Create a new dataframe called `filtered_yearly_gas_df` consisting of only the years that had all 12 months of production reported.

<details><summary markdown='span'>Hint
</summary>

 We can look at the **index** of the DataFrame, and build a [**boolean condition**](https://pandas.pydata.org/pandas-docs/stable/user_guide/indexing.html#boolean-indexing) using [`np.logical_and`](https://docs.scipy.org/doc/numpy/reference/generated/numpy.logical_and.html):

</details>


Can you plot your new dataframe?

### Test your code
Before going to the next step check if you performed the above steps correctly.

Add a new **markdown** cell:

```markdown
### Check your code
```

Then paste the following into a new code cell:

```python
from nbresult import ChallengeResult

result = ChallengeResult('filtered_gas',
    yearly_gas=filtered_yearly_gas_df.shape
)
result.write()

print(result.check())
```

If you got 100% commit the change and continue with the next section.


## Plotting several columns

Let's now create a new section in our Notebook to analyze the Gas production of different states in the US. First, let's insert a **Markdown** cell:

```markdown
## State production

Let's have a look at the yearly production of some specific states
```

Then let's have a look at the available states, looking at all the columns _except_ the first one.  We can use the dataframes `columns` attribute to see a clean print out of the available columns:

```python
filtered_yearly_gas_df.columns[1:].sort_values()
```

:question: Can you insert a new cell and write the code to plot linecharts of the gas production of four states of your choice? You can start from the `filtered_yearly_gas_df` dataframe.

<details><summary markdown='span'>View solution
</summary>
If we wanted to pick Colorado, Louisiana, Ohio and Utah, this is how we could do it:

```python
plot = filtered_yearly_gas_df.filter(items=['Colorado', 'Louisiana', 'Ohio', 'Utah']).plot()
plot.set_xlabel("Year");
```
</details>



## Loading a second CSV

The Kaggle dataset we are using does not only have information about the gas production, there is also some info about **crude oil**. Create a new section in your Notebook with the following Markdown cell:

```markdown
---

## Comparing with Crude Oil Production
```

Load the `U.S._crude_oil_production.csv` file located inside the `data` directory and assign it to a new dataframe called `oil_df`:

- Load it with the [`pd.read_csv()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_csv.html) function
- Parse the `Month` column into a `datetime` object

<details><summary markdown='span'>Hint
</summary>

Do you see anything in the [`pd.read_csv()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.read_csv.html) documentation that can help convert the `Month` column into a `datetime` object upon the initial load?

</details>



Let's take similar steps with investigating this new data, insert a **Markdown** cell and append the following code:

```markdown
---

## Yearly Oil production
```

Now aggregate the rows based on the year of the `Month` column. Insert a new code cell and code this aggregation using DataFrame.groupby() and DataFrame.sum(), assigning the result to a new variable called `yearly_oil_df`.  Let's plot the total U.S. Crude Oil production by year from our new dataframe.  Do you notice anything that might prevent us from doing this?  Take a look at the your column names through the `yearly_oil_df.columns` attribute.

<details><summary markdown='span'>Hint
</summary>

Have a look at the [`str.strip`](https://pandas.pydata.org/docs/reference/api/pandas.Series.str.strip.html#pandas.Series.str.strip) documentation.

</details>

Once you have handled the column names insert a new cell to plot the `U.S. Crude Oil` column:

```python
yearly_oil_df.filter(items=['U.S. Crude Oil']).plot(kind='bar');
```

Again, let's filter our `yearly_oil_df` to only contain years with 12 full months of data.  Assign this new dataframe to a variable called `filtered_yearly_oil_df`

### Test your code

Add a new **markdown** cell:

```markdown
### Check your code
```

and then the code to persist and test your variables:

```python
from nbresult import ChallengeResult

result = ChallengeResult('oil',
    filtered_oil_shape=filtered_yearly_oil_df.shape,
    filtered_oil_index_year=filtered_yearly_oil_df.index[0],
    us_total=filtered_yearly_oil_df.iloc[0,0]
)
result.write()

print(result.check())
```

If you got 100% commit the change and continue with the next section.

## Merging Datasets

Let's create a new dataframe, holding the U.S. totals for both Oil and Gas production by year. Start with adding a new section into your notebooks by inserting a new markdown cell:

```markdown
## Merging Oil and Gas Production
```

Next create two dataframes `total_gas` and `total_oil` filtering only the **total US** production for both commodities from the `filtered_yearly_oil_df` and `filtered_yearly_gas_df` dataframes. [Rename the columns](https://stackoverflow.com/questions/11346283/renaming-columns-in-pandas) in each of the new dataframes to `Gas` and `Crude Oil`.



Now that you have those two dataframes, create one by concatenating both. Store this new dataframe into a `merged_df` variable. You should use the [`pd.concat()`](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.concat.html) function, and don't forget to set the `axis` parameter!


Finally, plot the `merged_df` dataframe and try to set the legend to include the units advertised in the original [Kaggle dataset](https://www.kaggle.com/djzurawski/us-oil-and-gas-production-june-2008-to-june-2018).

<details><summary markdown='span'>View solution
</summary>

```python
plot = merged_df.plot(kind="bar")
plot.set_xlabel("Year")
plot.legend(['Gas (Millions of Cubic feet)', 'Crude Oil (Thousands of barrels)']);
```

</details>

### Test your code

Add a new **markdown** cell:

```markdown
### Check your code
```

and then the code to persist your variables:

```python
from nbresult import ChallengeResult

result = ChallengeResult('merged_dataframes',
    merged_df_shape=merged_df.shape,
    yearly_oil_2009=merged_df.iloc[0]["Crude Oil"],
)
result.write()

print(result.check())
```

That's it, congratulations on completing your first Data Analysis through a Jupyter Notebook :clap:

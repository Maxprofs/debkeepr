
<!-- README.md is generated from README.Rmd. Please edit that file -->
debkeepr: Analysis of Non-Decimal Currencies and Double-Entry Bookkeeping
=========================================================================

[![Travis build status](https://travis-ci.org/jessesadler/debkeepr.svg?branch=master)](https://travis-ci.org/jessesadler/debkeepr) [![Coverage status](https://codecov.io/gh/jessesadler/debkeepr/branch/master/graph/badge.svg)](https://codecov.io/github/jessesadler/debkeepr?branch=master)

`debkeepr` provides an interface for analyzing non-decimal currencies that use the tripartite system of pounds, shillings, and pence. It includes functions to apply arithmetic and financial operations to single or multiple values and to analyze account books that use either [single-entry bookkeeping](https://en.wikipedia.org/wiki/Single-entry_bookkeeping_system) or [double-entry bookkeeping](https://en.wikipedia.org/wiki/Double-entry_bookkeeping_system) with the latter providing the name for `debkeepr`. The use of non-decimal currencies throughout the medieval and early modern period presents difficulties for the analysis of historical accounts. The pounds, shillings, and pence system complicates even relatively simple arithmetic manipulations, as each unit has to be [normalized](https://en.wikipedia.org/wiki/Arithmetic#Compound_unit_arithmetic) or converted to the correct base. `debkeepr` does the work of applying arithmetic operations and normalizing the units to the correct bases. `debkeepr` uses numeric vectors of length three, lists of such numeric vectors, and three separate variables in a data frame to represent pounds, shillings, and pence values.

The system of recording value according to pounds, shillings, and pence — or to use the Latin terms from which the English derived [libra](https://en.wikipedia.org/wiki/French_livre), [solidus](https://en.wikipedia.org/wiki/Solidus_(coin)), and [denarius](https://en.wikipedia.org/wiki/Denarius) — developed in the 7th and 8th century in the Carolingian Empire. The [ratios](https://en.wikipedia.org/wiki/Non-decimal_currency) between a libra, solidus, and denarius, or [lsd](https://en.wikipedia.org/wiki/%C2%A3sd) for short, were never completely uniform, but most commonly there were 12 denarii in a solidus and 20 solidi in a libra. The custom of counting coins in dozens (solidus) and scores of dozens (libra) spread throughout the Carolingian Empire and became engrained in much of Europe until decimalization after the French Revolution.

Installation
------------

`debkeepr` is still under development and in beta. Basic functionality should be stable at this point, but there could still be some breaking changes. You can install `debkeepr` from GitHub with [devtools](https://github.com/hadley/devtools):

``` r
# install.packages("devtools")
devtools::install_github("jessesadler/debkeepr")
```

Overview
--------

-   All of the functions in `debkeepr` begin with the prefix `deb_`, which is short for double-entry bookkeeping.
-   The nomenclature used throughout the package follows the [original Latin terms](https://en.wikipedia.org/wiki/%C2%A3sd) in using `l`, `s`, and `d` to represent librae, solidi, and denarii respectively and to refer to such values as lsd values. These terms were translated into the various European languages.
    -   English: pounds, shillings, pence
    -   French: livres, sols or sous, deniers
    -   Italian: lire, soldi, denari
    -   Flemish: ponden, schellingen, groten or penningen
-   The functions are designed to be used with three types of input objects:
    -   Numeric vectors of length 3 in which the first position represents librae (`l`), the second position solidi (`s`), and the third position denarii (`d`). Such lsd vectors can either be a single numeric vector or a list of such vectors.
    -   A data frame that contains pounds, shillings, and pence variables alongside any other variables. The pounds, shillings, and pence columns can have any desired names, but the default is to have the columns named “l”, “s”, and “d” respectively.
    -   The final object is a data frame that mimics the structure of an account book and can be thought of as a transactions data frame. In addition to pounds, shillings, and pence variables that denote the value of each transaction, a transactions data frame contains variables recording the [creditor and debtor](https://en.wikipedia.org/wiki/Debits_and_credits) for each transaction.
-   There are equivalent functions to manipulate lsd vectors and data frames with lsd variables. Anything that can be done on an lsd vector can also be done to a data frame with lsd values. Functions that use a transactions data frame that also possess credit and debit variables do not have equivalent functions of lsd vectors.

### lsd objects

An lsd vector consists of a numeric vector of length three representing the pounds, shillings, and pence units. A set of lsd vectors can be created by placing multiple vectors in a list.

``` r
# Load debkeepr
library(debkeepr)

# Create lsd vector equivalent to £5 8s. 11d
lsd_vector <- c(5, 8, 11)

# Create a list of lsd vectors
lsd_list <- list(c(12, 7, 9), c(5, 8, 11), c(3, 18, 5))
```

`debkeepr` also works with data frames that contain separate variables for pounds, shillings, and pence. The functions default to use “l”, “s”, and “d” as the names of the pounds, shillings, and pence variables, so using these names simplifies the use of the functions.

``` r
# Create data frame with lsd values
lsd_df <- data.frame(l = c(12, 5, 3),
                     s = c(7, 8, 18),
                     d = c(9, 11, 5))
```

`debkeepr` has a set of helper functions to go between lists of lsd vectors and data frames with lsd variables. `deb_list_to_df()` transforms a list of lsd vectors into a [tibble](https://tibble.tidyverse.org) object. `deb_df_to_list()` does the opposite. Any non-lsd variables in the data frame are dropped in order to create numeric vectors of length 3.

``` r
# list of lsd vectors to tibble or tbl_df
deb_list_to_df(lsd_list = lsd_list)
#> # A tibble: 3 x 3
#>       l     s     d
#>   <dbl> <dbl> <dbl>
#> 1    12     7     9
#> 2     5     8    11
#> 3     3    18     5

# data frame to list of lsd vectors
deb_df_to_list(df = lsd_df, l = l, s = s, d = d)
#> [[1]]
#>  l  s  d 
#> 12  7  9 
#> 
#> [[2]]
#>  l  s  d 
#>  5  8 11 
#> 
#> [[3]]
#>  l  s  d 
#>  3 18  5
```

Transaction data frames present a way to record data from an account book. They consist of five variables: "credit", "debit", "l", "s", and "d". The credit and debit variables contain information about the accounts involved in the transactions, and the lsd variables record the value of the transactions. Following the principles of double-entry bookkeeping, the credit account is the account that gives or sends the value, and the debit account receives the value. The `debkeepr` functions that work specifically on transaction data frames use "credit" and "debit" as the default names for these variables, though one could follow the convention of [network analysis](http://kateto.net/network-visualization) and name the variables "from" and "to".

Here is an example transactions data frame with four accounts named "a", "b", "c", and "d" and 15 transactions with values randomly created:

``` r
set.seed(240)
transactions_df <- data.frame(credit = sample(letters[1:4], 15, replace = TRUE),
                              debit = sample(letters[1:4], 15, replace = TRUE),
                              l = sample(1:30, 15, replace = TRUE),
                              s = sample(1:19, 15, replace = TRUE),
                              d = sample(1:11, 15, replace = TRUE),
                              stringsAsFactors = FALSE)
```

lsd vectors
-----------

lsd vectors and lists of such vectors simplify the process of doing quick calculations on values in historical sources. A particularly useful function for one-off uses is `deb_normalize()`, which normalizes an lsd vector or list of vectors to the desired bases for the `s` and `d` units. Thus, adding together a set of lsd values by hand might result in the non-standard form of £10 64s. 21d. `deb_normalize()` normalizes the value to the proper bases for the solidus and denarius units.

``` r
# Normalize a non-standard lsd vector
deb_normalize(lsd = c(10, 64, 21))
#>  l  s  d 
#> 13  5  9
```

Notice that the result is a named vector with the elements of the vector named “l”, “s”, and “d” respectively.

While much of Europe used the ratio of 1:20:240 from the 8th century on, there also existed [systems that used different bases](https://en.wikipedia.org/wiki/Non-decimal_currency) for the solidus and denarius units. For example, the [money of account](https://en.wikipedia.org/wiki/Unit_of_account) in the [Dutch Republic](https://en.wikipedia.org/wiki/Stuiver) consisted of gulden, stuivers, and penningen. Like the more prevalent system of libra, solidus, and denarius, there were 20 stuivers in a gulden, but there were 16 penningen in a stuiver. It is possible to normalize the above value with this alternative set of lsd bases, or any other bases, with the `lsd_bases` argument. This argument takes a numeric vector of length two, corresponding to the bases for the solidus and denarius units. The default is the most commonly used bases of 20 and 12: `c(20, 12)`. The desired bases can be set in all of the relevant functions in `debkeepr`.

``` r
# Normalize a non-standard lsd vector with alternative bases
deb_normalize(lsd = c(10, 64, 21), lsd_bases = c(20, 16))
#>  l  s  d 
#> 13  5  5
```

You can normalize multiple lsd values by placing lsd vectors into a list. The below example demonstrates some of the types of values that can be properly normalized by `deb_normalize()`. The function accepts negative values or even a mix of positive and negative values within an lsd vector. Any of the values can also possess decimalized values.

``` r
# To normalize multiple lsd values use a list of lsd vectors
deb_normalize(lsd = list(c(4, 34, 89), c(-9, -75, -19), c(15.85, 36.15, 56)))
#> [[1]]
#> l s d 
#> 6 1 5 
#> 
#> [[2]]
#>   l   s   d 
#> -12 -16  -7 
#> 
#> [[3]]
#>    l    s    d 
#> 17.0 17.0  9.8
```

### Arithmetic functions

`debkeepr` contains functions to perform arithmetic operations such as addition, subtraction, multiplication, and division on lsd vectors.

There are two different ways to add lsd vectors and/or lists of lsd vectors. `deb_sum()` takes any number of lsd vectors and/or lists of lsd vectors and returns a single numeric vector of length 3 that is the sum of the input values. `deb_add()` has a different use case. It only accepts two lsd vectors and/or lists of lsd vectors: `lsd1` and `lsd2`. If `lsd1` and `lsd2` in `deb_add()` are both vectors, the output will be equivalent to `deb_sum()`. However, if one or both of the inputs are lists of lsd vectors, the output will be the length of the longer list and each element of the list is added to the equivalent element of the other input. If one input is shorter than the other, the shorter input will be recycled. `deb_subtract()` is equivalent to `deb_add()` with `lsd2` subtracted from `lsd1`.

``` r
# Use deb_sum to reduce multiple lsd values to a single value
deb_sum(c(8, 14, 11), c(5, 13, 8))
#>  l  s  d 
#> 14  8  7
deb_sum(lsd_list, c(5, 13, 8))
#>  l  s  d 
#> 27  8  9

# deb_add is the same as deb_sum if inputs are two lsd vectors
deb_add(lsd1 = c(8, 14, 11), lsd2 = c(5, 13, 8))
#>  l  s  d 
#> 14  8  7

# If one input is a list, the output is also a list
# and thus different from deb_sum. Here, £5 13s. 8d.
# is added to each lsd vector in lsd_list.
deb_add(lsd1 = lsd_list, lsd2 = c(5, 13, 8))
#> [[1]]
#>  l  s  d 
#> 18  1  5 
#> 
#> [[2]]
#>  l  s  d 
#> 11  2  7 
#> 
#> [[3]]
#>  l  s  d 
#>  9 12  1

# deb_subtract has the same use case as deb_add
deb_subtract(lsd1 = c(8, 14, 11), lsd2 = c(5, 13, 8))
#> l s d 
#> 3 1 3

# Subtract lsd vector from a list of lsd vectors
deb_subtract(lsd1 = lsd_list, lsd2 = c(5, 13, 8))
#> [[1]]
#>  l  s  d 
#>  6 14  1 
#> 
#> [[2]]
#>  l  s  d 
#>  0 -4 -9 
#> 
#> [[3]]
#>   l   s   d 
#>  -1 -15  -3
```

Multiplication and division work similarly to `deb_add()` and `deb_subtract()`, but instead of using a second lsd value, `deb_multiply()` and `deb_divide()` multiply and divide an lsd vector or list of such vectors by a single value: `x`.

``` r
# Multiplcation
deb_multiply(lsd = c(5, 13, 8), x = 5)
#>  l  s  d 
#> 28  8  4

# Multiplication of a list of lsd vectors
deb_multiply(lsd = lsd_list, x = 5)
#> [[1]]
#>  l  s  d 
#> 61 18  9 
#> 
#> [[2]]
#>  l  s  d 
#> 27  4  7 
#> 
#> [[3]]
#>  l  s  d 
#> 19 12  1

# Division
deb_divide(lsd = c(136, 17, 9), x = 5)
#>    l    s    d 
#> 27.0  7.0  6.6

# Division of a list of lsd vectors
deb_divide(lsd = lsd_list, x = 3)
#> [[1]]
#> l s d 
#> 4 2 7 
#> 
#> [[2]]
#>         l         s         d 
#>  1.000000 16.000000  3.666667 
#> 
#> [[3]]
#>        l        s        d 
#> 1.000000 6.000000 1.666667
```

### Financial functions

Alongside arithmetic operations, `debkeepr` possesses functions to do common financial operations such as calculate interest and the exchange between different currencies. `deb_interest()` possesses arguments for the interest rate, the duration over which the interest should be calculated, and whether to include the principal or not in the answer. The default interest rate is 6.25%, which was the standard interest rate in the Low Countries at the end of the 16th century. `deb_exchange()` uses shillings to compare the two currencies, which was the most common unit used in providing an exchange rate. If the exchange rate includes a denarius value, you can either convert to a decimalized solidus by hand or add the denarius over the base of the denarius as shown below.

``` r
# Interest rate at 6.25% over a 5 year period with principal
deb_interest(c(100, 0, 0), interest = 0.0625, duration = 5)
#>   l   s   d 
#> 131   5   0

# Calculate only the accrued interest
deb_interest(c(100, 0, 0), interest = 0.0625, duration = 5, with_principal = FALSE)
#>  l  s  d 
#> 31  5  0

# Exchange between currencies at rate of 31 shillings or 1 to 1.55
deb_exchange(c(100, 0, 0), rate_per_shillings = 31)
#>   l   s   d 
#> 155   0   0

# Exchange rate of 31s. 4d.
deb_exchange(c(100, 0, 0), rate_per_shillings = 31 + 4/12)
#>   l   s   d 
#> 156  13   4
```

Data frames with lsd variables
------------------------------

The same arithmetic and financial operations used for lsd vectors and lists of lsd vectors are also available for pounds, shillings, and pence values in separate variables of a data frame. The functions default to column names of “l”, “s”, and “d” to refer to pounds, shillings, and pence respectively, but any other set of names can be substituted. The data frame functions share the names with their equivalent functions for lsd vectors, but they possess a sufix of either `_df` or `_mutate` to denote the object on which they work. The `_mutate` suffix is used when the operation creates three new lsd variables, which can be modified by the `replace` argument. If `replace = FALSE`, a suffix is added to the names of each of the new variables by the `suffix` argument to distinguish the new values from the original ones. As the `_mutate` suffix implies, these functions are based on the [tidyverse](https://www.tidyverse.org).

`deb_normalize_df()` performs the same basic task as `deb_normalize()` in normalizing a set of lsd values to the correct bases. It differs slightly from the other data frame functions in that the default is `replace = TRUE` so that the new normalized values replace the original non-standard values.

``` r
# Data frame to be normalized
normalize_df <- data.frame(l = c(4, -9, 15.85),
                           s = c(34, -75, 36.15),
                           d = c(89, -19, 56))

# Normalize the data frame
deb_normalize_df(df = normalize_df, l = l, s = s, d = d)
#>     l   s    d
#> 1   6   1  5.0
#> 2 -12 -16 -7.0
#> 3  17  17  9.8
```

### Arithmetic functions

`deb_sum_df()` uses `dplyr::summarise()` to accomplish the same task as `deb_sum()`. When used on a data frame without any grouping, the result will be a data frame with a single row consisting of columns for pounds, shillings, and pence. When used in conjunction with `dplyr::group_by()` on a non-lsd grouping variable, `deb_sum_df()` sums and normalizes the pounds, shillings, and pence columns for each group.

``` r
# Sum of a data frame of lsd variables
deb_sum_df(df = lsd_df, l = l, s = s, d = d)
#>    l  s d
#> 1 21 15 1

# Change the base to 20s. and 16d.
deb_sum_df(df = lsd_df, l = l, s = s, d = d, lsd_bases = c(20, 16))
#>    l  s d
#> 1 21 14 9
```

Addition, subtraction, multiplication, and division all result in three new variables and so use the `_mutate` suffix. `deb_add_mutate()` and `deb_subtract_mutate()` add and subtract an lsd vector from the lsd values in a data frame. `deb_multiply_mutate()` and `deb_divide_mutate()` multiply and divide the lsd values in a data frame by a single value.

``` r
# Add £5 13s. 8d. to lsd variables in a data frame
deb_add_mutate(df = lsd_df,
               l = l, s = s, d = d,
               lsd = c(5, 13, 8))
#>    l  s  d l.1 s.1 d.1
#> 1 12  7  9  18   1   5
#> 2  5  8 11  11   2   7
#> 3  3 18  5   9  12   1

# Subtract £5 13s. 8d. from lsd variables in a data frame,
# and change the suffix of the new variables
deb_subtract_mutate(df = lsd_df,
                    l = l, s = s, d = d,
                    lsd = c(5, 13, 8),
                    suffix = ".sub")
#>    l  s  d l.sub s.sub d.sub
#> 1 12  7  9     6    14     1
#> 2  5  8 11     0    -4    -9
#> 3  3 18  5    -1   -15    -3

# Because lsd_df uses the default column names
# of l, s, and d, they can be ommited in the function

# Multiply lsd variables in a data frame by 5
deb_multiply_mutate(df = lsd_df, x = 5)
#>    l  s  d l.1 s.1 d.1
#> 1 12  7  9  61  18   9
#> 2  5  8 11  27   4   7
#> 3  3 18  5  19  12   1

# Divide lsd variables in a data frame by 3
deb_divide_mutate(df = lsd_df, x = 3)
#>    l  s  d l.1 s.1      d.1
#> 1 12  7  9   4   2 7.000000
#> 2  5  8 11   1  16 3.666667
#> 3  3 18  5   1   6 1.666667
```

### Financial functions

`deb_interest_mutate()` and `deb_exchange_mutate()` use the same arguments as their equivalent functions for lsd vectors. The new variables get a suffix of ".interest" and ".exchange" by default.

``` r
# Interest rate at 6.25% over a 5 year period with principal
deb_interest_mutate(df = lsd_df, interest = 0.0625, duration = 5)
#>    l  s  d l.interest s.interest d.interest
#> 1 12  7  9         16          5     2.0625
#> 2  5  8 11          7          2    11.4375
#> 3  3 18  5          5          2    11.0625

# Exchange between currencies at rate of 30 shillings or 1 to 1.5
deb_exchange_mutate(df = lsd_df, rate_per_shillings = 30)
#>    l  s  d l.exchange s.exchange d.exchange
#> 1 12  7  9         18         11        7.5
#> 2  5  8 11          8          3        4.5
#> 3  3 18  5          5         17        7.5
```

Decimalization
--------------

Sometimes it is useful to decimalize lsd values, reducing the values to a single unit with a base of 10. Alternatively, you may come across decimalized values that you want to expand to lsd values. `debkeepr` provides functions to convert between decimalized and non-decimalized values for both vectors and variables in data frames.

All of the decimalization functions follow the naming convention of `input-unit_output-unit`. For instance, to convert from an lsd vector to decimalized librae or pounds you use `deb_lsd_l()`, while conversion between decimalized pounds to lsd values is done with `deb_l_lsd()`. There are functions to do the same process with both shillings and pence.

``` r
# lsd to decimalized denarii
deb_lsd_d(lsd = c(10, 12, 7))
#> [1] 2551

# Decimalized denarii to lsd
deb_d_lsd(d = 2551)
#>  l  s  d 
#> 10 12  7
```

The equivalent decimalization functions that work on a data frame with lsd variables have the same basic functionality and naming convention. These functions are based on `dplyr::mutate()`, and they contain `_mutate` in the function names to distinguish them from those used for lsd vectors. Thus, `deb_lsd_s_mutate()` adds a decimalized solidi variable to a data frame with lsd variables. The default is to name these decimalized columns after the Latin convention of librae, solidi, and denarii. Conversely, `deb_s_lsd_mutate()` uses a decimalized solidi variable in a data frame to create three new variables corresponding to the pounds, shillings, and pence values.

``` r
# Create decimalized solidi variable
deb_lsd_s_mutate(df = lsd_df)
#>    l  s  d    solidi
#> 1 12  7  9 247.75000
#> 2  5  8 11 108.91667
#> 3  3 18  5  78.41667

# From decimalized solidi variable to lsd variables
solidi_df <- data.frame(s = c(247.75, 108.91667, 78.41667))
deb_s_lsd_mutate(df = solidi_df, solidi = s)
#>           s l.1 s.1      d.1
#> 1 247.75000  12   7  9.00000
#> 2 108.91667   5   8 11.00004
#> 3  78.41667   3  18  5.00004

# Use the pipe to go to decimalized librae and then back to lsd
lsd_df %>% 
  deb_lsd_l_mutate(column_name = librae) %>%
  deb_l_lsd_mutate(librae = librae)
#>    l  s  d    librae l.1 s.1 d.1
#> 1 12  7  9 12.387500  12   7   9
#> 2  5  8 11  5.445833   5   8  11
#> 3  3 18  5  3.920833   3  18   5
```

Account books: transaction data frames
--------------------------------------

The account family of functions are designed to analyze a transaction data frame such as `transactions_df` created above. `deb_account()` provides information about the total credit and debit and the current balance of a single account. `deb_account_summary()` gives the same type of information but includes all accounts in the transactions data frame.

``` r
# Credit, debit, and current values for account "a"
deb_account(df = transactions_df,
            account_id = "a",
            credit = credit, debit = debit,
            l = l, s = s, d = d)
#>   relation  l s d
#> 1   credit 23 4 2
#> 2    debit 22 3 8
#> 3  current  1 0 6

# Credit, debit, and current values for all accounts
deb_account_summary(df = transactions_df)
#> # A tibble: 12 x 5
#>    account_id relation     l     s     d
#>    <chr>      <chr>    <dbl> <dbl> <dbl>
#>  1 a          credit      23     4     2
#>  2 a          debit       22     3     8
#>  3 a          current      1     0     6
#>  4 b          credit     115     4     3
#>  5 b          debit       73     7     3
#>  6 b          current     41    17     0
#>  7 c          credit      82    16     8
#>  8 c          debit       71     5     5
#>  9 c          current     11    11     3
#> 10 d          credit      52    14     3
#> 11 d          debit      107     3     0
#> 12 d          current    -54    -8    -9
```

The remaining functions build on `deb_account_summary()`. Three functions simplify the information produced by `deb_account_summary`: `deb_credit()` shows the total credit for each account, `deb_debit()` does the same for the debits, and `deb_current()` shows on the current value for each account.

``` r
# Total credit for each account
deb_credit(df = transactions_df)
#> # A tibble: 4 x 4
#>   account_id     l     s     d
#>   <chr>      <dbl> <dbl> <dbl>
#> 1 a             23     4     2
#> 2 b            115     4     3
#> 3 c             82    16     8
#> 4 d             52    14     3

# Total debit for all accounts by getting sum of deb_debit
deb_debit(df = transactions_df) %>% 
  deb_sum_df()
#> # A tibble: 1 x 3
#>       l     s     d
#>   <dbl> <dbl> <dbl>
#> 1   273    19     4

# Current value of each account
deb_current(df = transactions_df)
#> # A tibble: 4 x 4
#>   account_id     l     s     d
#>   <chr>      <dbl> <dbl> <dbl>
#> 1 a              1     0     6
#> 2 b             41    17     0
#> 3 c             11    11     3
#> 4 d            -54    -8    -9
```

`deb_open()` is similar to `deb_current()`, but it removes any accounts that have been closed by being zeroed out. This is useful if there are many accounts in the transactions data frame that have been closed. In the example of `transactions_df` all accounts are open, and so `deb_open()` has the same result as `deb_current()`. `deb_balance()` shows the total credit and debit remaining in the transactions data frame. The values for credit and debit will always be the same in `deb_balance()`, as there should always be the same amount of credit as debit in an account book.

``` r
# Balance remaining on transactions_df
deb_balance(transactions_df)
#> # A tibble: 2 x 4
#>   relation     l     s     d
#>   <chr>    <dbl> <dbl> <dbl>
#> 1 credit      54     8     9
#> 2 debit       54     8     9
```

Notes
-----

-   See Peter Spufford, *Money and its Use in Medieval Europe* (Cambridge: Cambridge University Press, 1988), especially pages 411–414, for a discussion of money of account in medieval Europe.

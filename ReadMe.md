
How the script works?

Script opens a files for reading, then creates data frames, filters and transforms data.
Do it for train and test separately and then merge these sets.

1) Read data.
2) Join tables to change activty numbers to activity descriptive labels.
3) Filter out unsignificant data (leave only columns with "mean" and "std")
4) Aggregate tidy dataset using aggregate() function.
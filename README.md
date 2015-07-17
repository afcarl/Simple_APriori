## A priori algorithm using Python 2.7

This is a simple implementation of the a-priori algorithm without use of external libraries. It expects a .csv file and a support integer, as in:

```
python apriori.py apriory.csv 20

```

If the format of the .csv file is a bit different than the one used in the example, just comment the lines "To be cleaned" and it should probably work.

Important note: this implementation loads the whole dataset of transactions into memory. If your dataset is too large, please make sure it fits in memory and you choose an adequately large support.

# Heros of Pymoli Data Analysis

Observation 1: Male players as a category make up the majority of the player population (81%) and generate a proportionaite percentage of total revenue (82%)
Observation 2: The single largest category of players (45%) are males aged 20 to 24 and they generate a roughly proportionate percentage of total revenue (43%)
Observation 3: The most popular items are not the most profitable, with item price being more associated with total revenues generated than popularity


```python
# Load libraries
import pandas as pd
import json
import numpy as py

# Initialize variables
fileInput='purchase_data.json'

# Open input file, read into fram
pdframePurchaseData = pd.read_json(fileInput)
```


```python
# Unique players
UniquePlayerCount = len(pdframePurchaseData.groupby('SN').nunique())
pdframeOutput = pd.DataFrame(data={'Total Players':{0: UniquePlayerCount}})
pdframeOutput
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Total Players</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>573</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Purchase Analysis (Total)
UniqueItems=len(pdframePurchaseData.groupby('Item ID').nunique())
AvgPurchasePrice=pdframePurchaseData['Price'].mean()
TotalNumberPurchases=len(pdframePurchaseData)
TotalRevenue=pdframePurchaseData['Price'].sum()
pdfOutput = pd.DataFrame(data={'Number of Unique Items':{0: UniqueItems},
                                  'Average Price':{0:AvgPurchasePrice},
                                  'Number of Purchases' :{0: TotalNumberPurchases},
                                  'Total Revenue':{0: TotalRevenue}})
pdfOutput = pdfOutput[['Number of Unique Items', 'Average Price', 'Number of Purchases', 'Total Revenue']]
pdfOutput['Average Price'] = pdfOutput['Average Price'].map('${:,.2f}'.format)
pdfOutput['Total Revenue'] = pdfOutput['Total Revenue'].map('${:,.2f}'.format)
pdfOutput
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Number of Unique Items</th>
      <th>Average Price</th>
      <th>Number of Purchases</th>
      <th>Total Revenue</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>183</td>
      <td>$2.93</td>
      <td>780</td>
      <td>$2,286.33</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Gender demographics
pdfOutput2=pdframePurchaseData.groupby('Gender', as_index=True).agg({'SN': pd.Series.nunique})
pdfOutput2['Percentage'] = pdfOutput2['SN'] / UniquePlayerCount * 100
pdfOutput2.columns = ['Total Count', 'Percentage']
pdfOutput2 = pdfOutput2[['Percentage', 'Total Count']]
pdfOutput2.round({'Percentage': 2})
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Percentage</th>
      <th>Total Count</th>
    </tr>
    <tr>
      <th>Gender</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Female</th>
      <td>17.45</td>
      <td>100</td>
    </tr>
    <tr>
      <th>Male</th>
      <td>81.15</td>
      <td>465</td>
    </tr>
    <tr>
      <th>Other / Non-Disclosed</th>
      <td>1.40</td>
      <td>8</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Purchasing analysis (gender)
pdfOutput3=pdframePurchaseData.groupby('Gender', as_index=True).agg({'Item Name': 'count','Price': 'mean'})
pdfOutput3['Total Purchase Value'] = pdfOutput3['Price'] * pdfOutput3['Item Name']
pdfOutput3.columns = ['Purchase Count', 'Average Purchase Price', 'Total Purchase Value']
pdfOutput3['Average Purchase Price'] = pdfOutput3['Average Purchase Price'].map('${:,.2f}'.format)
pdfOutput3['Total Purchase Value'] = pdfOutput3['Total Purchase Value'].map('${:,.2f}'.format)
pdfOutput3
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>Gender</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Female</th>
      <td>136</td>
      <td>$2.82</td>
      <td>$382.91</td>
    </tr>
    <tr>
      <th>Male</th>
      <td>633</td>
      <td>$2.95</td>
      <td>$1,867.68</td>
    </tr>
    <tr>
      <th>Other / Non-Disclosed</th>
      <td>11</td>
      <td>$3.25</td>
      <td>$35.74</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Age demographics
bins = [0, 9, 14, 19, 24, 29, 34, 39, 40]
group_names = ['<10', '10-14', '15-19', '20-24', '25-29', '30-34', '35-39', '40+']
pdfBinned= pdframePurchaseData[0:len(pdframePurchaseData)].copy()
categories = pd.cut(pdfBinned['Age'], bins, labels=group_names)
pdfBinned['Ages'] = pd.cut(pdfBinned['Age'], bins, labels=group_names)
pdfBinned['agesBinned'] = pd.cut(pdfBinned['Age'], bins)
pdfOutput4=pdfBinned.groupby('Ages', as_index=True).agg({'SN': pd.Series.nunique})
pdfOutput4['Percentage'] = pdfOutput4['SN'] / UniquePlayerCount * 100
pdfOutput4.columns = ['Total Count', 'Percentage of Players']
pdfOutput4 = pdfOutput4[['Percentage of Players', 'Total Count']]
pdfOutput4.round({'Percentage of Players': 2})
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Percentage of Players</th>
      <th>Total Count</th>
    </tr>
    <tr>
      <th>Ages</th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>&lt;10</th>
      <td>3.32</td>
      <td>19</td>
    </tr>
    <tr>
      <th>10-14</th>
      <td>4.01</td>
      <td>23</td>
    </tr>
    <tr>
      <th>15-19</th>
      <td>17.45</td>
      <td>100</td>
    </tr>
    <tr>
      <th>20-24</th>
      <td>45.20</td>
      <td>259</td>
    </tr>
    <tr>
      <th>25-29</th>
      <td>15.18</td>
      <td>87</td>
    </tr>
    <tr>
      <th>30-34</th>
      <td>8.20</td>
      <td>47</td>
    </tr>
    <tr>
      <th>35-39</th>
      <td>4.71</td>
      <td>27</td>
    </tr>
    <tr>
      <th>40+</th>
      <td>1.40</td>
      <td>8</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Purchasing Analysis (Age)
pdfBinned= pdframePurchaseData[0:len(pdframePurchaseData)].copy()
categories = pd.cut(pdfBinned['Age'], bins, labels=group_names)
pdfBinned['Ages'] = pd.cut(pdfBinned['Age'], bins, labels=group_names)
pdfBinned['agesBinned'] = pd.cut(pdfBinned['Age'], bins)
pdfOutput5=pdfBinned.groupby('Ages', as_index=True).agg({'Item Name': 'count','Price': 'mean'})
pdfOutput5['Total Purchase Value'] = pdfOutput5['Price'] * pdfOutput5['Item Name']
pdfOutput5.columns = ['Purchase Count', 'Average Purchase Price', 'Total Purchase Value']
pdfOutput5['Average Purchase Price'] = pdfOutput5['Average Purchase Price'].map('${:,.2f}'.format)
pdfOutput5['Total Purchase Value'] = pdfOutput5['Total Purchase Value'].map('${:,.2f}'.format)
pdfOutput5
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>Ages</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>&lt;10</th>
      <td>28</td>
      <td>$2.98</td>
      <td>$83.46</td>
    </tr>
    <tr>
      <th>10-14</th>
      <td>35</td>
      <td>$2.77</td>
      <td>$96.95</td>
    </tr>
    <tr>
      <th>15-19</th>
      <td>133</td>
      <td>$2.91</td>
      <td>$386.42</td>
    </tr>
    <tr>
      <th>20-24</th>
      <td>336</td>
      <td>$2.91</td>
      <td>$978.77</td>
    </tr>
    <tr>
      <th>25-29</th>
      <td>125</td>
      <td>$2.96</td>
      <td>$370.33</td>
    </tr>
    <tr>
      <th>30-34</th>
      <td>64</td>
      <td>$3.08</td>
      <td>$197.25</td>
    </tr>
    <tr>
      <th>35-39</th>
      <td>42</td>
      <td>$2.84</td>
      <td>$119.40</td>
    </tr>
    <tr>
      <th>40+</th>
      <td>14</td>
      <td>$3.22</td>
      <td>$45.11</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Top spenders
pdfOutput6=pdframePurchaseData.groupby('SN', as_index=True).agg({'Item Name': 'count','Price': 'mean'})
pdfOutput6['Total Purchase Value'] = pdfOutput6['Price'] * pdfOutput6['Item Name']
pdfOutput6.columns = ['Purchase Count', 'Average Purchase Price', 'Total Purchase Value']
pdfOutput6['Average Purchase Price'] = pdfOutput6['Average Purchase Price'].map('${:,.2f}'.format)
pdfOutput6['Total Purchase Value'] = pdfOutput6['Total Purchase Value'].map('${:,.2f}'.format)
pdfOutput6.sort_values('Total Purchase Value', ascending=False).head(5)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Purchase Count</th>
      <th>Average Purchase Price</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>SN</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Qarwen67</th>
      <td>4</td>
      <td>$2.49</td>
      <td>$9.97</td>
    </tr>
    <tr>
      <th>Sondim43</th>
      <td>3</td>
      <td>$3.13</td>
      <td>$9.38</td>
    </tr>
    <tr>
      <th>Tillyrin30</th>
      <td>3</td>
      <td>$3.06</td>
      <td>$9.19</td>
    </tr>
    <tr>
      <th>Lisistaya47</th>
      <td>3</td>
      <td>$3.06</td>
      <td>$9.19</td>
    </tr>
    <tr>
      <th>Tyisriphos58</th>
      <td>2</td>
      <td>$4.59</td>
      <td>$9.18</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Most popular items
pdfOutput7=pdframePurchaseData.groupby(['Item ID','Item Name'], as_index=True).agg({'Item Name': 'count','Price': 'sum'})
pdfOutput7.columns = ['Purchase Count', 'Total Purchase Value']
pdfOutput7['Item Price'] = pdfOutput7['Total Purchase Value'] / pdfOutput7['Purchase Count']
pdfOutput7=pdfOutput7[['Purchase Count', 'Item Price', 'Total Purchase Value']]
pdfOutput8=pdfOutput7.sort_values('Purchase Count', ascending=False).head(5)
pdfOutput8['Total Purchase Value'] = pdfOutput8['Total Purchase Value'].map('${:,.2f}'.format)
pdfOutput8['Item Price'] = pdfOutput8['Item Price'].map('${:,.2f}'.format)
pdfOutput8
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>Purchase Count</th>
      <th>Item Price</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>Item ID</th>
      <th>Item Name</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>39</th>
      <th>Betrayal, Whisper of Grieving Widows</th>
      <td>11</td>
      <td>$2.35</td>
      <td>$25.85</td>
    </tr>
    <tr>
      <th>84</th>
      <th>Arcane Gem</th>
      <td>11</td>
      <td>$2.23</td>
      <td>$24.53</td>
    </tr>
    <tr>
      <th>31</th>
      <th>Trickster</th>
      <td>9</td>
      <td>$2.07</td>
      <td>$18.63</td>
    </tr>
    <tr>
      <th>175</th>
      <th>Woeful Adamantite Claymore</th>
      <td>9</td>
      <td>$1.24</td>
      <td>$11.16</td>
    </tr>
    <tr>
      <th>13</th>
      <th>Serenity</th>
      <td>9</td>
      <td>$1.49</td>
      <td>$13.41</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Most profitable items
pdfOutput8=pdfOutput7.sort_values('Purchase Count', ascending=False).head(5)
pdfOutput8=pdfOutput7.sort_values('Total Purchase Value', ascending=False).head(5)
pdfOutput8['Total Purchase Value'] = pdfOutput8['Total Purchase Value'].map('${:,.2f}'.format)
pdfOutput8
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th></th>
      <th>Purchase Count</th>
      <th>Item Price</th>
      <th>Total Purchase Value</th>
    </tr>
    <tr>
      <th>Item ID</th>
      <th>Item Name</th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>34</th>
      <th>Retribution Axe</th>
      <td>9</td>
      <td>4.14</td>
      <td>$37.26</td>
    </tr>
    <tr>
      <th>115</th>
      <th>Spectral Diamond Doomblade</th>
      <td>7</td>
      <td>4.25</td>
      <td>$29.75</td>
    </tr>
    <tr>
      <th>32</th>
      <th>Orenmir</th>
      <td>6</td>
      <td>4.95</td>
      <td>$29.70</td>
    </tr>
    <tr>
      <th>103</th>
      <th>Singed Scalpel</th>
      <td>6</td>
      <td>4.87</td>
      <td>$29.22</td>
    </tr>
    <tr>
      <th>107</th>
      <th>Splitter, Foe Of Subtlety</th>
      <td>8</td>
      <td>3.61</td>
      <td>$28.88</td>
    </tr>
  </tbody>
</table>
</div>




```python

```

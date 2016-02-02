#!//anaconda/bin/python

import time # to time how long queries and processes take
from datetime import date, datetime, timedelta # to manipulate dates

# Make a list of the weeks between 2015-05-24 and now.
def makeWeekList(date_start, date_end):
    weekList = []
    date_start = datetime.strptime(date_start, "%Y-%m-%d")
    date_end = datetime.strptime(date_end, "%Y-%m-%d")
    #current_date = datetime.now()

    #while date_start < current_date + timedelta(days=7):
    while date_start < date_end:
        weekList.append(date_start)
        date_start += timedelta(days=7)

    # Make an identical list but filled with the string version of the variable 
    #instead of the datetime version.  (We have to use the [:] notation or else both
    # variable names point to the same object.)

    weekStringList=weekList[:]
    for w in range(len(weekStringList)):
        weekStringList[w]=str(weekStringList[w]).split(' ')[0]

    #print(weekList)
    #print(weekStringList)

    return weekList, weekStringList
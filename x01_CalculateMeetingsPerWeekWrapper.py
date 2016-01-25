#!//anaconda/bin/python

from datetime import date, datetime, timedelta
import x01_CalculateMeetingsPerWeek as calcmeetings


#date_arg = date.strptime('2015-05-17', "%Y-%m-%d")
date_arg = date(2015,05,17)

for d in range(36):
	date_arg += timedelta(days=7)
	print(str(date_arg))
	calcmeetings.x01_CalculateMeetingsPerWeek(str(date_arg))
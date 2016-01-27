#!//anaconda/bin/python

from datetime import date, datetime, timedelta
import x01_CalculateMeetingsPerWeek as calcmeetings

date_arg = date.strptime('2015-05-17', "%Y-%m-%d")

for d in range(24):
#for d in range(len(missed_months)):
	#date_arg = date(2015, missed_months[d], missed_days[d])
	print(str(date_arg))
	calcmeetings.x01_CalculateMeetingsPerWeek(str(date_arg))
	date_arg += timedelta(days=7)

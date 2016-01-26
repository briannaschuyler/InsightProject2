#!//anaconda/bin/python

from datetime import date, datetime, timedelta
import x01_CalculateMeetingsPerWeek as calcmeetings


#date_arg = date.strptime('2015-05-17', "%Y-%m-%d")
#date_arg = date(2015,05,17)
#date_arg = date(2015,06,07) # This date period erred out.  Why?
#date_arg = date(2015,06,21) # This date period erred out.  Why?
#date_arg = date(2015,07,05) # This date period erred out.  Why?
#date_arg = date(2015,08,09) 
#date_arg = date(2015,8,16) 
#date_arg = date(2015,8,23) 
#date_arg = date(2015,9,27) 
#date_arg = date(2015,10,11) 
#date_arg = date(2015,10,25) 

missed_months = [8,8,9,10]
missed_days = [16,23,27,11]

#for d in range(24):
for d in range(len(missed_months)):
	date_arg = date(2015, missed_months[d], missed_days[d])
	print(str(date_arg))
	calcmeetings.x01_CalculateMeetingsPerWeek(str(date_arg))
	date_arg += timedelta(days=7)

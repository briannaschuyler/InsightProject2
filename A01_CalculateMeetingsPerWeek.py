#!//anaconda/bin/python

def x01_CalculateMeetingsPerWeek(start_date_input):
	# coding: utf-8

	# # Script to calculate Meetings Per Week

	# This code will access data for my company from their space on a RedShift cluster so that I can analyze it and look for patterns to predict both retention (who sticks around) and virality (who is more likely to get other people to use the program).

	# In[23]:

	## Python packages - you may have to pip install sqlalchemy, sqlalchemy_utils, and psycopg2.
	import sys # To input the date you want to start with

	from sqlalchemy import create_engine
	from sqlalchemy_utils import database_exists, create_database
	import psycopg2
	import pandas as pd

	import re # to access database details in a file
	import time # to time how long queries and processes take
	import matplotlib.pyplot as plt
	from datetime import datetime, timedelta # to manipulate dates

	#get_ipython().magic(u'matplotlib inline')


	# In[2]:

	path='/Users/brianna/Documents/WL_DBdeets/'


	# ### Make a function to access each database

	# To keep the access details secure, keep them in a separate file that will remain private, even when the code is shared.

	# In[3]:

	def connect_db(which_db):
		# Grab the details from a text file for how to access the database
		db_file = open(path+which_db+'DBdeets.txt','r')
		db_deets = db_file.read()

		dbname=re.findall('dbname=(\S+)',db_deets)
		username=re.findall('username=(\S+)',db_deets)
		hostname=re.findall('hostname=(\S+)',db_deets)
		portname=re.findall('portname=(\S+)',db_deets)
		pw=re.findall('pw=(\S+)',db_deets)
	
		# Connect to the database.  (If you can't, jump out and give a polite notice!)
		con = None
		try:
			con = psycopg2.connect(database = dbname[0], 
								   user = username[0], 
								   host = hostname[0], 
								   port = portname[0], 
								   password = pw[0])
			# Set up a cursor.  (Anytime you get an error with the cursor, you have to reset the 
			# connection with it)
			cur=con.cursor()
			print('I connected to the '+which_db+' database!!')
		except:
			print('Unable to connect to '+which_db+' database :(')
	
		db_file.close()
	
		return  con, cur


	# ### Open the two databases where data are stored.

	# The 'events' database has a main table called 'events131567', which has a bunch of sub-tables with information on the events completed by the user.
	# 
	# The 'transactions' database has a bunch of tables with data about the user:
	# pg_stat_statements,
	# activities,
	# agenda_templates,
	# calendar_webhooks,
	# calendars,
	# contacts,
	# integration_authorizations,
	# integration_providers,
	# integrations,
	# meeting_seeds,
	# migrations,
	# notifications,
	# password_reset_tokens,
	# meetings,
	# short_urls,
	# team_invitations,
	# team_memberships,
	# teams,
	# users,
	# events,
	# items,
	# recurring_event_rules,
	# meeting_invitations
	# 

	# In[4]:

	# Access the 'events' database.
	conE, curE = connect_db('evnt')

	# Access the 'transactions' database.
	conT, curT = connect_db('trns')


	# ### Look at the number of meetings (and total events) stored on a user's calendar in a certain week.

	# In[30]:

	# Let's look at how many events on the calendar of each user.  We can't just pull a count of all of the
	# events since some of these events aren't actually meetings (ie. blocked off time for other things.) To 
	# figure out which events are actually meetings, let's pull all of the events, then go through and make 
	# a subset of events where there is more than one attendee.

	# Start the week before Sunday, 2015-05-31 when the first data are recorded.
	#start_date='2015-05-24 00:00:00+00:00'
	#end_date='2015-05-31 00:00:00+00:00'
	#start_date_input='2015-05-24'
	#start_date_input = str(sys.argv[0])

	print(start_date_input)

	start_date = datetime.strptime(start_date_input, "%Y-%m-%d")

	end_date = start_date + timedelta(days=7)

	print('Start on '+str(start_date))
	print('End on '+str(end_date))


	# In[31]:

	sql_string1 = """
	select c.user_id, u.primary_email, e.title, 
		   lower(e.time_range) meeting_start, upper(e.time_range) meeting_end, 
		   e.attendees
	from users u
	join 
		calendars c
	on
		u.id = c.user_id
	left outer join 
		events e 
	on 
		e.calendar_id = c.id
	where lower(e.time_range) between 
	"""

	#sql_string2 = "({date} - INTERVAL '7 days') and {date}".format(date = start_date)
	sql_string2 = "'{start_date}' and '{end_date}'".format(start_date = start_date, end_date = end_date)

	sql_query = sql_string1 + sql_string2

	print(sql_query)

	starttime=time.time()

	query_result = pd.read_sql_query(sql_query,conT)

	print(time.time()-starttime)


	# In[32]:

	# Make a temporary dataframe of all of the events in this date range
	df_allevts=query_result.iloc[:]
	df_allevts.columns


	# In[33]:

	# Sanity check: Only a subset of the user_id's should be unique since many users have more than 
	# one event in a week.
	print(len(df_allevts[:]['user_id'].unique()))
	print(len(df_allevts[:]['user_id']))

	#for i in range(10):
	#	print(len(df_allevts.attendees[i]))


	# In[34]:

	# First make sure there are no meetings with missing information (this should be
	# less than 1% of the meetings).  Then add a column that lists the number of
	# attendees at the meeting.

	df_allevts=df_allevts[pd.isnull(df_allevts.attendees)==False]

	df_allevts['num_attendees'] = df_allevts.attendees.apply(lambda x : len(x))


	# In[35]:

	#df_allevts.head()


	# In[36]:

	# Make a dataframe that's a subset of the original, with only the rows where the event is a meeting
	# (Meeting is defined as an event with more than one person attending)
	df_allmtngs = df_allevts[df_allevts.num_attendees > 1]

	print(len(df_allmtngs[:]['user_id'].unique()))
	print(len(df_allmtngs[:]['user_id']))
	#df_allmtngs.head()


	# In[37]:

	# This function takes a dataframe and finds whether the organizer of an event is the same as 
	# the user who has this event in their calendar
	def find_organizer(df):
		try:
			for a in range(len(df['attendees'])):
				try:
					# If this list contains the 'organizer' key, continue to find out who it is.
					if df['attendees'][a]['organizer'] == True:
						#print(df_allmtngs.attendees[x][a]['email'])
						#print(df_allmtngs.primary_email[x])
					
						# If the organizer is the same as the user, change the value in the 'organizer'
						# column to True (ie. this person organized this meeting.)
						if df['attendees'][a]['email'] == df['primary_email']:
							return True
							#return df['attendees'][a]['email']
				except:
					continue
			#print(str(x)+' '+str(a)+' '+organizer)
		except:
			return False


	# In[38]:

	# Create a column that checks whether the user was the organizer of the event.
	organizer_column = df_allmtngs.apply(lambda x : find_organizer(x), axis=1)

	df_allmtngs['organizer'] = organizer_column


	# In[39]:

	df_allmtngs.columns


	# ### Now make two deidentified dataframes we can actually save.  
	# 

	# In[40]:

	# The first will have a row for each event in the calendar and the following columns:
	# user_id, start time of each meeting, number of attendees in the meeting, organizer status

	del df_allmtngs['primary_email']; del df_allmtngs['title' ]; del df_allmtngs['attendees' ]

	#start_date = min(df_allmtngs.meeting_start)
	#end_date = max(df_allmtngs.meeting_start)
	df_allmtngs.to_csv(path+str(start_date)+'to'+str(end_date)+'Evnts_byEvnt.csv')


	# In[41]:

	# The second dataframe will be much simpler:
	# user_id, number of meetings this week

	df_allmtngs_simple = df_allmtngs.groupby(['user_id']).size()

	df_allmtngs_simple.to_csv(path+str(start_date)+'to'+str(end_date)+'EvntsCollapsedByUser.csv')

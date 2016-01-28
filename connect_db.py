#!//anaconda/bin/python

from sqlalchemy import create_engine
from sqlalchemy_utils import database_exists, create_database
import psycopg2
import pandas as pd

import re # to access database details in a file
import time # to time how long queries and processes take
import matplotlib.pyplot as plt
from datetime import date, datetime, timedelta # to manipulate dates


def connect_db(which_db, path):
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
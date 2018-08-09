from urllib.request import urlopen
from urllib.parse import urlencode
import dateutil.parser
from datetime import *
from dateutil.relativedelta import *
from contextlib import closing
try:
   from PIL import Image
except:
   print("If you are on a Windows machine, please install PIL (imaging library) using 'python -m pip install Pillow' in the Anaconda Prompt")
   exit()
import json


#Set Navigator URL
base_url = "http://navigator.oceansdata.ca/"



#Initialize Variables
dataset = 'giops_day' 
variable = 'votemper'
date_iso = '2016-07-21'
depth = '0'
location = '60,-56'

#Get Timestamps
timestamps_url = base_url + 'api/v1.0/timestamps/?dataset=' + dataset

with closing(urlopen(timestamps_url)) as timestamps:
    times = json.loads(timestamps.read().decode('utf-8'))

    first_time = len(times) - 12
    start_date = times[first_time]['value']

    #Convert to datetime object
    date = dateutil.parser.parse(start_date)

#Set min and max defaults (These will be reset by the first values retrieved)
minTemp = 400
maxTemp = -400
total = 0
avg = None

for i in range(1,12):

  date_iso = date.isoformat()
  api_url = "api/v1.0/data/%s/%s/%s/%s/%s.json"%(dataset, variable, date_iso, depth, location)
  completed_url = base_url + api_url

  with closing(urlopen(completed_url)) as f:

    data = json.loads(f.read().decode('utf-8'))
    print(data)
    temp = float(data['value'][0])

    if (temp < minTemp):
      minTemp = temp
    if (temp > maxTemp):
      maxTemp = temp
    total += temp

  date = date + relativedelta(days=1)

avg = total / 12
print("\n\n")
print("AVG: ")
print(avg)
print("MIN: ")
print(minTemp)
print("MAX: ")
print(maxTemp)
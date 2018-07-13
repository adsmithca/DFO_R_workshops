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

#Create JSON Object
query = {
  "area": [{'innerrings': [], 'name': '', 'polygons': [[[47.15537131040787, -64.75658703554912], [47.151635758268526, -61.34533215273662], [45.65169432222453, -61.31786633242412], [45.659373441579135, -64.73461437929912], [47.15537131040787, -64.75658703554912]]]}],
  "bathymetry": True,
  "colormap": "default",
  "contour": {'colormap': 'default', 'hatch': False, 'legend': True, 'levels': 'auto', 'variable': 'none'},
  "dataset": "giops_month",
  "depth": 0,
  "interp": "gaussian",
  "neighbours": 10,
  "projection": "EPSG:3857",
  "quiver": {'colormap': 'default', 'magnitude': 'length', 'variable': 'none'},
  "radius": 25,
  "scale": "-5,30",
  "showarea": False,
  "time": 'null',
  "type": "map",
  "variable": "votemper",
}

#Get Timestamps
timestamps_url = base_url + 'api/v1.0/timestamps/?dataset=' + query.get('dataset')
print(timestamps_url)
with closing(urlopen(timestamps_url)) as f:
    timestamps = f.read().decode('utf-8')
    timestamps = json.loads(timestamps)

    timeStamp = len(timestamps) - 12

    #Initializes Image List
    images = []

    #Loops through 12 Months
    for i in range(0, 11):
      
      query['time'] = timestamps[timeStamp]['value']

      url = base_url + "api/v1.0/plot/?" + urlencode({"query": json.dumps(query)})

      #Open URL and save response
      print("Sending Request")
      
      with closing(urlopen(url)) as f:
        img = Image.open(f)
        images.append(img)
        img.save("script_template_" + str(query["dataset"]) + "_" + str(query["time"]) + ".png" , "PNG")

      timeStamp += 1

    images[0].save(
      "Riops_timeCapture.gif",
      duration = 1000,
      loop = 0,
      save_all = True,
      append_images=images[1:]
    )


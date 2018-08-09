from urllib.request import urlopen
from urllib.parse import urlencode
from contextlib import closing
try:
    from PIL import Image
except:
    print("If you are on a Windows machine, please install PIL (imaging library) using 'python -m pip install Pillow' in the Anaconda Prompt")
    exit()
import json


# Set Navigator URL
base_url = "http://navigator.oceansdata.ca/"

# Create JSON Object
query = {
    "colormap": "default",
    "dataset": "giops_day",
    "depth_limit": False,
    "linearthresh": 200,
    "name": "Flemish Cap",
    "path": [[47, -52.83166666666669], [47, -52.705], [47, -52.58], [47, -52.3216666666667], [47, -52.03333333333332], [47, -51.48499999999999], [47, -50.99999999999999], [47, -50.66666666666669], [47, -50], [47, -49.11666666666671], [47, -48.6166666666667], [47, -48.1166666666667], [47, -47.81666666666669], [47, -47.5], [47, -47.25], [47, -47.1683333333333], [47, -47.0166666666667], [47, -46.83333333333331], [47, -46.67], [47, -46.4833333333333], [47, -46.0166666666667], [47, -45.73], [47, -45.49999999999999], [47, -45.2133333333333], [47, -44.9883333333333], [47, -44.7716666666667], [47, -44.5783333333333], [47, -44.4333333333333], [47, -44.2316666666667], [47, -44.0833333333333], [47, -43.8333333333333], [47, -43.75], [47, -43.4], [47, -43.25], [47, -43], [47, -42.75], [47, -42.5], [47, -42]],
    "plotTitle": "",
    "quantum": "day",
    "scale": "-5,30,auto",
    "selectedPlots": "0,1,1",
    "showmap": True,
    "surfacevariable": "none",
    "time": 849,
    "type": "transect",
    "variable": "votemper",
}

# Find all variables for the required dataset
variables_url = base_url + "api/v1.0/variables/?dataset=" + query["dataset"]
print(variables_url)

with closing(urlopen(variables_url)) as f:
    variables = f.read().decode('utf-8')
    variables = json.loads(variables)

    for variable in variables:

        print("Requesting: " + variable.get('id'))

        #Modify query to use next variable
        query['variable'] = variable.get('id')

        #Save Next Image
        url = base_url + "plot/?" + urlencode({"query": json.dumps(query)})
        with closing(urlopen(url)) as f:
            img = Image.open(f)
            file_location = 'Image_' + str(query["dataset"]) + '_' + str(query["variable"]) + '.png'
            img.save(file_location, "PNG")

        print("Done")

from datetime import date
import os
import requests
import shutil

session = os.environ.get('AOC_SESSION')
if not session:
	print("Missing AOC_SESSION env variable")
	exit()

today = date.today()
day_num = today.day

year = str(today.year)
day = "%02d" % day_num

if not os.path.exists(year):
	os.makedirs(path)

remote_input_path = "https://adventofcode.com/" + year + "/day/" + str(day_num) + "/input"
f = open(year + "/day" + day + ".input", "w")
response = requests.get(remote_input_path, cookies={ "session" : session })
f.write(response.text)
f.close()

shutil.copyfile("day.template.py", year + "/day" + day + ".py")

print("Ready to go!")

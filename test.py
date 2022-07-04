import requests;
from pprint import pprint
response = requests.get("http://api.steampowered.com/ISteamApps/GetAppList/v0002/?format=json")
pprint()
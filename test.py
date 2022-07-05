import requests;
from pprint import pprint
response = requests.get("https://api.steampowered.com/ISteamApps/GetAppList/v2/")
pprint(response.text)
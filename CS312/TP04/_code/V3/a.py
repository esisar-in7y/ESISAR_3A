import requests
import threading
import json

headers = {
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/111.0',
    'Accept': 'application/json, text/plain, */*',
    'Accept-Language': 'en-US,en;q=0.5',
    'Origin': 'https://jeu-orangina.fr',
    'Connection': 'keep-alive',
    'Referer': 'https://jeu-orangina.fr/',
    'Sec-Fetch-Dest': 'empty',
    'Sec-Fetch-Mode': 'cors',
    'Sec-Fetch-Site': 'cross-site',
    'Pragma': 'no-cache',
    'Cache-Control': 'no-cache',
}
def write_to_file(data_dict):
    if data_dict.get("win"):
        with open('data.json', 'a') as f:
            json.dump(data_dict, f, indent=4)
            f.write("\n")

def req():
    while 1:
        try:
            response = requests.post('https://s4icpvii1i.execute-api.eu-west-3.amazonaws.com/', headers=headers).json()
            print(response)
            write_to_file(response)
        except:
            pass


threads=[]
for i in range(10):
    t = threading.Thread(target=req)
    t.start()
    threads.append(t)

for thread in threads:
    thread.join()
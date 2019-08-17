import os 
import json
import urllib3
http = urllib3.PoolManager()
npmversions = os.environ["versions"]
branch = os.environ["branch"]
packageName = os.environ["packageName"]
masterRelease = os.environ["masterRelease"]

if masterRelease == "false":
    branch = 'pre-' + branch
    data=json.loads(npmversions)
    latestversion = data[-1]
    for version in data[::-1]: 
        if branch in version: 
            latestversion=version
            break
else: 
    latestversion=npmversions

slackmessage = branch + '\n' + packageName + ':' + '\n' + latestversion
encoded_body = json.dumps({
"text": slackmessage
})
r = http.request(
    'POST', 
    'https://hooks.slack.com/services/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', 
    headers={'Content-Type': 'application/json'}, 
    body=encoded_body
)
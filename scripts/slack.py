import os 
import json
import urllib3
http = urllib3.PoolManager()
npmversions = os.environ["versions"]
branch = os.environ["branch"]
repo = os.environ["repo"]
data=json.loads(npmversions)
latestversion = data[-1]
for version in data[::-1]: 
  if branch in version: 
    latestversion=version
    break
print("latestversion", latestversion)
slackmessage = repo + '-' + latestversion
encoded_body = json.dumps({
  "text": slackmessage
})
r = http.request('POST', 
                'https://hooks.slack.com/services/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', 
                headers={'Content-Type': 'application/json'}, 
                body=encoded_body)
print('slackstatus: ', r.status)
# Sample Python API call to Azure Open API using REST!
#Ryan Mangan
import requests
import json

api_key = "<API_KEY>"
api_url = "https://<Instance>.openai.azure.com/openai/deployments/<Model>/completions?api-version=2022-12-01"

headers = {
    "Content-Type": "application/json",
    "api-key": api_key,
}

data = {
    "prompt": "Hello ChatGPT!",
    "max_tokens": 100,
    "temperature": 1,
    "frequency_penalty": 0,
    "presence_penalty": 0,
    "top_p": 0.5,
    "best_of": 1,
    "stop": None
}

response = requests.post(api_url, headers=headers, data=json.dumps(data))

if response.status_code == 200:
    result = json.loads(response.content)["choices"][0]["text"]
    print(result)
else:
    print(f"Error: {response.status_code}")

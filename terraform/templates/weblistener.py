#!/bin/python3

import sys, json
import os
import subprocess
import re
from flask import Flask, request, abort, jsonify
import shlex

app = Flask(__name__)

@app.route('/webhook',methods=['GET', 'POST'])
def webhook():
	print("webhook");sys.stdout.flush()
	if request.method == 'POST':
		json_data = request.get_json()
		formatted_json = json.dumps(json_data, indent=2, sort_keys=True)
		with open("/home/${os_user}/jsonDataFile.json", "w") as outfile:
			outfile.write('%s' % formatted_json)
		nodeName = json_data["node_name"]
		nodeIP = re.search( r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})', nodeName ).group()
		shell_cmd = ("ansible-playbook --ssh-common-args='-o StrictHostKeyChecking=no' -u ${os_user} /home/${os_user}/playbooks/httpd.yml -i %s," % nodeIP)
		subprocess_cmd = shlex.split(shell_cmd)
		subprocess.call(subprocess_cmd)
		return '',200
	elif request.method == 'GET':
		return '',200
	else:
		abort(400)

if __name__ == '__main__':
	app.run(debug=True, host='0.0.0.0') 
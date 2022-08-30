#!/usr/bin/python3
import os
directory = os.path.join(os.path.dirname(__file__), "..")
dev_plugs = {}
max_dev_len = 0
for filename in os.listdir(directory):
	d = os.path.join(directory, filename)
	dev_name = os.path.basename(d)
	if os.path.isdir(d):
		for start in os.listdir(d):
			if os.path.basename(start) == "start":
				start_dir = os.path.join(d, start)
				for plugin in os.listdir(start_dir):
					plug_dir = os.path.join(start_dir, plugin)
					if os.path.isdir(plug_dir):
						if len(dev_name) > max_dev_len:
							max_dev_len = len(dev_name)
						plug_name = os.path.basename(plugin)
						if dev_name not in dev_plugs:
							dev_plugs[dev_name] = []
						dev_plugs.get(dev_name).append(plug_name)
for k in dev_plugs:
	v = dev_plugs[k]
	left_side = k.ljust(max_dev_len, ' ') + " | "
	for plug in v:
		print(left_side + plug)
		left_side = "".ljust(max_dev_len, ' ') + " | "

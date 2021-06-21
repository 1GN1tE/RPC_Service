#!/usr/bin/python3
# WARNING: The Windows/Linux interface is EXPERIMENTAL and has nothing to do with good coding, security, etc.
# USE AT YOUR OWN RISK.

import sys, subprocess, ctypes, os, string

#####
file_path = os.path.dirname(os.path.abspath(__file__))
if not os.path.exists(file_path+"\\config.txt"):
	print("[+] config.txt not found")
	exit()
file = open(file_path+"\\config.txt")
username = file.readline().strip()
ip_addr = file.readline().strip()
shell = file.readline().strip()
terminal = file.readline().strip()
#####

def translate_path(path):
	path = path.replace("\\","/")
	drive = path[:2]
	drive =drive.replace(":","")
	drive = "/"+drive.lower()
	path = drive + path[2:]
	path = path.replace(" ", "\ ")
	return path


def ping(host):
	command = ['ping', '-n', '1', host]
	return subprocess.call(command, stdout=subprocess.PIPE, shell=False, creationflags = 0x08000000) == 0

if(not ping(ip_addr)):
	print(f"[-] Client Unavailable at {ip_addr}")
	exit()

if(len(sys.argv) < 2):
	cwd = os.getcwd()
else:
	cwd = os.path.abspath(sys.argv[1])
cwd = translate_path(cwd)

ssh = subprocess.run([
	'ssh',
	'-t',
	username + '@' + ip_addr,
	'-q',
	f"cd {cwd} ; {shell} --login"
	],
	shell=True)

#! /usr/bin/env python3
import json
import os, os.path

x = lambda directory: len([name for name in os.listdir(directory) if os.path.isfile(os.path.join(directory, name))])
numberTenants=x("../../../namespace/") - 1
print(numberTenants)
# y=len([name for name in os.listdir("../../../namespace/") if os.path.isfile(os.path.join(directory, name))])
# print(y)
# tao ra 1 json object
# = a dictionary
# key = "test".i
# value = 172.16.i.0/24

iplist={}

for i in range(1, numberTenants+1):
    key='test'+str(i)
    value='172.' + str(16 + int( i / 256) ) + '.'+ str(i % 256)+'.0/24'
    iplist[key] = value

iplist['all']='172.16.0.0/14'
outfile=open("iplist.json",'w')
outfile.write(json.dumps(iplist))
outfile.close()

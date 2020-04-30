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

for i in range(numberTenants):
    key='test'+str(i+1)
    value='172.16.'+str(i+1)+'.0/24'
    iplist[key] = value

iplist['all']='172.16.0.0/17'
outfile=open("iplist.json",'w')
outfile.write(json.dumps(iplist))
outfile.close()

#!/usr/bin/env python3
# 1 dan input
# 1 cai template
# 1 thu vien de cong ip address
import sys
numOfTenants=0
try:
    numOfTenants=int(sys.argv[1])
except IndexError:
    print("Input, please !!!")

template='''
apiVersion: projectcalico.org/v3
kind: IPPool
metadata:
  name: pool{id}
spec:
  cidr: 172.{secondDigit}.{thirdDigit}.0/24
  blockSize: 29
  ipipMode: Always
  natOutgoing: true # If false --> No internet access for pod in this namespace
'''
newPool=""
for i in range(1, numOfTenants+1):
    second=16+int(i/256)
    third=i%256
    newPool = template.format(id=i, secondDigit=second, thirdDigit=third)
    f = open("../pool/pools-" + str(i), "w")
    print(newPool, file=f)
    f.close()




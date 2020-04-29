#! /usr/bin/env python3
import iptc
import json
import sys


# Input: file name of list IP range
# IPTable manipulate

def add_rule(IP, namespace):
    
    rule=iptc.Rule()
    # Target
    target_ACCEPT = rule.create_target("ACCEPT")
    target_DROP = rule.create_target("DROP")
    
    # Chain
    chain_input=iptc.Chain(iptc.Table(iptc.Table.FILTER), "INPUT")
    chain_output=iptc.Chain(iptc.Table(iptc.Table.FILTER), "OUTPUT")
    
    rule.src = IP
    rule.dst = IP
    if namespace != "all": 
        rule.target = target_ACCEPT
        chain_input.insert_rule(rule)
        chain_output.insert_rule(rule)
    else:
        rule.target = target_DROP
        chain_input.append_rule(rule)
        chain_output.append_rule(rule)

    # chain_input.insert_rule(rule)
    # chain_output.insert_rule(rule)

def flush_all():
    chain_input=iptc.Chain(iptc.Table(iptc.Table.FILTER), "INPUT")
    chain_output=iptc.Chain(iptc.Table(iptc.Table.FILTER), "OUTPUT")
    chain_input.flush()
    chain_output.flush()


def Input(filename):
    with open(filename, 'r') as f:
        ip_range_list = json.load(f)
        return ip_range_list

#----------Start From Here-------------------------
namespace=""
if len(sys.argv) > 1:
    namespace=sys.argv[1]
else:
    raise VallueError("I need the namespace of this pod")

filename="iplist.json"
ip_range_list = Input(filename)

# print(ip_range_list[namespace])
flush_all()
add_rule(ip_range_list[namespace], namespace)
add_rule(ip_range_list["all"], "all")
# for item in ip_range_list.items():
#     add_rule(item)

while True:
    pass


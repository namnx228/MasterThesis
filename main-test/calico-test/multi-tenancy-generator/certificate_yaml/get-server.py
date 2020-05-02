import yaml
stream=file("/home/vagrant/.kube/config", 'r')
yml=yaml.load(stream)
print yml["clusters"][0]["cluster"]["server"]
# print yaml.dump(yml)


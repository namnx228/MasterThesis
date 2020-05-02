import yaml
stream=file("/home/vagrant/.kube/config", 'r')
yml=yaml.load(stream)
print yml["clusters"][0]["cluster"]["certificate-authority-data"]
# print yaml.dump(yml)


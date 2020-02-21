import yaml
stream=file("/home/nam/.kube/kind-config-kind", 'r')
yml=yaml.load(stream)
print yml["clusters"][0]["cluster"]["certificate-authority-data"]
# print yaml.dump(yml)


import subprocess, os

COFFEE_DIRECTORY = "coffee/"
JS_DIRECTORY = "js/"

theFilesList = []
for fFileObj in os.walk(JS_DIRECTORY):
   theFilesList = fFileObj[2]
   break

print "Transpiling..."
for aFile in theFilesList:
    if aFile.split(".")[1] != "coffee":
        continue
    print aFile
    proc = subprocess.Popen(["coffee", "-c", JS_DIRECTORY + aFile],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    proc = subprocess.Popen(["rm", JS_DIRECTORY + aFile])

import subprocess, os

COFFEE_DIRECTORY = "coffee/"
JS_DIRECTORY = "js/"

theFilesList = []
for fFileObj in os.walk(JS_DIRECTORY):
   theFilesList = fFileObj[2]
   break


print theFilesList
print "Transpiling..."
for aFile in theFilesList:
    if aFile.split(".")[1] != "coffee":
        continue
    print str(JS_DIRECTORY + aFile)
    subprocess.call(["coffee", "-c", JS_DIRECTORY + aFile])
    proc = subprocess.Popen(["rm", JS_DIRECTORY + aFile])

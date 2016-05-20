import subprocess, os, csv
from copy import *
OUTPUT_LOCATION = "out/"
JS_DIRECTORY = "js/"

def parseFileName(fileName):
    condition = fileName.split("-")[1]
    studentID = fileName.split("-")[0]
    return (studentID, condition)

theFilesList = []
for fFileObj in os.walk(JS_DIRECTORY):
   theFilesList = fFileObj[2]
   break

if ".DS_Store" in theFilesList:
    theFilesList.remove(".DS_Store")

# Build a list of IDS and conditions
theList = []
for aFile in theFilesList:
    (aStudentID, aCondition) = parseFileName(aFile)
    temp = {"id":aStudentID , "condition":aCondition, "file_name":aFile}
    theList.append(temp)

text_list = [x for x in theList if x["condition"]=="text"]
hybrid_list = [x for x in theList if x["condition"]=="hybrid"]
blocks_list = [x for x in theList if x["condition"]=="block"]

master_list = deepcopy(text_list + hybrid_list + blocks_list)

columnArray = []
for aFileDict in master_list:
    rowArray = [aFileDict["id"]]
    for bFileDict in master_list:
        if aFileDict["id"] == bFileDict["id"]:
            rowArray.append(0)
        else:
            print "Compare ", aFileDict["id"], " with ", bFileDict["id"]
            proc = subprocess.Popen(["gumtree-2.1.0-SNAPSHOT/bin/gumtree", "adhocdiff", JS_DIRECTORY + aFileDict["file_name"],JS_DIRECTORY + bFileDict["file_name"]], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            stdout_value, stderr_value = proc.communicate('through stdin to stdout')
            with open(OUTPUT_LOCATION + aFileDict["file_name"] + "!" + bFileDict["file_name"], 'wb') as outfile:
                outfile.write(stdout_value)
            rowArray.append(len(stdout_value.splitlines()))
    columnArray.append(rowArray)

with open(OUTPUT_LOCATION + "master_comp_table.csv", 'wb') as outfile:
    writer = csv.writer(outfile)
    header = [""] + [x["id"] for x in master_list]
    writer.writerow(header)
    writer.writerows(columnArray)

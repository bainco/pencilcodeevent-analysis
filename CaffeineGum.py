def parseFileName(fileName):
    condition = fileName.split("-")[1]
    studentID = fileName.split("-")[0]
    return (studentID, condition)

def writeToCSV (theList, fileName):
   " Prints the contents of a list of dictionaries to a CSV file where each row is a dictionary "
   with open(fileName, 'wb') as outfile:
      w = csv.DictWriter(outfile, theList[0].keys())
      w.writeheader()
      for item in theList:
         w.writerow(item)

theFilesList = []
for fFileObj in os.walk(JS_DIRECTORY):
   theFilesList = fFileObj[2]
   break

if ".DS_Store" in theFilesList:
    theFilesList.remove(".DS_Store")

for aFile in theFilesList:

    (aStudentID, aCondition) = parseFileName(aFile)
    print "Loaded: ", str(aStudentID)

    for bFile in theFilesList:
        (bStudentID, bCondition) = parseFileName(bFile)
        if aStudentID == bStudentID:
            continue
        if aCondition != bCondition:
            continue

        print "Compare w/: ", str(bStudentID)

        # DO THE PROCESSING
        # Run the program and listen for errors

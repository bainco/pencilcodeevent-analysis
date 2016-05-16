import csv
# Read in CSV line by line
# Write each program to .coffee file
#  Store in coffee folder
# Transpile each program to .js file
#  Store in js folder

# Use gumtree to compare all of the files to all the other files

PCID_INDEX = 0
STUDENT_ID_INDEX = 1
ASSIGNMENT_INDEX = 2
PROJECT_NAME_INDEX = 3
TIME_STAMP_INDEX = 4
CONDITION_INDEX = 5
EDITOR_MODE_INDEX = 6
EVENT_TYPE_INDEX = 7
PROGRAM_INDEX = 8
FLOATING_BLOCK_INDEX = 9
PROJECT_HTML_INDEX = 10
PROJECT_CSS_INDEX = 11
HOST_INDEX = 12
PALETTE_VISIBLE_INDEX = 13

COFFEE_DIRECTORY = "coffee/"

with open("data/oas_pencilcodeevent-brickwall-lastentry.csv", "rb") as f:
    reader = csv.reader(f)
    headers = reader.next()
    print "Processing..."
    for i, line in enumerate(reader):
        loadStudentID = line[STUDENT_ID_INDEX]

        if loadStudentID == 11 or loadStudentID == 13:
            continue

        loadProgram = line[PROGRAM_INDEX]
        loadCondition = line[CONDITION_INDEX]

        # Write the program to file
        theCoffeeName = COFFEE_DIRECTORY + str(loadStudentID) + "-" + str(loadCondition) + "-" + "brickwall.coffee"
        text_file = open(theCoffeeName, "w")
        text_file.write(loadProgram)
        text_file.close()

        theJSName = JS_DIRECTORY + str(loadStudentID) + "-" + str(loadCondition) + "-" + "brickwall.coffee"
        text_file = open(theJSName, "w")
        text_file.write(loadProgram)
        text_file.close()

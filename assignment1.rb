#initializing our Student class
class Student
    attr_accessor :stuId, :stuIn1, :stuIn2, :stuIn3, :stuIn4, :available, :selectedClass, :valid1, :valid2, :valid3, :valid4, :found_intr

    def initialize(stuId, stuIn1, stuIn2, stuIn3, stuIn4, available)
        @stuId = stuId
        @stuIn1 = stuIn1
        @stuIn2 = stuIn2
        @stuIn3 = stuIn3
        @stuIn4 = stuIn4
        @selectedClass = 0
        @available = true
        @valid1 = false
        @valid2 = false
        @valid3 = false
        @valid4 = false
        @found_intr = 0

        
    end
end
#Initializing our Event class
class Event
    attr_accessor :eventId, :eventName, :eventIssu1, :eventIssu2, :eventIssu3, :minStu, :maxStu, :roster, :available, :confirmed

    def initialize(eventId, eventName, eventIssu1, eventIssu2, eventIssu3, minStu, maxStu, roster, available)
        @eventId = eventId
        @eventName = eventName
        @eventIssu1 = eventIssu1
        @eventIssu2 = eventIssu2
        @eventIssu3 = eventIssu3
        @minStu = minStu
        @maxStu = maxStu
        @available = true
        @roster = 0
        confirmed = false
    end
end
def is_integer(str)
    begin
      Integer(str)
      return true
    rescue ArgumentError
      return false
    end
end
# our function to strip through the information being given and sort out and place in respective variables for events
def initializeEvents(data)
    event_objects = []

    data.each do |sub_array|
        eventId = sub_array[0].lstrip.to_i
        eventName = sub_array[1].lstrip.downcase
        eventIssu1 = sub_array[2].lstrip.downcase
        
        if is_integer(sub_array[3])
            eventIssu2 = "N/A"
            eventIssu3 = "N/A"
            minStu = sub_array[3].lstrip.to_i
            maxStu = sub_array[4].lstrip.to_i
    
        elsif is_integer(sub_array[4])
            eventIssu2 = sub_array[3].lstrip.downcase
            eventIssu3 = "N/A"
            minStu = sub_array[4].lstrip.to_i
            maxStu = sub_array[5].lstrip.to_i
    
        elsif is_integer(sub_array[5])
            eventIssu2 = sub_array[3].lstrip.downcase
            eventIssu3 = sub_array[4].lstrip.downcase
            minStu = sub_array[5].lstrip.to_i
            maxStu = sub_array[6].lstrip.to_i
        end
    
        roster = 0
        available = true
    
        # instantiating new instances of "Event" objects and pushing them into an array to be interated through later
    
        currevent = Event.new(eventId, eventName, eventIssu1, eventIssu2, eventIssu3, minStu, maxStu, roster, available)
        event_objects.push(currevent)
    end

    return event_objects
end
# our function to strip through the information being given and sort out and place in respective variables for students
def initializeStudents(data)
    student_objects = []

    data.each do |stu_array|
        stuId = stu_array[0].lstrip
        stuIn1 = stu_array[1].lstrip.downcase
        stuIn2 = stu_array[2].lstrip.downcase
    
        if stu_array[3]
            stuIn3 = stu_array[3].lstrip.downcase
            stuIn3 = stuIn3.downcase
        else
            stuIn3 = "ANY"
        end
        if stu_array[4]
            stuIn4 = stu_array[4].lstrip.downcase
        else
            stuIn4 = "ANY"
        end
    
        available = true
    
        currstud = Student.new(stuId, stuIn1, stuIn2, stuIn3, stuIn4, available)
        student_objects.push(currstud)
    end
    #returning array with correct and formatted student information
    return student_objects
end
def findTotalStudents(arr)
    total_students = 0

    arr.each do |i|
        total_students = total_students + 1
    end

    return total_students
end
def openFile(file)

    text = File.read(file)
    lines = text.split("\n")
    data = lines[1..-1].map { |line| line.split(/[;,]/)} 
    
    return data
end
# Event sorter made specifally so that each student gets their first choice equally 
def eventSort(stuarr, eventarr)
    eventarr.each do |i|
        stuarr.each do |j|
            if ((i.eventIssu1 || i.eventIssu2 || i.eventIssu3) == j.stuIn1) && j.available && i.available
                if i.roster < i.maxStu
                    i.roster = i.roster + 1
                    j.selectedClass = i.eventId
                    j.available = false
                    j.found_intr = j.stuIn1
                else
                    i.available = false
                end
            end
        end
    end
    
   eventarr.each do |i|
       stuarr.each do |j|
            if ((i.eventIssu1 || i.eventIssu2 || i.eventIssu3) == j.stuIn2) && j.available && i.available
                if i.roster < i.maxStu
                    i.roster = i.roster + 1
                    j.selectedClass = i.eventId
                    j.available = false
                    j.found_intr = j.stuIn2
                else
                    i.available = false
                end
            end
        end
    end
    
    eventarr.each do |i|
        stuarr.each do |j|
            if ((i.eventIssu1 || i.eventIssu2 || i.eventIssu3) == j.stuIn3) && j.available && i.available
                if i.roster < i.maxStu
                    i.roster = i.roster + 1
                    j.selectedClass = i.eventId
                    j.available = false
                    j.found_intr = j.stuIn3
                else
                    i.available = false
                end
            end
        end
    end
    
    eventarr.each do |i|
        stuarr.each do |j|
            if ((i.eventIssu1 || i.eventIssu2 || i.eventIssu3) == j.stuIn4) && j.available && i.available
                if i.roster < i.maxStu
                    i.roster = i.roster + 1
                    j.selectedClass = i.eventId
                    j.available = false
                else
                    i.available = false
                end
            end
        end
    end
    # If a student still does not have a selected class, were going to find an open class thats low on students and 
    # put them in there

    eventarr.each do |i|
        stuarr.each do |j|
            if j.selectedClass == 0
                if i.minStu > i.roster && j.available = true && i.available = true
                    j.selectedClass = i.eventId
                    i.roster = i.roster + 1
                    j.available = false
                    j.found_intr = "Force Placed"
                end
            end
        end
    end
    eventarr.reverse_each do |i|
        stuarr.each do |j|
            if j.selectedClass == 0
                if i.roster < i.maxStu && j.available = true && i.available = true
                    j.selectedClass = i.eventId
                    i.roster = i.roster + 1
                    j.available = false
                    j.found_intr = "Force Placed"
                end
            end
        end
    end
end
#Checking to see if our students have valid issues
def checkValid(stuarr, validIssues)
    stuarr.each do |i|
        validIssues.each do |v|
    
            if i.stuIn1 == v && i.available
                i.valid1 = true
                break
            end
            if i.stuIn2 == v && i.available
                i.valid2 = true
                break
            end
            if i.stuIn3 == v && i.available
                i.valid3 = true
                break
            end
            if i.stuIn4 == v && i.available
                i.valid4 = true
                break
            end
        end
    #Checking for our students that are already selected for an event.
    stuarr.each do |i|
        validIssues.each do |v|
            if i.stuIn1 == v
                i.valid1 = true
                break
            end
        end
    end
    
    end
    stuarr.each do |i|
        validIssues.each do |v|
            if i.stuIn1 == v
                i.valid1 = true
                break
            end
        end
    end
end
#Checking our invalid students and changing their interest to ANY
def checkInvalid(stuarr)
    stuarr.each do |i|

        if !i.valid1 && i.available
            i.stuIn1 = "ANY"
        end
        if !i.valid2 && i.available
            i.stuIn2 = "ANY"
        end
        if !i.valid3 && i.available
            i.stuIn3 = "ANY"
        end
        if !i.valid4 && i.available
            i.stuIn4 = "ANY"
        end
    end
end
#Function to fix our format for our output CSV file
def fixFormat(eventarr)
    eventarr.each do |h|
        if h.eventIssu2 == "ANY"
            h.eventIssu2 = "none"
        end
        if h.eventIssu3 == "ANY"
            h.eventIssu3 = "none"
        end
        if h.minStu <= h.roster
            h.confirmed = true
        end
    end
end
def finalValid(stuarr, validIssues)
    num_invalid = 0


    stuarr.each do |i|
        validIssues.each do |v|
            if i.stuIn2 == v
                i.valid2 = true
                break
            end
        end
    end
    stuarr.each do |i|
        validIssues.each do |v|
            if i.stuIn3 == v && i.stuIn3 != "ANY"
                i.valid3 = true
                break
            end
        end
    end
    stuarr.each do |i|
        validIssues.each do |v|
            if i.stuIn4 == v
                i.valid4 = true
                break
            end
        end
    end
    
    stuarr.each do |m|
        if (m.valid1 == false || m.valid2 == false)
            num_invalid = num_invalid + 1
        end
    end

    return num_invalid
end
def sortInvalidStudents(stuarr, eventarr)
    eventarr.each do |i|
        stuarr.each do |j|
            if j.stuIn1 == "ANY" || j.stuIn2 == "ANY" || j.stuIn3 == "ANY" || j.stuIn4 == "ANY"
                if i.available && j.available && (i.minStu > i.roster)
                    if i.roster < i.maxStu
                        i.roster = i.roster + 1
                        j.selectedClass = i.eventId
                        j.available = false
                        j.found_intr = "Force Placed"
                    else
                        i.available = false
                    end
                end
            end
        end
    end
    eventarr.each do |i|
        stuarr.each do |j|
            if j.available && i.available && (i.minStu < i.roster)
                if i.roster < i.maxStu
                    i.roster = i.roster + 1
                    j.selectedClass = i.eventId
                    j.available = false
                    j.found_intr = "Force Placed"
                else
                    i.available = false
                end
            end
        end
    end
end
def formatCSV(eventarr, stuarr)

    roster = ""
    require 'csv'

    CSV.open('scheduling_plan.csv', 'wb') do |csv|
        csv << ['Event-Id', 'Event-Name', 'Event-Issues', 'Min-Students', 'Max-Students', 'Num-Students', 'Roster', 'Status']
    
        eventarr.each do |i|
            eventId = i.eventId
            event_name = i.eventName
            event_issues = "#{i.eventIssu1}; #{i.eventIssu2}; #{i.eventIssu3}"
            min_students = i.minStu
            max_students = i.maxStu
            num_students = i.roster
    
            roster = ""
    
            stuarr.each do |j|
                if j.selectedClass == i.eventId 
                    roster  = "#{roster} #{j.stuId} #{j.found_intr};"
                end
            end
    
            if i.confirmed
                status = "Ok"
            else
                satus = "Cancel"
            end
            csv << [eventId, event_name, event_issues, min_students, max_students, num_students, roster, status]
        end
    end
end
def initializeSummary(eventarr, stuarr, invalid)
    runnable_events = 0
    cancelled_event = 0
    empty_events = 0
    num_valid = 0

    total_students = findTotalStudents(stuarr)

    CSV.open('summary.txt', 'wb') do |csv|
        csv << ['Num. of Students', 'Runnable Events', 'Pot. Cancelled Events', 'Empty Events']

        eventarr.each do |n|
            if n.confirmed
                runnable_events = runnable_events + 1
            end
            if n.roster < n.minStu
                cancelled_event = cancelled_event + 1
            end
            if n.roster == 0
                empty_events = empty_events + 1
            end

        end
        num_valid = total_students - invalid
        csv << [num_valid, runnable_events, cancelled_event, empty_events]
    end

    puts "Number of students who's required (2) selected issues are valid: #{num_valid}"
    puts "Number of runnable events: #{runnable_events}"
    puts "Number of cancelled events: #{cancelled_event}"
    puts "Number of empty events: #{empty_events}"
end
def main()
    event_objects = []   
    student_objects = []
    valid_issues = ["food insecurity", "poverty", "racial inequality", "climate change", "homelessness", "healthcare", "gender inequality"]
    data = openFile(ARGV[0])
    event_objects = initializeEvents(data)
    sdata = openFile(ARGV[1])
    student_objects = initializeStudents(sdata)
    eventSort(student_objects, event_objects)
    checkValid(student_objects, valid_issues)
    checkInvalid(student_objects)
    sortInvalidStudents(student_objects, event_objects)
    fixFormat(event_objects)
    num_invalid = finalValid(student_objects, valid_issues)
    formatCSV(event_objects, student_objects)
    initializeSummary(event_objects, student_objects, num_invalid)
end
main()









    


        











                


            

    

        
            








 






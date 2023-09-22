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

event_objects = []
student_objects = []
valid_issues = ["food insecurity", "poverty", "racial inequality", "climate change", "homelessness", "healthcare", "gender inequality"]


file_name = "events2.csv"
text = File.read(file_name)

lines = text.split("\n")
data = lines[1..-1].map { |line| line.split(/[;,]/)} 

# Depending on where our "minimum students" starts in the file, we can determine how many student issues were given and 
# what are "Max students allowed" would be

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

file_name = "interests2.csv"
text = File.read(file_name)

slines = text.split("\n")
sdata = slines[1..-1].map { |sline| sline.split(/[;,]/)} 

# Checking to see how many student issues were selected, depending on the first integer placement
# we can tell how many student issues were given

total_students = 0;

sdata.each do |stu_array|
    stuId = stu_array[0].lstrip
    stuIn1 = stu_array[1].lstrip.downcase
    stuIn2 = stu_array[2].lstrip.downcase

    total_students = total_students + 1

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

# If the student issue matches any of the event issue, were going to select and put them in that class
# If the roster equals the max amount of studets, were going to set the class availablity to false
# so that no other student can get selected for that class

event_objects.each do |i|
    student_objects.each do |j|
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

event_objects.each do |i|
    student_objects.each do |j|
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

event_objects.each do |i|
    student_objects.each do |j|
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

event_objects.each do |i|
    student_objects.each do |j|
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

#Checking to see if the remaining students not selected for a class actually have valid issues selected
student_objects.each do |i|
    valid_issues.each do |v|

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

end

#If there selections arent valid, were goign to change this options to ANY so that they can be selected for an empty class
student_objects.each do |i|

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

# Iterating through both the students and events, if theres any students that have not been selected and need a class
# and have ANY as a issue and the class is below minimum amount of students, put them in that class

event_objects.each do |i|
    student_objects.each do |j|
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

# If theres still availbe students and classes, add the students to the class IFF the roster isnt maxed out yet

event_objects.each do |i|
    student_objects.each do |j|
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

# If a student still does not have a selected class, were going to find an open class thats low on students and 
# put them in there

event_objects.each do |i|
    student_objects.each do |j|
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

# Any open classes can begin to get filled up, this time from the bottom up

event_objects.reverse_each do |i|
    student_objects.each do |j|
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

event_objects.each do |h|
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

num_invalid = 0

student_objects.each do |i|
    valid_issues.each do |v|
        if i.stuIn1 == v
            i.valid1 = true
            break
        end
    end
end
student_objects.each do |i|
        valid_issues.each do |v|
        if i.stuIn2 == v
            i.valid2 = true
            break
        end
    end
end
student_objects.each do |i|
    valid_issues.each do |v|
        if i.stuIn3 == v && i.stuIn3 != "ANY"
            i.valid3 = true
            break
        end
    end
end
student_objects.each do |i|
    valid_issues.each do |v|
        if i.stuIn4 == v
            i.valid4 = true
            break
        end
    end
end

student_objects.each do |m|
    if (m.valid1 == false || m.valid2 == false)
        num_invalid = num_invalid + 1
    end
end

roster = ""

require 'csv'

CSV.open('scheduling_plan.csv', 'wb') do |csv|
    csv << ['Event-Id', 'Event-Name', 'Event-Issues', 'Min-Students', 'Max-Students', 'Num-Students', 'Roster', 'Status']

    event_objects.each do |i|
        eventId = i.eventId
        event_name = i.eventName
        event_issues = "#{i.eventIssu1}; #{i.eventIssu2}; #{i.eventIssu3}"
        min_students = i.minStu
        max_students = i.maxStu
        num_students = i.roster

        student_objects.each do |j|
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

runnable_events = 0
cancelled_event = 0
empty_events = 0
num_valid = 0

CSV.open('summary.txt', 'wb') do |csv|
    csv << ['Num. of Students', 'Runnable Events', 'Pot. Cancelled Events', 'Empty Events']

    event_objects.each do |n|
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
    num_valid = total_students - num_invalid
    csv << [num_valid, runnable_events, cancelled_event, empty_events]
end

puts "Number of students who's required (2) selected issues are valid: #{num_valid}"
puts "Number of runnable events: #{runnable_events}"
puts "Number of cancelled events: #{cancelled_event}"
puts "Number of empty events: #{empty_events}"


    


        











                


            

    

        
            








 






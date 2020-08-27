#!/usr/local/bin/ruby -w

require_relative './main'

first_file_name = 'input/webserver.log'
second_file_name = 'input/webserver.log'

file = LogReader.read(first_file_name)
unique_visits_file = LogReader.read(second_file_name)
visits_hash = LogFormater.parseLines(file)
unique_visits_hash = LogFormater.parseUniqueLines(unique_visits_file)
sorted_visits = LogFormater.sortHash(visits_hash)
unique_sorted_visits = LogFormater.sortHash(unique_visits_hash)
views_string = LogFormater.formatVisits(sorted_visits)
unique_visits_string = LogFormater.formatUniqueVisits(unique_sorted_visits)

file.close
unique_visits_file.close

puts ' *** Page Visits: *** '
LogOutput.printOutput(views_string)
puts "\n"
puts ' *** Unique Page Views: *** '
LogOutput.printOutput(unique_visits_string)

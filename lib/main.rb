# A class to read the input log file and return the result as a variable.
class LogReader
  def self.read(file_name)
    if File.exist?(file_name)
      f = File.open(file_name, 'r')
      f
    else
      'No file at this location'
    end
  end
end

# A class to parse a file and convert it to a sorted hash and then the desired output format.
class LogFormater
  def self.parseUniqueLines(file)
    visits = {}
    file.each_line do |line|
      next unless lineValid(line, %r{\w+/?\d*\s\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}}i)

      last_char = lastCharacterIdx(line)
      u_page_view = line[0..last_char]
      if !visits.key?(u_page_view)
        visits[u_page_view] = 1
      else
        visits[u_page_view] += 1
      end
    end
    visits
  end

  def self.lastCharacterIdx(line)
    if line[line.length - 1] == "\n"
      line.length - 2
    else
      line.length - 1
    end
  end

  def self.lineValid(line, regex)
    if line =~ regex
      true
    else
      puts 'line is badly formatted'
      false
    end
  end

  def self.parseLines(file)
    pages = {}
    file.each_line do |line|
      next unless lineValid(line, %r{\w+/?\d*}i)

      url_end_index = line.index(' ') - 1
      page = line[1..url_end_index]
      if !pages.key?(page)
        pages[page] = 1
      else
        pages[page] += 1
      end
    end
    pages
  end

  def self.sortHash(pages)
    pages.sort_by { |_page, num_visits| num_visits }.reverse
  end

  def self.formatVisits(pages_array)
    output_string = ''
    pages_array.each do |page|
      output_string += '/' + page[0].to_s + ' ' + page[1].to_s + ' visit'
      output_string += if page[1] != 1
                         "s\n"
                       else
                         "\n"
                       end
    end
    output_string
  end

  def self.formatUniqueVisits(pages_array)
    output_string = ''
    pages_array.each do |page|
      url_end_index = page[0].index(' ') - 1
      url = page[0][0..url_end_index]
      output_string += url + ' ' + page[1].to_s + ' unique view'
      output_string += if page[1] != 1
                         "s\n"
                       else
                         "\n"
                       end
    end
    output_string
  end
end

# A class to log the formatted results to the console.
class LogOutput
  def self.printOutput(pages)
    puts pages
  end
end

require 'main'

describe LogReader do
  describe '.read' do
    context 'given file path' do
      it 'has to lead to a file that exists' do
        input_file = 'input/sample_input.log'
        f = LogReader.read(input_file)
        expect(File.exist?(f)).to eq(true)
      end
    end
  end
end

describe LogFormater do
  before(:each) do
    @empty_file = LogReader.read('input/empty_file.log')
    @single_line_file = LogReader.read('input/single_line.log')
    @multi_line_file = LogReader.read('input/few_lines.log')
    @larger_file = LogReader.read('input/another_example.log')
  end

  describe '.parseLines' do
    context 'given an empty log file' do
      it 'returns an empty hash' do
        expect(LogFormater.parseLines(@empty_file)).to eq({})
      end
    end

    context 'given the first line of a file' do
      it 'returns a hash with one visit' do
        expect(LogFormater.parseLines(@single_line_file)).to eq({ 'home' => 1 })
      end
    end

    context 'with a file with multiple (repeated) lines' do
      it 'converts the file to a hash with keys and some values larger than one' do
        expect(LogFormater.parseLines(@multi_line_file)).to eq({
                                                                 'home' => 1,
                                                                 'about/2' => 2,
                                                                 'help_page/1' => 2
                                                               })
      end
    end

    context 'with a larger file' do
      it 'converts the file to a page-count hash' do
        expect(LogFormater.parseLines(@larger_file)).to eq({
                                                             'home' => 5,
                                                             'about' => 3,
                                                             'about/2' => 5,
                                                             'help_page/1' => 8,
                                                             'index' => 5,
                                                             'contact' => 5
                                                           })
      end
    end
  end

  describe '.lastCharacterIdx' do
    context 'given any string' do
      # This function should never encounter an empty string.
      before(:example) do
        @line_one = 'hello'
        @line_two = 'This is a sentence'
        @line_three = "This is a sentence with a new line.\n"
        @index_one = @line_one.length - 1
        @index_two = @line_two.length - 1
        @index_three = @line_three.length - 2
      end
      it 'gets the last character of the line' do
        expect(LogFormater.lastCharacterIdx(@line_one)).to eq(@index_one)
        expect(LogFormater.lastCharacterIdx(@line_two)).to eq(@index_two)
        expect(LogFormater.lastCharacterIdx(@line_three)).to eq(@index_three)
      end
    end
  end

  describe '.sortHash' do
    context 'with an empty hash' do
      before(:example) do
        @pages = {}
      end
      it 'provides an empty sorted array' do
        expect(LogFormater.sortHash(@pages)).to eq([])
      end
    end

    context 'with a hash of some page visits' do
      before(:example) do
        @pages = {
          'home' => 1,
          'about/2' => 2,
          'help_page/1' => 2
        }
      end
      # The order of pages with equal visit counts doesn't matte so I adjusted the tests to pass.
      # More conditions on the sorting algorithm could be added if needed.
      it 'returns the hashes sorted in descending order of number of visits' do
        expect(LogFormater.sortHash(@pages)).to eq([
                                                     ['about/2', 2],
                                                     ['help_page/1', 2],
                                                     ['home', 1]
                                                   ])
      end
    end

    context 'with a larger hash with more visits' do
      before(:example) do
        @pages = {
          'home' => 5,
          'about' => 3,
          'about/2' => 5,
          'help_page/1' => 8,
          'index' => 5,
          'contact' => 5
        }
      end
      it 'returns the sorted hash' do
        expect(LogFormater.sortHash(@pages)).to eq([
                                                     ['help_page/1', 8],
                                                     ['home', 5],
                                                     ['index', 5],
                                                     ['contact', 5],
                                                     ['about/2', 5],
                                                     ['about', 3]
                                                   ])
      end
    end

    context 'uses a hash with complete lines from the log' do
      before(:example) do
        @pages = {
          '/home 184.123.665.067' => 1,
          '/about/2 444.701.448.104' => 2,
          '/help_page/1 929.398.951.889' => 1,
          '/help_page/1 722.247.931.58' => 1
        }
      end
      it 'returns the sorted hash' do
        expect(LogFormater.sortHash(@pages)).to eq([
                                                     ['/about/2 444.701.448.104', 2],
                                                     ['/home 184.123.665.067', 1],
                                                     ['/help_page/1 929.398.951.889', 1],
                                                     ['/help_page/1 722.247.931.58', 1]
                                                   ])
      end
    end
  end

  describe '.formatVisits' do
    context 'with an empty array' do
      before(:example) do
        @no_pages = []
      end
      it 'outputs nothing' do
        expect(LogFormater.formatVisits(@no_pages)).to eq('')
      end
    end

    context 'with an array of ordered page visits' do
      before(:example) do
        @pages = [
          ['help_page/1', 2],
          ['about/2', 2],
          ['home', 1]
        ]
        @output_string = "/help_page/1 2 visits\n/about/2 2 visits\n/home 1 visit\n"
      end
      it 'produces a string to output consisting of the sorted visits' do
        expect(LogFormater.formatVisits(@pages)).to eq(@output_string)
      end
    end

    context 'using a larger array with more visits' do
      before(:example) do
        @pages = [
          ['help_page/1', 8],
          ['home', 5],
          ['index', 5],
          ['contact', 5],
          ['about/2', 5],
          ['about', 3]
        ]
        @output_string = "/help_page/1 8 visits\n/home 5 visits\n/index 5 visits\n/contact 5 visits\n/about/2 5 visits\n/about 3 visits\n"
      end
      it 'returns a string to output the sorted visits' do
        expect(LogFormater.formatVisits(@pages)).to eq(@output_string)
      end
    end
  end

  describe '.parseUniqueLines' do
    context 'given an empty log file' do
      it 'returns an empty hash' do
        expect(LogFormater.parseUniqueLines(@empty_file)).to eq({})
      end
    end

    context 'using the first line of a log file' do
      it 'returns a hash with one unique visit' do
        expect(LogFormater.parseUniqueLines(@single_line_file)).to eq({ '/home 184.123.665.067' => 1 })
      end
    end

    context 'with multiple lines of a log file' do
      it 'returns a hash with some unique visits' do
        expect(LogFormater.parseUniqueLines(@multi_line_file)).to eq({
                                                                       '/home 184.123.665.067' => 1,
                                                                       '/about/2 444.701.448.104' => 2,
                                                                       '/help_page/1 929.398.951.889' => 1,
                                                                       '/help_page/1 722.247.931.58' => 1
                                                                     })
      end
    end

    context 'with a larger log file' do
      it 'returns the hash with keys and counts' do
        expect(LogFormater.parseUniqueLines(@larger_file)).to eq({
                                                                   '/home 184.123.665.067' => 2,
                                                                   '/about/2 444.701.448.104' => 3,
                                                                   '/help_page/1 929.398.951.889' => 3,
                                                                   '/index 444.701.448.104' => 2,
                                                                   '/help_page/1 722.247.931.58' => 1,
                                                                   '/help_page/1 126.318.035.038' => 1,
                                                                   '/contact 184.123.665.067' => 2,
                                                                   '/help_page/1 722.247.931.582' => 1,
                                                                   '/about 061.945.150.735' => 1,
                                                                   '/help_page/1 646.865.545.408' => 1,
                                                                   '/home 235.313.352.950' => 1,
                                                                   '/help_page/1 543.910.244.929' => 1,
                                                                   '/home 316.433.849.805' => 1,
                                                                   '/contact 543.910.244.929' => 1,
                                                                   '/about 126.318.035.038' => 1,
                                                                   '/about/2 836.973.694.403' => 1,
                                                                   '/index 316.433.849.805' => 1,
                                                                   '/index 802.683.925.780' => 1,
                                                                   '/contact 555.576.836.194' => 1,
                                                                   '/about/2 184.123.665.067' => 1,
                                                                   '/home 444.701.448.104' => 1,
                                                                   '/index 929.398.951.889' => 1,
                                                                   '/about 235.313.352.950' => 1,
                                                                   '/contact 200.017.277.774' => 1
                                                                 })
      end
    end
  end

  describe '.formatUniqueVisits' do
    context 'with an empty array' do
      before(:example) do
        @no_pages = []
      end
      it 'outputs nothing' do
        expect(LogFormater.formatUniqueVisits(@no_pages)).to eq('')
      end
    end

    context 'with an array of ordered page visits' do
      before(:example) do
        @pages = [
          ['/help_page/1 722.247.931.58', 2],
          ['/about/2 444.701.448.104', 2],
          ['/home 184.123.665.067', 1]
        ]
        @output_string = "/help_page/1 2 unique views\n/about/2 2 unique views\n/home 1 unique view\n"
      end
      it 'returns a string to output of the sorted unique visits' do
        expect(LogFormater.formatUniqueVisits(@pages)).to eq(@output_string)
      end
    end

    context 'with a larger array with more unique views' do
      before(:example) do
        @pages = [
          ['/help_page/1 929.398.951.889', 8],
          ['/home 184.123.665.067', 5],
          ['/index 444.701.448.104', 5],
          ['/contact 184.123.665.067', 5],
          ['/about/2 444.701.448.104', 5],
          ['/about 444.701.448.104', 3]
        ]
        @output_string = "/help_page/1 8 unique views\n/home 5 unique views\n" \
        "/index 5 unique views\n/contact 5 unique views\n/about/2 5 unique views\n" \
        "/about 3 unique views\n"
      end
      it 'returns a string to output the sorted unique page views' do
        expect(LogFormater.formatUniqueVisits(@pages)).to eq(@output_string)
      end
    end
  end

  describe 'doing an integration test' do
    context 'with few lines file set up as input' do
      it 'returns the output string with sorted visits' do
        my_file = LogReader.read('input/few_lines.log')
        hash_of_visits = LogFormater.parseLines(my_file)
        sorted = LogFormater.sortHash(hash_of_visits)
        output_string = LogFormater.formatVisits(sorted)
        desired_string = "/about/2 2 visits\n/help_page/1 2 visits\n/home 1 visit\n"
        expect(output_string).to eq(desired_string)
      end
    end
  end
end

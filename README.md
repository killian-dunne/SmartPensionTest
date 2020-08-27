# README

## Approach

I took a TDD approach so far as I could. At times I ended up writing similar tests multiple times but the main thing for me was that it was clear what was being tested.

### Assumptions

Assume it doesn't matter what the page order is when two pages have the same number visits.

Assume you always want both outputs printed simultaneously.

Assume multiple visits from the same IP address are considered part of the same session.

## Installation

To run this on your device there are a couple of requirements:

* Ensure you have Ruby, bundler, and rspec installed. The latter two can be installed by typing `gem install <package>` in the root directory of your terminal.

* Run `bundle install`.
  
* To run the tests type `rspec` also in the terminal.
  
* To execute the script type `lib/scipt.rb` in the terminal.

## Further

If I were to add to this, I would further define under what conditions the visits should be ordered - notably when two pages have been visited the same number of times.

Furthermore, I would cater for a wider range of log input types although this can vary massively and would mostly depend on what the particular logging needs were of the app.

# encoding: utf-8

require_relative 'found_senryu_models'

if $stdin.stat.size > 0
  formatted = TextFormater.new($stdin.readlines.join("")).format_text
  new_dictionary = SyllableDictionary.new('cmulex_pronunciation.csv').dictionary
  counter = SyllableCounter.new(new_dictionary)
  finder = SenryuFinder.new(counter)
  finder.find_senryu(formatted)
else
  puts "Please provide a text file."
  puts "For example, run this from the command line:"
  puts "'cat test.txt | ruby found_senryu_driver.rb'"
end
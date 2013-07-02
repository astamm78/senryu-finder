require 'debugger'
require 'csv'

class SyllableDictionary

  attr_accessor :dictionary
  attr_reader :file

  def initialize(file)
    @file = file
    @dictionary = {}
    open_file
  end

  def open_file
   CSV.open(file).read.map do |row|
      dictionary[row[0].to_sym] = row[1].to_s.scan(/(\d)/).size
    end
  end

end

class SyllableCounter

  attr_reader :dictionary

  def initialize(dictionary)
    @dictionary = dictionary
  end

  def count_syllable(word)
    dictionary[word.upcase.to_sym]
  end

end

class TextFormater

  attr_reader :text

  def initialize(text)
    @text = text
    format_text
  end

  def remove_extra_characters(input)
    input.gsub(/[\-\,\.\b\s\"]+|\\n/, " ")
  end

  def format_text
    remove_extra_characters(text).split(" ")
  end

end

class SenryuFinder

  attr_reader :counter

  def initialize(counter)
    @counter = counter
  end

  def find_senryu(array)
    results = []
    find_blocks(array, 17).each do |block|
      results << block if clean_breaks?(syl_sums(block))
    end
    print_results(results)
  end

  def find_blocks(array, size)
    matching_blocks = []
    until array.length == 0
      if match = block_of_syllable_for_count(array, size)
        matching_blocks << match
      end
      array.shift
    end
    matching_blocks
  end

  def block_of_syllable_for_count(source, count)
    syllable_count = 0
    match = []
    source.each do |word|
      if counter.count_syllable(word) == nil
        break
      else
        syllable_count += counter.count_syllable(word)
        match << word
        if syllable_count > count
          return nil
        elsif syllable_count == count
          return match
        end
      end
    end
    nil
  end

  def syl_sums(array)
    totals_count = []
    sum = 0
    count_each_word(array).each { |i| totals_count << sum += i unless i == nil }
    totals_count
  end

  def clean_breaks?(array)
    array.include?(5) && array.include?(12)
  end

  def count_each_word(array)
    array.map { |word| counter.count_syllable(word) }
  end

  def print_results(array)
    array.each { |result| puts result.join(" ")}
  end

end
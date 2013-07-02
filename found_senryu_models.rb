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

  def remove_space(input)
    input.gsub(/[\-\,\.\b\s]+|\\n/, " ")
  end

  def format_text
    remove_space(text).split(" ")
  end

end

class SenryuFinder

  attr_reader :counter

  def initialize(counter)
    @counter = counter
  end

  def find_blocks(array, size)
    blocks = []
    array.each_index do |index|
      word_array = []
      count = 0
      until index == array.length - 1
        if counter.count_syllable(array[index]) == nil
          break
        else
          count += counter.count_syllable(array[index])
          word_array << array[index]
          index += 1
        end
        if count == size
          blocks << word_array unless word_array.include?(nil)
          break
        elsif count > size
          break
        end
      end
    end
    blocks
  end

  def syl_sums(array)
    totals_count = []
    sum = 0
    count_each_word(array).each { |i| totals_count << sum += i }
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

  def find_senryu(array)
    results = []
    find_blocks(array, 17).each do |block|
      results << block if clean_breaks?(syl_sums(block))
    end
    print_results(results)
  end

end
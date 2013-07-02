require_relative 'found_senryu_models'


describe 'SyllableDictionary' do

  before do
    @dictionary = SyllableDictionary.new('test.csv')
  end

  it "should require a file as input" do
    expect { SyllableDictionary.new }.to raise_exception
  end

  it "should create a hash" do
    @dictionary.dictionary.class.should eq Hash
  end

  it "should return a hash with correct syllable count" do
    @dictionary.dictionary.first[1].should eq 2
  end

end

describe 'SyllableCounter' do

  before do
    @dictionary = { TESTING: 2 }
    @counter = SyllableCounter.new(@dictionary)
  end

  it "should require a dictionary hash as input" do
    expect { SyllableCounter.new }.to raise_exception
  end

  it "should return a a syllable count" do
    @counter.count_syllable('testing').should eq 2
  end

end

describe 'TextFormater' do

  before do
    @text = "This is - test, yes"
    @formatter = TextFormater.new(@text)
  end

  it "should require a block of text" do
    expect { TextFormater.new }.to raise_exception
  end

  it "should remove extra characters" do
    @formatter.remove_extra_characters(@text).should eq "This is test yes"
  end

  it "should format text into an array" do
    @formatter.format_text.class.should eq Array
  end

  it "should return an array of the input text" do
    @formatter.format_text.should eq ["This", "is", "test", "yes"]
  end

end

describe "SenryuFinder" do

  before do
    @dictionary = { TESTING: 2, TEST: 1, IS: 1, THIS: 1 }
    @counter = SyllableCounter.new(@dictionary)
    @finder = SenryuFinder.new(@counter)
    @array = ["testing", "test"]
  end

  it "should require a counter" do
    expect { SenryuFinder.new }.to raise_exception
  end

  it "should require an array for syl_sums" do
    expect { @finder.syl_sums }.to raise_exception
  end

  it "should return an array of syllable sums" do
    @finder.syl_sums(@array).should eq [2, 3]
  end

  it "should require an array for clean_breaks?" do
    expect { @finder.clean_breaks? }.to raise_exception
  end

  it "should return false if array doesn't include 5 & 12" do
    @finder.clean_breaks?([1, 3, 7, 9]).should eq false
  end

  it "should return true if array does include 5 & 12" do
    @finder.clean_breaks?([5, 12, 15]).should eq true
  end

  it "should require an array for count_each_word" do
    expect { @finder.count_each_word }.to raise_exception
  end

  it "should return an array of syllable counts for each word in array" do
    @finder.count_each_word(["this", "is", "testing"]).should eq [1, 1, 2]
  end

  it "should require an an array for print_results" do
    expect { @finder.print_results }.to raise_exception
  end

  it "should require an input array for find_blocks" do
    expect { @finder.find_blocks(2) }.to raise_exception
  end

  it "should require a block size for find_blocks" do
    expect { @finder.find_blocks(["testing"]) }.to raise_exception
  end

  it "should return blocks of a given size" do
    @finder.find_blocks(["testing", "test", "this"], 2).should eq [["testing"], ["test", "this"]]
  end

  it "should find a senryu from an input array" do
    text = ["nil", "testing", "test", "testing", "test", "this", "is", "testing", "testing", "testing", "testing", "test", "test"]
    @finder.find_senryu(text).should eq [["testing", "test", "testing", "test", "this", "is", "testing", "testing", "testing", "testing", "test"]]
  end

  it "should receive a string from the input array with print_results" do
    array = [["test", "this"]]
    @finder.should_receive(:puts).with("test this")
    @finder.print_results(array)
  end

end
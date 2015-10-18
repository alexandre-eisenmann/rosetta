#!/usr/bin/env ruby
# 
# ROSETTA 
# 
# Author: Alexandre Luis Kundrat Eisenmann
# Ruby version: 1.9.3p194
# 
# The program recognizes which language a given file was written.
# 
# My idea is identify the language using frequency analysis. Each natural language has a kind of 
# "frequency signature", so the set of frequencies of each letter characterizes a language. 
# Per example, the most common letter in english is "e" followed by "t" and "a". This is not true
# for other languages and is secure to say that all languages are different in that sense.
# 
# In order to capture the "language signature" for each language, the program will read the DATA 
# folder to calculate the frequency profile for the provided languages. After that, it calculates 
# the frequency of the input file as well. 
# 
# Finally, to determine which language is "closest" I defined the concept of "distance", which is similar to
# a vectorial distance, but in this case the "vector" has 26 dimensions, one for each letter.
# 
# Remarks:
# 
# 1) A folder called DATA containing the sample languages MUST be located in the root of the project
# 
# 2) The program can recognize an unlimited number of languages as long as one or more samples of
# this particular language were provided in the DATA folder. 
# 
# 3) The quality of recognition is proportional to the size of the file being verified. The longer, 
# the better. The reason is that very small files doesn't necessarily follow the statistical profile of 
# the language. That being said, the program, surprisingly, was able to recognize the languages of really 
# small files, containing just one phrase of 30 to 50 caracters
# 
# 4) To keep things simple all classes, tests, and command line code are keep in this unique file
#
# Usage:
# 
# ruby rosetta.rb <filePath> => identify which language <filePath> was written
# ruby rosetta.rb -runtests  => Run the tests
# ruby rosetta.rb -usage     => show this options
# 
# Example: 
# 
# > ruby rosetta.rb TEXT.txt 
# -------------------------------------------------------
# TEXT.txt was written in ENGLISH
# -------------------------------------------------------


# FrequencyMap is a immutable object that calculates 
# the frequency profile of a given string

class FrequencyMap

  #Initialize using a map from Character to Int {"A"=>3,"B"=>5,....}
  #See helper methods below  
  def initialize(map)
    @map = map
    @size = map.values.inject{|sum,x| sum + x }
  end
  
  #Helper static method that creates an empty frequency map
  def self.empty
    new(Hash.new(0))
  end
   
  #Helper static method that create an frequency map from a string 
  def self.from_string(content)
    map = Hash.new(0)
    content.upcase.each_char do |i|
      map[i] = map[i] + 1
    end
    new(map)
  end
  
  # Returns the expected frequency for a given letter
  def frequency(char) 
    return 0 if (@size.nil? || @size <= 0)
    @map[char.upcase] * 100/@size
  end
  
  # Calculates the distance between two frequency profiles.
  # The idea behind that is generalize the distance of vectors
  # of two dimensions to vectors of 26 dimensions, one for each
  # letter
  def distance(other) 
   ('A'..'Z').inject(0) { |acc, i| acc + (frequency(i) - other.frequency(i))**2}
  end

  #Combine 2 frequency maps adding each other and resulting an new FrequencyMap
  def +(other) 
     FrequencyMap.new(@map.merge(other.map){|key, first, second| first + second })
  end
  
  #Expose map to be used in the method above other.map
  #But being protected is still not accessed by other classes
  #so the class is immutable
  protected
  def map
    @map
  end
end

# This class is responsable for assembly all 
# data for a language in a single entry in a hash.
#
# E.g. Assuming files ENGLISH.1, ENGLISH.2, 
# PORTUGUESE.1, FRENCH.1, FRENCH.2 and FRENCH.3 in
# the DATA folder, FileAnalysis will create a hash
# with the following structure:
#
# key         value
# ENGLISH     frequency profile of ENGLISH.1 + frequency profile of ENGLISH.2
# PORTUGUESE  frequency profile of PORTUGUESE.1
# FRENCH      frequency profile of FRENCH.1 + frequency profile of FRENCH.2 +
#             frequency profile of FRENCH.3

class FileAnalysis
  def initialize(files)
    @freq = Hash.new(FrequencyMap.empty)
    files.each {|file| 
      key = File.basename( file, ".*" ).upcase
      #Note that this adding operation was overloaded, so 
      #the frequenciesMap are being added in the particular way defined in
      #FrequencyMap class
      @freq[key] = @freq[key] + FrequencyMap.from_string(File.read(file))
    }
  end

  # This method will calculate the "distance" from 
  # frequency signature of the given string to all
  # provided languages and finally pick the closest
  # language.
  def detect_language(text)
   fm = FrequencyMap.from_string(text)
   (@freq.sort_by {|key,value| fm.distance(value)})[0][0]
  end
  
end

# Comand line code
if __FILE__ == $0

  def usage()
    STDOUT.puts("Usage:")
    STDOUT.puts("ruby #{File.basename($0)} <filePath>")
    STDOUT.puts("ruby #{File.basename($0)} -runtests")
    STDOUT.puts("ruby #{File.basename($0)} -usage")
    exit(2)  
  end

  case ARGV[0]
  when "-runtests"
    # Tests
    require 'test/unit'
    class FrequencyMapTest  < Test::Unit::TestCase
      def test_frequency_of_chars
          fm = FrequencyMap.from_string "AABCCCDDDD"
          assert_equal(20, fm.frequency("A"),"Frequency of char A should be 20%")
          assert_equal(10, fm.frequency("B"),"Frequency of char B should be 10%")
          assert_equal(30, fm.frequency("C"),"Frequency of char C should be 30%")
          assert_equal(40, fm.frequency("D"),"Frequency of char D should be 40%")
          assert_equal(0 , fm.frequency("E"),"Frequency of char E should be 0%")
      end
    
      def test_distance_of_strings
          fm1 = FrequencyMap.from_string "AABCCCDDDD"
          fm2 = FrequencyMap.from_string "ABBBBBDDDE"
        
          assert_equal(0, fm1.distance(fm1),"Distance between 2 identical strings should be 0")
          assert_equal(fm2.distance(fm1), fm1.distance(fm2),"Distance should be equal regardless the order of parameters")
          assert_equal(2800, fm1.distance(fm2),"Distance should be equal to 10**2 + 40**2 + 30**2 + 10**2 + 10**2 = 2800")
      end
      
      def test_adding_frequency_maps
          fm1 = FrequencyMap.from_string "AABCCCDDDD"
          fm2 = FrequencyMap.from_string "ABBBBBDDDE"
          empty = FrequencyMap.empty

          fm = fm1 + fm2
          fm4 = fm + empty
          
          assert_equal(0 , empty.frequency("A"),"Frequency of char A in a empty object should be 0%")
        
          assert_equal(15, fm.frequency("A"),"Frequency of char A should be 15%")
          assert_equal(30, fm.frequency("B"),"Frequency of char B should be 30%")
          assert_equal(15, fm.frequency("C"),"Frequency of char C should be 15%")
          assert_equal(35, fm.frequency("D"),"Frequency of char D should be 35%")
          assert_equal(5 , fm.frequency("E"),"Frequency of char E should be 5%")
          assert_equal(0 , fm.frequency("F"),"Frequency of char F should be 0%")

          assert_equal(15, fm4.frequency("A"),"Frequency of char A should be 15%")
  
      end
      
    
    end
    class FileAnanlysisTest  < Test::Unit::TestCase
      def test_detect_language
          fa = FileAnalysis.new Dir["data/*"]
          assert_equal("SPANISH",fa.detect_language(File.read("test-spanish.txt")))
          assert_equal("PORTUGUESE",fa.detect_language(File.read("test-portuguese.txt")))
          assert_equal("GERMAN",fa.detect_language(File.read("test-german.txt")))
          assert_equal("ENGLISH",fa.detect_language(File.read("test-english.txt")))
          assert_equal("PORTUGUESE",fa.detect_language("Meu nome e Fabiana e eu gosto muito de comer chocolate"))
          assert_equal("ENGLISH",fa.detect_language("According to analysis,magpies do not form the monophyletic group they are traditionally believed to be a long tail has certainly elongated (or shortened) independently in multiple lineages of corvid birds. Among the traditional magpies, there appear to be two distinct lineages: one consists of Holarctic species with"))
          assert_equal("FRENCH",fa.detect_language("Marseille est en tete des villes francaises pour la grande criminalite. Au palais de justice, la permanence durgence du parquet traite les appels des commissariats. Immersion dans la tour de controle de la delinquance marseillaise"));
      end
    end
  when "-usage"
    usage()
  when nil
    usage()
  else
    fa = FileAnalysis.new Dir["data/*"]
    language = fa.detect_language File.read(ARGV[0])
    puts  '-------------------------------------------------------'
    puts "#{ARGV[0]} was written in #{language}"
    puts  '-------------------------------------------------------'
  end
end
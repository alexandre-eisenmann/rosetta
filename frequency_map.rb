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


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
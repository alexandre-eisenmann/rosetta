#!/usr/bin/env ruby

require './frequency_map'
require './file_analysis'

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
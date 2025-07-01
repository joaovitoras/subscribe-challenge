if ARGV.empty?
  puts <<~USAGE
    Usage:
    ruby main.rb input.txt [input-2.txt ...]
    ruby main.rb inputs/*
  USAGE

  exit
end

$LOAD_PATH.unshift("#{Dir.pwd}/lib")

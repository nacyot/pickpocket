# reload for pry
Dir[File.join(__dir__, "../lib/**/*.rb")].each {|file| load file }

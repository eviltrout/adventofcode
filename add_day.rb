#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'

if ARGV[0].nil?
  puts "You need to specify a year on the command line"
  exit
end

folder = ARGV[0].chomp.gsub(/\/$/, '')

Dir.mkdir(folder) unless File.exists?(folder)

# find last day

days = Dir["#{folder}/*.rb"].map { |f| File.basename(f).sub(/\.rb$/, '').sub(/day/, '').to_i }
next_day = (days.max || 0) + 1

new_file = "#{folder}/day#{next_day.to_s.rjust(2, "0")}"

# empty test input to be replaced
File.write("#{new_file}.input", "")
puts "Created #{new_file}.input"
FileUtils.cp("template.rb", "#{new_file}.rb")
puts "Created #{new_file}.rb"


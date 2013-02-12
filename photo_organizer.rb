#!/usr/bin/env ruby

require 'optparse'
require 'rubygems'
require 'mini_exiftool'
require 'awesome_print'

options = {}

optparse = OptionParser.new do|opts|
  opts.on('-h', '--help', 'Displays this help output') do
    puts opts
    exit
  end

  opts.on('-i', '--import PATH/TO/DIRECTORY', 'Path to a folder of images to be imported') do |input_path|
    options[:input_path] = input_path
  end

  opts.on('-d', '--destination PATH/TO/DIRECTORY', 'Path to the folder to output organized images') do |dest_path|
    options[:dest_path] = dest_path
  end
end

optparse.parse!

# Set somewhat reasonable defaults (for my workflow)
options[:input_path] ||= "#{File.expand_path('~')}/Pictures/tmp"
options[:dest_path]  ||= '/Volumes/Public/photos/database'

ap options

ap 'Welcome to Photo Organizer'

def skipped_format? filename
  # exclude '.' and '..'
  skipped_format = !(filename =~ /^\.+$/).nil?
  # exclude '*.mov' and '*.mp4' videos
  skipped_format ||= !(filename =~ /\.m(ov|p4)/).nil?
  skipped_format
end

Dir.chdir(options[:input_path])
Dir.open(Dir.pwd).each do |file_name|
  next if skipped_format?(file_name.to_s)
  ap "Processing: #{File.absolute_path(file_name)}"
  ap "File not found!" unless File.exist?(File.absolute_path(file_name))
  photo = MiniExiftool.new file_name

  ap photo.date_time_original
  ap photo
end

exit

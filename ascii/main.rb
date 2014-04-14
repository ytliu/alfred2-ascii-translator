#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems' unless defined? Gem # rubygems is only needed in 1.8
require "./bundle/bundler/setup"
require "alfred"

def show_chars(fb, result)
  fb.add_item({
    :uid      => "",
    :title    => "#{result}",
    :subtitle => "",
    :arg      => "",
    :valid    => "yes",
  })
end

special_ascii_bk = ['null', 'heading_start', 'text_start', 'text_end', 'transmission_end', 'enquiry', 'acknowledge', 'bell', 'backspace', 'horizontal_tab', 'new_line', 'vertical_tab', 'new_page', 'carriage_return', 'shift_out', 'shift_in', 'data_link_escape', 'device_control_1', 'device_control_2', 'device_control_3', 'device_control_4', 'negative_ack', 'synchronous_idle', 'block', 'cancel', 'medium_end', 'substitude', 'escape', 'file_separator', 'group_separator', 'record_separator', 'unit_separator']
special_ascii = ['NUL', 'SOH', 'STX', 'ETX', 'EOT', 'ENQ', 'ACK', 'BEL', 'BS', 'TAB', 'LF', 'VT', 'FF', 'CR', 'SO', 'SI', 'DLE', 'DC1', 'DC2', 'DC3', 'DC4', 'NAK', 'SYN', 'ETB', 'CAN', 'EM', 'SUB', 'ESC', 'FS', 'GS', 'RS', 'US']
special_ascii_7f = 'del'

Alfred.with_friendly_error do |alfred|
  alfred.with_rescue_feedback = true
  fb = alfred.feedback

  type = ARGV[0]

  if (type =~ /[d|h|c]/) == nil 
    raise Alfred::InvalidFormat, "Usage: ascii [d|h|c] args"
  end

  if type == 'd'
    query = ARGV[1..-1].map(&:to_i)
  elsif type == 'h'
    query = ARGV[1..-1].map(&:hex)
  else
    query = ARGV[1..-1].join(" ")
  end

  result = Array.new
  if type == 'c'
    result = query.bytes.map { |c| "0x#{c.to_s(16)}" }
  else
    query.each do |q|
      if q < 0x20
        result << special_ascii[q]
      elsif q == 0x7f
        result << special_ascii_7f
      elsif q < 0x7f
        result << q.chr
      else
        result << 'undefined'
      end
    end
  end
  
  for i in (0..result.size/10)
    show_chars(fb, result[i*10..[result.size-1, i*10+9].min].join(" ").strip)
  end
  puts fb.to_xml
end




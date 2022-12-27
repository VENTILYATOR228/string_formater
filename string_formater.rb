
require 'mysql2'

DB = Mysql2::Client.new(

)

@result = DB.query('SELECT candidate_office_name FROM hle_dev_test_viktor_solovei').to_a.map(&:values).flatten

def prepare_string(string)
  return 'NO DATA' if string == ""
  string.sub!(',/', '/') if string.scan(',/') != []
  string.upcase
end



def get_clean_office_name # clean_name
  @result.map do |position|
    @the_string = prepare_string(position)
    open_abbriviations
  end
end

def get_sentence # sentence
  get_clean_office_name.map do |position|
    "The candidate is running for the #{position} office."
  end
end 

def parce_position_name
  parts_of_office = split_position_name(@the_string)
  place_of_position = parts_of_office.pop
  parts_of_office.unshift(place_of_position)
end

def split_position_name(position_sample)
  position_sample.split('/')
end

def remove_duplications_and_format_case
  return parce_position_name[0].downcase! if parce_position_name.length == 1 
  position_with_duplication = parce_position_name.map { |part| part.downcase.split(' ') }
  position_with_duplication[1].shift if position_with_duplication[0].last == position_with_duplication[1].first
  position_with_duplication.first.map(&:capitalize!)
  position_with_duplication.map { |word| word.join(' ') }.join(' ')
end

def coma_formating
  unique_position_name = remove_duplications_and_format_case
  if unique_position_name.scan(',') == []
    unique_position_name
  else
    sentence_splited_by_coma = unique_position_name.split(', ')
    place_in_brackets = sentence_splited_by_coma[1].split(' ').map(&:capitalize!)
    "#{sentence_splited_by_coma[0]} (#{place_in_brackets.join(' ')})"
  end
end

def open_abbriviations
  open_abbr = coma_formating
  open_abbr.sub!('Twp', 'Township') || open_abbr.sub!('twp', 'Township') 
  open_abbr.sub!('Hwy', 'Highway') || open_abbr.sub!('hwy', 'Highway')
  open_abbr.sub!('.', '')
  open_abbr
end

###############

puts get_clean_office_name
'\n'
puts get_sentence

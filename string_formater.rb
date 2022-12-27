
def get_clean_office_name # clean_name
  open_abbriviations
end

def get_sentence # sentence
  "The candidate is running for the #{get_clean_office_name} office."
end

@the_string = 'Twp Committeeman/Wayne Twp'

def parce_position_name
  parts_of_office = split_position_name(@the_string)
  place_of_position = parts_of_office.pop
  parts_of_office.unshift(place_of_position)
end

def split_position_name(position_sample)
  position_sample.split('/')
end

def remove_duplications_and_format_case
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

p get_clean_office_name
'\n'
p get_sentence

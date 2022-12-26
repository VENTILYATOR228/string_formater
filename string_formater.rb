

# def get_string_from_db # по-хорошему это должно быть вынесено отдельнo (я не знаю, что должно здесь происходить)
#   @all_strings = SELECT candidate_office_name FROM hle_dev_test_viktor_solovei;
# end

@the_string = 'Twp Committeeman/Wayne Twp'

def parce_position_name
  parts_of_office = split_position_name(@the_string)
  place_of_position = parts_of_office.pop
  parts_of_office.unshift(place_of_position)
end

def split_position_name(position_sentence)
  position_sentence.split('/')
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
    place_in_breakits = sentence_splited_by_coma[1].split(' ').map(&:capitalize!)
    "#{sentence_splited_by_coma[0]} (#{place_in_breakits.join(' ')})"
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

def get_the_string # здесь я должен записать это значение в таблицу clean_name
  open_abbriviation
end

def get_full_string # а здесь в таблицу sentence
  "The candidate is running for the #{get_the_string} office."
end

p get_the_string
'\n'
p get_full_string

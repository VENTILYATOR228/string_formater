
require 'mysql2'

DB = Mysql2::Client.new(

)

def insert_data_into_table
  db_rows.each do |row|
    clean_name = get_clean_name(row.values.last)
    sentence = get_sentence(clean_name)
    update_row(row.values.first, clean_name, sentence)
  end
end

def db_rows
  DB.query('SELECT id, candidate_office_name FROM hle_dev_test_viktor_solovei').to_a
end

def update_row(row_id, clean_name, sentence)
  DB.query("UPDATE hle_dev_test_viktor_solovei SET clean_name = '#{clean_name}', sentence = '#{sentence}'  WHERE id = #{row_id}")
end


def prepare_string(string)
  return 'NO DATA' if string == ""
  string.sub!(',/', '/') if string.scan(',/') != []
  string.sub!("'", "\'\'") if string.scan("'") != []
  string.upcase
end

def get_clean_name(candidate_office_name) # clean_name
    @the_string = prepare_string(candidate_office_name)
    open_abbriviations
end

def get_sentence(clean_name) # sentence
  "The candidate is running for the #{clean_name} office."
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
  open_abbr.sub!('Township Township', 'Township') || open_abbr.sub!('Township township', 'Township')
  open_abbr.sub!('Hwy', 'Highway') || open_abbr.sub!('hwy', 'Highway')
  open_abbr.sub!('.', '')
  open_abbr
end

###############

p insert_data_into_table 

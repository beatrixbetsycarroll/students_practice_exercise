require 'csv'

#make a parser module

#print out all names alphabetical
#print out all names that start with one letter

#Release 0
module Parser
  class << self
    def parse(filename) #Release 0 a
      parsed_array = []
      CSV.foreach(filename, headers: true, :header_converters => :symbol) do |row|
        parsed_array << Student.new(row)
      end
      parsed_array
    end

    def first_name_array(filename) #Release 0 b
      student_names = []
      CSV.foreach(filename, headers: true, :header_converters => :symbol) do |row|
        student_names << row[:first_name]
      end
      student_names
    end

    def add_names_to_first_name_array(filename, *name)
      first_name_array(filename)
      names.each { student_names << name }
    end
  end
end

class View
  attr_accessor :first_name_array, :student_names, :student_object_array

  def initialize(filename)
    @filename = filename
    first_name_array
  end

  def parse
    @student_object_array = Parser.parse(@filename)
  end

  def first_name_array #Release 0 b
    parse
    @student_names = student_object_array.map do |student|
      student.first_name
    end
  end

  def add_names_to_first_name_array(*names) #Release 0 c
    first_name_array
    names.each { |name| student_names << name }
  end

  def alphabatize_names
    student_names.sort!
  end

  def number_names
    new_array = student_names.each_with_index {|name, i| name.insert(0, "#{i+1}. ")}
    student_names = new_array
  end

  def print_all_names #Release 0 d
    student_names.each { |name| puts name }
    first_name_array
  end

  def print_all_names_in_alph_order #Release 1 b
    alphabatize_names
    print_all_names
  end

  def print_all_names_numbered #Release 1 a
    number_names
    print_all_names
  end

  def print_all_names_numbered_and_alph
    alphabatize_names
    number_names
    print_all_names
  end

  def print_all_names_that_start_with(letter) #Release 1 C
    student_names.select! { |name| name.start_with?(letter) }
    print_all_names
  end

end


class Student #Release 2 b
  attr_reader :first_name

  def initialize(args)
    @id = args[:id]
    @first_name = args[:first_name]
    @last_name = args[:last_name]
    @email = args[:email]
    @phone = args[:phone]
    @grade = args[:grade]
    @cohort = args[:cohort]
  end
end


class School #Release 2 b
  attr_reader :students, :filename
  attr_accessor :view

  def initialize(filename)
    @filename = filename
    @view = View.new(filename)
  end

  def generate_students # Release 2 d
    @students = Parser.parse(@filename)
  end

  def alphabetically_list_student_names
    @view.print_all_names_in_alph_order
  end



end


school = School.new('students.csv')
# school.view
school.alphabetically_list_student_names





# p Parser.parse('students.csv')





# view = View.new('students.csv')
# puts "\nPRINT ALL NAMES"
# view.print_all_names
# puts "\nPRINT ALL NAMES IN ALPH"
# view.print_all_names_in_alph_order
# puts"\nPRINT ALL NAMES NUMBERED"
# view.print_all_names_numbered
# puts "\nPRINT ALL NAMES IN ALPH"
# view.print_all_names_in_alph_order
# puts "\nPRINT ALL NAMES IN ALPH AND NUMBERED"
# view.print_all_names_numbered_and_alph
# puts "\nPRINT ALL NAMES THAT START WITH"
# view.print_all_names_that_start_with('K')


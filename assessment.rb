require 'csv'
require 'faker'

module Parser
  class << self
    def parse(csv_file)
      student_info = []
      CSV.foreach(csv_file, headers: true, :header_converters => :symbol) do |row|
        student_info << Student.new(row)
      end
      student_info
    end

    def save(array_of_students, csv_file)
      CSV.open(csv_file, "wb", write_headers: true, headers: ["id", "first_name", "last_name", "email", "phone", "grade", "cohort"]) do |csv|
         array_of_students.each do |row|
          csv << [row.id, row.first_name, row.last_name, row.email, row.phone, row.grade, row.cohort]
        end
       end
    end
  end
end

module View
  class << self
    def print_numbered_student_list
      Parser.parse('students.csv').each do |student|
        puts "#{student.id}. #{student.first_name}"
      end
    end

    def print_alphabetical_student_list
      array = Parser.parse('students.csv').map {|student| student.first_name}
      puts array.sort
    end

    def print_names_starting_with(letter)
      Parser.parse('students.csv').each do |student|
        if student.first_name.start_with?(letter.upcase)
          puts student.first_name
        end
      end
    end

    def print_cohort_list
      Parser.parse('students.csv').each do |student|
        puts "#{student.cohort} - #{student.first_name}"
      end
    end
  end
end

class Student

  attr_reader :id, :first_name, :last_name, :email, :phone, :grade
  attr_accessor :cohort

  def initialize(args={})
    @id = args[:id]
    @first_name = args[:first_name]
    @last_name = args[:last_name]
    @email = args[:email]
    @phone = args[:phone]
    @grade = args[:grade]
    @cohort = args[:cohort]
  end
end

class School

  attr_reader :students

  def initialize
    @students = []
  end

  def populate_school
    @students = Parser.parse('students.csv')
  end

  def add_student(student_info={})
    student_info[:id] = (students.length + 1).to_s
    students << Student.new(student_info)
    assign_cohort
  end

  def updated_records(csv_file)
    Parser.save(students,csv_file)
  end

  def assign_cohort
    students.each do |student|
      if student.id.to_i.even?
        student.cohort = "Ospreys"
      else
        student.cohort = "Narwhals"
      end
    end
  end

end



neshaminy = School.new
p neshaminy.populate_school

# p Parser.parse('students.csv')
# View.print_numbered_student_list
# View.print_alphabetical_student_list
# View.print_names_starting_with('b')
p neshaminy.assign_cohort
View.print_cohort_list
puts "*" * 50
neshaminy.add_student({first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, phone: Faker::PhoneNumber.phone_number, grade: rand(50..100)})
p neshaminy.updated_records('students.csv')
p neshaminy.students




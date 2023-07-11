class CsvImportService
  require 'csv'

  def call(file)
    opened_file = File.open(file)
    csv = CSV.parse(opened_file)
    number_rows = csv[0].length
    # number_rows.times do
    #   p "passei aqui"
    # end 
    cvs.each_with_index do |value, index|
      next if index == 0
      header.each_with_index do |h, i|
        next if == 0
        Student.create!(date: value[0], name: h[i], report: value[i])
      end
    end
    
  end
  # CSV.foreach(opened_file) do |row|
    #   student_hash = {}
    #   student_hash[:name] = row
    #   student_hash[:report] = row
    #   student_hash[:date] = row
    #   Student.find_or_create_by!(student_hash)
    # end

    # binding.b

    # options = { headers: true }
    
    # CSV.foreach(opened_file, **options) do |row|
      
    #   student_hash = {}
    #   student_hash[:name] = row["nome"]
    #   student_hash[:report] = row["01/02"]
    #   student_hash[:date] = row[2]
    #   p '--------------------------'
    #   p row["nome"]
    #   p row["01/02"]
      # Student.find_or_create_by!(student_hash)
      # for performance, you could create a separate job to import each user
    
    
  
end
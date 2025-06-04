module ColorHelper
  require "digest"

  def color_for_student(student)
    hash = Digest::MD5.hexdigest(student.id.to_s)
    r = hash[0..1].hex / 2
    g = hash[2..3].hex / 2
    b = hash[4..5].hex / 2
    format("%02x%02x%02x", r, g, b)
  end

  def color_for_teacher(teacher)
    hash = Digest::MD5.hexdigest(teacher.id.to_s)
    r = 30 + (hash[0..1].hex % 180)  # entre 30 e 210
    g = 30 + (hash[2..3].hex % 180)
    b = 30 + (hash[4..5].hex % 180)
    format("%02x%02x%02x", r, g, b)
  end
end
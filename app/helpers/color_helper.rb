module ColorHelper
  require "digest"

  def color_for_student(student)
    hash = Digest::MD5.hexdigest(student.id.to_s)
    r = hash[0..1].hex / 2
    g = hash[2..3].hex / 2
    b = hash[4..5].hex / 2
    format("%02x%02x%02x", r, g, b)
  end
end
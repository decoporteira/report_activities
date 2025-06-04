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
    {
      1 => "#463663",
      2 => "#690480",
      3 => "#804B4B",
      4 => "#D91D00",
      5 => "#010A80",
      6 => "#047E00",
      7 => "#2E6B6B"
    }[teacher.id] || "#263300" # cor default para ids fora da lista
  end
end
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
      1 => "#196ea5",
      2 => "#cf3545",
      3 => "#f2b954",
      4 => "#5a0000",
      5 => "#0000b3",
      6 => "#047E00",
      7 => "#b37400"
    }[teacher.id] || "#787878" # cor default para ids fora da lista
  end
end
module MemberKeyHelper

  def decipher(char)
    ["z", "a", "d", "i", "p", "y", "j", "w", "l", "c"].each_with_index do |c, i|
      return i if char == c
    end
    0 #何も当てはまらなかったら0を返す
  end

end
module MemberKeyHelper

  def decipher(char)
    ["z", "a", "d", "i", "p", "y", "j", "w", "l", "c"].each_with_index do |c, i|
      return i if char == c
    end
    0 #何も当てはまらなかったら0を返す
  end

  def get_alphabet(n)
    n %= 26
    ("a".."z").to_a[n] || n.to_s
  end

end
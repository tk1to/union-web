module MemberKeyHelper

  def decipher(char)
    ["z", "a", "d", "i", "p", "y", "j", "w", "l", "c"].each_with_index do |c, i|
      return i if char == c
    end
    0 #何も当てはまらなかったら0を返す
  end
  def deciph(keys)
    decipher(keys[6])*1000 + decipher(keys[7])*100 + decipher(keys[2])*10 + decipher(keys[4])
  end

  def get_alphabet(n)
    n %= 26
    ("a".."z").to_a[n] || n.to_s
  end
  def get_dummy_alphabet
    be_dummy = true
    dummy = ""
    while be_dummy do
      dummy = get_alphabet(rand(26))
      be_dummy = false if decipher(dummy) == 0
    end
    dummy
  end

end

def publish_key_str(circle_id)
  key = ""
  for i in 0..8
    if i==2
      if circle_id.to_s[-2].nil?
        key += get_dummy_alphabet
      else
        key += get_alphabet((circle_id.to_s[-2].to_i ** 2) - 1)
      end
    elsif i==4
      if circle_id.to_s[-1].nil?
        key += get_dummy_alphabet
      else
        key += get_alphabet((circle_id.to_s[-1].to_i ** 2) - 1)
      end
    elsif i==6
      if circle_id.to_s[-4].nil?
        key += get_dummy_alphabet
      else
        key += get_alphabet((circle_id.to_s[-4].to_i ** 2) - 1)
      end
    elsif i==7
      if circle_id.to_s[-3].nil?
        key += get_dummy_alphabet
      else
        key += get_alphabet((circle_id.to_s[-3].to_i ** 2) - 1)
      end
    else
      key += get_alphabet(rand(26))
    end
  end
  key
end
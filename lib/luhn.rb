class Luhn
  def self.valid?(str)
    #strip spaces
    str.gsub!(/\s+/, "")
    #false if there are non digits and shorter than 1
    return false if !str.scan(/\D/).empty? || str.length <= 1
    #validate digits
    digits = str.split('').map(&:to_i)
    sum = 0
    digits.reverse.each_with_index do |n,i|
      sum += i.odd? ? (n*2 > 9 ? (n*2)-9 : n*2) : n
    end
    sum % 10 == 0
  end
end

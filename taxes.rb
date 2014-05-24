require 'csv'

class TaxRate
  attr_reader :first, :last, :income, :tax_paid, :tax_rate
  def initialize(first, last, income, tax_paid, tax_rate)
    @first = first
    @last = last
    @income = income
    @tax_paid = tax_paid
    @tax_rate = tax_rate
  end

  def separate_comma(number)
    number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
  end

  def convert
    tax_rate = @tax_rate.to_f / 100
    total_tax = income.to_i * tax_rate
    tax_return = tax_paid.to_i - total_tax
    tax_return = tax_return.to_i
  end

  def output
    if self.convert < 0
      owe = separate_comma(self.convert.abs)
      "#{@first} #{@last} owes $#{owe} in taxes"
    else
      owe = separate_comma(self.convert)
      "#{@first} #{@last} will receive a refund of $#{owe}"
    end
  end
end


CSV.foreach('taxes.csv', headers: true) do |row|
  taxee = TaxRate.new(row[0], row[1], row[2], row[3], row[4])
  puts taxee.output
end


class Item
  # parent class with some default values
  def initialize(quantity)
    @quantity = quantity || 0
  end

  def price
    raise "should be defined in subclass"
  end

  def sale_quantity
    # buy n items for `sale_price`
    0
  end

  def sale_price
    raise "should be defined in subclass"
  end

  def total_non_sale_cost
    (price * @quantity).round(2)
  end

  def total_cost
    return total_non_sale_cost unless sale_item?

    # sale items that get some kind of bogo pricing:
    sale_items_cost = (@quantity/sale_quantity) * sale_price
    # remaining items charged full price:
    non_sale_items_cost = (@quantity%sale_quantity) * price

    (sale_items_cost + non_sale_items_cost).round(2)
  end

  def total_savings
    total_non_sale_cost - total_cost
  end

  def sale_item?
    false
  end

  def formatted_item_string
    # output string as:
    # Item    Quantity   Cost
    # with a standardized spacing for each column
    columns = [8,10,8]
    # right_pad string to fit a given string width
    rp = ->(input, total_width) {
      string = input.to_s
      string + ' ' * (total_width - string.length)
    }
    rp.call(self.class.name, columns[0]) + rp.call(@quantity, columns[1]) + rp.call("$#{total_cost}", columns[2])
  end

end

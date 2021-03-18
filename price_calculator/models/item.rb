class Item
  # parent class with some default values
  def new(quantity)
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
    price * quantity
  end

  def total_cost
    return total_non_sale_cost unless sale_item?

    sale_items_cost = (@quantity/sale_quantity) * price
    non_sale_items_cost = (@quantity%sale_quantity) * price

    sale_items + non_sale_items
  end

  def total_savings
    total_non_sale_cost - total_cost
  end

  def sale_item?
    false
  end

  def self.subclasses
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

end

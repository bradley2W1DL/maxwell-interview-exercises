class Bread < Item

  def price
    2.17
  end

  def sale_item?
    true
  end

  def sale_price
    # BOGO_QUANTITY for:
    6.00
  end

  def sale_quantity
    3
  end

end

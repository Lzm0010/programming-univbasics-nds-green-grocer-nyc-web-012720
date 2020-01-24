def find_item_by_name_in_collection(name, collection)
  i = 0
  item_found = nil
  while i < collection.size do
    if collection[i][:item] == name
      item_found = collection[i]
    end
    i += 1
  end
  item_found
end

def consolidate_cart(cart)
  better_cart = []
  i = 0
  
  while i < cart.size do
    name = cart[i][:item]
    
    # find_item_by_name_in_collection will find truthy or falsey value (hash or nil)
    if find_item_by_name_in_collection(name, better_cart)
      current_item = find_item_by_name_in_collection(name, better_cart)
      current_item[:count] += 1
    else
      cart[i][:count] = 1
      better_cart << cart[i]
    end
    
    i += 1
  end
  better_cart
end

def apply_coupons(cart, coupons)
  coupon_idx = 0
  while coupon_idx < coupons.size do
    cart_item = find_item_by_name_in_collection(coupons[coupon_idx][:item], cart)
    coupon_item_name = "#{coupons[coupon_idx][:item]} W/COUPON"
    cart_item_with_coupon = find_item_by_name_in_collection(coupon_item_name, cart)
    if cart_item && cart_item[:count] >= coupons[coupon_idx][:num]
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += coupons[coupon_idx][:num]
        cart_item[:count] -= coupons[coupon_idx][:num]
      else
        cart_item_with_coupon = {
          :item => coupon_item_name,
          :price => coupons[coupon_idx][:cost] / coupons[coupon_idx][:num],
          :count => coupons[coupon_idx][:num],
          :clearance => cart_item[:clearance]
        }
        cart << cart_item_with_coupon
        cart_item[:count] -= coupons[coupon_idx][:num]
      end
    end
    coupon_idx += 1
  end
  cart
end

def apply_clearance(cart)
  i = 0
  while i < cart.size do 
    is_on_clearance = cart[i][:clearance]
    if is_on_clearance
      cart[i][:price] -= (cart[i][:price] * 0.20.round(3))
    end
    i += 1
  end
  cart
end

def checkout(cart, coupons)
  pp coupons
  consolidated_cart = consolidate_cart(cart)
  pp consolidated_cart
  cart_w_coups = apply_coupons(consolidated_cart, coupons)
  cart_w_coups_and_clear = apply_clearance(cart_w_coups)
  i = 0
  cart_total = 0
  while i < cart_w_coups_and_clear.size do
    cart_total += cart_w_coups_and_clear[i][:price] * cart_w_coups_and_clear[i][:count]
    i += 1
  end
  
  if cart_total > 100
    return cart_total * 0.90
  else
    return cart_total
  end
end

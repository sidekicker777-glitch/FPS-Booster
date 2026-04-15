-- Copy these entries into ox_inventory/data/items.lua
-- Use client.export to trigger consume animation via this resource.

return {
  burger = { label = 'Burger', weight = 200, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } },
  hotdog = { label = 'Hot Dog', weight = 180, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } },
  donut = { label = 'Donut', weight = 120, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } },
  chocolate = { label = 'Chocolate Bar', weight = 100, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } },
  sandwich = { label = 'Sandwich', weight = 180, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } },
  water = { label = 'Water', weight = 250, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } },
  soda = { label = 'Soda', weight = 220, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } },
  coffee = { label = 'Coffee', weight = 220, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } },
  kawaii_sushi = { label = 'Kawaii Sushi Plate', weight = 220, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } },
  cl_frappe = { label = 'CL Frappe', weight = 220, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } },
  cl_boba = { label = 'CL Boba', weight = 220, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } },
  cl_cupcake = { label = 'CL Cupcake', weight = 110, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } },
  cl_donut = { label = 'CL Donut', weight = 120, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } },
  cl_icecream = { label = 'CL Ice Cream', weight = 130, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } },
  cl_milkshake = { label = 'CL Milkshake', weight = 230, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } },
  cl_pizza = { label = 'CL Pizza Slice', weight = 190, stack = true, close = true, client = { export = 'FPS-Booster.consumeItem' } }
}

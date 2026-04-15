-- ESX items table seed for all consumables in config.lua
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('burger', 'Burger', 1, 0, 1),
('hotdog', 'Hot Dog', 1, 0, 1),
('donut', 'Donut', 1, 0, 1),
('chocolate', 'Chocolate Bar', 1, 0, 1),
('sandwich', 'Sandwich', 1, 0, 1),
('water', 'Water', 1, 0, 1),
('soda', 'Soda', 1, 0, 1),
('coffee', 'Coffee', 1, 0, 1),
('kawaii_sushi', 'Kawaii Sushi Plate', 1, 0, 1),
('cl_frappe', 'CL Frappe', 1, 0, 1),
('cl_boba', 'CL Boba', 1, 0, 1),
('cl_cupcake', 'CL Cupcake', 1, 0, 1),
('cl_donut', 'CL Donut', 1, 0, 1),
('cl_icecream', 'CL Ice Cream', 1, 0, 1),
('cl_milkshake', 'CL Milkshake', 1, 0, 1),
('cl_pizza', 'CL Pizza Slice', 1, 0, 1)
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `weight` = VALUES(`weight`), `can_remove` = VALUES(`can_remove`);

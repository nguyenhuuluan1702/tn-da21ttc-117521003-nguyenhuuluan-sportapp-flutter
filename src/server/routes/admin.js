const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const { Product } = require("../models/product");
const { PromiseProvider } = require("mongoose");
const Order = require("../models/order");

// Add product
adminRouter.post("/admin/add-product", admin, async (req, res) => {
  try {
    const { name, description, images, quantity, price, category } = req.body;
    let product = new Product({
      name,
      description,
      images,
      quantity,
      price,
      category,
    });
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Get all your products
adminRouter.get("/admin/get-products", admin, async (req, res) => {
  try {
    const products = await Product.find({});
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Delete the product
adminRouter.post("/admin/delete-product", admin, async (req, res) => {
  try {
    const { id } = req.body;
    let product = await Product.findByIdAndDelete(id);
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Update product
adminRouter.put("/admin/update-product/:id", admin, async (req, res) => {
  try {
    const { id } = req.params;
    const { name, description, images, quantity, price, category } = req.body;

    const updatedProduct = await Product.findByIdAndUpdate(
      id,
      {
        name,
        description,
        images,
        quantity,
        price,
        category,
      },
      { new: true } // Returns the updated document
    );

    if (!updatedProduct) {
      return res.status(404).json({ msg: "Không tìm thấy sản phẩm" });
    }

    res.json(updatedProduct);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.get("/admin/get-orders", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.post("/admin/change-order-status", admin, async (req, res) => {
  try {
    const { id, status } = req.body;
    let order = await Order.findById(id);
    order.status = status;
    order = await order.save();
    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.get("/admin/analytics", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    let totalEarnings = 0;

    for (let i = 0; i < orders.length; i++) {
      if (orders[i].status === 4) {
        for (let j = 0; j < orders[i].products.length; j++) {
          totalEarnings +=
            orders[i].products[j].quantity *
            orders[i].products[j].product.price;
        }
      }
    }

    let earnings = {
      totalEarnings,
      gymEquipmentEarnings: await fetchCategoryWiseProduct("Gym"),
      homeGymToolsEarnings: await fetchCategoryWiseProduct("Calisthenics"),
      yogaEarnings: await fetchCategoryWiseProduct("Yoga"),
      outdoorSportsToolsEarnings: await fetchCategoryWiseProduct("Sports"),
      relatedAccessoriesEarnings: await fetchCategoryWiseProduct("Accessories"),
    };

    res.json(earnings);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.post('/admin/cancel-order', admin, async (req, res) => {
  try {
    const { id } = req.body;
    const order = await Order.findById(id);
    
    if (!order) {
      return res.status(404).json({ msg: 'Không tìm thấy đơn hàng' });
    }
    
    if (order.status >= 2) {
      return res.status(400).json({ msg: 'Không thể hủy đơn hàng đã giao' });
    }
    
    order.status = 3; // Trạng thái hủy
    order.cancelledAt = new Date();
    await order.save();
    
    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

adminRouter.delete('/admin/delete-order/:id', admin, async (req, res) => {
  try {
    const { id } = req.params;
    const order = await Order.findById(id);
    
    if (!order) {
      return res.status(404).json({ msg: 'Không tìm thấy đơn hàng' });
    }

    // Kiểm tra cả status 3 (đã hủy) và 4 (đã giao)
    if (order.status === 3 || order.status === 4) {
      const message = order.status === 3 
        ? 'Không thể hủy đơn hàng đang giao'
        : 'Không thể hủy đơn hàng đã giao thành công';
      return res.status(400).json({ msg: message });
    }
    
    await Order.findByIdAndDelete(id);
    res.json({ msg: 'Đã hủy đơn hàng thành công' });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
})

async function fetchCategoryWiseProduct(category) {
  let earnings = 0;
  const orders = await Order.find({
    "products.product.category": category,
    status: 3,
  });

  for (let i = 0; i < orders.length; i++) {
    for (let j = 0; j < orders[i].products.length; j++) {
      if (orders[i].products[j].product.category === category) {
        earnings +=
          orders[i].products[j].quantity * orders[i].products[j].product.price;
      }
    }
  }

  return earnings;
}

module.exports = adminRouter;

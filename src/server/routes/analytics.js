const express = require('express');
const analyticsRouter = express.Router();
const auth = require('../middlewares/auth');
const admin = require('../middlewares/admin');
const Order = require('../models/order');
const Product = require('../models/product');
const User = require('../models/user');

// Get overview statistics
analyticsRouter.get('/admin/analytics/overview', auth, admin, async (req, res) => {
  try {
    const today = new Date();
    const startOfDay = new Date(today.setHours(0, 0, 0, 0));
    const startOfWeek = new Date(today.setDate(today.getDate() - today.getDay()));
    const startOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);

    // Get revenue data
    const dailyRevenue = await Order.aggregate([
      { $match: { createdAt: { $gte: startOfDay }, status: 'delivered' } },
      { $group: { _id: null, total: { $sum: '$totalPrice' } } }
    ]);

    const weeklyRevenue = await Order.aggregate([
      { $match: { createdAt: { $gte: startOfWeek }, status: 'delivered' } },
      { $group: { _id: null, total: { $sum: '$totalPrice' } } }
    ]);

    const monthlyRevenue = await Order.aggregate([
      { $match: { createdAt: { $gte: startOfMonth }, status: 'delivered' } },
      { $group: { _id: null, total: { $sum: '$totalPrice' } } }
    ]);

    // Get new orders count
    const newOrders = await Order.countDocuments({
      createdAt: { $gte: startOfDay }
    });

    // Get new customers count
    const newCustomers = await User.countDocuments({
      createdAt: { $gte: startOfDay }
    });

    // Get completion rate
    const totalOrders = await Order.countDocuments({});
    const completedOrders = await Order.countDocuments({ status: 'delivered' });
    const completionRate = (completedOrders / totalOrders) * 100;

    // Get product stats
    const totalProducts = await Product.countDocuments({});
    const lowStockProducts = await Product.countDocuments({ quantity: { $lt: 10 } });

    // Get category revenue
    const categoryRevenue = await Order.aggregate([
      { $match: { status: 'delivered' } },
      { $unwind: '$products' },
      {
        $lookup: {
          from: 'products',
          localField: 'products.product',
          foreignField: '_id',
          as: 'productDetails'
        }
      },
      { $unwind: '$productDetails' },
      {
        $group: {
          _id: '$productDetails.category',
          total: { $sum: { $multiply: ['$products.quantity', '$productDetails.price'] } }
        }
      }
    ]);

    // Get top products
    const topProducts = await Order.aggregate([
      { $match: { status: 'delivered' } },
      { $unwind: '$products' },
      {
        $group: {
          _id: '$products.product',
          soldQuantity: { $sum: '$products.quantity' },
          revenue: { $sum: { $multiply: ['$products.quantity', '$products.price'] } }
        }
      },
      { $sort: { revenue: -1 } },
      { $limit: 5 },
      {
        $lookup: {
          from: 'products',
          localField: '_id',
          foreignField: '_id',
          as: 'productDetails'
        }
      },
      { $unwind: '$productDetails' }
    ]);

    res.json({
      dailyRevenue: dailyRevenue[0]?.total || 0,
      weeklyRevenue: weeklyRevenue[0]?.total || 0,
      monthlyRevenue: monthlyRevenue[0]?.total || 0,
      newOrders,
      newCustomers,
      completionRate,
      totalProducts,
      lowStockProducts,
      categoryRevenue: Object.fromEntries(
        categoryRevenue.map(({ _id, total }) => [_id, total])
      ),
      topProducts: topProducts.map(product => ({
        id: product._id.toString(),
        name: product.productDetails.name,
        imageUrl: product.productDetails.images[0],
        price: product.productDetails.price,
        soldQuantity: product.soldQuantity,
        revenue: product.revenue
      }))
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = analyticsRouter;
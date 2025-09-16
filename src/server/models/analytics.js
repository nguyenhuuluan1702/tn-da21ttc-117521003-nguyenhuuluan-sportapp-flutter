const mongoose = require('mongoose');

const analyticsSchema = mongoose.Schema({
  date: {
    type: Date,
    required: true,
  },
  dailyRevenue: {
    type: Number,
    required: true,
    default: 0,
  },
  weeklyRevenue: {
    type: Number,
    required: true,
    default: 0,
  },
  monthlyRevenue: {
    type: Number,
    required: true,
    default: 0,
  },
  newOrders: {
    type: Number,
    required: true,
    default: 0,
  },
  newCustomers: {
    type: Number,
    required: true,
    default: 0,
  },
  completionRate: {
    type: Number,
    required: true,
    default: 0,
  },
  categoryRevenue: {
    type: Map,
    of: Number,
    default: new Map(),
  },
  topProducts: [{
    productId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Product',
      required: true,
    },
    soldQuantity: {
      type: Number,
      required: true,
      default: 0,
    },
    revenue: {
      type: Number,
      required: true,
      default: 0,
    }
  }],
}, {
  timestamps: true,
});

const Analytics = mongoose.model('Analytics', analyticsSchema);
module.exports = Analytics;
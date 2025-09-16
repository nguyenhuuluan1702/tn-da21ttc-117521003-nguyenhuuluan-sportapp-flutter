const express = require("express"); // Nhập module Express
const mongoose = require("mongoose");
const adminRouter = require("./routes/admin");
const authRouter = require("./routes/auth");
const cors = require("cors"); // Thêm dòng này
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");
const analyticsRouter = require('./routes/analytics');


const PORT = 3000; // Định nghĩa cổng
const app = express(); // Tạo ứng dụng Express
const DB = "Your db";


app.use(cors({
  origin: '*', // Cho phép tất cả các cổng
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// middleware
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);
app.use(analyticsRouter);

// Connections
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });


app.listen(PORT, "0.0.0.0", () => {
  // Khởi động server
  console.log(`connected at port ${PORT}`);
});

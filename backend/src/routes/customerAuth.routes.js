import express from "express";
import {
  registerCustomer,
  customerLogin,
  getCustomerProfile,
  updateCustomerPassword,
} from "../controllers/customerAuth.controller.js";
import customerAuthMiddleware from "../middlewares/customerAuthMiddleware.js";

const router = express.Router();

/**
 * @route   POST /api/customer-auth/register
 * @desc    Register a new customer account
 * @access  Public
 */
router.post("/register", registerCustomer);

/**
 * @route   POST /api/customer-auth/login
 * @desc    Login for customers using AccountId and Password
 * @access  Public
 */
router.post("/login", customerLogin);

/**
 * @route   GET /api/customer-auth/profile
 * @desc    Get logged-in customer profile
 * @access  Private (Customer)
 */
router.get("/profile", customerAuthMiddleware, getCustomerProfile);

/**
 * @route   PUT /api/customer-auth/update-password
 * @desc    Update customer password
 * @access  Private (Customer)
 */
router.put("/update-password", customerAuthMiddleware, updateCustomerPassword);

export default router;

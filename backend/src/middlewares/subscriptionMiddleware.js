import Company from '../models/Company.js';
import { tenantStorage } from './tenantSupport.js';

const checkSubscriptionValidity = async (req, res, next) => {
    try {
        // Super admins are exempt from subscription checks
        if (req.user && req.user.role === 'super_admin') {
            return next();
        }

        const companyId = tenantStorage.getStore();
        if (!companyId) {
            // If no company context but user is not super_admin, something is wrong
            // However, some public routes might not have company context. 
            // We'll let them pass if they aren't protected or let AuthMiddleware handle it.
            return next();
        }

        const company = await Company.findById(companyId);
        if (!company) {
            return res.status(404).json({ success: false, message: "Company not found" });
        }

        if (company.isBlocked) {
            return res.status(403).json({
                success: false,
                message: "ACCOUNT_BLOCKED"
            });
        }

        const today = new Date();
        const expiryDate = new Date(company.planExpiryDate);
        
        // Priority: Use gracePeriodEndDate if set in model, otherwise fallback to 7 days
        const graceEndDate = company.gracePeriodEndDate ? new Date(company.gracePeriodEndDate) : new Date(expiryDate);
        if (!company.gracePeriodEndDate) {
            graceEndDate.setDate(graceEndDate.getDate() + 7);
        }

        if (today > graceEndDate) {
            return res.status(403).json({
                success: false,
                message: "SUBSCRIPTION_EXPIRED"
            });
        }

        next();
    } catch (error) {
        console.error("Subscription Middleware Error:", error);
        res.status(500).json({ success: false, message: "Error checking subscription status" });
    }
};

export default checkSubscriptionValidity;

import Voucher from '../models/Voucher.model.js';
import Account from '../models/Account.js';
import mongoose from 'mongoose';

const updateAccountBalances = async (voucher, isDeletion = false) => {
    for (const row of voucher.rows) {
        if (!row.account && !row.accountId) continue;

        // Balance Impact Rule: Credit increases balance, Debit decreases it.
        // This is consistent with the ledger aggregation (Credit - Debit).
        const impact = (row.credit || 0) - (row.debit || 0);
        const finalImpact = isDeletion ? -impact : impact;

        if (finalImpact === 0) continue;

        const query = row.accountId 
            ? { _id: row.accountId } 
            : { Name: row.account };

        const account = await Account.findOne(query);
        if (account) {
            let currentAmount = account.CurrentBalance?.amount || 0;
            let newAmount = currentAmount + finalImpact;
            
            // Note: In this system, Dr/Cr type is also stored.
            // We'll update the type based on the sign of the new amount.
            // Assuming positive is Cr and negative is Dr (as per aggregation)
            // But let's check Account model defaults: { amount: 0, type: "Dr" }
            // If they use "Dr" for positive, then impact should be flipped.
            // HOWEVER, based on ledger.aggregation: balanceImpact = credit - debit.
            // Usually, Credit is positive for Liability/Income and negative for Assets.
            // But this is a simple "Statement" ledger where we just show Dr/Cr columns.
            
            await Account.updateOne(query, {
                $set: {
                    "CurrentBalance.amount": Math.abs(newAmount),
                    "CurrentBalance.type": newAmount >= 0 ? "Cr" : "Dr"
                }
            });
        }
    }
};

export const createVoucher = async (req, res) => {
    try {
        const voucher = new Voucher(req.body);
        await voucher.save();
        await updateAccountBalances(voucher);
        res.status(201).json({ success: true, data: voucher, message: 'Voucher created successfully' });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

export const getVouchers = async (req, res) => {
    try {
        const vouchers = await Voucher.find().sort({ createdAt: -1 });
        res.status(200).json({ success: true, data: vouchers });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

export const getVoucherById = async (req, res) => {
    try {
        const voucher = await Voucher.findById(req.params.id);
        if (!voucher) return res.status(404).json({ success: false, message: 'Voucher not found' });
        res.status(200).json({ success: true, data: voucher });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

export const updateVoucher = async (req, res) => {
    try {
        const oldVoucher = await Voucher.findById(req.params.id);
        if (!oldVoucher) return res.status(404).json({ success: false, message: 'Voucher not found' });
        
        // Reverse old impact
        await updateAccountBalances(oldVoucher, true);
        
        const voucher = await Voucher.findByIdAndUpdate(req.params.id, req.body, { new: true });
        
        // Apply new impact
        await updateAccountBalances(voucher);
        
        res.status(200).json({ success: true, data: voucher, message: 'Voucher updated successfully' });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

export const deleteVoucher = async (req, res) => {
    try {
        const voucher = await Voucher.findById(req.params.id);
        if (!voucher) return res.status(404).json({ success: false, message: 'Voucher not found' });
        
        // Reverse impact before deleting
        await updateAccountBalances(voucher, true);
        
        await Voucher.findByIdAndDelete(req.params.id);
        res.status(200).json({ success: true, message: 'Voucher deleted successfully' });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

export const getNextBillNo = async (req, res) => {
    try {
        const { recordType, billSeries } = req.query;
        // Find highest billNo for this series
        const lastVoucher = await Voucher.findOne({ recordType, billSeries }).sort({ createdAt: -1 });
        let nextBillNo = 1;
        if (lastVoucher && !isNaN(Number(lastVoucher.billNo))) {
            nextBillNo = Number(lastVoucher.billNo) + 1;
        }
        res.status(200).json({ success: true, nextBillNo });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};

import React, { useState, useEffect } from 'react';
import ApiClient from '../../ApiClient';
import { CreditCard, Calendar, Check, AlertTriangle, Search, Activity, Trash2, Clock, MapPin, Mail, Phone, ExternalLink } from 'lucide-react';
import toast from 'react-hot-toast';

const SubscriptionManagement = () => {
    const [companies, setCompanies] = useState([]);
    const [plans, setPlans] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [selectedCompany, setSelectedCompany] = useState(null);
    const [formData, setFormData] = useState({
        planId: '',
        billingCycle: 'monthly',
        startDate: new Date().toISOString().split('T')[0]
    });

    useEffect(() => {
        fetchData();
    }, []);

    const fetchData = async () => {
        try {
            const [companiesRes, plansRes] = await Promise.all([
                ApiClient.get('/super-admin/companies'),
                ApiClient.get('/super-admin/plans')
            ]);
            setCompanies(companiesRes.data);
            setPlans(plansRes.data);
        } catch (error) {
            toast.error("Failed to load subscription data");
        } finally {
            setLoading(false);
        }
    };

    const handleAssign = async (e) => {
        e.preventDefault();
        try {
            await ApiClient.post('/super-admin/assign-subscription', {
                companyId: selectedCompany._id,
                ...formData
            });
            toast.success("Subscription updated successfully!");
            setIsModalOpen(false);
            fetchData();
        } catch (error) {
            toast.error("Failed to assign subscription");
        }
    };

    const handleToggleBlock = async (companyId, currentStatus) => {
        if (!window.confirm(`Are you sure you want to ${currentStatus ? 'Unblock' : 'Block'} this company?`)) return;
        try {
            await ApiClient.patch(`/super-admin/companies/${companyId}/toggle-block`);
            toast.success(`Company ${currentStatus ? 'unblocked' : 'blocked'} successfully`);
            fetchData();
        } catch (error) {
            toast.error("Failed to toggle block status");
        }
    };

    const calculateDetailedStatus = (company) => {
        if (company.isBlocked) return 'blocked';
        
        const today = new Date();
        const expiryDate = new Date(company.planExpiryDate);
        if (!company.planExpiryDate) return 'trial';

        const graceEndDate = company.gracePeriodEndDate ? new Date(company.gracePeriodEndDate) : new Date(expiryDate);
        if (!company.gracePeriodEndDate) {
            graceEndDate.setDate(graceEndDate.getDate() + 7);
        }

        if (today <= expiryDate) return 'active';
        if (today > expiryDate && today <= graceEndDate) return 'grace_period';
        return 'expired';
    };

    const getStatusColor = (status) => {
        switch (status) {
            case 'active': return 'bg-emerald-100 text-emerald-700 border-emerald-200';
            case 'grace_period': return 'bg-amber-100 text-amber-700 border-amber-200';
            case 'expired': return 'bg-rose-100 text-rose-700 border-rose-200';
            case 'blocked': return 'bg-slate-900 text-white border-slate-900';
            case 'trial': return 'bg-blue-100 text-blue-700 border-blue-200';
            default: return 'bg-slate-100 text-slate-700 border-slate-200';
        }
    };

    const filteredCompanies = companies.filter(c => 
        c.name.toLowerCase().includes(searchTerm.toLowerCase()) || 
        c.email.toLowerCase().includes(searchTerm.toLowerCase())
    );

    return (
        <div className="space-y-6">
            <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h1 className="text-2xl font-bold text-slate-900">Subscription & Billing</h1>
                    <p className="text-slate-500 text-sm">Manage tenant lifecycle, billing cycles, and payment records.</p>
                </div>
            </div>

            <div className="bg-white rounded-2xl shadow-sm border border-slate-100 p-4">
                <div className="relative max-w-md mb-6">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
                    <input 
                        type="text" 
                        placeholder="Search tenants..." 
                        className="w-full pl-10 pr-4 py-2.5 rounded-xl border border-slate-200 focus:outline-none focus:border-indigo-500 transition-all"
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </div>

                <div className="overflow-x-auto">
                    <table className="w-full text-left">
                        <thead>
                            <tr className="border-b border-slate-50 text-slate-400 text-xs font-bold uppercase tracking-wider">
                                <th className="px-4 py-4">Company Details</th>
                                <th className="px-4 py-4">Current Plan</th>
                                <th className="px-4 py-4">Status</th>
                                <th className="px-4 py-4">Expiry Date</th>
                                <th className="px-4 py-4 text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-slate-50">
                            {loading ? (
                                <tr><td colSpan="5" className="text-center py-10 text-slate-400">Loading subscriptions...</td></tr>
                            ) : filteredCompanies.map(company => {
                                const status = calculateDetailedStatus(company);
                                return (
                                <tr key={company._id} className="hover:bg-slate-50 transition-colors group">
                                    <td className="px-4 py-4">
                                        <div className="flex items-center gap-3">
                                            <div className="w-10 h-10 bg-indigo-50 rounded-full flex items-center justify-center text-indigo-500">
                                                <Activity size={20} />
                                            </div>
                                            <div>
                                                <p className="font-bold text-slate-800">{company.name}</p>
                                                <p className="text-xs text-slate-400 font-medium">{company.email}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td className="px-4 py-4">
                                        <div className="flex flex-col gap-1">
                                            <span className="text-sm font-bold text-slate-700">{company.planId?.name || 'No Plan Active'}</span>
                                            <span className="text-[10px] text-slate-400 uppercase font-black">{company.billingCycle}</span>
                                        </div>
                                    </td>
                                    <td className="px-4 py-4">
                                        <span className={`px-2.5 py-1 rounded-full text-[10px] border font-black uppercase tracking-wider ${getStatusColor(status)}`}>
                                            {status.replace('_', ' ')}
                                        </span>
                                    </td>
                                    <td className="px-4 py-4">
                                        <div className="flex flex-col">
                                            <p className={`text-sm font-medium ${new Date(company.planExpiryDate) < new Date() ? 'text-rose-500' : 'text-slate-600'}`}>
                                                {company.planExpiryDate ? new Date(company.planExpiryDate).toLocaleDateString() : '--/--/----'}
                                            </p>
                                            {status === 'grace_period' && (
                                                <span className="text-[10px] text-amber-500 font-bold">GRACE PERIOD</span>
                                            )}
                                        </div>
                                    </td>
                                    <td className="px-4 py-4 text-right">
                                        <div className="flex items-center justify-end gap-2">
                                            <button 
                                                onClick={() => handleToggleBlock(company._id, company.isBlocked)}
                                                className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-bold transition-all border ${company.isBlocked ? 'bg-emerald-50 text-emerald-600 border-emerald-100 hover:bg-emerald-100' : 'bg-rose-50 text-rose-600 border-rose-100 hover:bg-rose-100'}`}
                                            >
                                                {company.isBlocked ? 'Unblock' : 'Block'}
                                            </button>
                                            <button 
                                                onClick={() => { setSelectedCompany(company); setIsModalOpen(true); }}
                                                className="inline-flex items-center gap-1.5 px-3 py-1.5 bg-indigo-50 text-indigo-600 hover:bg-indigo-100 rounded-lg text-xs font-bold transition-all border border-indigo-100"
                                            >
                                                <CreditCard size={14} />
                                                Manage
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                );
                            })}
                        </tbody>
                    </table>
                </div>
            </div>

            {/* Subscription Assign Modal */}
            {isModalOpen && (
                <div className="fixed inset-0 z-[1000] flex items-center justify-center p-4">
                    <div className="absolute inset-0 bg-slate-900/40 backdrop-blur-sm" onClick={() => setIsModalOpen(false)} />
                    <div className="bg-white rounded-3xl shadow-2xl w-full max-w-md relative z-10 overflow-hidden animate-in fade-in zoom-in duration-200">
                        <div className="p-8 border-b border-slate-50 bg-slate-50/50">
                            <h2 className="text-xl font-bold text-slate-900">Manage Subscription</h2>
                            <p className="text-slate-500 text-sm">{selectedCompany?.name}</p>
                        </div>
                        <form onSubmit={handleAssign} className="p-8 space-y-6">
                            <div>
                                <label className="block text-sm font-bold text-slate-700 mb-2">Select Plan</label>
                                <select 
                                    className="w-full px-4 py-3 bg-slate-50 border border-slate-100 rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none font-medium"
                                    value={formData.planId}
                                    onChange={e => setFormData({...formData, planId: e.target.value})}
                                    required
                                >
                                    <option value="">-- Choose a Plan --</option>
                                    {plans.map(p => (
                                        <option key={p._id} value={p._id}>{p.name}</option>
                                    ))}
                                </select>
                            </div>

                            <div>
                                <label className="block text-sm font-bold text-slate-700 mb-2">Billing Cycle</label>
                                <div className="grid grid-cols-3 gap-2">
                                    {['monthly', 'quarterly', 'yearly'].map(cycle => (
                                        <button 
                                            key={cycle}
                                            type="button"
                                            onClick={() => setFormData({...formData, billingCycle: cycle})}
                                            className={`py-2 text-[10px] uppercase font-black rounded-lg border transition-all ${formData.billingCycle === cycle ? 'bg-indigo-600 text-white border-indigo-600' : 'bg-white text-slate-400 border-slate-100 hover:border-indigo-200'}`}
                                        >
                                            {cycle}
                                        </button>
                                    ))}
                                </div>
                            </div>

                            <div>
                                <label className="block text-sm font-bold text-slate-700 mb-2">Subscription Start Date</label>
                                <input 
                                    type="date"
                                    className="w-full px-4 py-3 bg-slate-50 border border-slate-100 rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none font-medium"
                                    value={formData.startDate}
                                    onChange={e => setFormData({...formData, startDate: e.target.value})}
                                    required
                                />
                            </div>

                            <div className="bg-amber-50 p-4 rounded-2xl flex gap-3 text-amber-700">
                                <AlertTriangle className="flex-shrink-0" size={18} />
                                <div className="text-xs">
                                    Assigning a new subscription will automatically calculate the expiry date and record a payment entry in billing history.
                                </div>
                            </div>

                            <div className="flex gap-3 pt-2">
                                <button type="button" onClick={() => setIsModalOpen(false)} className="flex-1 py-3 text-slate-500 font-bold hover:bg-slate-50 rounded-xl transition-colors">Cancel</button>
                                <button type="submit" className="flex-1 bg-emerald-600 text-white py-3 rounded-xl font-bold shadow-emerald-100 shadow-xl hover:bg-emerald-700 transition-all">Assign & Activate</button>
                            </div>
                        </form>
                    </div>
                </div>
            )}
        </div>
    );
};

export default SubscriptionManagement;

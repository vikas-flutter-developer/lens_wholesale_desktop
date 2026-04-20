import React, { useState, useEffect, useMemo, useRef } from 'react';
import {
    Search,
    RotateCcw,
    FileSpreadsheet,
    Printer,
    ChevronDown,
    Filter,
    BarChart3,
    Package,
    Table,
    PieChart,
    Check,
    X,
} from 'lucide-react';
import { getLensStockReport } from '../controllers/Reports.controller';
import { getAllGroups } from '../controllers/groupcontroller';
import { getAllItems } from '../controllers/itemcontroller';
import { getPowerRangeLibrary } from '../controllers/LensGroupCreationController';
import toast from 'react-hot-toast';

// Custom Multi-Select Dropdown Component
const MultiSelectDropdown = ({ options, selectedValues, onChange, label, placeholder, loading }) => {
    const [isOpen, setIsOpen] = useState(false);
    const [searchTerm, setSearchTerm] = useState('');
    const dropdownRef = useRef(null);

    useEffect(() => {
        const handleClickOutside = (event) => {
            if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
                setIsOpen(false);
            }
        };
        document.addEventListener('mousedown', handleClickOutside);
        return () => document.removeEventListener('mousedown', handleClickOutside);
    }, []);

    const filteredOptions = useMemo(() => {
        if (!searchTerm) return options;
        return options.filter(opt =>
            opt.label.toLowerCase().includes(searchTerm.toLowerCase())
        );
    }, [options, searchTerm]);

    const handleToggle = (value) => {
        const newSelected = selectedValues.includes(value)
            ? selectedValues.filter(v => v !== value)
            : [...selectedValues, value];
        onChange(newSelected);
    };

    const handleSelectAll = (e) => {
        e.stopPropagation();
        if (selectedValues.length === options.length) {
            onChange([]);
        } else {
            onChange(options.map(opt => opt.value));
        }
    };

    return (
        <div className="relative" ref={dropdownRef}>
            <label className="block text-xs font-semibold text-slate-500 mb-1 uppercase tracking-wider">{label}</label>
            <div
                onClick={() => !loading && setIsOpen(!isOpen)}
                className={`w-full px-3 py-2 border rounded-lg flex items-center justify-between cursor-pointer transition text-sm min-h-[40px] ${isOpen ? 'ring-2 ring-blue-500 border-blue-500' : 'border-slate-300 bg-white hover:border-blue-400'
                    } ${loading ? 'opacity-60 cursor-not-allowed' : ''}`}
            >
                <div className="flex flex-wrap gap-1 max-w-[90%] overflow-hidden overflow-ellipsis whitespace-nowrap">
                    {selectedValues.length === 0 ? (
                        <span className="text-slate-400">{loading ? 'Loading...' : placeholder}</span>
                    ) : selectedValues.length === options.length ? (
                        <span className="text-blue-600 font-semibold italic">All Selected</span>
                    ) : (
                        <span className="text-blue-700 font-medium">
                            {selectedValues.length} {selectedValues.length === 1 ? 'item' : 'items'} selected
                        </span>
                    )}
                </div>
                <ChevronDown className={`w-4 h-4 text-slate-400 transition-transform ${isOpen ? 'rotate-180' : ''}`} />
            </div>

            {isOpen && (
                <div className="absolute z-[100] mt-1 w-full bg-white border border-slate-200 rounded-xl shadow-xl overflow-hidden animate-in fade-in zoom-in duration-200">
                    <div className="p-2 border-b border-slate-100 bg-slate-50 space-y-2">
                        <div className="relative">
                            <Search className="absolute left-2.5 top-2.5 w-4 h-4 text-slate-400" />
                            <input
                                type="text"
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                                className="w-full pl-9 pr-3 py-1.5 text-sm border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none"
                                placeholder="Search..."
                                onClick={(e) => e.stopPropagation()}
                            />
                        </div>
                        <div className="flex items-center justify-between px-1">
                            <button
                                onClick={handleSelectAll}
                                className="text-[10px] uppercase tracking-wider font-bold text-blue-600 hover:text-blue-800 transition"
                            >
                                {selectedValues.length === options.length ? 'Unselect All' : 'Select All'}
                            </button>
                            <span className="text-[10px] text-slate-400 font-medium">{filteredOptions.length} options</span>
                        </div>
                    </div>
                    <div className="max-h-[250px] overflow-y-auto py-1 custom-scrollbar">
                        {filteredOptions.length === 0 ? (
                            <div className="px-4 py-3 text-sm text-slate-400 italic text-center">No matches found</div>
                        ) : (
                            filteredOptions.map((opt) => (
                                <div
                                    key={opt.value}
                                    onClick={(e) => {
                                        e.stopPropagation();
                                        handleToggle(opt.value);
                                    }}
                                    className="px-4 py-2 hover:bg-blue-50 cursor-pointer flex items-center justify-between group transition-colors"
                                >
                                    <span className={`text-sm ${selectedValues.includes(opt.value) ? 'text-blue-700 font-semibold' : 'text-slate-600'}`}>
                                        {opt.label}
                                    </span>
                                    {selectedValues.includes(opt.value) ? (
                                        <div className="w-4 h-4 bg-blue-600 rounded flex items-center justify-center">
                                            <Check className="w-3 h-3 text-white" />
                                        </div>
                                    ) : (
                                        <div className="w-4 h-4 border border-slate-300 rounded group-hover:border-blue-400 transition" />
                                    )}
                                </div>
                            ))
                        )}
                    </div>
                </div>
            )}
        </div>
    );
};

export default function LensStockReport() {
    const [reportData, setReportData] = useState([]);
    const [loading, setLoading] = useState(false);
    const [groups, setGroups] = useState([]);
    const [items, setItems] = useState([]);
    const [libraryRanges, setLibraryRanges] = useState([]);
    const [loadingLibrary, setLoadingLibrary] = useState(false);

    const [activeTab, setActiveTab] = useState('summary'); // 'summary', 'detail', 'eye'
    const [viewMode, setViewMode] = useState('report'); // 'report', 'analysis'
    const [pagination, setPagination] = useState({
        total: 0,
        currentPage: 1,
        limit: 50,
        totals: { stockTotal: 0, purValueTotal: 0, saleValueTotal: 0 }
    });

    const [filters, setFilters] = useState({
        groupName: '',
        productName: '',
        itemIds: [], // New Multi-select
        powerGroupIds: [], // New Multi-select
        barcode: '',
        boxNo: '',
        eye: 'All',
        showQty: 'All',
        orderByAdd: false,
        showEye: true
    });

    useEffect(() => {
        fetchInitialData();
        handleSearch(); // Initial fetch
    }, []);

    // Task 4: Fetch library ranges when groupName changes
    useEffect(() => {
        if (filters.groupName) {
            fetchLibrary(filters.groupName);
        } else {
            setLibraryRanges([]);
            handleFilterChange('powerGroupIds', []);
        }
    }, [filters.groupName]);

    const fetchLibrary = async (gName) => {
        try {
            setLoadingLibrary(true);
            const res = await getPowerRangeLibrary(gName);
            if (res && Array.isArray(res)) {
                setLibraryRanges(res);
            } else if (res && res.success && Array.isArray(res.data)) {
                setLibraryRanges(res.data);
            } else {
                setLibraryRanges([]);
            }
        } catch (error) {
            console.error('Error fetching library:', error);
            setLibraryRanges([]);
        } finally {
            setLoadingLibrary(false);
        }
    };

    const fetchInitialData = async () => {
        try {
            const groupRes = await getAllGroups();
            const groupsList = groupRes.groups || groupRes.data?.groups || [];
            setGroups(groupsList);

            const itemRes = await getAllItems();
            let itemsList = [];
            if (itemRes.items && Array.isArray(itemRes.items)) {
                itemsList = itemRes.items;
            } else if (itemRes.data && Array.isArray(itemRes.data)) {
                itemsList = itemRes.data;
            } else if (itemRes.data?.items && Array.isArray(itemRes.data.items)) {
                itemsList = itemRes.data.items;
            } else if (Array.isArray(itemRes)) {
                itemsList = itemRes;
            }

            setItems(itemsList);
        } catch (error) {
            toast.error('Failed to load initial data');
            setItems([]);
        }
    };

    const handleFilterChange = (field, value) => {
        setFilters(prev => ({ ...prev, [field]: value }));
    };

    const handleSearch = async (page = 1, limit = pagination.limit) => {
        try {
            setLoading(true);
            // Task 6: Pass itemIds and powerGroupIds in payload
            const res = await getLensStockReport({ ...filters, page, limit });
            if (res.success) {
                setReportData(res.data);
                setPagination(prev => ({
                    ...prev,
                    total: res.total || res.data.length,
                    currentPage: res.page || page,
                    limit: res.limit || limit,
                    totals: res.totals || prev.totals
                }));
            }
        } catch (error) {
            toast.error('Failed to fetch report data');
        } finally {
            setLoading(false);
        }
    };

    const handleReset = () => {
        setFilters({
            groupName: '',
            productName: '',
            itemIds: [],
            powerGroupIds: [],
            barcode: '',
            boxNo: '',
            eye: 'All',
            showQty: 'All',
            orderByAdd: false,
            showEye: true
        });
        setLibraryRanges([]);
    };

    const handleExport = () => {
        toast.success('Exporting to Excel...');
    };

    const handlePrint = () => {
        window.print();
    };

    // Item options for multi-select
    const itemOptions = useMemo(() => {
        return items.map(item => ({
            label: item.itemName || item.name,
            value: item._id || item.id,
            group: item.groupName || item.group || ''
        }));
    }, [items]);

    // Power Group options
    const powerGroupOptions = useMemo(() => {
        return libraryRanges.map(pg => ({
            label: pg.label || `SPH(${pg.sphMin},${pg.sphMax}) | CYL(${pg.cylMin},${pg.cylMax}) | ADD(${pg.addMin},${pg.addMax})`,
            value: pg._id
        }));
    }, [libraryRanges]);

    return (
        <div className="min-h-screen bg-slate-50 p-4 md:p-6 print:p-0">
            <div className="max-w-[1600px] mx-auto">
                {/* Header */}
                <div className="mb-6 flex flex-col md:flex-row items-center justify-between gap-4 print:hidden bg-gradient-to-r from-blue-600 to-blue-700 rounded-xl px-6 py-4 shadow-md">
                    <div>
                        <h1 className="text-2xl font-bold text-white flex items-center gap-3">
                            <BarChart3 className="w-8 h-8" />
                            Lens Stock Report
                        </h1>
                        <p className="text-blue-100 text-sm mt-1">📊 Combined View With & Without Barcode Data</p>
                    </div>

                    {/* View Toggle */}
                    <div className="flex bg-blue-800/30 p-1 rounded-lg border border-blue-400/30 backdrop-blur-sm">
                        <button
                            onClick={() => setViewMode('report')}
                            className={`flex items-center gap-2 px-4 py-2 rounded-md transition font-medium text-sm ${viewMode === 'report'
                                ? 'bg-white text-blue-700 shadow-sm'
                                : 'text-blue-100 hover:bg-white/10'
                                }`}
                        >
                            <Table className="w-4 h-4" />
                            Stock Details
                        </button>
                        <button
                            onClick={() => setViewMode('analysis')}
                            className={`flex items-center gap-2 px-4 py-2 rounded-md transition font-medium text-sm ${viewMode === 'analysis'
                                ? 'bg-white text-blue-700 shadow-sm'
                                : 'text-blue-100 hover:bg-white/10'
                                }`}
                        >
                            <PieChart className="w-4 h-4" />
                            Analysis & Summary
                        </button>
                    </div>

                    <div className="flex gap-2">
                        <button
                            onClick={handleExport}
                            className="flex items-center gap-2 px-4 py-2 bg-emerald-500 text-white rounded-lg hover:bg-emerald-600 transition shadow-md font-semibold"
                        >
                            <FileSpreadsheet className="w-4 h-4" />
                            Excel
                        </button>
                        <button
                            onClick={handlePrint}
                            className="flex items-center gap-2 px-4 py-2 bg-white text-blue-600 rounded-lg hover:bg-blue-50 transition shadow-md font-semibold"
                        >
                            <Printer className="w-4 h-4" />
                            Print
                        </button>
                    </div>
                </div>

                {/* Filters Grid */}
                <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6 mb-6 print:hidden">
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 xl:grid-cols-6 gap-4 items-end">
                        {/* Group Name */}
                        <div>
                            <label className="block text-xs font-semibold text-slate-500 mb-1 uppercase tracking-wider">Group Name</label>
                            <input
                                type="text"
                                value={filters.groupName}
                                onChange={(e) => handleFilterChange('groupName', e.target.value)}
                                className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-sm"
                                placeholder="Search Group..."
                            />
                        </div>

                        {/* Task 1: Multi-Select Item Name */}
                        <div className="lg:col-span-2">
                            <MultiSelectDropdown
                                label={`Item Name ${items?.length ? `(${items.length})` : ''}`}
                                options={itemOptions}
                                selectedValues={filters.itemIds}
                                onChange={(val) => {
                                    handleFilterChange('itemIds', val);
                                    // Auto-fill group if only one item selected and group matches
                                    if (val.length === 1) {
                                        const selectedId = val[0];
                                        const item = itemOptions.find(opt => opt.value === selectedId);
                                        if (item && item.group && !filters.groupName) {
                                            handleFilterChange('groupName', item.group);
                                        }
                                    }
                                }}
                                placeholder="-- Select Items --"
                                loading={items.length === 0}
                            />
                        </div>

                        {/* Task 3 & 4: Power Group Filter */}
                        <div className="lg:col-span-2">
                            <MultiSelectDropdown
                                label="Power Group"
                                options={powerGroupOptions}
                                selectedValues={filters.powerGroupIds}
                                onChange={(val) => handleFilterChange('powerGroupIds', val)}
                                placeholder={filters.groupName ? "-- Select Power Groups --" : "Select Group first..."}
                                loading={loadingLibrary}
                            />
                        </div>

                        {/* Box No */}
                        <div>
                            <label className="block text-xs font-semibold text-slate-500 mb-1 uppercase tracking-wider">Box No</label>
                            <input
                                type="text"
                                value={filters.boxNo}
                                onChange={(e) => handleFilterChange('boxNo', e.target.value)}
                                className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-sm"
                                placeholder="Box No..."
                            />
                        </div>

                        {/* Barcode */}
                        <div>
                            <label className="block text-xs font-semibold text-slate-500 mb-1 uppercase tracking-wider">Barcode</label>
                            <input
                                type="text"
                                value={filters.barcode}
                                onChange={(e) => handleFilterChange('barcode', e.target.value)}
                                className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-sm"
                                placeholder="Scan or Type..."
                            />
                        </div>

                        {/* Show Qty */}
                        <div>
                            <label className="block text-xs font-semibold text-slate-500 mb-1 uppercase tracking-wider">Show Qty</label>
                            <select
                                value={filters.showQty}
                                onChange={(e) => handleFilterChange('showQty', e.target.value)}
                                className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-sm bg-white"
                            >
                                <option value="All">All Items</option>
                                <option value="Positive">Positive (&gt;0)</option>
                                <option value="Negative">Negative (&lt;0)</option>
                                <option value="Zero">Zero (=0)</option>
                            </select>
                        </div>

                        {/* EYE */}
                        <div>
                            <label className="block text-xs font-semibold text-slate-500 mb-1 uppercase tracking-wider">EYE</label>
                            <select
                                value={filters.eye}
                                onChange={(e) => handleFilterChange('eye', e.target.value)}
                                className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition text-sm bg-white"
                            >
                                <option value="All">All</option>
                                <option value="R">Right</option>
                                <option value="L">Left</option>
                            </select>
                        </div>

                        {/* Checkboxes */}
                        <div className="flex items-center gap-4 xl:col-span-2 py-2">
                            <label className="flex items-center gap-2 cursor-pointer group">
                                <input
                                    type="checkbox"
                                    checked={filters.orderByAdd}
                                    onChange={(e) => handleFilterChange('orderByAdd', e.target.checked)}
                                    className="w-4 h-4 text-blue-600 rounded focus:ring-blue-500 cursor-pointer"
                                />
                                <span className="text-sm font-medium text-slate-600 group-hover:text-slate-800 transition">Order by Add</span>
                            </label>
                            <label className="flex items-center gap-2 cursor-pointer group">
                                <input
                                    type="checkbox"
                                    checked={filters.showEye}
                                    onChange={(e) => handleFilterChange('showEye', e.target.checked)}
                                    className="w-4 h-4 text-blue-600 rounded focus:ring-blue-500 cursor-pointer"
                                />
                                <span className="text-sm font-medium text-slate-600 group-hover:text-slate-800 transition">Show Eye</span>
                            </label>
                        </div>

                        {/* Buttons */}
                        <div className="flex gap-2 lg:col-span-2 xl:col-span-1">
                            <button
                                onClick={() => handleSearch(1)}
                                disabled={loading}
                                className="flex-1 bg-blue-600 text-white rounded-lg py-2.5 font-bold hover:bg-blue-700 transition flex items-center justify-center gap-2 shadow-lg disabled:bg-blue-400 active:scale-95"
                            >
                                {loading ? <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin"></div> : <Search className="w-5 h-5" />}
                                Search
                            </button>
                            <button
                                onClick={handleReset}
                                className="p-2.5 bg-slate-100 text-slate-600 rounded-lg hover:bg-slate-200 transition border border-slate-300 shadow-sm active:scale-90"
                                title="Reset Filters"
                            >
                                <RotateCcw className="w-5 h-5" />
                            </button>
                        </div>
                    </div>
                </div>

                {/* Results Table */}
                {viewMode === 'report' && (
                    <div className="bg-white rounded-xl shadow-md border border-slate-200 overflow-hidden print:shadow-none print:border-none">
                        <div className="overflow-x-auto">
                            <table className="w-full text-sm text-left border-collapse">
                                <thead className="sticky top-0 z-10">
                                    <tr className="bg-blue-600 text-white text-xs uppercase tracking-wider font-bold">
                                        <th rowSpan="2" className="px-4 py-3 border-r border-blue-500 text-center">S No.</th>
                                        <th rowSpan="2" className="px-4 py-3 border-r border-blue-500">Lens Name</th>
                                        <th rowSpan="2" className="px-4 py-3 border-r border-blue-500">Group Name</th>
                                        <th colSpan="5" className="px-4 py-2 border-r border-blue-500 text-center border-b border-blue-500">Lense Configuration</th>
                                        <th rowSpan="2" className="px-4 py-3 border-r border-blue-500 text-center">B.Code</th>
                                        <th rowSpan="2" className="px-4 py-3 border-r border-blue-500 text-center">Verified</th>
                                        <th colSpan="5" className="px-4 py-2 border-r border-blue-500 text-center border-b border-blue-500">Quantity</th>
                                        <th colSpan="2" className="px-4 py-2 border-r border-blue-500 text-center border-b border-blue-500">Price</th>
                                        <th colSpan="2" className="px-4 py-2 text-center border-b border-blue-500">Amount</th>
                                    </tr>
                                    <tr className="bg-blue-500 text-white text-[10px] uppercase tracking-tighter">
                                        <th className="px-2 py-1 border-r border-blue-400 text-center">SPH</th>
                                        <th className="px-2 py-1 border-r border-blue-400 text-center">CYL</th>
                                        <th className="px-2 py-1 border-r border-blue-400 text-center">Axis</th>
                                        <th className="px-2 py-1 border-r border-blue-400 text-center">ADD</th>
                                        <th className="px-2 py-1 border-r border-blue-400 text-center">EYE</th>
                                        <th className="px-2 py-1 border-r border-blue-400 text-center">Alert</th>
                                        <th className="px-2 py-1 border-r border-blue-400 text-center">Excess Qty</th>
                                        <th className="px-2 py-1 border-r border-blue-400 text-center">Stock</th>
                                        <th className="px-2 py-1 border-r border-blue-400 text-center">Min</th>
                                        <th className="px-2 py-1 border-r border-blue-400 text-center">Max</th>
                                        <th className="px-2 py-1 border-r border-blue-400 text-right">Pur Price</th>
                                        <th className="px-2 py-1 border-r border-blue-400 text-right">Sale Price</th>
                                        <th className="px-2 py-1 border-r border-blue-400 text-right">Ttl Amt(P)</th>
                                        <th className="px-2 py-1 text-right">Ttl Amt(S)</th>
                                    </tr>
                                </thead>
                                <tbody className="divide-y divide-slate-100 italic font-medium">
                                    {reportData.length === 0 ? (
                                        <tr>
                                            <td colSpan="18" className="px-6 py-10 text-center text-slate-400 bg-slate-50 italic">
                                                <div className="flex flex-col items-center gap-2">
                                                    <Package className="w-12 h-12 text-slate-300" />
                                                    <span className="text-lg">No records found</span>
                                                    <span className="text-xs">Adjust your filters to see results</span>
                                                </div>
                                            </td>
                                        </tr>
                                    ) : (
                                        reportData.map((row, index) => (
                                            <tr key={index} className="hover:bg-blue-50 transition-colors group">
                                                <td className="px-4 py-2 border-r border-slate-100 text-center text-slate-500 tabular-nums">{index + 1}</td>
                                                <td className="px-4 py-2 border-r border-slate-100 font-semibold text-slate-700">{row.productName}</td>
                                                <td className="px-4 py-2 border-r border-slate-100 text-slate-600">{row.groupName}</td>
                                                <td className="px-2 py-2 border-r border-slate-100 text-center text-slate-800 font-bold">{parseFloat(row.sph).toFixed(2)}</td>
                                                <td className="px-2 py-2 border-r border-slate-100 text-center text-slate-800 font-bold">{parseFloat(row.cyl).toFixed(2)}</td>
                                                <td className="px-2 py-2 border-r border-slate-100 text-center text-slate-600">{row.axis || 0}</td>
                                                <td className="px-2 py-2 border-r border-slate-100 text-center text-slate-800 font-bold">{parseFloat(row.addValue).toFixed(2)}</td>
                                                <td className="px-2 py-2 border-r border-slate-100 text-center text-slate-600">{row.eye || '—'}</td>
                                                <td className="px-4 py-2 border-r border-slate-100 text-blue-600 font-mono text-xs">{row.barcode || '—'}</td>
                                                <td className="px-4 py-2 border-r border-slate-100 text-center">
                                                    {row.isVerified ? (
                                                        <div className="flex flex-col items-center">
                                                            <span className="text-green-600 font-bold">✓</span>
                                                            {row.lastVerifiedDate && (
                                                                <span className="text-[8px] text-slate-400">
                                                                    {new Date(row.lastVerifiedDate).toLocaleDateString("en-IN", { timeZone: "Asia/Kolkata" })}
                                                                </span>
                                                            )}
                                                        </div>
                                                    ) : (
                                                        <span className="text-slate-300">—</span>
                                                    )}
                                                </td>
                                                <td className="px-2 py-2 border-r border-slate-100 text-center text-red-600 font-bold">{row.alertQty || 0}</td>
                                                <td className={`px-2 py-2 border-r border-slate-100 text-center font-bold ${row.excess_qty > 0 ? 'text-green-600' : row.excess_qty < 0 ? 'text-rose-600' : 'text-slate-400'}`}>
                                                    {row.excess_qty || 0}
                                                </td>
                                                <td className={`px-2 py-2 border-r border-slate-100 text-center font-bold text-lg ${row.currentStock > 0 ? 'text-green-600' : 'text-slate-400'}`}>
                                                    {row.currentStock}
                                                </td>
                                                <td className="px-2 py-2 border-r border-slate-100 text-center text-slate-400">{row.alertQty || 0}</td>
                                                <td className="px-2 py-2 border-r border-slate-100 text-center text-slate-400">0</td>
                                                <td className="px-2 py-2 border-r border-slate-100 text-right font-medium text-slate-600">{(parseFloat(row.pPrice) || 0).toFixed(2)}</td>
                                                <td className="px-2 py-2 border-r border-slate-100 text-right font-medium text-slate-800">{(parseFloat(row.sPrice) || 0).toFixed(2)}</td>
                                                <td className="px-2 py-2 border-r border-slate-100 text-right font-bold text-slate-700 bg-slate-50">
                                                    {((parseFloat(row.currentStock) || 0) * (parseFloat(row.pPrice) || 0)).toFixed(2)}
                                                </td>
                                                <td className="px-2 py-2 text-right font-bold text-blue-800 bg-blue-50">
                                                    {((parseFloat(row.currentStock) || 0) * (parseFloat(row.sPrice) || 0)).toFixed(2)}
                                                </td>
                                            </tr>
                                        ))
                                    )}
                                </tbody>
                                <tfoot className="sticky bottom-0 bg-zinc-50 text-black font-bold">
                                    <tr className="border-t-2 border-blue-200">
                                        <td colSpan="13" className="px-4 py-3 text-right uppercase tracking-widest text-[10px] text-slate-500">Grand Total</td>
                                        <td className="px-2 py-3 text-center text-blue-700 text-base">
                                            {pagination.totals.stockTotal || reportData.reduce((sum, r) => sum + (parseInt(r.currentStock) || 0), 0)}
                                        </td>
                                        <td colSpan="3" className="px-2 py-3"></td>
                                        <td className="px-2 py-3 text-right text-emerald-600">
                                            ₹{pagination.totals.purValueTotal?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || reportData.reduce((sum, r) => sum + ((parseFloat(r.currentStock) || 0) * (parseFloat(r.pPrice) || 0)), 0).toFixed(2)}
                                        </td>
                                        <td className="px-2 py-3 text-right text-blue-600">
                                            ₹{pagination.totals.saleValueTotal?.toLocaleString("en-IN", { minimumFractionDigits: 2 }) || reportData.reduce((sum, r) => sum + ((parseFloat(r.currentStock) || 0) * (parseFloat(r.sPrice) || 0)), 0).toFixed(2)}
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                )}

                {/* Pagination Controls */}
                {viewMode === 'report' && reportData.length > 0 && (
                    <div className="mt-4 flex flex-col md:flex-row items-center justify-between gap-4 bg-white p-4 rounded-xl shadow-sm border border-slate-200 print:hidden">
                        <div className="text-sm text-slate-500">
                            Showing <span className="font-semibold text-slate-800">{(pagination.currentPage - 1) * pagination.limit + 1}</span> to <span className="font-semibold text-slate-800">{Math.min(pagination.currentPage * pagination.limit, pagination.total)}</span> of <span className="font-semibold text-slate-800">{pagination.total}</span> records
                        </div>

                        <div className="flex items-center gap-2">
                            <button
                                onClick={() => handleSearch(pagination.currentPage - 1)}
                                disabled={pagination.currentPage === 1 || loading}
                                className="flex items-center justify-center w-8 h-8 rounded-lg border border-slate-200 bg-white text-slate-600 hover:bg-slate-50 disabled:opacity-50 transition shadow-sm"
                            >
                                <span className="sr-only">Previous</span>
                                &larr;
                            </button>

                            <div className="flex items-center gap-1">
                                {(() => {
                                    const totalPages = Math.ceil(pagination.total / pagination.limit);
                                    const current = pagination.currentPage;
                                    let pages = [];

                                    if (totalPages <= 7) {
                                        pages = Array.from({ length: totalPages }, (_, i) => i + 1);
                                    } else {
                                        if (current <= 4) {
                                            pages = [1, 2, 3, 4, 5, '...', totalPages];
                                        } else if (current >= totalPages - 3) {
                                            pages = [1, '...', totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
                                        } else {
                                            pages = [1, '...', current - 1, current, current + 1, '...', totalPages];
                                        }
                                    }

                                    return pages.map((p, i) => (
                                        <button
                                            key={i}
                                            onClick={() => typeof p === 'number' && handleSearch(p)}
                                            disabled={typeof p !== 'number' || loading}
                                            className={`w-8 h-8 rounded-lg flex items-center justify-center text-sm font-medium transition shadow-sm ${pagination.currentPage === p
                                                    ? 'bg-blue-600 text-white border-blue-600'
                                                    : p === '...'
                                                        ? 'text-slate-400 cursor-default'
                                                        : 'bg-white text-slate-600 border border-slate-200 hover:bg-slate-50'
                                                }`}
                                        >
                                            {p}
                                        </button>
                                    ));
                                })()}
                            </div>

                            <button
                                onClick={() => handleSearch(pagination.currentPage + 1)}
                                disabled={pagination.currentPage >= Math.ceil(pagination.total / pagination.limit) || loading}
                                className="flex items-center justify-center w-8 h-8 rounded-lg border border-slate-200 bg-white text-slate-600 hover:bg-slate-50 disabled:opacity-50 transition shadow-sm"
                            >
                                <span className="sr-only">Next</span>
                                &rarr;
                            </button>
                        </div>

                        <div className="flex items-center gap-3">
                            <span className="text-sm text-slate-500">Rows:</span>
                            <select
                                value={pagination.limit}
                                onChange={(e) => handleSearch(1, parseInt(e.target.value))}
                                className="bg-white border border-slate-200 text-slate-600 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-1.5 shadow-sm outline-none cursor-pointer"
                            >
                                <option value="50">50</option>
                                <option value="100">100</option>
                                <option value="200">200</option>
                                <option value="500">500</option>
                            </select>
                        </div>
                    </div>
                )}

                {/* Analysis & Summary View */}
                {viewMode === 'analysis' && (
                    <div className="mt-6">
                        {reportData.length === 0 ? (
                            <div className="bg-white rounded-xl shadow-md border border-slate-200 p-12 flex flex-col items-center justify-center text-slate-400">
                                <PieChart className="w-16 h-16 mb-4 text-slate-300" />
                                <h3 className="text-xl font-semibold text-slate-600">No Data for Analysis</h3>
                                <p className="text-sm">Apply filters and search to view the analysis report.</p>
                            </div>
                        ) : (
                            <div>
                                <div className="mb-4">
                                    <h2 className="text-lg font-bold text-slate-800 flex items-center gap-2">
                                        <BarChart3 className="w-5 h-5 text-blue-600" />
                                        Analysis & Summary
                                    </h2>
                                    <p className="text-xs text-slate-500 mt-1">Multi-view analysis of lens inventory</p>
                                </div>

                                {/* Tab Navigation */}
                                <div className="bg-white rounded-t-xl shadow-sm border border-b-0 border-slate-200 flex overflow-x-auto">
                                    {[
                                        { id: 'summary', label: 'SPH/CYL Matrix', icon: '📊' },
                                        { id: 'eye', label: 'Eye Wise Summary', icon: '👁️' },
                                        { id: 'detail', label: 'Group Summary', icon: '📋' },
                                    ].map(tab => (
                                        <button
                                            key={tab.id}
                                            onClick={() => setActiveTab(tab.id)}
                                            className={`px-4 py-3 font-semibold text-sm whitespace-nowrap transition-all border-b-2 ${activeTab === tab.id
                                                ? 'border-blue-600 text-blue-600 bg-blue-50'
                                                : 'border-transparent text-slate-600 hover:text-slate-800 hover:bg-slate-50'
                                                }`}
                                        >
                                            {tab.icon} {tab.label}
                                        </button>
                                    ))}
                                </div>

                                {/* Tab Content */}
                                <div className="bg-white rounded-b-xl shadow-md border border-slate-200 overflow-auto min-h-[400px]">
                                    {/* SPH/CYL Matrix Tab */}
                                    {activeTab === 'summary' && (
                                        <div className="overflow-x-auto p-4">
                                            <table className="w-full text-sm text-center border-collapse">
                                                <thead className="sticky top-0 z-10 bg-emerald-600 text-white">
                                                    <tr>
                                                        <th className="px-3 py-2 border border-emerald-500 font-bold min-w-[80px]">SPH / CYL</th>
                                                        {[...new Set(reportData.map(r => r.sph))].sort((a, b) => parseFloat(a) - parseFloat(b)).map(sph => (
                                                            <th key={`sph-${sph}`} className="px-3 py-2 border border-emerald-500 font-bold min-w-[70px] bg-emerald-700">
                                                                {parseFloat(sph).toFixed(2)}
                                                            </th>
                                                        ))}
                                                        <th className="px-3 py-2 border border-emerald-500 font-bold min-w-[80px] bg-emerald-800">Total</th>
                                                    </tr>
                                                </thead>
                                                <tbody className="divide-y divide-slate-200">
                                                    {[...new Set(reportData.map(r => r.cyl))].sort((a, b) => parseFloat(a) - parseFloat(b)).map(cyl => {
                                                        const sphValues = [...new Set(reportData.map(r => r.sph))].sort((a, b) => parseFloat(a) - parseFloat(b));
                                                        const cylTotal = reportData
                                                            .filter(r => r.cyl === cyl)
                                                            .reduce((sum, r) => sum + (parseInt(r.currentStock) || 0), 0);

                                                        return (
                                                            <tr key={`cyl-${cyl}`} className="hover:bg-emerald-50 transition-colors">
                                                                <td className="px-3 py-2 border border-slate-200 font-bold bg-emerald-50 text-slate-700">
                                                                    {parseFloat(cyl).toFixed(2)}
                                                                </td>
                                                                {sphValues.map(sph => {
                                                                    const cellData = reportData.find(r => r.sph === sph && r.cyl === cyl);
                                                                    const qty = cellData ? (parseInt(cellData.currentStock) || 0) : 0;
                                                                    return (
                                                                        <td
                                                                            key={`${sph}-${cyl}`}
                                                                            className={`px-3 py-2 border border-slate-200 font-semibold ${qty > 0 ? 'bg-green-100 text-green-800' : 'bg-slate-50 text-slate-400'}`}
                                                                        >
                                                                            {qty > 0 ? qty : '—'}
                                                                        </td>
                                                                    );
                                                                })}
                                                                <td className="px-3 py-2 border border-slate-200 font-bold bg-emerald-700 text-white shadow-inner">
                                                                    {cylTotal}
                                                                </td>
                                                            </tr>
                                                        );
                                                    })}
                                                    {/* SPH Total Row */}
                                                    <tr className="bg-emerald-800 text-white font-bold sticky bottom-0">
                                                        <td className="px-3 py-2 border border-emerald-500">Total</td>
                                                        {[...new Set(reportData.map(r => r.sph))].sort((a, b) => parseFloat(a) - parseFloat(b)).map(sph => {
                                                            const sphTotal = reportData
                                                                .filter(r => r.sph === sph)
                                                                .reduce((sum, r) => sum + (parseInt(r.currentStock) || 0), 0);
                                                            return (
                                                                <td key={`sph-total-${sph}`} className="px-3 py-2 border border-emerald-500">
                                                                    {sphTotal}
                                                                </td>
                                                            );
                                                        })}
                                                        <td className="px-3 py-2 border border-emerald-500">
                                                            {reportData.reduce((sum, r) => sum + (parseInt(r.currentStock) || 0), 0)}
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    )}

                                    {/* Eye Wise Summary Tab */}
                                    {activeTab === 'eye' && (
                                        <div className="overflow-x-auto p-4">
                                            <table className="w-full text-sm border-collapse">
                                                <thead className="sticky top-0 z-10 bg-blue-600 text-white">
                                                    <tr>
                                                        <th className="px-4 py-3 border border-blue-500 text-left font-bold">Eye</th>
                                                        <th className="px-4 py-3 border border-blue-500 text-center font-bold">Total Items</th>
                                                        <th className="px-4 py-3 border border-blue-500 text-center font-bold">Total Quantity</th>
                                                        <th className="px-4 py-3 border border-blue-500 text-right font-bold">Total Value (Sale)</th>
                                                    </tr>
                                                </thead>
                                                <tbody className="divide-y divide-slate-200 italic font-medium">
                                                    {['R', 'L', '—'].map(eye => {
                                                        const eyeData = reportData.filter(r => (r.eye || '—') === eye);
                                                        if (eyeData.length === 0) return null;
                                                        const totalQty = eyeData.reduce((sum, r) => sum + (parseInt(r.currentStock) || 0), 0);
                                                        const totalValue = eyeData.reduce((sum, r) => sum + ((parseFloat(r.currentStock) || 0) * (parseFloat(r.sPrice) || 0)), 0);

                                                        return (
                                                            <tr key={eye} className="hover:bg-blue-50 transition-colors">
                                                                <td className="px-4 py-2 border border-slate-200 font-semibold text-slate-700">
                                                                    {eye === 'R' ? '👁️ Right' : eye === 'L' ? '👁️ Left' : 'Not Specified'}
                                                                </td>
                                                                <td className="px-4 py-2 border border-slate-200 text-center text-slate-700">{eyeData.length}</td>
                                                                <td className="px-4 py-2 border border-slate-200 text-center font-bold text-green-700">{totalQty}</td>
                                                                <td className="px-4 py-2 border border-slate-200 text-right font-semibold text-blue-700 bg-blue-50">
                                                                    ₹{totalValue.toLocaleString("en-IN", { minimumFractionDigits: 2 })}
                                                                </td>
                                                            </tr>
                                                        );
                                                    })}
                                                    <tr className="bg-blue-800 text-white font-bold sticky bottom-0">
                                                        <td colSpan="2" className="px-4 py-2 border border-blue-500 text-right uppercase tracking-widest text-xs">Grand Total</td>
                                                        <td className="px-4 py-2 border border-blue-500 text-center text-lg">{reportData.reduce((sum, r) => sum + (parseInt(r.currentStock) || 0), 0)}</td>
                                                        <td className="px-4 py-2 border border-blue-500 text-right text-lg">
                                                            ₹{reportData.reduce((sum, r) => sum + ((parseFloat(r.currentStock) || 0) * (parseFloat(r.sPrice) || 0)), 0).toLocaleString("en-IN", { minimumFractionDigits: 2 })}
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    )}

                                    {/* Group Summary Tab */}
                                    {activeTab === 'detail' && (
                                        <div className="overflow-x-auto p-4">
                                            <table className="w-full text-sm border-collapse">
                                                <thead className="sticky top-0 z-10 bg-purple-600 text-white">
                                                    <tr>
                                                        <th className="px-4 py-3 border border-purple-500 text-left font-bold">Group Name</th>
                                                        <th className="px-4 py-3 border border-purple-500 text-center font-bold">Items</th>
                                                        <th className="px-4 py-3 border border-purple-500 text-center font-bold">Total Qty</th>
                                                        <th className="px-4 py-3 border border-purple-500 text-right font-bold">Pur Value</th>
                                                        <th className="px-4 py-3 border border-purple-500 text-right font-bold">Sale Value</th>
                                                    </tr>
                                                </thead>
                                                <tbody className="divide-y divide-slate-200 italic font-medium">
                                                    {[...new Set(reportData.map(r => r.groupName))].sort().map(groupName => {
                                                        const groupData = reportData.filter(r => r.groupName === groupName);
                                                        const totalQty = groupData.reduce((sum, r) => sum + (parseInt(r.currentStock) || 0), 0);
                                                        const purValue = groupData.reduce((sum, r) => sum + ((parseFloat(r.currentStock) || 0) * (parseFloat(r.pPrice) || 0)), 0);
                                                        const saleValue = groupData.reduce((sum, r) => sum + ((parseFloat(r.currentStock) || 0) * (parseFloat(r.sPrice) || 0)), 0);

                                                        return (
                                                            <tr key={groupName} className="hover:bg-purple-50 transition-colors">
                                                                <td className="px-4 py-2 border border-slate-200 font-semibold text-slate-700">{groupName}</td>
                                                                <td className="px-4 py-2 border border-slate-200 text-center text-slate-700">{groupData.length}</td>
                                                                <td className="px-4 py-2 border border-slate-200 text-center font-bold text-green-700">{totalQty}</td>
                                                                <td className="px-4 py-2 border border-slate-200 text-right font-semibold text-slate-700">₹{purValue.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                                                                <td className="px-4 py-2 border border-slate-200 text-right font-semibold text-purple-700 bg-purple-50">₹{saleValue.toLocaleString("en-IN", { minimumFractionDigits: 2 })}</td>
                                                            </tr>
                                                        );
                                                    })}
                                                    <tr className="bg-purple-800 text-white font-bold sticky bottom-0">
                                                        <td colSpan="2" className="px-4 py-2 border border-purple-500 text-right uppercase tracking-widest text-xs">Total</td>
                                                        <td className="px-4 py-2 border border-purple-500 text-center text-lg">{reportData.reduce((sum, r) => sum + (parseInt(r.currentStock) || 0), 0)}</td>
                                                        <td className="px-4 py-2 border border-purple-500 text-right text-lg">
                                                            ₹{reportData.reduce((sum, r) => sum + ((parseFloat(r.currentStock) || 0) * (parseFloat(r.pPrice) || 0)), 0).toLocaleString("en-IN", { minimumFractionDigits: 2 })}
                                                        </td>
                                                        <td className="px-4 py-2 border border-purple-500 text-right text-lg">
                                                            ₹{reportData.reduce((sum, r) => sum + ((parseFloat(r.currentStock) || 0) * (parseFloat(r.sPrice) || 0)), 0).toLocaleString("en-IN", { minimumFractionDigits: 2 })}
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    )}
                                </div>
                            </div>
                        )}
                    </div>
                )}
            </div>
        </div>
    );
}

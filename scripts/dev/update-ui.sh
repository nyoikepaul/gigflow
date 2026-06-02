#!/usr/bin/env bash

# ==============================================================================
# GigFlow Frontend Logic Injector
# Auto-detects the core application entrypoint and updates the dashboard UI.
# ==============================================================================

set -euo pipefail

# Find target file path
if [ -f "app/page.tsx" ]; then
    TARGET_FILE="app/page.tsx"
elif [ -f "src/app/page.tsx" ]; then
    TARGET_FILE="src/app/page.tsx"
else
    echo -e "\033[0;33m[!] Error: Could not locate app/page.tsx or src/app/page.tsx\033[0m"
    exit 1
fi

echo -e "\033[0;36m[+] Target page detected: $TARGET_FILE\033[0m"
echo -e "\033[0;32m[+] Injecting advanced metrics engine and dynamic sorting logic...\033[0m"

cat << 'COMPONENT_EOF' > "$TARGET_FILE"
'use client';

import { useState, useMemo } from 'react';
import { useGigStore } from '@/store/useGigStore'; // Adjust if your store import path differs

type SortField = 'name' | 'budget' | 'status';
type SortOrder = 'asc' | 'desc';

export default function Dashboard() {
  const { projects, deleteProject } = useGigStore();
  
  // Local state for searching, filtering, and sorting
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('All');
  const [sortField, setSortField] = useState<SortField>('name');
  const [sortOrder, setSortOrder] = useState<SortOrder>('asc');

  // ==========================================
  // 1. ADVANCED METRICS ENGINE (Derived State)
  // ==========================================
  const metrics = useMemo(() => {
    const total = projects.length;
    const revenue = projects.reduce((acc, p) => acc + p.budget, 0);
    
    // Monthly Recurring Revenue (Active Retainers)
    const mrr = projects
      .filter((p) => p.status === 'ACTIVE')
      .reduce((acc, p) => acc + p.budget, 0);
      
    // Average Value per Engagement
    const avgDeal = total > 0 ? revenue / total : 0;
    
    // Percentage of successfully closed contracts
    const completed = projects.filter((p) => p.status === 'COMPLETED').length;
    const winRate = total > 0 ? (completed / total) * 100 : 0;

    const activeClientsCount = new Set(
      projects.filter((p) => p.status === 'ACTIVE').map((p) => p.client)
    ).size;

    return { total, revenue, mrr, avgDeal, winRate, activeClientsCount };
  }, [projects]);

  // ==========================================
  // 2. SEARCH, FILTER, AND SORT PIPELINE
  // ==========================================
  const handleSort = (field: SortField) => {
    const isAsc = sortField === field && sortOrder === 'asc';
    setSortOrder(isAsc ? 'desc' : 'asc');
    setSortField(field);
  };

  const processedProjects = useMemo(() => {
    return projects
      .filter((project) => {
        const matchesSearch =
          project.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
          project.client.toLowerCase().includes(searchTerm.toLowerCase());
        const matchesStatus =
          statusFilter === 'All' || project.status === statusFilter;
        return matchesSearch && matchesStatus;
      })
      .sort((a, b) => {
        let aVal = a[sortField];
        let bVal = b[sortField];

        if (typeof aVal === 'string') aVal = aVal.toLowerCase();
        if (typeof bVal === 'string') bVal = bVal.toLowerCase();

        if (aVal < bVal) return sortOrder === 'asc' ? -1 : 1;
        if (aVal > bVal) return sortOrder === 'asc' ? 1 : -1;
        return 0;
      });
  }, [projects, searchTerm, statusFilter, sortField, sortOrder]);

  return (
    <div className="p-8 bg-[#090d16] text-slate-100 min-h-screen font-sans">
      {/* HEADER ROW */}
      <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-8">
        <div>
          <div className="flex items-center gap-3">
            <h1 className="text-3xl font-extrabold tracking-tight">GigFlow</h1>
            <span className="px-2.5 py-0.5 text-xs font-semibold rounded-md bg-indigo-500/10 text-indigo-400 border border-indigo-500/20">
              v1.0 Professional
            </span>
          </div>
          <p className="text-sm text-slate-400 mt-1">
            Manage active contracts, track revenue pipeline, and generate statements.
          </p>
        </div>
        <button className="px-4 py-2 text-sm font-semibold text-white bg-indigo-600 hover:bg-indigo-500 rounded-lg transition-colors shadow-lg shadow-indigo-600/10 flex items-center gap-2">
          <svg className="w-4 h-4" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
          </svg>
          Export PDF
        </button>
      </div>

      {/* 4-COLUMN HIGH-FIDELITY METRICS GRID */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        {/* Total Revenue */}
        <div className="bg-[#111827] border border-slate-800/80 p-6 rounded-xl flex justify-between items-center shadow-md">
          <div>
            <p className="text-xs font-semibold text-slate-400 uppercase tracking-wider">Total Revenue</p>
            <h3 className="text-3xl font-bold text-emerald-400 mt-1">${metrics.revenue.toLocaleString()}</h3>
          </div>
          <div className="bg-emerald-950/40 p-3 rounded-lg border border-emerald-500/10 text-emerald-400">
            <svg className="w-6 h-6" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
          </div>
        </div>

        {/* Monthly MRR */}
        <div className="bg-[#111827] border border-slate-800/80 p-6 rounded-xl flex justify-between items-center shadow-md">
          <div>
            <p className="text-xs font-semibold text-slate-400 uppercase tracking-wider">Monthly MRR</p>
            <h3 className="text-3xl font-bold text-indigo-400 mt-1">${metrics.mrr.toLocaleString()}</h3>
          </div>
          <div className="bg-indigo-950/40 p-3 rounded-lg border border-indigo-500/10 text-indigo-400">
            <svg className="w-6 h-6" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" /></svg>
          </div>
        </div>

        {/* Avg Deal Size */}
        <div className="bg-[#111827] border border-slate-800/80 p-6 rounded-xl flex justify-between items-center shadow-md">
          <div>
            <p className="text-xs font-semibold text-slate-400 uppercase tracking-wider">Avg Deal Size</p>
            <h3 className="text-3xl font-bold text-purple-400 mt-1">${Math.round(metrics.avgDeal).toLocaleString()}</h3>
          </div>
          <div className="bg-purple-950/40 p-3 rounded-lg border border-purple-500/10 text-purple-400">
            <svg className="w-6 h-6" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" /></svg>
          </div>
        </div>

        {/* Win Rate */}
        <div className="bg-[#111827] border border-slate-800/80 p-6 rounded-xl flex justify-between items-center shadow-md">
          <div>
            <p className="text-xs font-semibold text-slate-400 uppercase tracking-wider">Win Rate</p>
            <h3 className="text-3xl font-bold text-amber-400 mt-1">{metrics.winRate.toFixed(1)}%</h3>
          </div>
          <div className="bg-amber-950/40 p-3 rounded-lg border border-amber-500/10 text-amber-400">
            <svg className="w-6 h-6" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
          </div>
        </div>
      </div>

      {/* FILTER CONTROLS BAR */}
      <div className="bg-[#111827] border border-slate-800 p-4 rounded-xl mb-6 flex flex-col sm:flex-row gap-4 justify-between items-center">
        <div className="relative w-full sm:w-72">
          <input
            type="text"
            placeholder="Search projects or clients..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full bg-[#1f2937] border border-slate-700/60 rounded-lg px-4 py-2 text-sm text-slate-100 placeholder-slate-400 focus:outline-none focus:border-indigo-500 transition-colors"
          />
        </div>
        <select
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value)}
          className="w-full sm:w-44 bg-[#1f2937] border border-slate-700/60 rounded-lg px-3 py-2 text-sm text-slate-100 focus:outline-none focus:border-indigo-500 transition-colors"
        >
          <option value="All">All Statuses</option>
          <option value="ACTIVE">Active</option>
          <option value="PENDING">Pending</option>
          <option value="COMPLETED">Completed</option>
        </select>
      </div>

      {/* INTERACTIVE DATA TABLE */}
      <div className="bg-[#111827] border border-slate-800 rounded-xl overflow-hidden shadow-xl">
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-slate-800">
            <thead>
              <tr className="text-slate-400 text-xs uppercase font-semibold tracking-wider bg-[#161f30]/30">
                <th onClick={() => handleSort('name')} className="px-6 py-4 text-left cursor-pointer select-none hover:text-indigo-400 transition-colors">
                  <div className="flex items-center gap-1.5">
                    Project Name
                    <svg className={`w-3.5 h-3.5 transition-transform ${sortField === 'name' && sortOrder === 'desc' ? 'rotate-180' : ''}`} fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4" /></svg>
                  </div>
                </th>
                <th className="px-6 py-4 text-left">Client</th>
                <th onClick={() => handleSort('budget')} className="px-6 py-4 text-left cursor-pointer select-none hover:text-indigo-400 transition-colors">
                  <div className="flex items-center gap-1.5">
                    Budget
                    <svg className={`w-3.5 h-3.5 transition-transform ${sortField === 'budget' && sortOrder === 'desc' ? 'rotate-180' : ''}`} fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4" /></svg>
                  </div>
                </th>
                <th onClick={() => handleSort('status')} className="px-6 py-4 text-left cursor-pointer select-none hover:text-indigo-400 transition-colors">
                  <div className="flex items-center gap-1.5">
                    Status
                    <svg className={`w-3.5 h-3.5 transition-transform ${sortField === 'status' && sortOrder === 'desc' ? 'rotate-180' : ''}`} fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4" /></svg>
                  </div>
                </th>
                <th className="px-6 py-4 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-800/60 bg-[#0e1420]/20">
              {processedProjects.map((project) => (
                <tr key={project.id} className="hover:bg-slate-800/30 transition-colors group">
                  <td className="px-6 py-4 font-medium text-slate-200">{project.name}</td>
                  <td className="px-6 py-4 text-slate-400">{project.client}</td>
                  <td className="px-6 py-4 text-emerald-400 font-medium">${project.budget.toLocaleString()}</td>
                  <td className="px-6 py-4">
                    <span className={`px-2.5 py-1 text-xs font-bold rounded-full ${
                      project.status === 'ACTIVE' ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20' :
                      project.status === 'PENDING' ? 'bg-amber-500/10 text-amber-400 border border-amber-500/20' :
                      'bg-slate-500/10 text-slate-400 border border-slate-500/20'
                    }`}>
                      {project.status}
                    </span>
                  </td>
                  {/* HIGH-FIDELITY CONTEXT ACTION BUTTONS */}
                  <td className="px-6 py-4 text-right text-sm font-medium">
                    <div className="flex items-center space-x-3 justify-end opacity-40 group-hover:opacity-100 transition-opacity">
                      <button className="text-slate-400 hover:text-indigo-400 p-1 rounded transition-colors" title="View Details">
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /><path strokeLinecap="round" strokeLinejoin="round" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" /></svg>
                      </button>
                      <button className="text-slate-400 hover:text-emerald-400 p-1 rounded transition-colors" title="Generate Invoice">
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" /></svg>
                      </button>
                      <button className="text-slate-400 hover:text-amber-400 p-1 rounded transition-colors" title="Edit Record">
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" /></svg>
                      </button>
                      <span className="text-slate-800">|</span>
                      <button 
                        onClick={() => deleteProject(project.id)} 
                        className="text-slate-500 hover:text-rose-500 p-1 rounded transition-colors" 
                        title="Delete Record"
                      >
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24"><path strokeLinecap="round" strokeLinejoin="round" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-4v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
              {processedProjects.length === 0 && (
                <tr>
                  <td colSpan={5} className="px-6 py-12 text-center text-sm text-slate-500">
                    No matching project files or client contracts found.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
COMPONENT_EOF

echo -e "\033[0;32m[+] UI Logic upgrade deployment successfully compiled inside $TARGET_FILE!\033[0m"

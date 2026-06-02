'use client';

import { useState } from 'react';
import { useGigStore, Gig } from '@/store/useGigStore';
import PDFExport from '@/components/PDFExport';
import { Trash2, Briefcase, Users, DollarSign } from 'lucide-react';

export default function Dashboard() {
  const { gigs, deleteGig } = useGigStore();
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState('ALL');

  // Computed metrics
  const filteredGigs = gigs.filter((gig) => {
    const matchesSearch = gig.title.toLowerCase().includes(search.toLowerCase()) || gig.client.toLowerCase().includes(search.toLowerCase());
    const matchesStatus = statusFilter === 'ALL' || gig.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const totalRevenue = gigs.reduce((sum, g) => sum + g.amount, 0);
  const activeClients = new Set(gigs.filter(g => g.status === 'ACTIVE').map(g => g.client)).size;

  return (
    <div className="min-h-screen bg-[#0B0F19] text-slate-100 p-8 font-sans">
      <div className="max-w-6xl mx-auto space-y-8">
        
        {/* Header */}
        <div className="flex justify-between items-center">
          <div>
            <h1 className="text-3xl font-bold tracking-tight text-white flex items-center gap-2">
              GigFlow <span className="text-xs bg-violet-500/10 text-violet-400 px-2 py-1 rounded-full border border-violet-500/20">v1.0 Professional</span>
            </h1>
            <p className="text-slate-400 text-sm mt-1">Manage active contracts, track revenue pipeline, and generate statements.</p>
          </div>
          <PDFExport />
        </div>

        {/* Metric Cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
          <div className="bg-[#151D30] p-6 rounded-xl border border-slate-800 flex items-center justify-between">
            <div>
              <p className="text-xs font-semibold uppercase tracking-wider text-slate-400">Total Revenue</p>
              <h3 className="text-2xl font-bold mt-1 text-emerald-400">${totalRevenue.toLocaleString()}</h3>
            </div>
            <div className="p-3 bg-emerald-500/10 text-emerald-400 rounded-lg"><DollarSign className="w-6 h-6" /></div>
          </div>
          <div className="bg-[#151D30] p-6 rounded-xl border border-slate-800 flex items-center justify-between">
            <div>
              <p className="text-xs font-semibold uppercase tracking-wider text-slate-400">Active Clients</p>
              <h3 className="text-2xl font-bold mt-1 text-blue-400">{activeClients}</h3>
            </div>
            <div className="p-3 bg-blue-500/10 text-blue-400 rounded-lg"><Users className="w-6 h-6" /></div>
          </div>
          <div className="bg-[#151D30] p-6 rounded-xl border border-slate-800 flex items-center justify-between">
            <div>
              <p className="text-xs font-semibold uppercase tracking-wider text-slate-400">Total Engagements</p>
              <h3 className="text-2xl font-bold mt-1 text-violet-400">{gigs.length}</h3>
            </div>
            <div className="p-3 bg-violet-500/10 text-violet-400 rounded-lg"><Briefcase className="w-6 h-6" /></div>
          </div>
        </div>

        {/* Filter Controls */}
        <div className="bg-[#151D30] p-4 rounded-xl border border-slate-800 flex flex-col sm:flex-row gap-4 items-center justify-between">
          <input
            type="text"
            placeholder="Search projects or clients..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="w-full sm:w-72 bg-[#0B0F19] border border-slate-700 rounded-lg px-4 py-2 text-sm text-slate-200 placeholder-slate-500 focus:outline-none focus:border-violet-500"
          />
          <select
            value={statusFilter}
            onChange={(e) => setStatusFilter(e.target.value)}
            className="w-full sm:w-44 bg-[#0B0F19] border border-slate-700 rounded-lg px-3 py-2 text-sm text-slate-200 focus:outline-none focus:border-violet-500"
          >
            <option value="ALL">All Statuses</option>
            <option value="ACTIVE">Active</option>
            <option value="PENDING">Pending</option>
            <option value="COMPLETED">Completed</option>
          </select>
        </div>

        {/* Data Table */}
        <div className="bg-[#151D30] rounded-xl border border-slate-800 overflow-hidden">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="border-b border-slate-800 bg-[#121A2C] text-xs font-semibold uppercase tracking-wider text-slate-400">
                <th className="p-4">Project Name</th>
                <th className="p-4">Client</th>
                <th className="p-4">Budget</th>
                <th className="p-4">Status</th>
                <th className="p-4 text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-800 text-sm">
              {filteredGigs.length > 0 ? (
                filteredGigs.map((gig) => (
                  <tr key={gig.id} className="hover:bg-[#1A243A] transition-colors">
                    <td className="p-4 font-medium text-white">{gig.title}</td>
                    <td className="p-4 text-slate-300">{gig.client}</td>
                    <td className="p-4 text-slate-200 font-mono">${gig.amount.toLocaleString()}</td>
                    <td className="p-4">
                      <span className={`px-2.5 py-1 rounded-full text-xs font-bold tracking-wide ${
                        gig.status === 'ACTIVE' ? 'bg-emerald-500/10 text-emerald-400' :
                        gig.status === 'PENDING' ? 'bg-amber-500/10 text-amber-400' : 'bg-slate-500/20 text-slate-400'
                      }`}>
                        {gig.status}
                      </span>
                    </td>
                    <td className="p-4 text-right">
                      <button
                        onClick={() => deleteGig(gig.id)}
                        className="text-slate-500 hover:text-red-400 p-1 rounded-md transition-colors"
                        title="Delete record"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan={5} className="p-8 text-center text-slate-500">No projects match the current filtering parameters.</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

      </div>
    </div>
  );
}

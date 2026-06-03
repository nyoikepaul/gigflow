"use client";

import React, { useState, useMemo } from "react";
import {
  Briefcase,
  TrendingUp,
  DollarSign,
  CheckCircle2,
  Search,
  Filter,
  Plus,
  LayoutDashboard,
  FileText,
  CreditCard,
  BarChart3,
  Settings,
  FolderKanban,
  SlidersHorizontal,
  Download,
  Eye,
  Trash2,
  Edit3
} from "lucide-react";

// Types for strict type safety
interface Project {
  id: string;
  name: string;
  client: string;
  budget: number;
  status: "ACTIVE" | "COMPLETED" | "PENDING";
  mrrContribution: number;
}

export default function Dashboard() {
  // 1. Core State Array - Acts as the database layer for the UI
  const [projects, setProjects] = useState<Project[]>([
    { id: "1", name: "E-commerce Redesign", client: "TechFlow Inc", budget: 4500, status: "ACTIVE", mrrContribution: 1500 },
    { id: "2", name: "Mobile App API", client: "Velocity Soft", budget: 4000, status: "COMPLETED", mrrContribution: 2000 },
    { id: "3", name: "SaaS Dashboard", client: "CloudScale", budget: 7200, status: "PENDING", mrrContribution: 1000 },
  ]);

  // UI Interactive States
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedStatus, setSelectedStatus] = useState<string>("ALL");
  const [currentTab, setCurrentTab] = useState<string>("dashboard");

  // 2. Logic Pipeline: Filtering Logic
  const filteredProjects = useMemo(() => {
    return projects.filter((project) => {
      const matchesSearch =
        project.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        project.client.toLowerCase().includes(searchQuery.toLowerCase());
      const matchesStatus = selectedStatus === "ALL" || project.status === selectedStatus;
      return matchesSearch && matchesStatus;
    });
  }, [projects, searchQuery, selectedStatus]);

  // 3. Logic Pipeline: Real-time Dynamic Metrics Calculations
  const metrics = useMemo(() => {
    const total = filteredProjects.reduce((sum, p) => sum + p.budget, 0);
    const mrr = filteredProjects.filter(p => p.status === "ACTIVE").reduce((sum, p) => sum + p.mrrContribution, 0);
    const avg = filteredProjects.length > 0 ? Math.round(total / filteredProjects.length) : 0;
    
    const completedCount = filteredProjects.filter(p => p.status === "COMPLETED").length;
    const winRate = filteredProjects.length > 0 ? ((completedCount / filteredProjects.length) * 100).toFixed(1) : "0.0";

    return { total, mrr, avg, winRate };
  }, [filteredProjects]);

  // Quick state modification logic handlers
  const deleteProject = (id: string) => {
    setProjects(projects.filter((p) => p.id !== id));
  };

  return (
    <div className="flex h-screen w-full bg-[#09090b] text-zinc-100 font-sans overflow-hidden">
      
      {/* ================= LEFT SIDEBAR LOGIC DASHBOARD ================= */}
      <aside className="w-64 bg-[#0c0c0e] border-r border-zinc-800 flex flex-col justify-between hidden md:flex shrink-0">
        <div>
          {/* Brand Header */}
          <div className="p-6 border-b border-zinc-800 flex items-center justify-between">
            <div className="flex flex-col">
              <span className="text-xl font-bold tracking-tight bg-gradient-to-r from-white via-zinc-200 to-zinc-500 bg-clip-text text-transparent">
                GigFlow
              </span>
              <span className="text-[10px] text-zinc-500 font-medium uppercase mt-0.5 tracking-wider">
                v1.0 Professional
              </span>
            </div>
            <span className="px-2 py-0.5 text-[10px] font-semibold text-purple-400 bg-purple-950/40 border border-purple-800/50 rounded-md">
              PRO
            </span>
          </div>

          {/* Quick Core Action */}
          <div className="px-4 py-4">
            <button className="w-full bg-zinc-100 hover:bg-zinc-200 text-zinc-950 font-medium text-xs py-2.5 px-4 rounded-lg transition-all duration-200 flex items-center justify-center gap-2 shadow-sm cursor-pointer">
              <Plus className="w-4 h-4 stroke-[2.5]" />
              New Contract
            </button>
          </div>

          {/* Core System Navigation */}
          <nav className="px-3 space-y-1">
            <p className="px-3 text-[10px] font-semibold text-zinc-500 uppercase tracking-wider mb-2">Platform Engine</p>
            {[
              { id: "dashboard", label: "Overview", icon: LayoutDashboard },
              { id: "contracts", label: "Contracts Desk", icon: FolderKanban },
              { id: "invoices", label: "Invoicing & Escrow", icon: CreditCard },
              { id: "analytics", label: "Performance Analytics", icon: BarChart3 },
            ].map((item) => {
              const Icon = item.icon;
              const isActive = currentTab === item.id;
              return (
                <button
                  key={item.id}
                  onClick={() => setCurrentTab(item.id)}
                  className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-xs font-medium transition-all cursor-pointer ${
                    isActive
                      ? "bg-zinc-800/60 text-white border-l-2 border-purple-500 pl-2.5"
                      : "text-zinc-400 hover:bg-zinc-900 hover:text-zinc-200"
                  }`}
                >
                  <Icon className={`w-4 h-4 ${isActive ? "text-purple-400" : "text-zinc-500"}`} />
                  {item.label}
                </button>
              );
            })}
          </nav>

          {/* Interactive State Filter Controls */}
          <div className="px-3 mt-8">
            <div className="flex items-center gap-2 px-3 mb-2">
              <SlidersHorizontal className="w-3.5 h-3.5 text-zinc-500" />
              <p className="text-[10px] font-semibold text-zinc-500 uppercase tracking-wider">State Filters</p>
            </div>
            <div className="space-y-1">
              {[
                { id: "ALL", label: "All Pipelines", count: projects.length },
                { id: "ACTIVE", label: "Active Engine", count: projects.filter(p => p.status === "ACTIVE").length },
                { id: "PENDING", label: "Pending Review", count: projects.filter(p => p.status === "PENDING").length },
                { id: "COMPLETED", label: "Settled Nodes", count: projects.filter(p => p.status === "COMPLETED").length },
              ].map((filter) => {
                const isActive = selectedStatus === filter.id;
                return (
                  <button
                    key={filter.id}
                    onClick={() => setSelectedStatus(filter.id)}
                    className={`w-full flex items-center justify-between px-3 py-2 rounded-md text-xs font-medium transition-all cursor-pointer ${
                      isActive ? "bg-purple-950/30 text-purple-300 border border-purple-900/50" : "text-zinc-400 hover:bg-zinc-900/50"
                    }`}
                  >
                    <span>{filter.label}</span>
                    <span className={`text-[10px] px-1.5 py-0.2 rounded font-mono ${isActive ? "bg-purple-900/60 text-purple-200" : "bg-zinc-900 text-zinc-500"}`}>
                      {filter.count}
                    </span>
                  </button>
                );
              })}
            </div>
          </div>
        </div>

        {/* Infrastructure Footprint Status Footer */}
        <div className="p-4 border-t border-zinc-800 bg-[#08080a]">
          <div className="flex items-center justify-between mb-2">
            <span className="text-[10px] font-medium text-zinc-500">M-Pesa Gateway Node</span>
            <span className="w-1.5 h-1.5 bg-emerald-500 rounded-full animate-pulse" />
          </div>
          <div className="w-full bg-zinc-900 rounded-full h-1">
            <div className="bg-gradient-to-r from-emerald-500 to-teal-400 h-1 rounded-full w-full" />
          </div>
          <button className="w-full mt-3 flex items-center gap-2 px-2.5 py-1.5 text-zinc-500 hover:text-zinc-300 rounded text-xs transition-colors cursor-pointer">
            <Settings className="w-3.5 h-3.5" />
            <span>Infrastructure Core</span>
          </button>
        </div>
      </aside>

      {/* ================= MAIN MONITORING VIEW ================= */}
      <main className="flex-1 overflow-y-auto bg-[#09090b] p-6 lg:p-8">
        
        {/* Top Operational Matrix Header */}
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-8">
          <div>
            <h1 className="text-2xl font-bold tracking-tight text-zinc-50">Operational Hub</h1>
            <p className="text-xs text-zinc-400 mt-1">
              Manage active contracts, track revenue pipeline, and generate statements.
            </p>
          </div>
          <button className="flex items-center gap-2 bg-purple-600 hover:bg-purple-700 text-white text-xs font-semibold px-4 py-2.5 rounded-lg shadow-md transition-all self-start sm:self-center cursor-pointer">
            <Download className="w-4 h-4" />
            Export PDF
          </button>
        </div>

        {/* Dynamic Metric Grid (Calculated on the Fly) */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
          {/* Card 1: Revenue */}
          <div className="bg-[#0c0c0e] border border-zinc-800 p-5 rounded-xl flex items-center justify-between">
            <div>
              <p className="text-[10px] font-bold uppercase tracking-wider text-zinc-400">Total Revenue</p>
              <p className="text-2xl font-extrabold tracking-tight text-emerald-400 mt-1">${metrics.total.toLocaleString()}</p>
            </div>
            <div className="p-3 bg-emerald-950/30 border border-emerald-900/40 rounded-xl text-emerald-400">
              <DollarSign className="w-5 h-5" />
            </div>
          </div>

          {/* Card 2: MRR */}
          <div className="bg-[#0c0c0e] border border-zinc-800 p-5 rounded-xl flex items-center justify-between">
            <div>
              <p className="text-[10px] font-bold uppercase tracking-wider text-zinc-400">Monthly MRR</p>
              <p className="text-2xl font-extrabold tracking-tight text-blue-400 mt-1">${metrics.mrr.toLocaleString()}</p>
            </div>
            <div className="p-3 bg-blue-950/30 border border-blue-900/40 rounded-xl text-blue-400">
              <TrendingUp className="w-5 h-5" />
            </div>
          </div>

          {/* Card 3: Average Deal Size */}
          <div className="bg-[#0c0c0e] border border-zinc-800 p-5 rounded-xl flex items-center justify-between">
            <div>
              <p className="text-[10px] font-bold uppercase tracking-wider text-zinc-400">Avg Deal Size</p>
              <p className="text-2xl font-extrabold tracking-tight text-purple-400 mt-1">${metrics.avg.toLocaleString()}</p>
            </div>
            <div className="p-3 bg-purple-950/30 border border-purple-900/40 rounded-xl text-purple-400">
              <Briefcase className="w-5 h-5" />
            </div>
          </div>

          {/* Card 4: Win Rate */}
          <div className="bg-[#0c0c0e] border border-zinc-800 p-5 rounded-xl flex items-center justify-between">
            <div>
              <p className="text-[10px] font-bold uppercase tracking-wider text-zinc-400">Win Rate</p>
              <p className="text-2xl font-extrabold tracking-tight text-amber-500 mt-1">{metrics.winRate}%</p>
            </div>
            <div className="p-3 bg-amber-950/30 border border-amber-900/40 rounded-xl text-amber-500">
              <CheckCircle2 className="w-5 h-5" />
            </div>
          </div>
        </div>

        {/* Data Filtering Bar */}
        <div className="bg-[#0c0c0e] border border-zinc-800 rounded-xl p-4 mb-4 flex flex-col sm:flex-row items-center gap-3">
          <div className="relative w-full sm:flex-1">
            <Search className="absolute left-3 top-2.5 h-4 w-4 text-zinc-500" />
            <input
              type="text"
              placeholder="Search projects or clients..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full bg-[#141417] border border-zinc-800 rounded-lg pl-9 pr-4 py-2 text-xs text-zinc-200 placeholder-zinc-500 focus:outline-none focus:border-purple-500 transition-colors"
            />
          </div>
          <div className="flex items-center gap-2 w-full sm:w-auto shrink-0">
            <div className="flex items-center gap-1.5 bg-[#141417] border border-zinc-800 px-3 py-2 rounded-lg text-xs text-zinc-400">
              <Filter className="w-3.5 h-3.5" />
              <span>Status:</span>
              <select
                value={selectedStatus}
                onChange={(e) => setSelectedStatus(e.target.value)}
                className="bg-transparent text-zinc-200 focus:outline-none ml-1 font-medium cursor-pointer"
              >
                <option value="ALL">All Statuses</option>
                <option value="ACTIVE">Active</option>
                <option value="PENDING">Pending</option>
                <option value="COMPLETED">Completed</option>
              </select>
            </div>
          </div>
        </div>

        {/* The Relational Reactive Data Table */}
        <div className="bg-[#0c0c0e] border border-zinc-800 rounded-xl overflow-hidden shadow-xl">
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className="border-b border-zinc-800 text-[10px] font-bold uppercase tracking-wider text-zinc-400 bg-[#08080a]">
                  <th className="py-4 px-6">Project Name</th>
                  <th className="py-4 px-6">Client</th>
                  <th className="py-4 px-6">Budget</th>
                  <th className="py-4 px-6">Status</th>
                  <th className="py-4 px-6 text-right">Actions</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-zinc-800/60 text-xs">
                {filteredProjects.length === 0 ? (
                  <tr>
                    <td colSpan={5} className="text-center py-8 text-zinc-500 font-medium">
                      No computational records match the query parameters.
                    </td>
                  </tr>
                ) : (
                  filteredProjects.map((project) => (
                    <tr key={project.id} className="hover:bg-zinc-900/30 transition-colors group">
                      <td className="py-4 px-6 font-semibold text-zinc-100">{project.name}</td>
                      <td className="py-4 px-6 text-zinc-400">{project.client}</td>
                      <td className="py-4 px-6 font-mono font-medium text-emerald-400">${project.budget.toLocaleString()}</td>
                      <td className="py-4 px-6">
                        <span
                          className={`inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-bold border ${
                            project.status === "ACTIVE"
                              ? "bg-emerald-950/40 text-emerald-400 border-emerald-800/40"
                              : project.status === "COMPLETED"
                              ? "bg-zinc-800 text-zinc-300 border-zinc-700"
                              : "bg-amber-950/40 text-amber-500 border-amber-900/40"
                          }`}
                        >
                          {project.status}
                        </span>
                      </td>
                      <td className="py-4 px-6 text-right">
                        <div className="flex items-center justify-end gap-1 opacity-60 group-hover:opacity-100 transition-opacity">
                          <button className="p-1.5 hover:bg-zinc-800 rounded text-zinc-400 hover:text-zinc-200 cursor-pointer">
                            <Eye className="w-3.5 h-3.5" />
                          </button>
                          <button className="p-1.5 hover:bg-zinc-800 rounded text-zinc-400 hover:text-zinc-200 cursor-pointer">
                            <Edit3 className="w-3.5 h-3.5" />
                          </button>
                          <button 
                            onClick={() => deleteProject(project.id)}
                            className="p-1.5 hover:bg-red-950/40 rounded text-zinc-500 hover:text-red-400 cursor-pointer"
                          >
                            <Trash2 className="w-3.5 h-3.5" />
                          </button>
                        </div>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>

      </main>
    </div>
  );
}

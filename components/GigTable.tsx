"use client";
import { useState, useMemo } from "react";
import { useReactTable, getCoreRowModel, getSortedRowModel, getFilteredRowModel, getPaginationRowModel, flexRender, ColumnDef, SortingState, ColumnFiltersState } from "@tanstack/react-table";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Download, FileText, Edit, Trash2 } from "lucide-react";
import Papa from "papaparse";
import { motion } from "framer-motion";

export interface Gig {
  id: string;
  title: string;
  client: string;
  budget: number;
  status: "active" | "pending" | "completed";
}

const data: Gig[] = [
  { id: "1", title: "E-commerce Redesign", client: "TechFlow Inc", budget: 4500, status: "active" },
  { id: "2", title: "SaaS Dashboard", client: "CloudScale", budget: 7200, status: "pending" },
  { id: "3", title: "Mobile App API", client: "Velocity Soft", budget: 3000, status: "completed" },
];

export default function GigTable() {
  const [sorting, setSorting] = useState<SortingState>([]);
  const [columnFilters, setColumnFilters] = useState<ColumnFiltersState>([]);
  const [globalFilter, setGlobalFilter] = useState("");
  const [statusFilter, setStatusFilter] = useState<string>("all");

  const columns: ColumnDef<Gig>[] = [
    { accessorKey: "title", header: "Project Name" },
    { accessorKey: "client", header: "Client" },
    { accessorKey: "budget", header: "Budget", cell: ({ row }) => `$${row.original.budget.toLocaleString()}` },
    {
      accessorKey: "status",
      header: "Status",
      cell: ({ row }) => {
        const status = row.original.status;
        const colors = { active: "bg-emerald-500", pending: "bg-amber-500", completed: "bg-blue-500" };
        return <span className={`px-3 py-1 text-xs font-medium text-white rounded-full ${colors[status]}`}>{status.toUpperCase()}</span>;
      },
    },
  ];

  const filteredData = useMemo(() => {
    let result = data;
    if (statusFilter !== "all") {
      result = result.filter(g => g.status === statusFilter);
    }
    return result;
  }, [statusFilter]);

  const table = useReactTable({
    data: filteredData,
    columns,
    state: { sorting, columnFilters, globalFilter },
    onSortingChange: setSorting,
    onColumnFiltersChange: setColumnFilters,
    onGlobalFilterChange: setGlobalFilter,
    getCoreRowModel: getCoreRowModel(),
    getSortedRowModel: getSortedRowModel(),
    getFilteredRowModel: getFilteredRowModel(),
    getPaginationRowModel: getPaginationRowModel(),
  });

  const exportCSV = () => {
    const csv = Papa.unparse(data);
    const blob = new Blob([csv], { type: "text/csv" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "gigflow-export.csv";
    a.click();
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col md:flex-row gap-4 items-center justify-between">
        <Input
          placeholder="Search projects or clients..."
          value={globalFilter}
          onChange={(e) => setGlobalFilter(e.target.value)}
          className="max-w-sm"
        />
        <div className="flex gap-3">
          <Select value={statusFilter} onValueChange={setStatusFilter}>
            <SelectTrigger className="w-40">
              <SelectValue placeholder="Filter Status" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">All Status</SelectItem>
              <SelectItem value="active">Active</SelectItem>
              <SelectItem value="pending">Pending</SelectItem>
              <SelectItem value="completed">Completed</SelectItem>
            </SelectContent>
          </Select>
          <Button onClick={exportCSV} variant="outline">
            <Download className="w-4 h-4 mr-2" /> Export CSV
          </Button>
        </div>
      </div>

      <div className="border border-zinc-800 rounded-2xl overflow-hidden">
        <Table>
          <TableHeader>
            {table.getHeaderGroups().map(headerGroup => (
              <TableRow key={headerGroup.id}>
                {headerGroup.headers.map(header => (
                  <TableHead key={header.id} onClick={header.column.getToggleSortingHandler()} className="cursor-pointer hover:bg-zinc-900">
                    {flexRender(header.column.columnDef.header, header.getContext())}
                    {header.column.getIsSorted() && (header.column.getIsSorted() === "asc" ? " ↑" : " ↓")}
                  </TableHead>
                ))}
                <TableHead>Actions</TableHead>
              </TableRow>
            ))}
          </TableHeader>
          <TableBody>
            {table.getRowModel().rows.map(row => (
              <motion.tr
                key={row.id}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                className="hover:bg-zinc-900/50"
              >
                {row.getVisibleCells().map(cell => (
                  <TableCell key={cell.id}>
                    {flexRender(cell.column.columnDef.cell, cell.getContext())}
                  </TableCell>
                ))}
                <TableCell>
                  <div className="flex gap-2">
                    <Button size="sm" variant="ghost"><Edit className="w-4 h-4" /></Button>
                    <Button size="sm" variant="ghost"><Trash2 className="w-4 h-4" /></Button>
                    <Button size="sm" variant="ghost" onClick={() => alert("PDF coming soon 🚀")}><FileText className="w-4 h-4" /></Button>
                  </div>
                </TableCell>
              </motion.tr>
            ))}
          </TableBody>
        </Table>
      </div>

      <div className="flex items-center justify-between text-sm text-zinc-500">
        <div>Showing {table.getRowModel().rows.length} gigs</div>
        <div className="flex gap-2">
          <Button variant="outline" size="sm" onClick={() => table.previousPage()} disabled={!table.getCanPreviousPage()}>Previous</Button>
          <Button variant="outline" size="sm" onClick={() => table.nextPage()} disabled={!table.getCanNextPage()}>Next</Button>
        </div>
      </div>
    </div>
  );
}

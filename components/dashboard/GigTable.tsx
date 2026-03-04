'use client';

import React from 'react';
import {
  createColumnHelper,
  flexRender,
  getCoreRowModel,
  useReactTable,
} from '@tanstack/react-table';
import { Gig } from '@/types';

const columnHelper = createColumnHelper<Gig>();

const columns = [
  columnHelper.accessor('title', {
    header: () => 'Project Name',
    cell: (info) => <span className="font-medium text-slate-900">{info.getValue()}</span>,
  }),
  columnHelper.accessor('client', {
    header: () => 'Client',
  }),
  columnHelper.accessor('budget', {
    header: () => 'Budget',
    cell: (info) => (
      <span className="text-emerald-600 font-semibold">\$ {info.getValue().toLocaleString()}</span>
    ),
  }),
  columnHelper.accessor('status', {
    header: () => 'Status',
    cell: (info) => (
      <span className="px-2 py-1 rounded-full text-xs font-medium bg-slate-100 text-slate-600 uppercase">
        {info.getValue()}
      </span>
    ),
  }),
];

export function GigTable({ data }: { data: Gig[] }) {
  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel(),
  });

  return (
    <div className="overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm">
      <table className="w-full text-left text-sm">
        <thead className="bg-slate-50 text-slate-500 uppercase text-[10px] tracking-wider">
          {table.getHeaderGroups().map((headerGroup) => (
            <tr key={headerGroup.id}>
              {headerGroup.headers.map((header) => (
                <th key={header.id} className="px-6 py-4 font-semibold">
                  {header.isPlaceholder
                    ? null
                    : flexRender(header.column.columnDef.header, header.getContext())}
                </th>
              ))}
            </tr>
          ))}
        </thead>
        <tbody className="divide-y divide-slate-200">
          {table.getRowModel().rows.map((row) => (
            <tr key={row.id} className="hover:bg-slate-50 transition-colors">
              {row.getVisibleCells().map((cell) => (
                <td key={cell.id} className="px-6 py-4">
                  {flexRender(cell.column.columnDef.cell, cell.getContext())}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

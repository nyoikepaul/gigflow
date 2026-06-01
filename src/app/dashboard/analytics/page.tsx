'use client';

import React from 'react';
import { useContractStore } from '../../../store/useContractStore';

export default function FinancialAnalyticsCard() {
  const activeMetrics = useContractStore((state) => state.getActiveFinancialMetrics());
  const exchangeRate = useContractStore((state) => state.exchangeRateUSDToKES);

  if (!activeMetrics) {
    return (
      <div className="p-6 rounded-xl border border-zinc-800 bg-zinc-950 text-zinc-400 font-mono text-xs">
        [*] Awaiting contract matrix hydration... Run target seed pipelines.
      </div>
    );
  }

  return (
    <div className="p-6 rounded-xl border border-zinc-800 bg-zinc-950 text-white shadow-md max-w-md">
      <div className="mb-4 flex items-center justify-between">
        <span className="text-xs font-mono tracking-widest text-zinc-500">LEDGER METRICS ENGINE</span>
        <span className="text-xs bg-emerald-950 text-emerald-400 font-mono px-2 py-0.5 rounded border border-emerald-800">
          FX: {exchangeRate.toFixed(2)} KES
        </span>
      </div>

      <h3 className="text-sm font-medium text-zinc-400">Total Contract Value (Gross)</h3>
      <p className="text-3xl font-bold tracking-tight font-mono mb-6">${activeMetrics.grossAmount.toLocaleString()}</p>

      <div className="space-y-3 font-mono text-xs text-zinc-400 border-t border-zinc-900 pt-4">
        <div className="flex justify-between">
          <span>Upwork Platform Fee (10%)</span>
          <span className="text-rose-500">-${activeMetrics.upworkFee.toFixed(2)}</span>
        </div>
        <div className="flex justify-between">
          <span>Withholding Tax Buffer (5%)</span>
          <span className="text-rose-400">-${activeMetrics.localTaxReserve.toFixed(2)}</span>
        </div>
        <div className="flex justify-between border-t border-zinc-900 pt-2 text-zinc-200 text-sm font-semibold">
          <span>Net Disbursable Balance</span>
          <span className="text-emerald-400">${activeMetrics.netPayoutUSD.toFixed(2)}</span>
        </div>
        <div className="flex justify-between text-zinc-500 text-[10px]">
          <span>Local Currency Equivalent</span>
          <span>KES {activeMetrics.netPayoutKES.toLocaleString()}</span>
        </div>
      </div>
    </div>
  );
}

"use client";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import GigTable from "@/components/GigTable";
import { BarChart3, Users, DollarSign } from "lucide-react";

export default function GigFlowOverview() {
  return (
    <div className="min-h-screen bg-zinc-950 text-zinc-100 p-8">
      <div className="max-w-6xl mx-auto">
        <div className="flex justify-between items-center mb-10">
          <div>
            <h1 className="text-5xl font-bold tracking-tighter text-blue-400">GigFlow</h1>
            <p className="text-xl text-zinc-400 mt-2">Manage your active contracts and agency revenue.</p>
          </div>
          <div className="flex gap-8 text-sm">
            <div className="flex items-center gap-3">
              <DollarSign className="text-emerald-400" /> <span>$15,700 total</span>
            </div>
            <div className="flex items-center gap-3">
              <Users className="text-blue-400" /> <span>3 active clients</span>
            </div>
          </div>
        </div>

        <Card className="bg-zinc-900 border-zinc-800">
          <CardHeader>
            <CardTitle className="flex items-center gap-3 text-2xl">
              <BarChart3 className="text-blue-400" /> Overview
            </CardTitle>
          </CardHeader>
          <CardContent>
            <GigTable />
          </CardContent>
        </Card>
      </div>
    </div>
  );
}

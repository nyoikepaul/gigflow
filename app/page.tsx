import { GigTable } from '@/components/dashboard/GigTable'
import { Gig } from '@/types'

const mockGigs: Gig[] = [
  { id: '1', title: 'E-commerce Redesign', client: 'TechFlow Inc', status: 'active', budget: 4500, deadline: '2026-04-12' },
  { id: '2', title: 'SaaS Dashboard', client: 'CloudScale', status: 'pending', budget: 7200, deadline: '2026-05-01' },
  { id: '3', title: 'Mobile App API', client: 'Velocity Soft', status: 'completed', budget: 3000, deadline: '2026-02-20' },
]

export default function Dashboard() {
  return (
    <main className="p-8 max-w-7xl mx-auto space-y-8">
      <div>
        <h1 className="text-3xl font-bold tracking-tight text-slate-900">GigFlow Overview</h1>
        <p className="text-slate-500">Manage your active contracts and agency revenue.</p>
      </div>
      
      <GigTable data={mockGigs} />
    </main>
  )
}

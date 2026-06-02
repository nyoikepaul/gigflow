import { create } from 'zustand';

export interface Gig {
  id: string;
  title: string;
  client: string;
  amount: number;
  status: 'ACTIVE' | 'PENDING' | 'COMPLETED';
}

interface GigState {
  gigs: Gig[];
  addGig: (gig: Omit<Gig, 'id'>) => void;
  deleteGig: (id: string) => void;
}

export const useGigStore = create<GigState>((set) => ({
  gigs: [
    { id: '1', title: 'E-commerce Redesign', client: 'TechFlow Inc', amount: 4500, status: 'ACTIVE' },
    { id: '2', title: 'SaaS Dashboard', client: 'CloudScale', amount: 7200, status: 'PENDING' },
    { id: '3', title: 'Mobile App API', client: 'Velocity Soft', amount: 4000, status: 'COMPLETED' }
  ],
  addGig: (gig) => set((state) => ({
    gigs: [...state.gigs, { ...gig, id: Date.now().toString() }]
  })),
  deleteGig: (id) => set((state) => ({
    gigs: state.gigs.filter((g) => g.id !== id)
  }))
}));

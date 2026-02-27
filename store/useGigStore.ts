import { create } from 'zustand';
import { Gig } from '@/types';

interface GigState {
  gigs: Gig[];
  addGig: (gig: Gig) => void;
  removeGig: (id: string) => void;
}

export const useGigStore = create<GigState>((set) => ({
  gigs: [],
  addGig: (gig) => set((state) => ({ gigs: [...state.gigs, gig] })),
  removeGig: (id) => set((state) => ({ gigs: state.gigs.filter((g) => g.id !== id) })),
}));

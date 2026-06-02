import { create } from 'zustand';

export const useGigStore = create((set) => ({
  gigs: [],
  addGig: (_gig: any) => set({}),
  removeGig: (_id: string) => set({}),
}));

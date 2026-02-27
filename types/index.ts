export interface Gig {
  id: string;
  title: string;
  client: string;
  status: 'active' | 'completed' | 'pending';
  budget: number;
  deadline: string;
}

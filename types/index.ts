export interface Gig {
  id: string;
  title: string;
  client: string;
  status: 'active' | 'completed' | 'pending';
  budget: number;
  deadline: string;
  amount?: number;  // actual earnings/paid amount (used in PDFExport + future revenue charts)
}

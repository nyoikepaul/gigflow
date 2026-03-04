'use client';

import jsPDF from 'jspdf';
import { Download } from 'lucide-react';
import { useGigStore } from '@/store/useGigStore';

export default function PDFExport() {
  const gigs = useGigStore((state) => state.gigs);

  const exportPDF = () => {
    const doc = new jsPDF();
    doc.setFontSize(22);
    doc.text('GigFlow — $10k+/month Pipeline', 20, 25);

    let y = 50;
    gigs.forEach((gig, i) => {
      doc.setFontSize(14);
      doc.text(`${i + 1}. ${gig.title || 'Gig'}`, 20, y);
      doc.setFontSize(11);
      doc.text(`Client: ${gig.client || 'Upwork'} • $${gig.amount || '0'}`, 25, y + 8);
      y += 30;
    });

    doc.setFontSize(10);
    doc.text(`Generated on ${new Date().toLocaleDateString()}`, 20, y + 10);
    doc.save('GigFlow-Pipeline.pdf');
  };

  return (
    <button
      onClick={exportPDF}
      className="flex items-center gap-3 px-8 py-4 bg-gradient-to-r from-violet-600 to-indigo-600 hover:from-violet-700 hover:to-indigo-700 rounded-3xl font-semibold text-white shadow-xl shadow-violet-500/30 transition-all active:scale-95"
    >
      <Download className="w-5 h-5" />
      Export PDF for Client / Portfolio
    </button>
  );
}

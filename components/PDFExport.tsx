'use client';

import jsPDF from 'jspdf';
import { Download } from 'lucide-react';
import { useGigStore, Gig } from '@/store/useGigStore';

export default function PDFExport() {
  const gigs = useGigStore((state) => state.gigs);

  const exportPDF = () => {
    const doc = new jsPDF();
    doc.setFontSize(22);
    doc.text('GigFlow - Pipeline Report', 20, 25);

    let y = 50;
    gigs.forEach((gig: Gig, i: number) => {
      if (y > 270) {
        doc.addPage();
        y = 20;
      }
      doc.setFontSize(14);
      doc.text(`${i + 1}. ${gig.title || 'Untitled Gig'}`, 20, y);
      doc.setFontSize(11);
      doc.text(`Client: ${gig.client || 'N/A'}  |  Budget: $${gig.amount || 0}  |  Status: ${gig.status}`, 25, y + 8);
      y += 25;
    });

    doc.setFontSize(10);
    doc.text(`Generated on ${new Date().toLocaleDateString()}`, 20, y + 10);
    doc.save('GigFlow-Pipeline.pdf');
  };

  return (
    <button
      onClick={exportPDF}
      className="flex items-center gap-2 px-4 py-2 bg-violet-600 hover:bg-violet-700 active:scale-95 transition-all text-white font-medium rounded-lg text-sm shadow-md shadow-violet-900/20"
    >
      <Download className="w-4 h-4" />
      Export PDF
    </button>
  );
}

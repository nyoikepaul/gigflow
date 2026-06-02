import { create } from 'zustand';

interface ContractMetrics {
  grossAmount: number;
  upworkFee: number;
  localTaxReserve: number;
  netPayoutUSD: number;
  netPayoutKES: number;
}

interface ContractState {
  exchangeRateUSDToKES: number;
  grossAmount: number;
  setContract: (_payload: any) => void;
  removeContract: (_id: string) => void;
  updateContractStatus: (_id: string, _newStatus: string) => void;
  getActiveFinancialMetrics: () => ContractMetrics;
}

export const useContractStore = create<ContractState>((set, get) => ({
  exchangeRateUSDToKES: 130.00,
  grossAmount: 5000,
  setContract: (_payload) => set({}),
  removeContract: (_id) => set({}),
  updateContractStatus: (_id, _newStatus) => set({}),
  getActiveFinancialMetrics: () => {
    const gross = get().grossAmount;
    const rate = get().exchangeRateUSDToKES;
    const upworkFee = gross * 0.10;
    const localTaxReserve = gross * 0.05;
    const netPayoutUSD = gross - upworkFee - localTaxReserve;
    const netPayoutKES = netPayoutUSD * rate;

    return {
      grossAmount: gross,
      upworkFee,
      localTaxReserve,
      netPayoutUSD,
      netPayoutKES,
    };
  },
}));

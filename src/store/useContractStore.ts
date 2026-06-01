import { create } from 'zustand';
import { ContractEntity } from '../lib/validations/contract.schema';
import { FinanceEngine, FinancialSummary } from '../lib/domain/finance-engine';

interface ContractState {
  contracts: ContractEntity[];
  activeContractId: string | null;
  exchangeRateUSDToKES: number;
  seedContracts: (payload: ContractEntity[]) => void;
  setActiveContract: (id: string) => void;
  transitionContractStatus: (id: string, newStatus: ContractEntity['status']) => void;
  getActiveFinancialMetrics: () => FinancialSummary | null;
}

export const useContractStore = create<ContractState>((set, get) => ({
  contracts: [],
  activeContractId: null,
  exchangeRateUSDToKES: 132.50,

  seedContracts: (payload) => set({ 
    contracts: payload,
    activeContractId: payload.length > 0 ? payload[0].id : null 
  }),

  setActiveContract: (id) => set({ activeContractId: id }),

  transitionContractStatus: (id, newStatus) => set((state) => ({
    contracts: state.contracts.map((contract) => 
      contract.id === id ? { ...contract, status: newStatus } : contract
    )
  })),

  getActiveFinancialMetrics: () => {
    const { contracts, activeContractId, exchangeRateUSDToKES } = get();
    const activeContract = contracts.find((c) => c.id === activeContractId);
    
    if (!activeContract) return null;
    
    return FinanceEngine.calculateMilestoneBreakdown(
      activeContract.grossBudgetUSD, 
      exchangeRateUSDToKES
    );
  }
}));

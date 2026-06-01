export interface FinancialSummary {
  grossAmount: number;
  upworkFee: number;
  localTaxReserve: number;
  netPayoutUSD: number;
  netPayoutKES: number;
}

export class FinanceEngine {
  private static UPWORK_FEE_RATE = 0.10; // 10% Flat Upwork platform service tier
  private static RETENTION_TAX_RATE = 0.05; // 5% Localized withholding/withdrawn target buffer

  /**
   * Deterministically parses gross milestone contract fees down to absolute net values.
   */
  public static calculateMilestoneBreakdown(
    grossAmount: number, 
    exchangeRateUSDToKES: number
  ): FinancialSummary {
    if (grossAmount <= 0) {
      return { grossAmount: 0, upworkFee: 0, localTaxReserve: 0, netPayoutUSD: 0, netPayoutKES: 0 };
    }

    const upworkFee = Math.round(grossAmount * this.UPWORK_FEE_RATE * 100) / 100;
    const netAfterPlatform = grossAmount - upworkFee;
    const localTaxReserve = Math.round(netAfterPlatform * this.RETENTION_TAX_RATE * 100) / 100;
    
    const netPayoutUSD = Math.round((netAfterPlatform - localTaxReserve) * 100) / 100;
    const netPayoutKES = Math.round(netPayoutUSD * exchangeRateUSDToKES * 100) / 100;

    return {
      grossAmount,
      upworkFee,
      localTaxReserve,
      netPayoutUSD,
      netPayoutKES
    };
  }
}

import { z } from 'zod';

export const ContractStatusSchema = z.enum(['PROPOSAL', 'ACTIVE_ESCROW', 'MILESTONE_PENDING', 'COMPLETED', 'ARCHIVED']);
export const BillingTypeSchema = z.enum(['HOURLY', 'FIXED_PRICE']);

export const ContractEntitySchema = z.object({
  id: z.string().uuid(),
  clientName: z.string().min(2, "Client identity trace must satisfy minimal length properties."),
  title: z.string().min(3, "Contract naming context is structurally invalid."),
  billingType: BillingTypeSchema,
  status: ContractStatusSchema,
  grossBudgetUSD: z.number().positive("Financial allocation fields must be greater than zero."),
  exchangeRateSnapshot: z.number().gt(100, "Transient FX metrics bounds out of scale parameters."),
  createdAt: z.date().default(() => new Date())
});

export type ContractEntity = z.infer<typeof ContractEntitySchema>;

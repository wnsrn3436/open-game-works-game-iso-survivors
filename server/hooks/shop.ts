import type { ItemLedgerContent } from '../core/item-ledger/index.ts';
import type { ShopProductHook } from '../core/shop/index.ts';
import type { RequestCtx } from '../core/storage/index.ts';
import * as GameContract from '../generated/contract/game_contract.ts';

/**
 * `validate_shop_purchase`: a product that is a step of a permanent upgrade (`upgrade_step`) is bought only as the next
 * step: the user's level of that upgrade is the step level − 1, and the quantity is 1. Other products pass.
 */
export function validate_upgrade_step(items: ItemLedgerContent): ShopProductHook {
  return (ctx: RequestCtx, product_id: number, quantity: number) => {
    if (!ctx.data.UpgradeStepTable.has_row(product_id)) return 'pass';
    const step = ctx.data.UpgradeStepTable.get_row(product_id);
    if (quantity !== 1 || items.get_balance(ctx, step.upgrade) !== BigInt(step.level - 1)) {
      return GameContract.GameError.GAME_ERROR_UPGRADE_ORDER;
    }
    return 'pass';
  };
}

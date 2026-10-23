import type { ItemLedgerContent } from './core/item-ledger/index.ts';
import type { ApplyHook, PrepareHook, VerifyHook } from './core/play-session/index.ts';
import type { ShopProductHook } from './core/shop/index.ts';
import type { StorageContent } from './core/storage/index.ts';
import type { IntegerOps } from './common/run_reward.ts';
import { apply_run, prepare_run, verify_run } from './hooks/play_session.ts';
import { validate_upgrade_step } from './hooks/shop.ts';

/** The `core` object of `register`: the module objects this content uses. */
export interface RegisterCore {
  readonly routing: {
    register_hook(module: 'play-session', hook: 'prepare_play_session', fn: PrepareHook): void;
    register_hook(module: 'play-session', hook: 'verify_play_session', fn: VerifyHook): void;
    register_hook(module: 'play-session', hook: 'apply_play_session', fn: ApplyHook): void;
    register_hook(module: 'shop', hook: 'validate_shop_purchase', fn: ShopProductHook): void;
  };
  readonly storage: StorageContent;
  readonly 'item-ledger': ItemLedgerContent;
  readonly validation: IntegerOps;
}

/**
 * Registers the hooks of the run and of the lantern shrine. The game has no `service Game` `rpc`: a run starts with the
 * core `StartPlaySession` and ends with the core `FinishPlaySession`, whose hooks check the result, grant the run gold
 * and count the run; a permanent upgrade is a core `BuyShopProduct` whose hook keeps the upgrade steps in order.
 */
export function register(core: RegisterCore): void {
  const items = core['item-ledger'];
  core.routing.register_hook('play-session', 'prepare_play_session', prepare_run(core.storage, items));
  core.routing.register_hook('play-session', 'verify_play_session', verify_run(core.validation));
  core.routing.register_hook('play-session', 'apply_play_session', apply_run(core.storage, items, core.validation));
  core.routing.register_hook('shop', 'validate_shop_purchase', validate_upgrade_step(items));
}

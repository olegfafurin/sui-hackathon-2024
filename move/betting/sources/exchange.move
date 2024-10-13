module betting::exchange {

    use betting::proposal::BetProposal;
    use sui::balance::Balance;
    use sui::table::Table;
    use sui::sui::SUI;
    use sui::coin::Coin;
    use sui::clock::Clock;
    //use sui::table::{Self, Table};
    //use sui::balance::{Self, Balance};
    //use betting::proposal::{BetProposal, newBetProposal};

    public struct ExchangeAdminCap has key, store { id: UID }

    public struct Exchange has key {
        id: UID,
        // proposalsByUser: Table<address, vector<BetProposal>>,
        // contractsByUser: Table<address, vector<BetContract>>,
        proposals: vector<BetProposal>,
        balance: Balance<SUI>,
    }

    fun init(ctx: &mut TxContext) {
        // Transfers the ShopOwnerCap to the sender (publisher).
        transfer::transfer(ExchangeAdminCap {
            id: object::new(ctx)
        }, ctx.sender());

        // Shares the Exchange object.
        transfer::share_object(Exchange {
            id: object::new(ctx),
            // proposalsByUser: table::new<address, vector<BetContract>>(ctx),
            // contractsByUser: table::new<address, vector<BetContract>>(ctx),
            proposals: vector<BetProposal>,
            balance: balance::zero(),
        });
    }

    public fun proposeBet(ctx: &mut TxContext,
                          exchange: &mut Exchange,
                          image_url: string::String,
                          description: string::String,
                          c: Coin<SUI>,
                          coefficient: u64,
                          expiry_time: u64,
                          payoff_time: u64): BetProposal {

        assert!(expiry_time > clock.timestamp_ms(), 1);
        // Ensure payoff time is after expiry time
        assert!(payoff_time > expiry_time, 2);

        let bp = BetProposal {
            id: object::new(ctx),
            image_url,
            description,
            c,
            coefficient,
            expiry_time,
            payoff_time,
            address_of_bet_creator: ctx.sender(),
        };
        exchange.proposals.add(bp);
        return bp;
    }

    public fun retractBet(ctx: &mut TxContext, exchange: &mut Exchange, bp: &mut BetProposal): bool {
        //assert!(ctx.sender() == bp.address_of_bet_creator, 1);
        assert!(ctx.sender() == betting::proposal::get_address_of_bet_creator(bp), 1);

        let len = std::vector::length(exchange.proposals);
        let mut i = 0;
        while (i < len) {
            let elem_ref = std::vector::borrow(exchange.proposals, i);
            if (elem_ref == bp) {
                std::vector::remove(exchange.proposals, i);
                object::delete(bp.id);
                return true;
            };
            i = i + 1;
        };
        return false;
    }

    // public fun acceptBet(ctx: &mut TxContext, exchange: &mut Exchange, bp: &mut BetProposal) {}


}
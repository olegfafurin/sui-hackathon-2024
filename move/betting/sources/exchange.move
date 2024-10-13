module betting::exchange {

    // as in examples::donuts in online tutorial
    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::object::{Self, UID};
    use sui::balance::{Self, Balance};
    use sui::tx_context::{Self, TxContext};

    // personal imports
    use betting::proposal::BetProposal;
    use betting::contract::BetContract;
    use sui::table::Table;
    use sui::clock::Clock;

    //use sui::coin::Coin;
    //use sui::table::{Self, Table};
    //use betting::proposal::{BetProposal, newBetProposal};


    // for when Coin balance is too low
    const ENotEnoughBalance: u64 = 0;

    // capability that grants an owner the ability to collect profits
    public struct ExchangeAdminCap has key { id: UID }

    // each BetProposal is purchasable on the exchange
    // the BetProposals are stored in a vector


    public struct Exchange has key {
        id: UID,
        // proposalsByUser: Table<address, vector<BetProposal>>,
        // contractsByUser: Table<address, vector<BetContract>>,
        v_proposals: vector<BetProposal>,
        validBets: vector<BetContract>,
        balance: Balance<SUI>,
    }

    fun init(ctx: &mut TxContext) {
        // Transfers the ExchangeAdminCap to the sender (publisher).
        transfer::transfer(ExchangeAdminCap {
            id: object::new(ctx)
        }, ctx.sender());

        // Shares the Exchange object to make it accessible to everyone.
        transfer::share_object(Exchange {
            id: object::new(ctx),
            // proposalsByUser: table::new<address, vector<BetContract>>(ctx),
            // contractsByUser: table::new<address, vector<BetContract>>(ctx),
            v_proposals: vector::empty<BetProposal>(),
            validBets: vector::empty<BetContract>(),
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
        exchange.v_proposals.add(bp);
        return bp;
    }

    public fun retractBet(ctx: &mut TxContext, exchange: &mut Exchange, bp: &mut BetProposal): bool {
        //assert!(ctx.sender() == bp.address_of_bet_creator, 1);
        assert!(ctx.sender() == betting::proposal::get_address_of_bet_creator(bp), 1);

        let len = vector::length(exchange.v_proposals);
        let mut i = 0;
        while (i < len) {
            let elem_ref = vector::borrow(exchange.v_proposals, i);
            if (elem_ref == bp) {
                vector::remove(exchange.v_proposals, i);
                object::delete(bp.id);
                return true;
            };
            i = i + 1;
        };
        return false;
    }

    // public fun acceptBet(ctx: &mut TxContext, exchange: &mut Exchange, bp: &mut BetProposal) {}


}
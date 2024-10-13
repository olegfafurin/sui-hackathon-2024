#[allow(unused_use)]
module betting::exchange {

    // as in examples::donuts in online tutorial
    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};


    // personal imports
    use betting::proposal::BetProposal;
    use betting::contract::BetContract;
    use sui::table::Table;
    use sui::clock::Clock;

    //use sui::coin::Coin;
    //use sui::table::{Self, Table};
    //use betting::proposal::{BetProposal, newBetProposal};

    public struct Exchange has key, store {
        id: UID,
        v_proposals: vector<BetProposal>,
        v_validBets: vector<BetContract>,
    }

    public fun newExchange(ctx: &mut TxContext): Exchange {
        Exchange {
            id: object::new(ctx),
            v_proposals: vector::empty(),
            v_validBets: vector::empty(),
        }


    }

    fun  init(ctx: &mut TxContext) {
        // Shares the Exchange object.
        let obj = Exchange {
            id: object::new(ctx),
            v_proposals: vector::empty(),
            v_validBets: vector::empty(),
        };

        transfer::share_object(obj);
    }






    public fun proposeBet(
        ctx: &mut TxContext, 
        exchange: &mut Exchange, 
        description: std::string::String,
        c: Coin<SUI>, 
        coefficient: u64,
        expiry_time: u64,
        payoff_time: u64,
        clock: &Clock, 
        address_of_bet_creator: address
    ) {

        assert!(expiry_time > clock.timestamp_ms(), 11);
        // Ensure payoff time is after expiry time
        assert!(payoff_time > expiry_time, 12);

        let bp = betting::proposal::make_proposal(ctx, clock, description, c, coefficient, expiry_time, payoff_time, address_of_bet_creator); 

        exchange.v_proposals.push_back(bp);

    }

    public fun my_main(ctx: &mut TxContext, exchange: &mut Exchange) {
        proposeBet(ctx, Exchange, std::string::utf8(b"Hello World!"), Coin::new(100), 2, 3, 4, clock, address);
    }
    

    // equivalent to 'buy_donut' in examples::donuts
    public fun acceptBet(exchange: &mut Exchange, c: Coin<SUI>, ctx: &mut TxContext, proposal_idx: u64, address_of_bet_taker: address, clock: &Clock) {
        let len = vector::length(&exchange.v_proposals);
        assert!(len > 0, 100);
        assert!(proposal_idx < len, 10);
        let bp = vector::swap_remove(&mut exchange.v_proposals, proposal_idx);


        let valid_contract = betting::contract::make_contract(
            ctx, 
            clock,
            bp, 
            address_of_bet_taker, 
            c
        );

        vector::push_back(&mut exchange.v_validBets, valid_contract);

    }

}
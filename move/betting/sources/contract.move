module betting::contract {
    use sui::clock::Clock;
    use sui::coin::Coin;
    use betting::proposal::BetProposal;
    use sui::sui::SUI;
    use sui::coin::split;

    /// Structure representing a bet contract
    #[allow(lint(coin_field))]
    public struct BetContract has key, store {
        id: sui::object::UID,
        proposal: BetProposal,
        address_of_bet_taker: address,
        c: Coin<SUI>
    }

    /// Function to create a new bet contract
    public fun new(
        ctx: &mut tx_context::TxContext,
        clock: &Clock,
        proposal: BetProposal,
        address_of_bet_taker: address,
        c: Coin<SUI>,
    ): BetContract {
        // Ensure expiry time is in the future
        assert!(!betting::proposal::is_expired(clock, &proposal), 3);
        assert!(c.value() == betting::proposal::get_amount_to_accept_bet(&proposal), 4);

        BetContract {
            id: object::new(ctx),
            proposal,
            address_of_bet_taker,
            c
        }
    }

    // function that returns a BetContract object so that it can be used in exchange.move
    public fun make_contract(ctx: &mut tx_context::TxContext, clock: &Clock, proposal: BetProposal, address_of_bet_taker: address, c: Coin<SUI>): BetContract {
        new(ctx, clock, proposal, address_of_bet_taker, c)
    }



    public fun pay_out(contract: &mut BetContract, winner: address, broker: address, commission_percentage: u64, ctx: &mut tx_context::TxContext) {
        let total_value = contract.c.value();
        let commission = total_value * commission_percentage / 100;

        let commission_coin = split(&mut contract.c, commission, ctx);
        let winnings_coin = split(&mut contract.c, total_value - commission, ctx);
        
        transfer::public_transfer(commission_coin, broker);
        transfer::public_transfer(winnings_coin, winner);
    }
}
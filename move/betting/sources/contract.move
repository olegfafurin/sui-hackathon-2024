module betting::contract {
    use sui::clock::Clock;
    use sui::coin::Coin;
    use betting::betting::BetProposal;
    use sui::sui::SUI;

    /// Structure representing a bet contract
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
        assert!(!betting::betting::is_expired(clock, &proposal), 3);
        assert!(c.value() == betting::betting::get_amount_to_accept_bet(&proposal), 4);

        BetContract {
            id: object::new(ctx),
            proposal,
            address_of_bet_taker,
            c
        }
    }








}
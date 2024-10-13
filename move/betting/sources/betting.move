/*
/// Module: betting
module betting::proposal;
*/

module betting::proposal {

    use std::string;
    use sui::clock::Clock;
    use sui::sui::SUI;
    use sui::coin::Coin;

    /// Structure representing a bet proposal
    #[allow(lint(coin_field))]
    public struct BetProposal has key, store {
        id: sui::object::UID,
        image_url: string::String,      // URL to the image representing the bet
        description: string::String,    // Description of the bet
        c: Coin<SUI>,                         // Desired sum of the stake
        coefficient: u64,               // Real-valued coefficient for the bet
        expiry_time: u64,               // Expiry time of the bet as a timestamp
        payoff_time: u64,               // Payoff time as a timestamp
        address_of_bet_creator: address
    }

    /// Function to create a new bet proposal
    public fun new(
        ctx: &mut tx_context::TxContext,
        clock: &Clock,
        image_url: string::String,
        description: string::String,
        c: Coin<SUI>,
        coefficient: u64,
        expiry_time: u64,
        payoff_time: u64,
        address_of_bet_creator: address
    ): BetProposal {
        // Ensure expiry time is in the future
        assert!(expiry_time > clock.timestamp_ms(), 1);
        // Ensure payoff time is after expiry time
        assert!(payoff_time > expiry_time, 2);

        BetProposal {
            id: object::new(ctx),
            image_url,
            description,
            c,
            coefficient,
            expiry_time,
            payoff_time,
            address_of_bet_creator
        }
    }

    
    /// Function to check if the bet proposal has expired
    public fun is_expired(clock: &Clock, bet: &BetProposal): bool {
        clock.timestamp_ms() > bet.expiry_time
    }

    /// Function to check if it's time for the payoff
    public fun is_payoff_time(clock: &Clock, bet: &BetProposal): bool {
        clock.timestamp_ms() >= bet.payoff_time
    }

    public fun get_amount_to_accept_bet(bet: &BetProposal): u64 {
        bet.c.value() * bet.coefficient
    }

    public fun get_bet_creator_address(bet: &BetProposal): address {
        bet.address_of_bet_creator
    }

    public fun get_address_of_bet_creator(bet: &BetProposal): address {
        bet.address_of_bet_creator
    }

}

/*
/// Module: betting
module betting::betting;
*/

module betting::betting {

    use std::string;
    use sui::clock::Clock;

    /// Structure representing a bet proposal
    public struct BetProposal has key, store {
        id: sui::object::UID,
        image_url: string::String,      // URL to the image representing the bet
        description: string::String,    // Description of the bet
        stake: u64,                     // Desired sum of the stake
        coefficient: u64,               // Real-valued coefficient for the bet
        expiry_time: u64,               // Expiry time of the bet as a timestamp
        payoff_time: u64,               // Payoff time as a timestamp
    }

    /// Function to create a new bet proposal
    public fun new(
        ctx: &mut tx_context::TxContext,
        clock: &Clock,
        image_url: string::String,
        description: string::String,
        stake: u64,
        coefficient: u64,
        expiry_time: u64,
        payoff_time: u64,
    ): BetProposal {
        // Ensure expiry time is in the future
        assert!(expiry_time > clock.timestamp_ms(), 1);
        // Ensure payoff time is after expiry time
        assert!(payoff_time > expiry_time, 2);

        BetProposal {
            id: object::new(ctx),
            image_url,
            description,
            stake,
            coefficient,
            expiry_time,
            payoff_time
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
}

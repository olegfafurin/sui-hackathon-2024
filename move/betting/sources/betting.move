/*
/// Module: betting
module betting::betting;
*/

module betting::betting {

    use std::string;
    use std::option;
    use sui::clock;
    use sui::tx_context;
    use sui::object;

    /// Structure representing a bet proposal
    public struct BetProposal has key, copy, drop, store {
        id: sui::object::UID,
        image_url: string::String,      // URL to the image representing the bet
        description: string::String,    // Description of the bet
        stake: u64,                     // Desired sum of the stake
        coefficient: f64,               // Real-valued coefficient for the bet
        expiry_time: u64,               // Expiry time of the bet as a timestamp
        payoff_time: u64,               // Payoff time as a timestamp
    }

    /// Function to create a new bet proposal
    public fun init(
        image_url: string::String,
        description: string::String,
        stake: u64,
        coefficient: f64,
        expiry_time: u64,
        payoff_time: u64,
        ctx: &mut tx_context::TxContext
    ): BetProposal {
        // Ensure expiry time is in the future
        assert!(expiry_time > clock::now(), 1);
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
    public fun is_expired(bet: &BetProposal): bool {
        clock::now() > bet.expiry_time
    }

    /// Function to check if it's time for the payoff
    public fun is_payoff_time(bet: &BetProposal): bool {
        clock::now() >= bet.payoff_time
    }
}

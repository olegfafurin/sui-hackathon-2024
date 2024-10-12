module betting::exchange {

    use betting::betting::BetProposal;

    public struct ExchangeAdminCap has key, store { id: UID }

    public struct Exchange has key {
        id: UID,
        proposalsByUser: Table<address, vector<BetProposal>>,
        contractsByUser: Table<address, vector<BetContract>>,
    }

    fun init(ctx: &mut TxContext) {
        // Transfers the ShopOwnerCap to the sender (publisher).
        transfer::transfer(ExchangeAdminCap {
            id: object::new(ctx)
        }, ctx.sender());

        // Shares the Exchange object.
        transfer::share_object(Exchange {
            id: object::new(ctx),
            proposalsByUser: table::new<address, vector<BetContract>>(ctx),
            contractsByUser: table::new<address, vector<BetContract>>(ctx),
        });
    }
}

# There will be a Betting App project for BSA 2024

Welcome to the [BSA](https://bsaepfl.ch/) x [SUI](https://sui.io/) Hackathon Official Starter Pack ! This kit should provide you with tons of tools to make your hackathon experience seamless and easy, so ou can focus on what you do best ! 

This starter pack was made by BSA comitee member [Loris](https://github.com/Loris-EPFL), feel free to contact me for any questions, bug reports, etc...

This dApp was created using `@mysten/create-dapp` that sets up a basic React
Client dApp using the following tools:

- [React](https://react.dev/) as the UI framework
- [TypeScript](https://www.typescriptlang.org/) for type checking
- [Vite](https://vitejs.dev/) for build tooling
- [TailwindCSS](https://tailwindcss.com/) for styling classes
- [Daisy UI](https://daisyui.com/) for pre-built UI components
- [ESLint](https://eslint.org/) for linting
- [`@mysten/dapp-kit`](https://sdk.mystenlabs.com/dapp-kit) for connecting to
  wallets and loading data
- [pnpm](https://pnpm.io/) for package management

IMPORTANT ! : To select your desired network for the dapp, create a .env file at the root of the project, add either VITE_NETWORK="testnet" for testnet or VITE_NETWORK="mainnet" for mainnet. Dapp default to testnet if no .env file is provided.

For a full guide on how to build this dApp from scratch, visit this
[guide](http://docs.sui.io/guides/developer/app-examples/e2e-counter#frontend).

## Deploying your Move code

### Install Sui cli

Before deploying your move code, ensure that you have installed the Sui CLI. You
can follow the [Sui installation instruction](https://docs.sui.io/build/install)
to get everything set up.

This template uses `testnet` by default, so we'll need to set up a testnet
environment in the CLI:

```bash
sui client new-env --alias testnet --rpc https://fullnode.testnet.sui.io:443
sui client switch --env testnet
```

If you haven't set up an address in the sui client yet, you can use the
following command to get a new address:

```bash
sui client new-address secp256k1
```

This well generate a new address and recover phrase for you. You can mark a
newly created address as you active address by running the following command
with your new address:

```bash
sui client switch --address 0xYOUR_ADDRESS...
```

We can ensure we have some Sui in our new wallet by requesting Sui from the
faucet (make sure to replace the address with your address):

```bash
curl --location --request POST 'https://faucet.testnet.sui.io/gas' \
--header 'Content-Type: application/json' \
--data-raw '{
    "FixedAmountRequest": {
        "recipient": "<YOUR_ADDRESS>"
    }
}'
```

### Publishing the move package

The move code for this template is located in the `move` directory. To publish
it, you can enter the `move` directory, and publish it with the Sui CLI:

```bash
cd move
sui client publish --gas-budget 100000000 counter
```

In the output there will be an object with a `"packageId"` property. You'll want
to save that package ID to the `src/constants.ts` file as `PACKAGE_ID`:

```ts
export const TESTNET_COUNTER_PACKAGE_ID = "<YOUR_PACKAGE_ID>";
```

Now that we have published the move code, and update the package ID, we can
start the app.

## Starting your dApp

To install dependencies you can run

```bash
pnpm install
```

To start your dApp in development mode run

```bash
pnpm dev
```

## Building

To build your app for deployment you can run

```bash
pnpm build
```

# Netherbus-Docker

## Usage

1. ```sh
   cp default.env .env
   cp default.nethermind.env nethermind.env
   ```
1. Edit `.env` and `nethermind.env`
1. Create JWT secret and save it in `jwtsecret.txt`. E.g. run
   ```sh
   openssl rand -hex 32 | tr -d "\n" > "jwtsecret.txt"
   ```
1. Create a secret for the keymanager API and save it in `keymanagersecret.txt`. You can use the `openssl` invocation above.
1. If you are a validator, create a folder named `validator_keys` and place your validator keystores in the folder. Add keystore encryption key to `.env`.
1. ```sh
   ./start.sh
   ```

## (Optional) Sync from a trusted node

Run the following commands in shell to fetch the current state of the consensus layer chain.
If your Beacon API provider is not rate limiting you (free plans of third-party API providers typically rate limit),
you should omit the `--backfill=false` flag to also obtain full block history.

```sh
# Set a working Beacon API URL here. Does not need to be provided by Infura
beacon_api_url=https://272GSCR2NRpg5n55qsSc4y5sMD8:4c9e4d691e34ge523456bb29f3e0332f@eth2-beacon-mainnet.infura.io

mkdir nimbus-snapshot
docker run -i --rm \
    -v ${PWD}/nimbus-snapshot:/home/user/nimbus-eth2/build/data -u $(id -u):$(id -g) \
    statusim/nimbus-eth2:amd64-latest trustedNodeSync --network=mainnet --data-dir=/home/user/nimbus-eth2/build/data --trusted-node-url=${beacon_api_url} --backfill=false
```

Now check that the checkpoint block root hash (printed in the last log message) is that of the canonical chain (compare to block explorers, friends etc.).
Then move `nimbus-snapshot/db` to your `$CONSENSUS_DATA` directory.

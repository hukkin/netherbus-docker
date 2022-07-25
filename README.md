1. `cp default.env .env`
1. Edit `.env`
1. Create JWT secret and save it in `jwtsecret.txt`. E.g. run
   ```console
   openssl rand -hex 32 | tr -d "\n" > "jwtsecret.txt"
   ```
1. If you are a validator, create a folder named `validator_keys` and place your validator keystores in the folder. Add keystore encryption key to `.env`.
1. `./start.sh`
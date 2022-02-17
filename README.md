# tzs-ever-bridge-ligo-contract

# Scripts usage
## Deposit contract
### Compile storage
Located in `scripts/deposit`
```
./compile_storage QUORUM_ADDRESS ADMIN_ADDRESS
```
* `QUORUM_ADDRESS` &ndash; valid Tezos contract address string
* `ADMIN_ADDRESS` &ndash; valid Tezos address string

## Quorum contract
### Compile storage
Located in `scripts/quorum`
```
./compile_storage TRUSTED_FILENAME THRESHOLD DEPOSIT_ADDRESS ADMIN_ADDRESS
```
* `TRUSTED_FILENAME` &ndash; path to file containing trusted addresses, one on each line. The file must not be empty.
  
  Example file:

  ```
  tz1VSUr8wwNhLAzempoch5d6hLRiTh8Cjcjb
  tz1aSkwEot3L2kmUvcoxzjMomb9mvBNuzFK6
  tz1aSkwEot3L2kmUvcoxzjMomb9mvBNuzFK6
  ```
* `THRESHOLD` &ndash; transaction approval threshold, a positive integer
* `DEPOSIT_ADDRESS` &ndash; valid Tezos contract address string
* `ADMIN_ADDRESS` &ndash; valid Tezos address string

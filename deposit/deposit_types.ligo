#if !DEPOSIT_TYPES
#define DEPOSIT_TYPES

type everscale_address is string
type tezos_address is address

type parameter is
  Deposit of everscale_address
| Withdraw of tezos_address * tez
| SetQuorumAddress of tezos_address
| SetAdminAddress of tezos_address

type storage is record [
  quorum_address : tezos_address;
  admin_address : tezos_address
]

type return is list (operation) * storage

const no_operations = (nil : list (operation))

#endif
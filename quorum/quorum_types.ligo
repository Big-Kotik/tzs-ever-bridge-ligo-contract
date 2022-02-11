#if !QUORUM_TYPES
#define QUORUM_TYPES

type transfer is [@layout:comb] record [
  receiver : address;
  amt : tez
]

type approvals is set (address)

type storage is record [
  trusted_addresses : set (address);
  transfer_approvals : big_map (transfer, approvals);
  threshold : nat;
  deposit_address : address;
  admin_address : address;
]

type parameter is
  ApproveTransfer of transfer
| SendTransfer of transfer
| AddTrustedAddress of address
| RemoveTrustedAddress of address
| SetThreshold of nat
| SetDepositAddress of address
| SetAdminAddress of address

type deposit_parameter is Withdraw of address * tez

type deposit_contract is contract (deposit_parameter)

type return is list (operation) * storage

const no_operations = (nil : list (operation))

#endif
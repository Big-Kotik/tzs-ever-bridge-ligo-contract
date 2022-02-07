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

function validate_deposit (const everscale_addr : everscale_address) : unit is 
  if Tezos.amount = 0tez then (failwith ("Can't deposit 0 tez") : unit) else unit
  
function validate_withdraw (const s : storage) : unit is
  if Tezos.sender =/= s.quorum_address then (failwith ("Unauthorized withdrawal") : unit) else unit

function validate_admin (const s : storage) : unit is 
  if Tezos.sender =/= s.admin_address then (failwith ("Unauthorized address change") : unit) else unit

function deposit (const everscale_addr : everscale_address; const s : storage) : return is 
  block {
    validate_deposit (everscale_addr)
  } with (no_operations, s)

function withdraw (const receiver_addr : tezos_address; const amt : tez; const s : storage) : return is
  block {
    validate_withdraw (s);
    const receiver_wallet : contract (unit) = 
      case (Tezos.get_contract_opt (receiver_addr) : option (contract (unit))) of
        Some (c) -> c
      | None -> (failwith ("Receiver not found") : contract (unit))
      end
  } with (list [Tezos.transaction (unit, amt, receiver_wallet)], s)

function set_quorum_address (const quorum_addr : tezos_address; const s : storage) : return is 
  block {
    validate_admin (s)
  } with (no_operations, s with record [quorum_address = quorum_addr])

function set_admin_address (const admin_addr: tezos_address; const s : storage) : return is
  block {
    validate_admin (s)
  } with (no_operations, s with record [admin_address = admin_addr])

function main (const p : parameter; const s : storage) : return is 
  case p of
    Deposit (everscale_addr) -> deposit (everscale_addr, s)
  | Withdraw (receiver_addr, amt) -> withdraw (receiver_addr, amt, s)
  | SetQuorumAddress (quorum_addr) -> set_quorum_address (quorum_addr, s)
  | SetAdminAddress (admin_addr) -> set_admin_address (admin_addr, s)
  end
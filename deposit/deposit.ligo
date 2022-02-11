#include "deposit_types.ligo"
#include "deposit_admin_ops.ligo"

function validate_deposit (const everscale_addr : everscale_address) : unit is 
  if Tezos.amount = 0tez then 
    (failwith ("Can't deposit 0 tez") : unit) 
  else 
    unit
  
function validate_withdraw (const s : storage) : unit is
  if Tezos.sender =/= s.quorum_address then 
    (failwith ("Unauthorized withdrawal") : unit) 
  else 
    unit

function deposit (const everscale_addr : everscale_address; const s : storage) : return is 
  block {
    validate_deposit (everscale_addr)
  } with (no_operations, s)

function withdraw (const receiver_address : tezos_address; const amt : tez; const s : storage) : return is
  block {
    validate_withdraw (s);
    const receiver_wallet : contract (unit) = 
      case (Tezos.get_contract_opt (receiver_address) : option (contract (unit))) of
        Some (c) -> c
      | None -> (failwith ("Receiver not found") : contract (unit))
      end
  } with (list [Tezos.transaction (unit, amt, receiver_wallet)], s)

function main (const p : parameter; const s : storage) : return is 
  case p of
    Deposit (everscale_addr) -> deposit (everscale_addr, s)
  | Withdraw (receiver_address, amt) -> withdraw (receiver_address, amt, s)
  | SetQuorumAddress (quorum_address) -> set_quorum_address (quorum_address, s)
  | SetAdminAddress (admin_address) -> set_admin_address (admin_address, s)
  end
#include "quorum_types.ligo"
#include "quorum_admin_ops.ligo"

function get_approval_count (const t : transfer; const s : storage) : nat is
  case (s.transfer_approvals [t] : option (approvals)) of [
    Some (apps) -> Set.size (apps)
  | None -> 0n
  ]

function validate_transfer (const t : transfer; const s : storage) : unit is 
  block {
    if t.receiver =/= Tezos.sender then 
      failwith ("Cannot send someone else's transfer") 
    else 
      skip;
    if get_approval_count (t, s) < s.threshold then
      failwith ("Not enough approvals")
    else
      skip;
  } with unit

function add_approval (const t : transfer; const s : storage) : approvals is
  case (s.transfer_approvals [t] : option (approvals)) of [
    Some (apps) -> 
      if apps contains Tezos.sender then 
        (failwith ("Cannot approve the same transfer multiple times") : approvals) 
      else 
        Set.add (Tezos.sender, apps)
  | None -> Set.add (Tezos.sender, (set [] : approvals)) 
  ]

function validate_trusted (const s : storage) : unit is
  if not (s.trusted_addresses contains Tezos.sender) then 
    (failwith ("Untrusted address") : unit) 
  else 
    unit 

function approve_transfer (const t : transfer; var s : storage) : return is 
  block {
    validate_trusted (s);
    s.transfer_approvals [t] := add_approval (t, s)
  } with (no_operations, s)

function send_transfer (const t : transfer; var s : storage) : return is
  block {
    validate_transfer (t, s);
    const deposit : deposit_contract = 
      case (Tezos.get_entrypoint_opt("%withdraw", s.deposit_address) : option (deposit_contract)) of [
        Some (c) -> c
      | None -> (failwith ("Deposit contract not found") : deposit_contract) 
      ];
    remove t from map s.transfer_approvals;
  } with (list [Tezos.transaction (Withdraw (t.receiver, t.amt), 0tez, deposit)], s)


function main (const p : parameter; const s : storage) : return is 
  case p of [ 
    ApproveTransfer (t) -> approve_transfer (t, s)
  | SendTransfer (t) -> send_transfer (t, s)
  | AddTrustedAddress (addr) -> add_trusted_address (addr, s)
  | RemoveTrustedAddress (addr) -> remove_trusted_address (addr, s)
  | SetThreshold (threshhold) -> set_threshold (threshhold, s)
  | SetDepositAddress (addr) -> set_deposit_address (addr, s)
  | SetAdminAddress (addr) -> set_admin_address (addr, s)
  ]
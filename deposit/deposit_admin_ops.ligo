#include "deposit_types.ligo"

function validate_admin (const s : storage) : unit is 
  if Tezos.sender =/= s.admin_address then 
    (failwith ("Unauthorized address change") : unit) 
  else 
    unit

function set_quorum_address (const quorum_address : tezos_address; var s : storage) : return is 
  block {
    validate_admin (s);
    s.quorum_address := quorum_address
  } with (no_operations, s)

function set_admin_address (const admin_address: tezos_address; var s : storage) : return is
  block {
    validate_admin (s);
    s.admin_address := admin_address
  } with (no_operations, s)
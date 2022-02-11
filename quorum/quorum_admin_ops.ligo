#include "quorum_types.ligo"

function validate_admin (const s : storage) : unit is 
  if Tezos.sender =/= s.admin_address then 
    (failwith ("Unauthorized address change") : unit) 
  else 
    unit

function add_trusted_address (const addr : address; var s : storage) : return is
  block {
    validate_admin (s);
    s.trusted_addresses := Set.add (addr, s.trusted_addresses)
  } with (no_operations, s)

function remove_trusted_address (const addr : address; var s : storage) : return is
  block {
    validate_admin (s);
    s.trusted_addresses := Set.remove (addr, s.trusted_addresses)
  } with (no_operations, s)

function set_threshold (const threshold : nat; var s : storage) : return is 
  block {
    validate_admin (s);
    s.threshold := threshold
  } with (no_operations, s)

function set_deposit_address (const deposit_address : address; var s : storage) : return is
  block {
    validate_admin (s);
    s.deposit_address := deposit_address
  } with (no_operations, s)

function set_admin_address (const admin_address : address; var s : storage) : return is
  block {
    validate_admin (s);
    s.admin_address := admin_address
  } with (no_operations, s)
type everscale_address is string
type tezos_address is address

type parameter is
  Deposit of everscale_address
| Withdraw of tezos_address * tez

type storage is unit

type return is list (operation) * storage

const empty_ops = (nil : list (operation))

function validate_deposit (const addr : everscale_address; const amt : tez) : unit is 
  block {
    if amt = 0tez then failwith ("Can't deposit 0 tez") else skip
  } with unit

function main (const p : parameter; const s : storage) : return is 
  block {
    case p of
      Deposit (addr) -> validate_deposit (addr, Tezos.amount)
    | Withdraw (addr, amt) -> skip
    end  
  } with (empty_ops, s)
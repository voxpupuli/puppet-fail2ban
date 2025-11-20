# can be a list of IP addresses, CIDR masks or DNS hosts
type Fail2ban::IP = Variant[
  Stdlib::Fqdn,
  Stdlib::IP::Address,
  Stdlib::IP::Address::CIDR
]

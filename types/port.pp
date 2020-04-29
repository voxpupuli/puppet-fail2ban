# Port type
type Fail2ban::Port = Variant[
  Integer,
  String,
  Tuple[Variant[Integer, String], 1, default]
]

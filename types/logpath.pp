# Describes logpath format allowed
type Fail2ban::Logpath = Variant[
  String[1],
  Array[String[1]],
]

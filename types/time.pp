# Describes time format allowed for bantime and findtime
# The time entries in fail2ban configuration (like findtime or bantime)
# can be provided as integer in seconds or as string using special abbreviation
# format (e. g. 600 is the same as 10m).
# 
# Abbreviation tokens:
# 
#   years?, yea?, yy?
#   months?, mon?
#   weeks?, wee?, ww?
#   days?, da, dd?
#   hours?, hou?, hh?
#   minutes?, min?, mm?
#   seconds?, sec?, ss?
# 
#   The question mark (?) means the optional character, so day as well as days can be used.
# 
# You can combine multiple tokens in format (separated with space resp. without separator), e. g.: 1y 6mo or 1d12h30m.
# Note that tokens m as well as mm means minutes, for month use abbreviation mo or mon.
# 
# The time format can be tested using fail2ban-client:
# 
#        fail2ban-client --str2sec 1d12h
#
type Fail2ban::Time = Variant[
  Integer[0],
  Pattern['^\d.*$'],
]

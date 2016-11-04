module Puppet::Parser::Functions
  newfunction(:default_content, type: :rvalue) do |args|
    Puppet::Parser::Functions.function('template')

    content_string   = args[0]
    content_template = args[1]

    return content_string if content_string != ''
    return function_template([content_template]) if content_template != ''

    return :undef
  end
end

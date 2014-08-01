class apache ( $port='default', $somearray) {
  notify { $port: }
  notify { $somearray: }
}

include apache

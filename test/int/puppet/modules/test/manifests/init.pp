class test (
  $teststring = 'class',
) {

  notify { $teststring: }
  if $teststring != 'valid_string' {
    fail ('Puppet data binding failed')
  }
}



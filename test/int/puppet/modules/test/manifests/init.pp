## This class tests some integration with hiera

class test (
  $teststring = 'class',
  $beers = []
) {

  #
  # Test regular data binding
  #
  notify { $teststring: }
  if $teststring != 'valid_string' {
    fail ('Puppet data binding failed')
  } else {
    notice("PASS: $teststring == 'valid_string'")
  }

  #
  # Data binding searching array
  #
  notify { $beers: }
  $test_beers = ['cruzcampo', 'sanmiguel']
  if $test_beers != $beers {
    fail ("$test_beers != $beers")
  } else {
    notice("PASS: $test_beers == $beers")
  }

  #
  # Function lookup using hiera_array 
  #
  $beers_array = hiera_array('test::beers')
  $test_beers_array = ['cruzcampo', 'sanmiguel','estrella','victoria']
  if $test_beers_array != $beers_array {
    fail ("$test_beers_array != $beers_array")
  } else {
    notice("PASS: $test_beers_array == $beers_array")
  }


  
}



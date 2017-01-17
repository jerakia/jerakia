## This class tests some integration with hiera

class test::binding (
  $teststring = 'class',
  $beers = []
) {

  #
  # Test regular data binding
  #
  notify { $teststring: }
  if $teststring != 'bound_var' {
    fail ("FAIL: teststring should be bound_var but is $teststring")
  } else {
    notice("PASS: $teststring == 'bound_var'")
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

}



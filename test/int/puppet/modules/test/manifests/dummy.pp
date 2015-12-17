class test::dummy (
  $dummy_data_string = 'in class'
) {

  if ( $dummy_data_string == "Dummy data string" ) {
    notify { "PASS: $dummy_data_string": }
  } else {
    fail("FAIL: $dummy_data_string != Dummy data string")
  }
}



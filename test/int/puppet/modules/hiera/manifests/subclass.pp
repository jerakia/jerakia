class hiera::subclass (
  $second_level = 'class'
) {

  if ( $second_level == "hiera_second" ) {
    notify { "PASS: $second_level == hiera_second": }
  } else {
    fail("FAIL: $secondlevel != hiera_second")
  }
}



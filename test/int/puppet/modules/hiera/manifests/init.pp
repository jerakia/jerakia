class hiera (
  $first_level="class"
) {

  if ( $first_level == "hiera_first" ) {
    notify { "PASS: hiera_first == $first_level": }
  }else{
    fail("FAIL: $first_level != hiera_first")
  }
}




if [ ! -d "./lib/jerakia" ]; then
  echo "FAILED: You don't appear to be in the Jerakia root directory!"

else
  export RUBYLIB=${PWD}/lib
  export JERAKIA_CONFIG=./test/fixtures/etc/jerakia/jerakia.yaml
  export PATH=${PATH}:${PWD}/bin
fi



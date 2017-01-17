#!/bin/bash

URL=http://localhost:5984/hiera

DOC=$1

curl -X GET $URL/$DOC >/tmp/.$DOC.$$.json
ruby -rjson -ryaml -e "puts JSON.load(File.read('/tmp/.$DOC.$$.json')).to_yaml" > /tmp/.$DOC.$$.yaml

vim /tmp/.$DOC.$$.yaml

echo -n "Submit (y/n)"
read RESP
if [ "$RESP" == "y" ]; then
  ruby -rjson -ryaml -e "puts YAML.load(File.read('/tmp/.$DOC.$$.yaml')).to_json" > /tmp/.$DOC.$$.send.json
  curl -X PUT $URL/$DOC -d @/tmp/.$DOC.$$.send.json
fi

rm -rf /tmp/.$DOC.$$.*



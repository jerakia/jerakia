require 'spec_helper'

describe Jerakia do
  let(:subject) { Jerakia.new(:config =>  "#{JERAKIA_ROOT}/test/fixtures/etc/jerakia/jerakia.yaml") }
  let(:request) { Jerakia::Request.new }
  let(:answer) { subject.lookup(request) }

  describe 'Keyless' do
    context 'first result lookup without schema' do
      let(:request) do
        Jerakia::Request.new(
          policy: 'schema',
          key: nil,
          metadata: { env: 'dev' },
          namespace: ['test'],
          lookup_type: :first,
          use_schema: false
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should contain the first result' do
        expect(answer.payload).to eq({
          "teststring" => "valid_string",
          "accounts" => {
            "oracle" => {
              "uid" => 500
            }
          },
          "beers" => [
            "cruzcampo",
            "sanmiguel"
            ],
          "hash" => {
            "key1" => {
              "element2" => "env"
            },
            "key2" => {
              "element3" => {
                "subelement3" => "env"
              }
            },
            "key3" => "env"
          },
          "admins" => [
            "joseph",
            "gerald",
            "craig",
          ],
          "jewels" => [
            "ruby",
            "opal",
            "diamond",
          ],
          "cities" => {
            "uk" => "london",
            "spain" => "madrid",
          },
          "databases" => {
            "mdb" => {
              "syncrepl" => {
                "foo" => "bar",
                "taz" => "tango",
              }
            }
          },
          "boolfalse" => false,
          "booltrue" => true,
          "msgpack" => {
            "values"=>{
              1=>"Test 1",
              "2"=>"Test 2"
            }
          },
          "null_value" => nil,
          "passwords" => {
            "root"=>"vault:v1:HBlr4Ao2oUYBOqgzwbZOKrn63HyduS2y9QYZklXgBOuENA=="
          },
          "root_password" => "vault:v1:HBlr4Ao2oUYBOqgzwbZOKrn63HyduS2y9QYZklXgBOuENA==",
          "sub_value" => "Environment is %{env}",
          "subhash" => {
            "walk"=>{
              "another"=>{
                "deeper"=>"%{env}"
              },
              "replace"=>"%{env}"
            }
          },
          "users" => [
            "joshua",
            "craig",
            "karina",
            "max"
          ]
        })
      end
    end

    context 'first result lookup with schema cascade' do
      let(:request) do
        Jerakia::Request.new(
          policy: 'schema',
          key: nil,
          metadata: { env: 'dev' },
          namespace: ['test'],
          lookup_type: :first,
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should contain the first result' do
        expect(answer.payload).to eq({
          "teststring" => "valid_string",
          "accounts" => {
            "oracle" => {
              "uid" => 500
            }
          },
          "beers" => [
            "cruzcampo",
            "sanmiguel"
          ],
          "hash" => {
            "key1" => {
              "element2" => "env"
            },
            "key2" => {
              "element3" => {
                "subelement3" => "env"
              }
            },
            "key3" => "env"
          },
          "admins" => [
            "joseph",
            "gerald",
            "craig",
          ],
          "jewels" => [
            "ruby",
            "opal",
            "diamond",
            "quartz",
            "topaz",
          ],
          "cities" => {
            "uk" => "london",
            "spain" => "madrid",
            "argentina" => "buenos aires",
            "france"=>"paris",
          },
          "databases" => {
            "mdb" => {
              "syncrepl" => {
                "foo" => "bar",
                "taz" => "tango",
              }
            }
          },
          "boolfalse" => false,
          "booltrue" => true,
          "msgpack" => {
            "values"=>{
              1=>"Test 1",
              "2"=>"Test 2"
            }
          },
          "null_value" => nil,
          "passwords" => {
            "root"=>"vault:v1:HBlr4Ao2oUYBOqgzwbZOKrn63HyduS2y9QYZklXgBOuENA=="
          },
          "root_password" => "vault:v1:HBlr4Ao2oUYBOqgzwbZOKrn63HyduS2y9QYZklXgBOuENA==",
          "sub_value" => "Environment is %{env}",
          "subhash" => {
            "walk"=>{
              "another"=>{
                "deeper"=>"%{env}"
              },
              "replace"=>"%{env}"
            }
          },
          "users" => [
            "joshua",
            "craig",
            "karina",
            "max"
          ]
        })
      end
    end


    context 'cascade merge array result lookup' do
      let(:request) do
        Jerakia::Request.new(
          policy: 'schema',
          key: nil,
          metadata: { env: 'dev' },
          namespace: ['test'],
          lookup_type: :cascade,
          merge: :array,
          use_schema: false
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should contain the string valid_string' do
        expect(answer.payload).to eq({
          "teststring" => "valid_string",
          "accounts" => {
            "oracle" => {
              "uid" => 500
            }
          },
          "beers" => [
            "cruzcampo",
            "sanmiguel",
            "estrella",
            "victoria",
          ],
          "hash" => {
            "key1" => {
              "element2" => "env"
            },
            "key2" => {
              "element3" => {
                "subelement3" => "env"
              }
            },
            "key3" => "env"
          },
          "admins" => [
            "joseph",
            "gerald",
            "craig",
            "bill",
            "susan",
            "fred",
            "bob",
          ],
          "jewels" => [
            "ruby",
            "opal",
            "diamond",
            "quartz",
            "topaz",
          ],
          "cities" => {
            "spain" => "madrid",
            "uk" => "london",
          },
          "databases" => {
            "mdb" => {
              "syncrepl" => {
                "foo" => "bar",
                "taz" => "tango"
              }
            }
          },
          "boolfalse" => false,
          "booltrue" => true,
          "msgpack" => {
            "values"=>{
              1=>"Test 1",
              "2"=>"Test 2"
            }
          },
          "null_value" => nil,
          "passwords" => {
            "root"=>"vault:v1:HBlr4Ao2oUYBOqgzwbZOKrn63HyduS2y9QYZklXgBOuENA=="
          },
          "root_password" => "vault:v1:HBlr4Ao2oUYBOqgzwbZOKrn63HyduS2y9QYZklXgBOuENA==",
          "sub_value" => "Environment is %{env}",
          "subhash" => {
            "walk"=>{
              "another"=>{
                "deeper"=>"%{env}"
              },
              "replace"=>"%{env}"
            }
          },
          "users" => [
            "joshua",
            "craig",
            "karina",
            "max"
          ]
        })

      end
    end

    context 'cascade merge hash result lookup' do
      let(:request) do
        Jerakia::Request.new(
          policy: 'schema',
          key: nil,
          metadata: { env: 'dev' },
          namespace: ['test'],
          use_schema: false,
          lookup_type: :cascade,
          merge: :hash,
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should contain the string valid_string' do
        expect(answer.payload).to eq({
          "teststring" => "valid_string",
          "accounts" => {
            "admin" => {
              "uid" => 99
            },
            "oracle" => {
              "uid" => 500
            }
          },
          "beers" => [
            "cruzcampo",
            "sanmiguel",
          ],
          "hash" => {
            "key0" => {
              "element0" => "common"
            },
            "key1" => {
              "element2" => "env"
            },
            "key2" => {
              "element3" => {
                "subelement3" => "env"
              }
            },
            "key3" => "env"
          },
          "admins" => [
            "joseph",
            "gerald",
            "craig",
          ],
          "jewels" => [
            "ruby",
            "opal",
            "diamond",
          ],
          "cities" => {
            "spain" => "madrid",
            "argentina" => "buenos aires",
            "france"=>"paris",
            "uk"=>"london",
          },
          "databases" => {
            "mdb" => {
              "syncrepl" => {
                "foo" => "bar",
                "taz" => "tango"
              }
            },
            "other_database" => {
              "foo" => {
                "bar" => nil
              }
            }
          },
          "boolfalse" => false,
          "booltrue" => true,
          "msgpack" => {
            "values"=>{
              1=>"Test 1",
              "2"=>"Test 2"
            }
          },
          "null_value" => nil,
          "passwords" => {
            "root"=>"vault:v1:HBlr4Ao2oUYBOqgzwbZOKrn63HyduS2y9QYZklXgBOuENA=="
          },
          "root_password" => "vault:v1:HBlr4Ao2oUYBOqgzwbZOKrn63HyduS2y9QYZklXgBOuENA==",
          "sub_value" => "Environment is %{env}",
          "subhash" => {
            "walk"=>{
              "another"=>{
                "deeper"=>"%{env}"
              },
              "replace"=>"%{env}"
            }
          },
          "users" => [
            "joshua",
            "craig",
            "karina",
            "max"
          ]
        })
      end
    end

    context 'cascade merge deep_hash result lookup' do
      let(:request) do
        Jerakia::Request.new(
          policy: 'schema',
          key: nil,
          metadata: { env: 'dev' },
          lookup_type: :cascade,
          merge: :deep_hash,
          namespace: ['test']
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should contain the string valid_string' do
        expect(answer.payload).to eq({
          "teststring" => "valid_string",
          "accounts" => {
            "admin" => {
              "uid" => 99
            },
            "oracle" => {
              "uid" => 500
            }
          },
          "beers" => [
            "cruzcampo",
            "sanmiguel",
          ],
          "hash" => {
            "key0" => {
              "element0" => "common"
            },
            "key1" => {
              "element1" => "common",
              "element2" => "env"
            },
            "key2" => {
              "element1" => "common",
              "element2" => {
                "subelement2" => "common"
              },
              "element3" => {
                "subelement3" => "env"
              }
            },
            "key3" => "env"
          },
          "admins" => [
            "joseph",
            "gerald",
            "craig",
          ],
          "jewels" => [
            "ruby",
            "opal",
            "diamond",
            "quartz",
            "topaz",
          ],
          "cities" => {
            "spain" => "madrid",
            "argentina" => "buenos aires",
            "france"=>"paris",
            "uk"=>"london",
          },
          "databases" => {
            "mdb" => {
              "boo" => {
                "bear" => "baz"
              },
              "otherstuff" => {
                "yea" => "man"
              },
              "syncrepl" => {
                "foo" => "bar",
                "taz" => "tango"
              }
            },
            "other_database" => {
              "foo" => {
                "bar" => nil
              }
            }
          },
          "boolfalse" => false,
          "booltrue" => true,
          "msgpack" => {
            "values"=>{
              1=>"Test 1",
              "2"=>"Test 2"
            }
          },
          "null_value" => nil,
          "passwords" => {
            "root"=>"vault:v1:HBlr4Ao2oUYBOqgzwbZOKrn63HyduS2y9QYZklXgBOuENA=="
          },
          "root_password" => "vault:v1:HBlr4Ao2oUYBOqgzwbZOKrn63HyduS2y9QYZklXgBOuENA==",
          "sub_value" => "Environment is %{env}",
          "subhash" => {
            "walk"=>{
              "another"=>{
                "deeper"=>"%{env}"
              },
              "replace"=>"%{env}"
            }
          },
          "users" => [
            "joshua",
            "craig",
            "karina",
            "max"
          ]
        })
      
      end
    end

    context 'cascade merge deep_all result lookup' do
      let(:request) do
        Jerakia::Request.new(
          policy: 'schema',
          key: nil,
          metadata: { env: 'dev' },
          lookup_type: :cascade,
          merge: :deep_all,
          namespace: ['test']
        )
      end

      it 'should return a response' do
        expect(answer).to be_a(Jerakia::Answer)
      end

      it 'should contain the string valid_string' do
        expect(answer.payload).to eq({
          "teststring" => "valid_string",
          "accounts" => {
            "admin" => {
              "uid" => 99
            },
            "oracle" => {
              "uid" => 500
            }
          },
          "beers" => [
            "cruzcampo",
            "sanmiguel",
            "estrella",
            "victoria",
            ],
          "hash" => {
            "key0" => {
              "element0" => "common"
            },
            "key1" => {
              "element1" => "common",
              "element2" => "env"
            },
            "key2" => {
              "element1" => "common",
              "element2" => {
                "subelement2" => "common"
              },
              "element3" => {
                "subelement3" => "env"
              }
            },
            "key3" => "env"
          },
          "admins" => [
            "joseph",
            "gerald",
            "craig",
            "bill",
            "susan",
            "fred",
            "bob",
          ],
          "jewels" => [
            "ruby",
            "opal",
            "diamond",
            "quartz",
            "topaz",
          ],
          "cities" => {
            "spain" => "madrid",
            "argentina" => "buenos aires",
            "france"=>"paris",
            "uk"=>"london",
          },
          "databases" => {
          "mdb" => {
              "boo" => {
                "bear" => "baz"
              },
              "otherstuff" => {
                "yea" => "man"
              },
                "syncrepl" => {
                "foo" => "bar",
                "taz" => "tango"
              }
            },
            "other_database" => {
              "foo" => {
                "bar" => nil
              }
            }
          },
          "boolfalse" => false,
          "booltrue" => true,
          "msgpack" => {
            "values"=>{
              1=>"Test 1",
              "2"=>"Test 2"
            }
          },
          "null_value" => nil,
          "passwords" => {
            "root"=>"vault:v1:HBlr4Ao2oUYBOqgzwbZOKrn63HyduS2y9QYZklXgBOuENA=="
          },
          "root_password" => "vault:v1:HBlr4Ao2oUYBOqgzwbZOKrn63HyduS2y9QYZklXgBOuENA==",
          "sub_value" => "Environment is %{env}",
          "subhash" => {
            "walk"=>{
              "another"=>{
                "deeper"=>"%{env}"
              },
              "replace"=>"%{env}"
            }
          },
          "users" => [
            "joshua",
            "craig",
            "karina",
            "max"
          ]
        })
      end
    end

  end
end

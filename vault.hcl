storage "consul" {
 address = "127.0.0.1:8500"
 path = "vault/"
 }

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = "true"
}

seal "transit" {
  address            = "http://EU-guystack-vault-355642182.eu-west-2.elb.amazonaws.com:8200"
  token              = "s.QLbMC2vgy3DTzPLArP3Is1WY"
  disable_renewal    = "false"

  // Key configuration
  key_name           = "autounseal"
  mount_path         = "transit/"
  tls_skip_verify   = "true"
}


disable_mlock="true"
disable_cache="true"
ui = "true"

max_least_ttl="10h"
default_least_ttl="10h"
raw_storage_endpoint=true
cluster_name="mycompany-vault"
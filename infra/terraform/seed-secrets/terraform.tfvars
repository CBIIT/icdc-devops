tags = {
  Project   = "example"
  Env       = "text"
  ManagedBy = "Terraform"
  POC       = "you@example.com"
}

secret_values = {
  app = {
    secretKey = "bento/test/dev"
    secretValue = {
      neo4j         = "neo4j"
      neo4j_password = "securedPass"
    }
  }
  db = {
    secretKey = "mydbsecret"
    secretValue = {
      username = "admin"
      password = "secretPass"
    }
  }
}
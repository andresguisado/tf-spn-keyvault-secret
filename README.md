# Create new Azure SPN storing its APPID and KEY as secrets on Key Vault 

This repository performs the folowing tasks:

* Creating a new Azure SPN with a random password
* Creating an Azure key vault
* Creating an APPId and an KEY as secrets in the above Azure Key Vault
* Assigning the above SPN to the Contributor Role on a specific Subscription

### Implementation

1- Create a ```my-test.tfvars``` copiying from ```app1-template.tfvars``` and fill in the values.

2- ```terraform init```

3- ``` terraform plan -var-file="my-test.tfvars" --out plan.out```

4- ```terraform apply plan.out```

5- ```terraform destroy -var-file="my-test.tfvars"```
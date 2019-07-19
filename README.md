# terraform-gke-vault

Vault enterprise hosted on GKE with Terraform.

the terraform script does all the scafolding for the K8s cluster then the "KubeConfig.sh" configures Vault and Consul enterprise.

note, you will need a custom Docker image with Vault Enterprise as Hashicorp currently doesnt have any offical Vault Ent images. [GCP Docker quickstart](https://cloud.google.com/cloud-build/docs/quickstart-docker).

## kubectl
    this project relies heavily on kubectl, [install kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## GCP

The following setup assumes you have already a Google Profile created.

1. As the first step, go to the [Google Cloud Platform Console](https://console.cloud.google.com/) and sign in or, if you don't already have an account, sign up.
2. Then, [create a new Billing Account](https://cloud.google.com/billing/docs/how-to/manage-billing-account).
3. Finally [create a new project](https://console.cloud.google.com/projectcreate).

### CLI

To interact with the Google Cloud Platform you will use `gcloud` CLI which is a part of the Google Cloud SDK. You must download and install the SDK on your system and initialize it before you can use the gcloud command-line tool:

    brew tap caskroom/cask
    brew cask install google-cloud-sdk

Use the following command to perform several common SDK setup tasks. These include authorizing the SDK tools to access Google Cloud Platform using your user account credentials and setting up the default SDK configuration.

    gcloud init

## Terraform

To use your own user credentials for Terraform when interacting with Google Cloud, run:

    gcloud auth application-default login

In your browser, log in to your Google user account when prompted and click _Allow_ to grant permission to access Google Cloud Platform resources.

Your credentials will be stored in `~/.config/gcloud/application_default_credentials.json` and used with Terraform to authorize.

please note,  you may need to add the gke api authorizations to your credentials. 

### Usage

#### GKE

Firstly, to initialize Terraform and install all required plugins, you should do:

    terraform init 

Then, to compare the remote state with the required changes, run:

    terraform plan

Finally, to promote the local changes onto the current setup, execute:

    terraform apply

#### configure Vault and Consul
    before running the script, get your Consul ent license and put them in the project directory (or change the script to point them to the right place)
    in the kubeConfig.sh script, you have a step by step process to configure both Consul enterprise and Vault enterprise. I would recommend doing this manually line by line until this script can be improved to be run automatically. 


### Thanks

    thanks to Corrigan Neralich and his [gke vault project](https://github.com/cneralich/gke-vault-consul-poc)
    thanks to John boero for his [vault helm script](https://github.com/hashicorp/vault-guides/blob/master/shared/vault/scripts/vault-k8s-helm.sh)
    and countless others like Lance Haig, Nicolas Ehrman, Jerome Baude who helped me troubleshoot when I got stuck


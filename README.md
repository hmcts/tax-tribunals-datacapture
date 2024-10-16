# Tax Tribunals Data Capture
        
[![Build
Status](https://travis-ci.org/ministryofjustice/tax-tribunals-datacapture.svg?branch=master)](https://travis-ci.org/ministryofjustice/tax-tribunals-datacapture)

Ruby on Rails Web application for making an appeal to the Tax Tribunal.

## Running Locally

This is using your local Ruby-ready environment and a PostgreSQL server that you can set up.

Set up environment variables `cp .env.example .env`.

You will need to instal the GovUK FrontEnd package
https://frontend.design-system.service.gov.uk/installing-with-npm/#requirements
`npm install govuk-frontend --save`

And then precompile the assets 
`rake assets:precompile`

Create the database with `rake db:setup db:migrate`

Then run `rails server`

## AZURE Blob storage ##

Until we refactor file uploader to use active storage we have to use storage for Demo or AAT env.
Example for AAT(Staging)

### Add your IP to storoage ###
Add your IP to whitelisting on relevant storage account
Storage account -> Security + networking -> Networking -> Firewall and virtual networks tab
https://portal.azure.com/#@HMCTS.NET/resource/subscriptions/58a2ce36-4e09-467b-8330-d164aa559c68/resourceGroups/tt_stg_taxtribunalsazure_resource_group/providers/Microsoft.Storage/storageAccounts/stgttfilestore/networking

Firewall section -> Add IP ranges to allow access from the internet or your on-premises networks.
There should be checkbox with your IP address. Check it and click on save (at the top of the page)

### Load storoage credentials on your local ###
Find a tax-tribunals-cft-aat key/vault on portal (https://portal.azure.com/#@HMCTS.NET/resource/subscriptions/1c4f0704-a29e-403d-b719-b90c34ef14c9/resourceGroups/tax-tribunals-aat/providers/Microsoft.KeyVault/vaults/tax-tribunals-cft-aat/overview)

Copy azure-storage-account, azure-storage-container and azure-storage-key into your localhost .env setup accordingly.


 
## Mutation testing performance issues and resolution

### Background

At the end of March 2017, we encountered problems with CircleCI and
mutation testing.  Calls to `self` in `TribunalCase` were causing heavy
recursion in two of the mutation tests run against that model's spec [1].
These consumed large amounts of memory, ran very slowly, and effectively
blocked two mutants threads for hours on a locally running instance.

### CircleCI vs. Travis

Even after the issue was fixed, the mutation tests sometimes exceeded the 4GB
memory limit imposed by CircleCI.  Circle was also consitently slow to
run the mutations.  Experiments with Travis, however, showed it to be
consistently much more performant with the mutations.

### Running on Travis

Early experiments with `.travis.yml` showed that it was not properly
setting the environment variables.  To work around this, the following
variables are set directly in the trais configuration:

* `DATABASE_URL`
* `GLIMR_API_URL`
* `GOVUK_NOTIFY_API_KEY`
* `TAX_TRIBUNALS_DOWNLOADER_URL`

[1]: At the time of writing, `TribunalCase` brings in 17 other objects via the
`.has_value_object` call.  Any mutation referencing a `self` call will
need to include all of these in its syntax tree.


Trigger rebuild: 3
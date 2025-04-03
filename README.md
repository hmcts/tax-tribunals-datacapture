# Tax Tribunals Data Capture


Ruby on Rails Web application for making an appeal or closure to the Tax Tribunal.

## Prerequisites

Before proceeding, ensure you have the following installed on your system:

* **Ruby:** Version [Specify Required Ruby Version, e.g., 3.2.2]. You can use a version manager like `rbenv` or `rvm` to manage Ruby versions.
* **Bundler:** Install it with `gem install bundler`.
* **Database:** Ensure PostgreSQL server is running and `libpq-dev` (or equivalent) is installed for native gem compilation.
* **Yarn:** Install it using `npm install -g yarn`.

## Setup Instructions

1.  **Clone the Repository**

    Set up environment variables 
    ```bash
    cp .env.example .env
    ```

2.  **Install Dependencies:**

    ```bash
    bundle install
    ```
    You will need to install the GovUK FrontEnd package
    https://frontend.design-system.service.gov.uk/installing-with-npm/#requirements

    ```bash
    npm install govuk-frontend --save
    ```

    And then precompile the assets

    ```bash
    rake assets:precompile
    ```
3.  **Configure Database:**

    * Edit `config/database.yml` and configure your database settings. Replace the placeholders with your database credentials.

    * Create the database:

        ```bash
        rails db:create
        ```

    * Run Migrations:
        ```bash
        rails db:migrate
        ```

4.  **Install JavaScript Dependencies:**

    ```bash
    yarn install
    ```
## Running the Application Locally

1.  **Start the Rails Server:**

    ```bash
    rails server
    ```

    The application will be available at `http://localhost:3000`.

2.  **Running Tests:**

   * For Rspec:
     ```bash
     bundle exec rspec
     ```
   * For Cucumber:
     ```bash
     bundle exec cucumber
     ```

## AZURE Blob storage ##

Until we refactor file uploader to use active storage we have to use storage for Demo or AAT env.
Example for AAT(Staging)

### Add your IP to storage ###
Add your IP to whitelisting on relevant storage account
Storage account -> Security + networking -> Networking -> Firewall and virtual networks tab
https://portal.azure.com/#@HMCTS.NET/resource/subscriptions/58a2ce36-4e09-467b-8330-d164aa559c68/resourceGroups/tt_stg_taxtribunalsazure_resource_group/providers/Microsoft.Storage/storageAccounts/stgttfilestore/networking

Firewall section -> Add IP ranges to allow access from the internet or your on-premises networks.
There should be checkbox with your IP address. Check it and click on save (at the top of the page)

### Load storage credentials on your local ###
Find a tax-tribunals-cft-aat key/vault on portal (https://portal.azure.com/#@HMCTS.NET/resource/subscriptions/1c4f0704-a29e-403d-b719-b90c34ef14c9/resourceGroups/tax-tribunals-aat/providers/Microsoft.KeyVault/vaults/tax-tribunals-cft-aat/overview)

Copy azure-storage-account, azure-storage-container and azure-storage-key into your localhost .env setup accordingly.

Trigger rebuild: 5
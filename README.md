# Terraform Setup Guide for autosetup of Wordpress with RDS

This guide will help you set up an Amazon S3 bucket and an Amazon DynamoDB table for remote Terraform state management, configure your Terraform project, and apply configurations to create your environment.

## Prerequisites

- An AWS account with permissions to create S3 buckets and DynamoDB tables.
- AWS CLI installed and configured with access credentials.
- Terraform installed on your local machine.

## Step 1: Create an S3 Bucket

1. **Log in to the AWS Management Console** and navigate to the S3 service.

2. **Create a new S3 bucket**:
   - Click on "Create bucket."
   - Provide a unique name for your bucket (e.g., `my-terraform-state-bucket`).
   - Choose a region (preferably the same region where you plan to run Terraform).
   - Leave the remaining settings as default or adjust as necessary for your use case.
   - Click "Create bucket" to finalize.

## Step 2: Create a DynamoDB Table

1. **Navigate to the DynamoDB service** in the AWS Management Console.

2. **Create a new table**:
   - Click on "Create table."
   - Set the **Table name** to something like `terraform-locks`.
   - Set the **Partition key** to `lockID` (String type).
   - Adjust other settings as needed or leave them as default.
   - Click "Create table" to finalize.

## Step 3: Configure Terraform

### 3.1. Update `provider.tf`

You need to configure your Terraform `provider.tf` file to use the S3 bucket and DynamoDB table for remote state management. 

### 3.2. Initialize Terraform

With the `provider.tf` file configured, you need to initialize your Terraform project. This command will set up the backend and download necessary provider plugins.

1. **Open a terminal** and navigate to your Terraform project directory.

2. **Run the initialization command**:

   ```sh
   terraform init
   ```

   This will configure Terraform to use the S3 bucket and DynamoDB table for state management.

### 3.3. Create the Environment

1. **Validate your Terraform configuration** to ensure there are no syntax errors:

   ```sh
   terraform validate
   ```

2. **Plan the changes** to see what will be created, modified, or destroyed:

   ```sh
   terraform plan
   ```

3. **Apply the configuration** to create or update the infrastructure:

   ```sh
   terraform apply
   ```

   You will be prompted to confirm the changes. Type `yes` and press Enter to proceed.

## Step 4: Verify Setup

After running `terraform apply`, verify the creation of your resources:

1. **Check the terminal** your public IP address will be displayed for your reference.
2. **access the new WP environment** within your selected internet browser navigate to http://(your public ip)/wp-admin/install.php.
3. **Complete Wordpress installation** follow the onscreen instruction to complete the wordpress install.

## Conclusion

You have successfully set up an S3 bucket and a DynamoDB table for Terraform remote state management, configured your Terraform project to launch Wordpress within aws, and applied your Terraform configurations to create your environment.
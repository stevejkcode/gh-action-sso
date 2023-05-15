TERRAFORM_STEP="${1:-plan}"

terraform_init() {
    environment="${1:-staging}"

    # Default environment to staging unless it is explicitly set as production
    if [ "$environment" != "production" ]
    then
        environment="staging"
    fi

    # Pull backend creds for the appropriate environment 
    if [ "$environment" = "staging" ]
    then
        export ACCESS_KEY="$BACKEND_STAGING_ACCESS_KEY"
        export SECRET_KEY="$BACKEND_STAGING_SECRET_KEY"
    elif [ "$environment" = "production" ]
    then
        export ACCESS_KEY="$BACKEND_PRODUCTION_ACCESS_KEY"
        export SECRET_KEY="$BACKEND_PRODUCTION_SECRET_KEY"
    fi

    cd environments/$environment
    terraform init -backend-config="access_key=$ACCESS_KEY" -backend-config="secret_key=$SECRET_KEY"
}

generate_clients() {
    environment="${1:-staging}"
    step="${2:-plan}"

    # Default environment to staging unless it is explicitly set as production
    if [ "$environment" != "production" ]
    then
        environment="staging"
    fi

    terraform_init "$environment"

    # Setup terraform variables for the target environment
    if [ "$environment" = "staging" ]
    then
        export TF_VAR_username="$KEYCLOAK_STAGING_USERNAME"
        export TF_VAR_password="$KEYCLOAK_STAGING_PASSWORD"
        export TF_VAR_url="$KEYCLOAK_STAGING_URL"
    elif [ "$environment" = "production" ]
    then
        export TF_VAR_username="$KEYCLOAK_PRODUCTION_USERNAME"
        export TF_VAR_password="$KEYCLOAK_PRODUCTION_PASSWORD"
        export TF_VAR_url="$KEYCLOAK_PRODUCTION_URL"
    fi

    if [ "$step" = "plan" ]
    then
        terraform plan
    elif [ "$step" = "apply" ]
    then
        terraform plan
        terraform apply -auto-approve
    fi
}

# Default environment to staging unless explicitly set to production
if [[ "$ENVIRONMENT_LOWER" != *"production"* ]]
then
    ENVIRONMENT_LOWER="staging"
fi

# Run any environments present in the variable (can have more than one to run)
if [[ $ENVIRONMENT_LOWER == *"staging"* ]]
then
    echo "Running terraform for staging"
    generate_clients staging $TERRAFORM_STEP
fi

if [[ $ENVIRONMENT_LOWER == *"production"* ]]
then
    echo "Running terraform for production"
    generate_clients production $TERRAFORM_STEP
fi
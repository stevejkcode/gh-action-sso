import os
import json
import re

# Client application id naming conventions
def generate_client_id(s):
    s = s.lower()
    s = re.sub('\s', '_', s)

    return s

# Open issue parser result to pull form contents
with open(f'{os.environ["HOME"]}/issue-parser-result.json', 'r') as form:
    # Read form contents and parse as JSON
    form_text = form.readlines()
    form_body = json.loads(''.join(form_text))

    print(form_body)

    environment = form_body['environment']

    # Default environment to staging if it is an unexpected value
    if environment not in ['Staging', 'Production']: environment = 'Staging'

    # Strip leading and trailing whitespace from the client application id and name to prevent issues within Keycloak
    form_body['client_application_id'] = form_body['client_application_id'].strip()
    form_body['client_application_name'] = form_body['client_application_name'].strip()

    # If application id is empty, use application name by default
    if form_body['client_application_id'] == '': form_body['client_application_id'] = form_body['client_application_name']

    # Update client application id to enforce certain naming conventions
    form_body['client_application_id'] = generate_client_id(form_body['client_application_id'])

    # Add variable for environment so we can apply a label for it downstream in issues and PRs
    with open(os.environ['GITHUB_OUTPUT'], 'a') as gh:
        # Output application client id and name for downstream steps
        print(f'client_application_id={form_body["client_application_id"]}', file=gh)
        print(f'client_application_name={form_body["client_application_name"]}', file=gh)        

        # Output environment for downstream steps
        print(f'environment={environment}', file=gh)
        print(f'environment_lower={environment.lower()}', file=gh)
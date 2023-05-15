import os
import json

def add_quotes(s): 
    return f'"{s}"'

def remove_carriage_return(s):
    return s.replace('\r', '')

def generate_list_item(s):
    s = remove_carriage_return(s)
    s = add_quotes(s)
    return s

def build_list_str(l):
    return f"[{', '.join(list(map(generate_list_item, l)))}]"

# Open issue parser result to pull form contents
with open(f'{os.environ["HOME"]}/issue-parser-result.json', 'r') as form:
    # Read form contents and parse as JSON
    form_text = form.readlines()
    form_body = json.loads(''.join(form_text))

    form_body['client_application_id'] = os.environ.get('CLIENT_APPLICATION_ID')
    form_body['client_application_name'] = os.environ.get('CLIENT_APPLICATION_NAME')

    form_body['valid_redirect_uris'] = build_list_str(form_body.get('valid_redirect_uris').split('\n'))
    form_body['valid_post_logout_redirect_uris'] = build_list_str(form_body.get('valid_post_logout_redirect_uris').split('\n'))
    form_body['web_origins'] = build_list_str(form_body.get('web_origins').split('\n'))

    # Get the template filename
    templatefilename = f'./src/terraform/client.template.txt'

    # Use client application id to generate filename for the terraform file
    outfilename = f'./environments/staging/{form_body.get("client_application_id")}.tf'

    # Read template and open output file
    with open(templatefilename, 'r') as template, open(outfilename, 'w') as outfile:
        # Use the template to generate the terraform text and write out to the file
        outfile.write(template.read() % form_body)

        # If successful set an environment variable for the downstream process
        with open(os.environ['GITHUB_ENV'], 'a') as gh:
            print(f'TF_FILE={outfilename}', file=gh)
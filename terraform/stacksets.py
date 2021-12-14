import subprocess
import boto3
import json
import os

def init():
  subprocess.run(f"terraform init", check=True, shell=True)

def get_accounts():
  organizations = boto3.client('organizations')
  paginator = organizations.get_paginator("list_accounts")

  return [
        account["Id"]
        for page in paginator.paginate()
        for account in page["Accounts"]
  ]

def get_roots():
  organizations = boto3.client('organizations')
  root_id = organizations.list_roots()["Roots"][0]["Id"]

  return root_id

def get_ous(root_id):
  organizations = boto3.client('organizations')
  paginator = organizations.get_paginator("list_children")

  return [
        ou_id["Id"]
        for page in paginator.paginate(
          ParentId=root_id,
          ChildType='ORGANIZATIONAL_UNIT'
        )
        for ou_id in page["Children"]
  ]

def validate():
  subprocess.run(f"terraform validate", check=True, shell=True)

def workspace_exists(account):
  completed_process = subprocess.run(f"terraform workspace list | grep {account}", shell=True)
  return completed_process.returncode == 0

def create_workspace(account):
  subprocess.run(f"terraform workspace new {account}", check=True, shell=True)

def switch_to_workspace(account):
  subprocess.run(f"terraform workspace select {account}", check=True, shell=True)

def plan(account,ou_id):
  subprocess.run(f"terraform plan -var 'target_account_id={account}' -var 'target_ous={ou_id}'", check=True, shell=True)

def apply(account,ou_id):
  subprocess.run(f"terraform apply -var 'target_account_id={account}' -var 'target_ous={ou_id}' -auto-approve", check=True, shell=True)

#def destroy(account,ou_id):
#  subprocess.run(f"terraform destroy -var 'target_account_id={account}' -var 'target_ous={ou_id}' -auto-approve", check=True, shell=True)

def run():
  id=get_roots()
  list=get_ous(id)
  ou_ids=json.dumps(list)
  init()
  validate()
  for account in get_accounts():
    if not workspace_exists(account):
      create_workspace(account)
    plan(account,ou_ids)
    apply(account,ou_ids)
    #destroy(account,ou_ids)

if __name__ == "__main__":
  run()
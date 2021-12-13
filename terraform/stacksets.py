import subprocess
import boto3
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

def workspace_exists(account):
  completed_process = subprocess.run(f"terraform workspace list | grep {account}", shell=True)
  return completed_process.returncode == 0

def create_workspace(account):
  subprocess.run(f"terraform workspace new {account}", check=True, shell=True)

def switch_to_workspace(account):
  subprocess.run(f"terraform workspace select {account}", check=True, shell=True)

def plan(ou_id):
  subprocess.run(f"terraform plan -var org_ou={ou_id}", check=True, shell=True)

def apply(ou_id):
  subprocess.run(f"terraform apply -var org_ou={ou_id} -auto-approve", check=True, shell=True)

def run():
  init()
  for account in get_accounts():
    if not workspace_exists(account):
      create_workspace(account)
    switch_to_workspace(account)
    plan(account)
    apply(account)

if __name__ == "__main__":
  run()
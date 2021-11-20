from brownie import accounts
from .deploy import deploy_contracts
from .deposit_gtt import deposit_gtt
from .withdraw_gtt import withdraw_gtt

def main():
    deploy_contracts()
    
    for account in accounts:
        deposit_gtt(account, 1000)

    withdraw_gtt(accounts[0], 500)
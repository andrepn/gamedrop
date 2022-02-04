from brownie import *


def withdraw_gtt(account, amount):
    base = {"from": account}

    balance_in_contract = RaffleContract[-1].view_raw_balance(account)
    balance_in_wallet = GamingTestToken[-1].balanceOf(account)
    print(f"Current staked balance of {account} is {balance_in_contract}")
    print(f"Current wallet balance of {account} is {balance_in_wallet}")

    RaffleContract[-1].Withdraw(amount, base)

    balance_in_contract = RaffleContract[-1].view_raw_balance(account)
    time_balance_in_contract = RaffleContract[-1].view_odds_of_winning(account)
    balance_in_wallet = GamingTestToken[-1].balanceOf(account)
    print(f"New staked balance of {account} is {balance_in_contract}")
    print(f"New time weighted balance of {account} is {time_balance_in_contract}")
    print(f"New wallet balance of {account} is {balance_in_wallet}")

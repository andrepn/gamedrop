from brownie import *

def deposit_gtt(account, amount):
    base_account = {"from" : account}
    base = account

    #approve raffle contract to deposit amount gtt
    GamingTestToken[-1].approve(RaffleContract[-1], amount, base_account)

    #deposit 1000 gtt
    RaffleContract[-1].Deposit(amount, base_account)

    #check raw balance
    raw_balance = RaffleContract[-1].view_raw_balance(base)
    print(f'{account} Deposited Balance: {raw_balance}')

    #check time weited balance
    time_weighted_balance = RaffleContract[-1].view_time_weighted_balance(base)
    print(f'{account} Time Weighted: {time_weighted_balance} \n')
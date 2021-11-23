from brownie import *
import trio

#Initiate raffle look from raffle contract and this script auto complets
def main():

    base = {'from' : accounts[0]}

    request_id = RaffleContract[-1].initiateRaffle(base)

    random_number = GamedropVRF[-1].veiwRandomResponse()

    while (random_number == 0):
        trio.sleep(2)
        random_number = GamedropVRF[-1].veiwRandomResponse()

    result = RaffleContract[-1].completeRaffle(random_number, base)

    print(result)
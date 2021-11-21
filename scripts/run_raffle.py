from brownie import *
import trio

def main():

    base = {'from' : accounts[0]}

    request_id = RaffleContract[-1].initiateRaffle(base)

    random_number = GamedropVRF[-1].veiwRandomResponse()

    while (random_number == 0):
        trio.sleep(2)
        random_number = GamedropVRF[-1].veiwRandomResponse()

    result = RaffleContract[-1].completeRaffle(random_number, base)

    print(result)
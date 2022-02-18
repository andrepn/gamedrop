from brownie import *


def main():
    rc = RaffleContract.at("0x04D661Ba0f0F8e5C8BA07907695DAe9794aa48bC")
    info = RaffleContract.get_verification_info()

    print(info)

    with open("verify_info.json", "w") as file:
        file.write(str(info))

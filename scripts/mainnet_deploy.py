from brownie import *
from .load_mainnet_account import load_accounts


def main():
    account_list = load_accounts()

    base_account = account_list[0]
    base_from = {"from": base_account}

    # deploy vrf

    rc = RaffleContract.deploy(GamingTestToken[-1].address, base_from)
    GamedropVRF.deploy(
        0xAA77729D3466CA35AE8D28B3BBAC7CC36A5031EFDC430821C02BC31A238AF445,
        "0xf0d54349aDdcf704F77AE15b96510dEA15cb7952",
        "0x514910771AF9Ca656af840dff83E8264EcF986CA",
        "0x514910771AF9Ca656af840dff83E8264EcF986CA",
        base_from,
    )
    RaffleContract[-1].updateGamedropVRFContract(GamedropVRF[-1].address)

    # Whitelist wallet 0x885F12B525218Ca9377755F9a534CE230Ac5D2d8

    RaffleContract[-1].addAddressToWhitelist(
        "0x885F12B525218Ca9377755F9a534CE230Ac5D2d8"
    )

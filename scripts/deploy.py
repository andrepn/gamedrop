from brownie import *

def deploy_contracts():

    base_account = {"from" : accounts[0]}

    gtt = GamingTestToken.deploy("game_token", "GTT", base_account)
    cnft = CoolNFTs.deploy("Cool_NFT", "CNFT", base_account)
    rc = RaffleContract.deploy(GamingTestToken[0].address, base_account)

'''
    for account in accounts:
        gtt.transfer(account, 100000, base_account)

    cnft.transferFrom(accounts[0], accounts[1], 1, base_account)
    cnft.transferFrom(accounts[0], accounts[2], 2, base_account)

    cnft.approve(RaffleContract[0].address, 4, base_account)
    
    print("add base acount to whitelist then add NFT to whitelist")
    rc.addAddressToWhitelist(accounts[0], base_account)
    rc.addNFTToWhitelist(CoolNFTs[0].address, base_account)

    print("send NFT with token_id 4 to vault")
    rc.vaultNFT(CoolNFTs[0].address, 4, base_account)
'''

def main():
    deploy_contracts()


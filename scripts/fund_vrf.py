from brownie import *

#DOESNT WORK RIGHT NOW
#must run kovan start and vrf_deploy first
def main():
    
    base = {'from' : accounts[0]}
    
    erc20_abi = [
        {
            "constant": True,
            "inputs": [
                {
                    "name": "spender",
                    "type": "address"
                },
                {
                    "name": "amount",
                    "type": "uint256"
                }
            ],
            "name": "approve",
            "outputs": [
                {
                    "name": "",
                    "type": "bool"
                }
            ],
            "payable": False,
            "type": "function"
            },
            {
            "constant": True,
            "inputs": [
                {
                    "name": "sender",
                    "type": "address"
                },
                {
                    "name": "recipient",
                    "type": "address"
                },
                {
                    "name": "amount",
                    "type": "uint256"
                }
            ],
            "name": "transferFrom",
            "outputs": [
                {
                    "name": "",
                    "type": "bool"
                }
            ],
            "payable": False,
            "type": "function"
            },
            {
            "constant": True,
            "inputs": [
                {
                    "name": "recipient",
                    "type": "address"
                },
                {
                    "name": "amount",
                    "type": "uint256"
                }
            ],
            "name": "transfer",
            "outputs": [
                {
                    "name": "",
                    "type": "bool"
                }
            ],
            "payable": False,
            "type": "function"
            },
            {
                "constant": True,
                "inputs": [
                {
                    "name": "_owner",
                    "type": "address"
                }
                ],
                "name": "balanceOf",
                "outputs": [
                {
                    "name": "balance",
                    "type": "uint256"
                }
                ],
                "payable": False,
                "type": "function"
            }
        ]

    LINK = Contract.from_abi("ChainLink Token",'0xa36085F69e2889c224210F603D836748e7dC0088', erc20_abi)
    
    LINK.transfer(GamedropVRF[-1], 1e17, base)
    
    #link.approve(GamedropVRF[-1], 2e17, base)
    #link.transferFrom(accounts[0], GamedropVRF[-1], 2e17, base)

    #GamedropVRF[-1].getLinkFromAccount(2e17, base)

    #accounts[0].transfer(GamedropVRF[-1], 1e15)
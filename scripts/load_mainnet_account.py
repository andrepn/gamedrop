from brownie import *
import dotenv
import os

dotenv.load_dotenv()


def load_accounts():
    list_of_accounts = list()

    key = os.getenv("PRIVATE_KEY_ONE")
    list_of_accounts.append(accounts.add(key))

    return list_of_accounts

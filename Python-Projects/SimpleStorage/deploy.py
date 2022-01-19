# from eth_keys.datatypes import PrivateKey
from solcx import compile_standard, install_solc
import os
import json
from web3 import Web3

# Using code in the .sol file
with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()
#   print(simple_storage_file)

# Solidity source code
compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {
                    "*": ["abi", "metadata", "evm.bytecode", "evm.bytecode.sourceMap"]
                }
            }
        },
    },
    solc_version="0.6.0",
)

# print(compiled_sol)

# Putting our compiled solidity code in a file as JSON
with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)

# Lets Deploy the contract

# 1. Get Bytecode
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

# 2. Get ABI
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

# 3. Web3 for Connecting with Ganesh
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:7545"))
chain_id = 1337
my_address = "0x444E7B3f4Dac461Af8544B0023CDCaFC53e9aF72"
# Make this as an env variable, NEVER HARDCODE YOUR KEY!
private_key = "ae07f616dc9c29a7c10e53ca3c9dc442d859e24db48f94787b482cb38a57aa80"

# 4. Creating the Contract
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

# We need the nonce
# Getting the no. of txns
nonce = w3.eth.getTransactionCount(my_address)
# print(nonce)

# 1. Build the Transaction
# 2. Sign the Transaction
# 3. Send the Transaction

# Building
transaction = SimpleStorage.constructor().buildTransaction(
    {
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce,
        "gasPrice": w3.eth.gas_price,
    }
)

# Signing
signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)

# Send this signed txn
print("Deploying Contract.....")
tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print("Deployed Successfully!")

# Working with the contract, you always need 2 things
# COntract Address
# Contract ABI
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)

# Call -> Simulating making the call and getting a return value
# Transact -> Actually make a state change

print(simple_storage.functions.retrieve().call())

# THis is just a call and doesnt make a state change
# print(simple_storage.functions.store(10).call())

print("Updating Contract......")
store_transaction = simple_storage.functions.store(15).buildTransaction(
    {
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce + 1,
        "gasPrice": w3.eth.gas_price,
    }
)

signed_store_txn = w3.eth.account.sign_transaction(
    store_transaction, private_key=private_key
)

send_store_tx = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(send_store_tx)
print("Contract Updated!")
print(simple_storage.functions.retrieve().call())

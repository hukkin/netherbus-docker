import argparse
import json
from urllib.request import Request, urlopen

parser = argparse.ArgumentParser(description='Update fee recipients from a JSON file via the keymanager API.')
parser.add_argument('host', help='hostname and port of keymanager API, e.g. http://127.0.0.1:5052')
parser.add_argument('auth', help='keymanager API auth key')
parser.add_argument(
    'file',
    help='JSON file with fee recipients to update. Must be an array of objects that have keys "validating_pubkey" and "ethaddress"',
    type=argparse.FileType(encoding="utf-8")
)
args = parser.parse_args()

thematic_break = "-" * 70

def request(resource, data=None):
    req = Request(f"{args.host}{resource}", data=data)
    req.add_header("authorization", f"Bearer {args.auth}")
    if data:
        req.add_header("accept", "*/*")
        req.add_header("content-type", "application/json")
    else:
        req.add_header("accept", "application/json")
    with urlopen(req) as resp:
        content_bytes = resp.read()
    content_str = content_bytes.decode()
    if data:
        return content_str
    return json.loads(content_str)

# Read the JSON and normalize hex values to lower case
fee_recipient_data = [{"validating_pubkey": d["validating_pubkey"].lower(), "ethaddress": d["ethaddress"].lower()} for d in json.load(args.file)]

# Show all validators managed by the node to the user
resp_obj = request("/eth/v1/keystores")
managed_keystores = {validator_data["validating_pubkey"].lower() for validator_data in resp_obj["data"]}
print("The node manages the following validators:")
for v in managed_keystores:
    print(v)

# Exit if the JSON contains validators not managed by the node
for d in fee_recipient_data:
    if d["validating_pubkey"] not in managed_keystores:
       raise SystemExit(f"ERROR: Validator {d['validating_pubkey']} is not managed by the connected node.") 

# Update the fee recipient according to JSON if need be
for d in fee_recipient_data:
    print(thematic_break)
    pubkey = d["validating_pubkey"]
    new_ethaddress = d["ethaddress"]
    resp_obj = request(f"/eth/v1/validator/{pubkey}/feerecipient")
    old_ethaddress = resp_obj["data"]["ethaddress"].lower()
    print(f"Configuring {pubkey}...")
    if old_ethaddress == new_ethaddress:
        print("Fee recipient already in sync")
        continue
    req_data = json.dumps({"ethaddress": new_ethaddress}).encode()
    request(f"/eth/v1/validator/{pubkey}/feerecipient", data=req_data)
    print(f"Fee recipient updated. Previously {old_ethaddress}. Now {new_ethaddress}")

print(thematic_break)
print(f"Success. All fee recipients synchronized.")

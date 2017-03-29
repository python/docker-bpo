"""Send GitHub requests to the tracker."""
import sys
import json
import hmac
import hashlib
import pathlib
import argparse

from urllib.request import Request, urlopen


TRACKER_URL = 'http://localhost:9999/python-dev/pull_request'
SECRET_KEY = b'abcd'
# default path where to find the files
# assumes that both docker-b.p.o and roundup are in the same dir
DEFAULT_PATH = pathlib.Path('../roundup/test/data/')
DEFAULT_HEADERS = {
    'User-Agent': 'GitHub-Hookshot/5a08997', 'Host': '6fe90df5.ngrok.io',
    'Content-Type': 'application/json', 'Accept': '*/*',
    'X-GitHub-Delivery': '000b1380-21b2-11e6-8ab3-f3d2fde2f5a1'
}


def calc_sig(payload, key=SECRET_KEY):
    """Calculate the signature of the payload."""
    return 'sha1=' + hmac.new(key, payload, hashlib.sha1).hexdigest()

def parse_file(fname):
    """Parse a request file and return the payload and the headers."""
    # if only the fname is provided, look for it in the DEFAULT_PATH
    fname = (DEFAULT_PATH / fname) if len(fname.parts) == 1 else fname
    with fname.open() as f:
        data = f.read()
    request, payload = data.split('\n\n')
    payload = payload.strip().encode('utf-8')
    reqline, *headers = request.splitlines()
    headers = dict(headers.split(': ', 1) for headers in headers)
    return payload, headers

def send_request(payload, headers=DEFAULT_HEADERS, url=TRACKER_URL):
    """Send a GitHub request to the tracker."""
    headers['Content-Length'] = clen = len(payload)
    headers['X-Hub-Signature'] = sig = calc_sig(payload)
    print('* Sending request:')
    print('  - length:', clen)
    print('  - signature:', sig)
    req = Request(url, headers=headers)
    print('  = response:', end=' ')
    try:
        res = urlopen(req, payload)
        print(res.status, res.reason)
        return True
    except Exception as e:
        print(e)
        return False

def parse_args():
    """Parse the command-line arguments."""
    desc = 'Send GitHub requests to the tracker.'
    parser = argparse.ArgumentParser(description=desc)
    parser.add_argument('file', metavar='FILE', type=pathlib.Path,
                        help='a request file')
    return parser.parse_args()

if __name__ == '__main__':
    args = parse_args()
    payload, headers = parse_file(args.file)
    sys.exit(send_request(payload, headers))

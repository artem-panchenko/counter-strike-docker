#!/usr/bin/env python

from __future__ import print_function

import os
import re
import socket


address = os.environ.get('HLDS_ADDRESS', '127.0.0.1')
port = int(os.environ.get('HLDS_PORT', 27111))

server_name = os.environ.get('HLDS_NAME', 'Test auto')
map_name = os.environ.get('HLDS_MAP', 'de_dust2')
game_name = os.environ.get('HLDS_GAME', 'Counter-Strike')

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.settimeout(3)

request_data = 'ffffffff54536f7572636520456e67696e6520517565727900'
retries = 10
request_bytes = bytearray(request_data.decode('hex'))

while retries:
    retries -= 1
    try:
        sock.sendto(request_bytes, (address, port))
        response_data, remote_addr = sock.recvfrom(1024)
    except socket.timeout:
        if not retries:
            raise socket.timeout('Nothing was received from HLDS')

match = re.match('.*{0}.*{1}.*{2}.*'.format(server_name,
                                            map_name,
                                            game_name),
                 response_data)

assert match, ("Server discovery test failed!"
               "Recieved : {0}").format(response_data)
print("SUCCESS!")

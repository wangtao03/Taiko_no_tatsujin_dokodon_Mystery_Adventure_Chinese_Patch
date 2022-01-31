from Crypto.Cipher import AES
from Crypto.Util import Counter
from ctypes import *
import hashlib
import struct

# TODO:
#	-Parse NCCH data directly from the ROM
#	-Decrypt NCCH directly
#	-Use command-line based handling

#http://www.falatic.com/index.php/108/python-and-bitwise-rotation
rol = lambda val, r_bits, max_bits: \
    (val << r_bits%max_bits) & (2**max_bits-1) | \
    ((val & (2**max_bits-1)) >> (max_bits-(r_bits%max_bits)))

ror = lambda val, r_bits, max_bits: \
    ((val & (2**max_bits-1)) >> r_bits%max_bits) | \
    (val << (max_bits-(r_bits%max_bits)) & (2**max_bits-1))

def to_bytes(num):
    numstr = ''
    tmp = num
    while len(numstr) < 16:
        numstr += chr(tmp & 0xFF)
        tmp >>= 8
    return numstr[::-1]

class ncchinfo_hdr(Structure):
    _fields_ = [
        ('FFFFFFFF', c_uint32),
        ('Ver', c_uint32),
		('Entries', c_uint32),
        ('Reserved', c_uint32)
	]

class ncchinfo_entry(Structure):
    _fields_ = [
        ('Counter', c_uint8 * 0x10),
        ('KeyY', c_uint8 * 0x10),
		('Size', c_uint32),
        ('Reserved', c_uint32),
		('Reserved', c_uint32),
        ('CryptoFlag', c_uint32),
		('TitleID', c_uint32 * 2),
		('Name', c_char * 112)
	]

#https://github.com/archshift/Decrypt9/blob/master/scripts/ncchinfo_gen.py
def ArrayToString(ctypeArray):
    return ''.join('%02X' % x for x in ctypeArray[::+1])
	
def ReverseArrayToString(ctypeArray):
    return ''.join('%02X' % x for x in ctypeArray[::-1])
	
with open('ncchinfo.bin', 'rb') as f:
	info = ncchinfo_hdr()
	f.readinto(info)
	f.read(16)
	f.seek(16)
	
	for x in xrange(0, info.Entries):
		entry = ncchinfo_entry()
		f.readinto(entry)
		f.seek(168*x+16)
		f.read(168)
		
		KeyX = 0
		
		if (entry.CryptoFlag == 0):
			KeyX = 0xB98E95CECA3E4D171F76A94DE934C053 #KeyX 0x2C
		elif (entry.CryptoFlag == 0x01):
			KeyX = 0xCEE7D8AB30C00DAE850EF5E382AC5AF3 #KeyX 0x25
			if not hashlib.sha1(to_bytes(KeyX)).hexdigest().upper() == '4231F2B435EC7A456C0ACC5FAFCD4CB949F83BC0':
				KeyX = 0
		elif (entry.CryptoFlag == 0x0A):
			KeyX = 0x82E9C9BEBFB8BDB875ECC0A07D474374 #KeyX 0x18
			if not hashlib.sha1(to_bytes(KeyX)).hexdigest().upper() == 'FBEAA933DC7D4997463E8973AD1867C0B245E0BD':
				KeyX = 0
		elif (entry.CryptoFlag == 0x0B):
			KeyX = 0x45AD04953992C7C893724A9A7BCE6182 #KeyX 0x1B
			if not hashlib.sha1(to_bytes(KeyX)).hexdigest().upper() == '1E96BE527AC64E6F6929B38760B1A4873D051B96':
				KeyX = 0
		
		ctr = Counter.new(128, initial_value=long(ArrayToString(entry.Counter),16))
		KeyY = long(ArrayToString(entry.KeyY), 16)
		NormalKey = rol((rol(KeyX, 2, 128) ^ KeyY) + 0x1FF9E9AAC5FE0408024591DC5D52768A, 87, 128)
		ctrmode = AES.new(to_bytes(NormalKey), AES.MODE_CTR, counter = ctr)
		
		filename = entry.Name.encode('ascii','ignore')
		print(filename[1:])
		print(ArrayToString(entry.Counter))
		print(ArrayToString(entry.KeyY))
		print '%X' % (NormalKey)
		
		if (KeyX != 0):
			with open(filename[1:], 'w+b') as p:
				l = 0
				
				for i in xrange(0, entry.Size*0x10):
					out = ctrmode.decrypt("00000000000000000000000000000000".decode("hex"))
					for c in xrange(0, 4095): #0x10000 byte chunks seem to work the fastest
						out += ctrmode.decrypt("00000000000000000000000000000000".decode("hex"))
					p.write(out)
					
					percent = 100 * float(i)/float(entry.Size*0x10)
					if (percent >= l):
						print 'Generating XORpad... %d%%\r' % percent,
						l = l+1
				print 'Generating XORpad... 100%'
				
				print("Done!")
		else:
			print("Invalid KeyX!")
		
		print